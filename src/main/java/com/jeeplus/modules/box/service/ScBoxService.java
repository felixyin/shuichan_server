/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.box.service;

import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.collection.ListUtil;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.box.entity.ScBox;
import com.jeeplus.modules.box.mapper.ScBoxMapper;
import com.jeeplus.modules.boxitem.entity.ScBoxItem;
import com.jeeplus.modules.boxitem.mapper.ScBoxItemMapper;
import com.jeeplus.modules.boxitem.service.ScBoxItemService;
import com.jeeplus.modules.custom.service.ScCustomService;
import com.jeeplus.modules.order.entity.ScOrder;
import com.jeeplus.modules.order.service.ScOrderService;
import com.jeeplus.modules.production.entity.ScProduction;
import com.jeeplus.modules.production.service.ScProductionService;
import com.jeeplus.modules.sys.entity.Area;
import com.jeeplus.modules.sys.entity.Office;
import com.jeeplus.modules.sys.service.OfficeService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * 包装箱Service
 *
 * @author 尹彬
 * @version 2019-08-11
 */
@Service
@Transactional(readOnly = true)
public class ScBoxService extends CrudService<ScBoxMapper, ScBox> {

    @Resource
    private ScBoxItemMapper scBoxItemMapper;

    @Resource
    private ScBoxItemService scBoxItemService;

    @Resource
    private ScOrderService scOrderService;

    @Resource
    private ScProductionService scProductionService;

    @Resource
    private ScCustomService scCustomService;

    @Resource
    private OfficeService officeService;

    @Override
    public ScBox get(String id) {
        ScBox scBox = super.get(id);
        scBox.setScBoxItemList(scBoxItemMapper.findList(new ScBoxItem(scBox)));
        return scBox;
    }

    @Override
    public List<ScBox> findList(ScBox scBox) {
        return super.findList(scBox);
    }

    @Override
    public Page<ScBox> findPage(Page<ScBox> page, ScBox scBox) {
        return super.findPage(page, scBox);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(ScBox scBox) {
        // Fixme 生成装箱单号,不能在这里？？？
        String no = scBox.getNo();
        if (StringUtils.isBlank(no)) {
            this.preAddGenBoxNo(scBox, scBox.getOrder().getId());
        }

        // 计算总计快递费
        Double logisticsTotalPrice = scBox.getLogisticsTotalPrice();
        if (null == logisticsTotalPrice || logisticsTotalPrice == 0D) {
            Double logisticsPrice = scBox.getLogisticsPrice();
            if (null != logisticsPrice && logisticsPrice != 0D) {
                logisticsTotalPrice = scBox.getCount() * logisticsPrice;
                scBox.setLogisticsTotalPrice(logisticsTotalPrice);
            }
        }

        // 计算总计价格
        Double totalPrice = scBox.getTotalPrice();
        if (null == totalPrice || totalPrice == 0D) {
            BigDecimal weight = new BigDecimal(Double.toString(scBox.getWeight()));
            BigDecimal count = new BigDecimal(Double.toString(scBox.getCount()));
            BigDecimal singlePrice = new BigDecimal(Double.toString(scBox.getSinglePrice()));
            BigDecimal multiply = weight.multiply(count).multiply(singlePrice);
            scBox.setTotalPrice(multiply.doubleValue());
        }

        // 判断是否存在产品，如果不存在则创建，如果存在则修改
        ScProduction production = scBox.getProduction();
        if (null != production) {
            String name = production.getName();
            if (StringUtils.isNotBlank(name)) {
                ScProduction paramProduction = new ScProduction();
                paramProduction.setName(name);
                List<ScProduction> productionList = scProductionService.findList(paramProduction);
                if (null == productionList || productionList.isEmpty()) {
                    production.setId(null); // 如果id不为null，则会是修改，这里必须是添加
                    scProductionService.save(production);
                } else {
//                    assert productionList.size() == 1;
                    production = productionList.get(0);
                    production.setName(name);
                    Double singlePrice = scBox.getSinglePrice();
                    if (null != singlePrice && singlePrice != 0D) { // 如果表单上填写了每斤价格，则更新产品库
                        production.setLastUnitPrice(singlePrice);
                    }
                    scProductionService.save(production);
                }
                scBox.setProduction(production);
            }
        }

        // 判断是否存在调拨工厂，如果不存在则创建，如果存在则修改
        Office allotFactory = scBox.getAllotFactory();
        if (null != allotFactory) {
            String name = allotFactory.getName();
            if (StringUtils.isNotBlank(name)) {
                List<Office> officeList = officeService.findListByName(name);
                if (null == officeList || officeList.isEmpty()) {// 数据库中没有找到记录，则创建记录，找到不做任何处理
                    allotFactory.setId(null);
                    allotFactory.setParent(new Office("9330c28235614c8eb5ed146486612a07")); // 调拨工厂分类
                    allotFactory.setArea(new Area("a9beb8c645ff448d89e71f96dc97bc09")); // 中国
                    allotFactory.setType("1"); // 类别：物流
                    allotFactory.setGrade("3"); // 级别：三级
                    allotFactory.setUseable("1"); // 是否可用：是
                    officeService.save(allotFactory);
                } else {
                    assert officeList.size() == 1;
                    allotFactory = officeList.get(0);
                }
                scBox.setAllotFactory(allotFactory);
            }
        }

        super.save(scBox);

        // 获取包装箱上的数量
        Integer boxCount = scBox.getCount();

        ScBox scBox1 = new ScBox(scBox.getId());
        // 查询每箱表所有数据，按照箱号正序排列
        List<ScBoxItem> boxItems = scBoxItemMapper.findList(new ScBoxItem(scBox1));

//		判断如果没有查到，则是新增，生成数据，批量插入即可
        int size = boxItems.size();
        if (size == 0) {
            for (int i = 1; i <= boxCount; i++) {
                saveNewBoxItem(scBox, i);
            }
        } else if (size < boxCount) {
//		如果数据少于包装箱上的数量，则新增差的数量即可
            ScBoxItem last = ListUtil.getLast(boxItems);
            Integer few = last.getFew();
            int minusCount = boxCount - size + few;
            for (int i = 1 + few; i <= minusCount; i++) {
                saveNewBoxItem(scBox, i);
            }
        } else if (size > boxCount) {
//		如果数据多余包装箱上的数据，则

            int minusCount = size - boxCount;

            boxItems = ListUtil.reverse(boxItems);
            for (ScBoxItem boxItem : boxItems) {
//		如果所有订单已经生产，则不允许删除
//                if (!(boxItem.getProcess() > 1)) {
//		否则，从末尾删除多余数据
                scBoxItemMapper.delete(boxItem);
                minusCount--;
                if (minusCount <= 0) {
                    break;
                }
//                }
            }
        }

        String orderId = scBox.getOrder().getId();
        calAllPriceForPrice(orderId);

        //		for (ScBoxItem scBoxItem : scBox.getScBoxItemList()){
//			if (scBoxItem.getId() == null){
//				continue;
//			}
//			if (ScBoxItem.DEL_FLAG_NORMAL.equals(scBoxItem.getDelFlag())){
//				if (StringUtils.isBlank(scBoxItem.getId())){
//					scBoxItem.setBox(scBox);
//					scBoxItem.preInsert();
//					scBoxItemMapper.insert(scBoxItem);
//				}else{
//					scBoxItem.preUpdate();
//					scBoxItemMapper.update(scBoxItem);
//				}
//			}else{
//				scBoxItemMapper.delete(scBoxItem);
//			}
//		}
    }

    /**
     * 计算订单所有的价格信息
     *
     * @param orderId
     */
    public void calAllPriceForPrice(String orderId) {
        // 统计订单上的汇总数据，给与修改
        ScOrder scOrder = scOrderService.get(orderId);
        List<ScBox> scBoxList = scOrder.getScBoxList();
        Double goodsOrderPrice = 0D;
        Double deliverOrderPrice = 0D;
        Double logisticsOrderPrice = 0D;
        for (ScBox box : scBoxList) {
            Double totalPrice = box.getTotalPrice();
            if (null != totalPrice) {
                goodsOrderPrice += totalPrice;
            }
            Double logisticsTotalPrice = box.getLogisticsTotalPrice();
            if (null != logisticsTotalPrice) {
                logisticsOrderPrice += logisticsTotalPrice;
            }
            Double deliverTotalPrice = box.getDeliverTotalPrice();
            if (null != deliverTotalPrice) {
                deliverOrderPrice += deliverTotalPrice;
            }
        }
        scOrder.setGoodsOrderPrice(goodsOrderPrice);
        scOrder.setLogisticsOrderPrice(logisticsOrderPrice);
        scOrder.setDeliverOrderPrice(deliverOrderPrice);
        scOrder.setWillPayPrice(goodsOrderPrice + logisticsOrderPrice);
        scOrder.setScBoxList(new ArrayList<>());
        scOrderService.save(scOrder);
    }

    private void saveNewBoxItem(ScBox box, int i) {
        ScBoxItem scBoxItem = new ScBoxItem();
        scBoxItem.setBox(box);
        scBoxItem.setFew(i);
        scBoxItem.setProcess(1);
        scBoxItem.setSerialNum(box.getNo() + StringUtils.leftPad(i + "", 2, "0"));
        scBoxItemService.save(scBoxItem);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(ScBox scBox) {
        super.delete(scBox);
        scBoxItemMapper.delete(new ScBoxItem(scBox));
    }

    /**
     * 生成装箱单编号
     *
     * @param scBox
     * @param orderId
     * @return
     */
    public ScBox preAddGenBoxNo(ScBox scBox, String orderId) {

        //  如果是 增加 装箱单，自动关联订单编号
        ScOrder scOrder = scBox.getOrder();
        if (StringUtils.isNotBlank(orderId)) {
            if (null == scOrder || StringUtils.isBlank(scOrder.getId())) {

                // 查询订单
                scOrder = scOrderService.get(orderId);
                scBox.setOrder(scOrder);

                // 装箱单号生成
                int num = 0;
                if (StringUtils.isBlank(scBox.getNo())) { // 生成装箱单编号
                    String orderNo = scOrder.getNo();
                    String officeId = "box_" + scOrder.getFactory().getId();
                    num = Office.getSerialNumberStatic(officeId);
                    String after = StringUtils.leftPad("" + num, 2, '0');
                    scBox.setNo(orderNo + after);
                    Office.putSerialNumberStatic(officeId, ++num);
                }
            } else {
                // 装箱单号生成
                int num = 0;
                if (StringUtils.isBlank(scBox.getNo())) { // 生成装箱单编号
                    String orderNo = scOrder.getNo();
                    String officeId = "box_" + scOrder.getFactory().getId();
                    num = Office.getSerialNumberStatic(officeId);
                    String after = StringUtils.leftPad("" + num, 2, '0');
                    scBox.setNo(orderNo + after);
                    Office.putSerialNumberStatic(officeId, ++num);
                }
            }
        }

        return scBox;
    }


/*
    @Transactional(readOnly = true)
    public ScOrder scanBoxOrder(ScBox scBox) {
        ScOrder scOrder = scOrderService.get(scBox.getOrder().getId());

        ScCustom scCustom = scCustomService.get(scOrder.getCustom().getId());
        scOrder.setCustom(scCustom);

        List<ScBox> scBoxList = new ArrayList<>();
        scBoxList.add(scBox);
        scOrder.setScBoxList(scBoxList);

        return scOrder;
    }*/
}