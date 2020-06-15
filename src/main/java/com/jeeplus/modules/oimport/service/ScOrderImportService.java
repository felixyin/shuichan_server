/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.oimport.service;

import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.time.DateUtil;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.box.entity.ScBox;
import com.jeeplus.modules.box.service.ScBoxService;
import com.jeeplus.modules.boxitem.service.ScBoxItemService;
import com.jeeplus.modules.custom.entity.ScCustom;
import com.jeeplus.modules.custom.service.ScCustomService;
import com.jeeplus.modules.oimport.entity.ScOrderImport;
import com.jeeplus.modules.oimport.mapper.ScOrderImportMapper;
import com.jeeplus.modules.order.entity.ScOrder;
import com.jeeplus.modules.order.service.ScOrderService;
import com.jeeplus.modules.production.entity.ScProduction;
import com.jeeplus.modules.production.service.ScProductionService;
import com.jeeplus.modules.sys.entity.Area;
import com.jeeplus.modules.sys.entity.Office;
import com.jeeplus.modules.sys.service.OfficeService;
import com.jeeplus.modules.sys.utils.DictUtils;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 导入订单Service
 *
 * @author 尹彬
 * @version 2019-08-20
 */
@Service
@Transactional(readOnly = true)
public class ScOrderImportService extends CrudService<ScOrderImportMapper, ScOrderImport> {

    public static final String REMARKS_DEL = "注意：此数据将不会导入";

    @Resource
    private ScCustomService scCustomService;

    @Resource
    private ScProductionService scProductionService;

    @Resource
    private ScOrderService scOrderService;

    @Resource
    private ScBoxService scBoxService;

    @Resource
    private ScBoxItemService scBoxItemService;

    @Resource
    private OfficeService officeService;

    @Override
    protected void preExecute(ScOrderImport entity) {
        // 当前用户导入的数据
        if (!UserUtils.getUser().isAdmin()) {
            entity.setUser(UserUtils.getUser());
        }
    }

    @Override
    public ScOrderImport get(String id) {
        return super.get(id);
    }

    @Override
    public List<ScOrderImport> findList(ScOrderImport scOrderImport) {
        return super.findList(scOrderImport);
    }

    @Override
    @Transactional(readOnly = false)
    public Page<ScOrderImport> findPage(Page<ScOrderImport> page, ScOrderImport scOrderImport) {
        Page<ScOrderImport> page1 = super.findPage(page, scOrderImport);
        List<ScOrderImport> list = page1.getList();
        for (ScOrderImport orderImport : list) {
            autoCompleteUserInfo(orderImport);
            autoCompleteSpecInfo(orderImport);

            this.save(orderImport);
        }
        return page1;
    }

    /**
     * 客户要求的产品信息 补全
     *
     * @param orderImport
     * @return
     */
    private void autoCompleteSpecInfo(ScOrderImport orderImport) {

        // 判断产品名称
        String productionName = orderImport.getProductionName();
        if (null == productionName || StringUtils.isBlank(productionName)) {
            orderImport.setUsername("不能为空");
            orderImport.setRemarks(REMARKS_DEL);
        }

        // 设置每斤价格
        Double lastUnitPrice = orderImport.getLastUnitPrice();
        if (null == lastUnitPrice || 0D == lastUnitPrice) {
            ScProduction scProduction = new ScProduction();
            scProduction.setName(productionName);
            List<ScProduction> list = scProductionService.findList(scProduction);
            if (null != list && list.size() > 0) {
                ScProduction scProduction1 = list.get(0);
                orderImport.setLastUnitPrice(scProduction1.getLastUnitPrice());
            } else {
                orderImport.setProductionName("不在产品库中:" + productionName);
                orderImport.setRemarks(REMARKS_DEL);
            }
        }

        // 设置数量
        Integer count = orderImport.getCount();
        if (null == count || 0 == count) {
            orderImport.setCount(1);
        }

        // 设置所属加工厂
        orderImport.setFactoryName(UserUtils.getOfficeDirectly().getName());
    }

    /**
     * 客户信息 补全
     *
     * @param orderImport
     * @return
     */
    private void autoCompleteUserInfo(ScOrderImport orderImport) {
        boolean blankUsername = StringUtils.isBlank(orderImport.getUsername());
        boolean blankPhone = StringUtils.isBlank(orderImport.getPhone());
        boolean blankAddress = StringUtils.isBlank(orderImport.getAddress());
        if (blankUsername || blankAddress || blankPhone) {
            ScCustom scCustom = new ScCustom();
            if (!blankUsername) {
                scCustom.setUsername(orderImport.getUsername());
            }
            if (!blankPhone) {
                scCustom.setPhone(orderImport.getPhone());
            }
            if (!blankAddress) {
                scCustom.setAddress(orderImport.getAddress());
            }
            List<ScCustom> list1 = scCustomService.findList(scCustom);
            if (null == list1 || list1.size() == 0) { //如果没有查询到则是新增
                if (blankUsername && blankPhone && blankAddress) {
                    orderImport.setUsername("不能为空");
                    orderImport.setRemarks(REMARKS_DEL);
                }
            } else {
                ScCustom scCustom1 = list1.get(0); // 重名或手机号相同，默认取第一条
                if (blankUsername) {
                    orderImport.setUsername(scCustom1.getUsername());
                }
                if (blankPhone) {
                    orderImport.setPhone(scCustom1.getPhone());
                }
                if (blankAddress) {
                    orderImport.setAddress(scCustom1.getAddress());
                }
            }
        }
    }

    @Override
    @Transactional(readOnly = false)
    public void save(ScOrderImport scOrderImport) {
//        User currentUser = UserUtils.getUser();
//        scOrderImport.setUser(currentUser);
        super.save(scOrderImport);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(ScOrderImport scOrderImport) {
        super.delete(scOrderImport);
    }

    /**
     * 预订单数据，生成真实订单数据
     */
    @Transactional(readOnly = false)
    public void importToOrder() {
        System.out.println("ok");
        // 当天时间
        Date xiaDanDate = new Date();
        Date nowDate = DateUtil.endOfDate(xiaDanDate);


        // 查询当前用户的导入临时数据
        ScOrderImport paramOrderImport = new ScOrderImport();
        paramOrderImport.setUser(UserUtils.getUser());
        List<ScOrderImport> list = this.findList(paramOrderImport);
        for (ScOrderImport scOrderImport : list) {
            if (!REMARKS_DEL.equalsIgnoreCase(scOrderImport.getRemarks())) {
                ScOrder scOrder = new ScOrder();
                scOrder.setCreateDate(xiaDanDate);

                // 设置客户
                ScCustom scCustom = createOrGetScCustom(scOrderImport);
                scOrder.setCustom(scCustom);

                // 设置代理人
                String agentName = scOrderImport.getAgentName();
                if (StringUtils.isNotBlank(agentName)) {
                    scOrder.setAgentName(agentName);
                }

                // 设置物流公司
                String logisticsName = scOrderImport.getLogisticsName();
                if (StringUtils.isNotBlank(logisticsName)) {
                    Office office = createOrFindOffice(logisticsName, "e684ba5b88ae4b56b34a0625d9d372a8", "2");
                    scOrder.setShouldLogistics(office);
                }

                // 设置物流班次
                String logisticsShift = DictUtils.getDictValue(scOrderImport.getShiftName(), "logistics_shift", "4");
                scOrder.setShift(Integer.parseInt(logisticsShift));

                // 设置其他
                scOrder.setStatus(1); // 状态为：已下单
                scOrder.setTomorrowCancellation(1); // 作废并不创建新订单
                scOrder.setFactory(UserUtils.getOfficeDirectly()); // 设置所属公司
                scOrder.setDeliverDate(nowDate); // 设置要求发货时间

                // 保存订单，如果已经存在当天的订单，则合并订单
                // 如果客户信息、代理人、物流公司信息相同，则认为需要合并订单
                ScOrder paramOrder = new ScOrder();
                paramOrder.setCustom(scCustom);
                paramOrder.setDeliverDate(nowDate);
                paramOrder.setAgentName(paramOrder.getAgentName());
                paramOrder.setShouldLogistics(scOrder.getShouldLogistics());
                List<ScOrder> list1 = scOrderService.findList(paramOrder);
                if (null == list1 || list1.isEmpty()) {
                    System.out.println(scOrder);
                    scOrderService.save(scOrder);
                } else {
                    assert list1.size() == 1;
                    scOrder = list1.get(0); // 只可能有一个
                }

                ScBox scBox = new ScBox();

                // 设置装箱单号
               /* scBox = scBoxService.preAddGenBoxNo(scBox, scOrder.getId());

                // 设置调拨加工厂
                String allotFactoryName = scOrderImport.getAllotFactoryName();
                if (StringUtils.isNotBlank(allotFactoryName)) {
                    Office allotFactory = createOrFindOffice(allotFactoryName, "9330c28235614c8eb5ed146486612a07", "1");
                    scBox.setAllotFactory(allotFactory);
                }

                // 设置品名和价格
                Double lastUnitPrice = scOrderImport.getLastUnitPrice();
                if (null == lastUnitPrice) {
                    lastUnitPrice = 0D;
                }
                scBox.setSinglePrice(lastUnitPrice);

                String productionName = scOrderImport.getProductionName();
                if (StringUtils.isNotBlank(productionName)) {
                    ScProduction scProduction = createOrFindProduction(productionName, lastUnitPrice);
                    scBox.setProduction(scProduction);
                }

                // 设置重量
                Double weight = scOrderImport.getWeight();
                if (null == weight) {
                    weight = 0D;
                }
                scBox.setWeight(weight);

                // 设置数量
                Integer count = scOrderImport.getCount();
                if (null == count) {
                    count = 0;
                }
                scBox.setCount(count);

                // 计算总价
                scBox.setTotalPrice(scBox.getSinglePrice() * scBox.getWeight() * scBox.getCount());

                // 设置备注
                scBox.setRemarks(scOrderImport.getRemarks());
*/
                // 设置所属订单
                scBox.setOrder(scOrder);

                ScProduction scProduction = new ScProduction();
                scProduction.setName(scOrderImport.getProductionName());
                scBox.setProduction(scProduction);

                Office allotFactory = new Office();
                allotFactory.setName(scOrderImport.getAllotFactoryName());
                scBox.setAllotFactory(allotFactory);

                // 设置品名和价格
                Double lastUnitPrice = scOrderImport.getLastUnitPrice();
                if (null == lastUnitPrice) {
                    lastUnitPrice = 0D;
                }
                scBox.setSinglePrice(lastUnitPrice);


                // 设置重量
                Double weight = scOrderImport.getWeight();
                if (null == weight) {
                    weight = 0D;
                }
                scBox.setWeight(weight);

                // 设置数量
                Integer count = scOrderImport.getCount();
                if (null == count) {
                    count = 0;
                }
                scBox.setCount(count);

                Double logisticsPrice = scOrderImport.getLogisticsPrice();
                if(null == logisticsPrice){
                    logisticsPrice = 0D;
                }
                scBox.setLogisticsPrice(logisticsPrice);

                // 设置备注
                scBox.setRemarks(scOrderImport.getRemarks());
                // 保存包装箱
                scBoxService.save(scBox);
            }else{
                System.out.println("没有导入");
            }
//            this.delete(scOrderImport);
        }
    }

    private ScProduction createOrFindProduction(String productionName, Double lastUnitPrice) {
        ScProduction scProduction = new ScProduction();
        scProduction.setName(productionName);
        List<ScProduction> scProductionList = scProductionService.findList(scProduction);
        if (scProductionList == null || scProductionList.isEmpty()) {
            scProduction.setLastUnitPrice(lastUnitPrice);
            scProductionService.save(scProduction);
        } else {
            assert scProductionList.size() == 1;
            scProduction = scProductionList.get(0);
        }
        return scProduction;
    }

    private Office createOrFindOffice(String name, String parent, String type) {
        Office office = new Office();
        office.setName(name);
        List<Office> officeList = officeService.findListByName(name);
        if (null == officeList || officeList.isEmpty()) {
            office.setParent(new Office(parent));
            office.setArea(new Area("a9beb8c645ff448d89e71f96dc97bc09"));
            office.setType(type); // 类别：物流
            office.setGrade("3"); // 级别：三级
            office.setUseable("1"); // 是否可用：是
            officeService.save(office);
        } else {
            assert officeList.size() == 1;
            office = officeList.get(0);
        }
        return office;
    }

    private ScCustom createOrGetScCustom(ScOrderImport scOrderImport) {
        ScCustom scCustom = new ScCustom();
        scCustom.setPhone(scOrderImport.getPhone());
        scCustom.setUsername(scOrderImport.getUsername());
        scCustom.setAddress(scOrderImport.getAddress());
        List<ScCustom> scCustomList = scCustomService.findList(scCustom);
        if (null == scCustomList || scCustomList.isEmpty()) {
            scCustomService.save(scCustom);
        } else {
            assert scCustomList.size() == 1;
            scCustom = scCustomList.get(0);
        }
        return scCustom;
    }

    public List<Map<String, Object>> autoCompleteCustom( String phone, String username, String address, String officeId) {
        return this.mapper.autoCompleteCustom(phone, username, address, officeId);
    }
}