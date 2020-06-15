/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.order.service;

import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.time.DateUtil;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.box.entity.ScBox;
import com.jeeplus.modules.box.mapper.ScBoxMapper;
import com.jeeplus.modules.box.service.ScBoxService;
import com.jeeplus.modules.boxitem.entity.ScBoxItem;
import com.jeeplus.modules.boxitem.service.ScBoxItemService;
import com.jeeplus.modules.custom.entity.ScCustom;
import com.jeeplus.modules.custom.service.ScCustomService;
import com.jeeplus.modules.order.entity.OutOrder;
import com.jeeplus.modules.order.entity.ScOrder;
import com.jeeplus.modules.order.mapper.ScOrderMapper;
import com.jeeplus.modules.production.entity.ScProduction;
import com.jeeplus.modules.production.service.ScProductionService;
import com.jeeplus.modules.sys.entity.Area;
import com.jeeplus.modules.sys.entity.Office;
import com.jeeplus.modules.sys.entity.Role;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.service.OfficeService;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 订单Service
 *
 * @author 尹彬
 * @version 2019-08-09
 */
@Service
@Transactional(readOnly = true)
public class ScOrderService extends CrudService<ScOrderMapper, ScOrder> {

    @Resource
    private ScBoxMapper scBoxMapper;
    @Resource
    private ScCustomService scCustomService;
    @Resource
    private ScBoxService scBoxService;
    @Resource
    private ScBoxItemService scBoxItemService;
    @Resource
    private OfficeService officeService;
    @Resource
    private ScProductionService scProductionService;
    @Resource
    private ScOrderService scOrderService;

    @Override
    protected void preExecute(ScOrder entity) {
        if (!UserUtils.getUser().isAdmin()) {
            if (!"2".equals(UserUtils.getOfficeDirectly().getType())) { // 非快递人员，即包装人员
                entity.setFactory(UserUtils.getOfficeDirectly());
            }
        }
    }

    @Override
    public ScOrder get(String id) {
        ScOrder scOrder = super.get(id);
        scOrder.setScBoxList(scBoxMapper.findList(new ScBox(scOrder)));
        return scOrder;
    }

    @Override
    public List<ScOrder> findList(ScOrder scOrder) {
        return super.findList(scOrder);
    }

    @Override
    public Page<ScOrder> findPage(Page<ScOrder> page, ScOrder scOrder) {
        return super.findPage(page, scOrder);
    }

    public Page<OutOrder> findPageForOurOrder(Page<OutOrder> page, String[] ids, String spec) {
//        outOrder.setPage(page);
        List<OutOrder> forOutPrintByOrderIds = mapper.findForOutPrintByOrderIds(ids, spec);
        int sum = 0;
        for (OutOrder forOutPrintByOrderId : forOutPrintByOrderIds) {
            sum += forOutPrintByOrderId.getCount();
        }
        OutOrder outOrder2 = new OutOrder();
        outOrder2.setSpec("总数：");
        outOrder2.setCount(sum);
        forOutPrintByOrderIds.add(outOrder2);
        page.setList(forOutPrintByOrderIds);
        return page;
    }

    public Page<ScOrder> findPage2(Page<ScOrder> page, ScOrder scOrder) {
        Page<ScOrder> page1 = super.findPage(page, scOrder);
        List<ScOrder> list = page1.getList();
        Double goodsOrderPrice = 0D;
        Double deliverOrderPrice = 0D;
        Double logisticsOrderPrice = 0D;
        Double willPayPrice = 0D;
        Double realPayPrice = 0D;
        for (ScOrder so : list) {
            if (null != so.getGoodsOrderPrice()) {
                goodsOrderPrice += so.getGoodsOrderPrice();
            }
            if (null != so.getDeliverOrderPrice()) {
                deliverOrderPrice += so.getDeliverOrderPrice();
            }
            if (null != so.getLogisticsOrderPrice()) {
                logisticsOrderPrice += so.getLogisticsOrderPrice();
            }
            if (null != so.getWillPayPrice()) {
                willPayPrice += so.getWillPayPrice();
            }
            if (null != so.getRealPayPrice()) {
                realPayPrice += so.getRealPayPrice();
            }
        }
        ScOrder order = new ScOrder();
        Office realLogistics = new Office();
        realLogistics.setName("汇总：");
        order.setRealLogistics(realLogistics);
        order.setGoodsOrderPrice(goodsOrderPrice);
        order.setDeliverOrderPrice(deliverOrderPrice);
        order.setLogisticsOrderPrice(logisticsOrderPrice);
        order.setWillPayPrice(willPayPrice);
        order.setRealPayPrice(realPayPrice);
        list.add(order);
        return page1;
    }

    @Transactional(readOnly = false)
    public void saveOwner(ScOrder scOrder) {
        super.save(scOrder);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(ScOrder scOrder) {
        String officeId = "order_" + scOrder.getFactory().getId();
        int num = 0;
        if (StringUtils.isBlank(scOrder.getNo())) { // 生成订单编号
            num = Office.getSerialNumberStatic(officeId);
            ScCustom scCustom = scCustomService.get(scOrder.getCustom().getId());
            String date = DateUtils.getDate("yyyyMMdd");
            String usernamePyFirst = scCustom.getUsernamePyFirst();
            String after = StringUtils.leftPad("" + num, 2, '0');
            String no = date + usernamePyFirst + after;
            scOrder.setNo(no);
        }

        super.save(scOrder);
//          如果有装箱单，则更新注释
        for (ScBox scBox : scOrder.getScBoxList()) {
            // 默认采用订单上的注释
            if (StringUtils.isBlank(scBox.getRemarks())) {
                scBox.setRemarks(scOrder.getRemarks());
            }
            scBoxService.preAddGenBoxNo(scBox, scOrder.getId());
            scBoxService.save(scBox);
        }

        if (0 != num) { // 生成了序列号，并且订单确实保存成功了
            Office.putSerialNumberStatic(officeId, ++num);
        }
    }


    @Transactional(readOnly = false)
    public void saveOrder(ScOrder scOrder) {

        // 如果没有订单编号，则认为是新建订单，则生成订单编号
        String officeId = "order_" + scOrder.getFactory().getId();
        int num = 0;
        if (StringUtils.isBlank(scOrder.getNo())) { // 生成订单编号
            num = Office.getSerialNumberStatic(officeId);
            ScCustom scCustom = scCustomService.get(scOrder.getCustom().getId());
            String date = DateUtils.getDate("yyyyMMdd");
            String usernamePyFirst = scCustom.getUsernamePyFirst();
            String after = StringUtils.leftPad("" + num, 2, '0');
            String no = date + usernamePyFirst + after;
            scOrder.setNo(no);
        }
        if (scOrder.getNo().contains("null")) { // 第一次录入时没有填写客户姓名
            num = Office.getSerialNumberStatic(officeId);
            ScCustom custom = scOrder.getCustom();
            ScCustom scCustom = scCustomService.get(custom.getId());
            scCustom.setUsername(custom.getUsername());
            scCustom.setPhone(custom.getPhone());
            scCustom.setAddress(custom.getAddress());
            scCustomService.save(scCustom);
            String date = DateUtils.getDate("yyyyMMdd");
            String usernamePyFirst = scCustom.getUsernamePyFirst();
            String after = StringUtils.leftPad("" + num, 2, '0');
            String no = date + usernamePyFirst + after;
            scOrder.setNo(no);
        }

        // 设置订单状态为已下单
//        scOrder.setStatus(1); // 1 为已下单

        // 保存或更新客户
        ScCustom custom = scOrder.getCustom();
        if (null != custom) {
            scCustomService.save(custom);
        }

        // 保存或更新指定物流公司
        Office shouldLogistics = scOrder.getShouldLogistics();
        if (null != shouldLogistics) {
            String name = shouldLogistics.getName();
            if (StringUtils.isNotBlank(name)) {
                Office foundOffice = new Office();
                foundOffice.setName(name);
                // 不能通过id与否认为是新增，只能通过查询机构名称（机构名称是唯一的）
                List<Office> list = officeService.findListByName(name);
                if (null == list || list.isEmpty()) { //认为是新建
                    foundOffice.setParent(new Office("e684ba5b88ae4b56b34a0625d9d372a8")); // 物流分类
                    foundOffice.setArea(new Area("a9beb8c645ff448d89e71f96dc97bc09")); // 中国
                    foundOffice.setType("2"); // 类别：物流
                    foundOffice.setGrade("3"); // 级别：三级
                    foundOffice.setUseable("1"); // 是否可用：是
                    officeService.save(foundOffice);
                } else { // 认为是修改，直接修改名称
                    assert list.size() == 1;
                    foundOffice = list.get(0);
//                    foundOffice.setName(name);
//                    officeService.save(foundOffice);
                }
                scOrder.setShouldLogistics(foundOffice);
            }
        }

        Office realLogistics = scOrder.getRealLogistics();
        if (null != realLogistics) {
            String name = realLogistics.getName();
            if (StringUtils.isNotBlank(name)) {
                Office foundOffice = new Office();
                foundOffice.setName(name);
                // 不能通过id与否认为是新增，只能通过查询机构名称（机构名称是唯一的）
                List<Office> list = officeService.findList(foundOffice);
                if (null == list || list.isEmpty()) { //认为是新建
                    foundOffice.setParent(new Office("e684ba5b88ae4b56b34a0625d9d372a8")); // 物流分类
                    foundOffice.setArea(new Area("a9beb8c645ff448d89e71f96dc97bc09")); // 中国
                    foundOffice.setType("2"); // 类别：物流
                    foundOffice.setGrade("3"); // 级别：三级
                    foundOffice.setUseable("1"); // 是否可用：是
                    officeService.save(foundOffice);
                } else { // 认为是修改，直接修改名称
//                    officeService.save(foundOffice);
                    assert list.size() == 1;
                    foundOffice = list.get(0);
                }
                scOrder.setRealLogistics(foundOffice);
            }
        }

        // 默认发货日期为天
        Date deliverDate = scOrder.getDeliverDate();
        if (null == deliverDate) {
            scOrder.setDeliverDate(DateUtil.nextDate(new Date()));
        }

        // 仅仅保存订单信息
        scOrder.setCreateDate(new Date());
        super.save(scOrder);
    }

    @Transactional(readOnly = false)
    public void saveAll(ScOrder scOrder) {
        Office officeDirectly = UserUtils.getOfficeDirectly();
        // 先保存或更新客户
        ScCustom custom = scOrder.getCustom();
        if (null != custom) {
            custom.setOffice(officeDirectly);
            List<ScCustom> customList = scCustomService.findList(custom);
            if (null == customList || customList.isEmpty()) {
                custom.setId(null); // 新增
                scCustomService.save(custom);
            } else {
                assert customList.size() == 1;
                custom = customList.get(0);
            }
            scOrder.setCustom(custom);
        }

        // 生成订单编号
        String officeId = "order_" + scOrder.getFactory().getId();
        int num = 0;
        if (StringUtils.isBlank(scOrder.getNo())) { // 生成订单编号
            num = Office.getSerialNumberStatic(officeId);
            ScCustom scCustom = scCustomService.get(scOrder.getCustom().getId());
            String date = DateUtils.getDate("yyyyMMdd");
            String usernamePyFirst = scCustom.getUsernamePyFirst();
            String after = StringUtils.leftPad("" + num, 2, '0');
            String no = date + usernamePyFirst + after;
            scOrder.setNo(no);
        }

        // 设置订单状态为已下单
        scOrder.setStatus(1); // 1 为已下单


        // 保存或更新指定物流公司
        Office shouldLogistics = scOrder.getShouldLogistics();
        if (null != shouldLogistics) {
            String name = shouldLogistics.getName();
            if (StringUtils.isNotBlank(name)) {
                Office paramOffice = new Office();
                paramOffice.setName(name);
                List<Office> officeList = officeService.findListByName(name);
                if (null == officeList || officeList.isEmpty()) {
                    shouldLogistics.setParent(new Office("e684ba5b88ae4b56b34a0625d9d372a8")); // 物流分类
                    shouldLogistics.setArea(new Area("a9beb8c645ff448d89e71f96dc97bc09")); // 中国
                    shouldLogistics.setType("2"); // 类别：物流
                    shouldLogistics.setGrade("3"); // 级别：三级
                    shouldLogistics.setUseable("1"); // 是否可用：是
                    officeService.save(shouldLogistics);
                } else {
                    assert officeList.size() == 1;
                    shouldLogistics = officeList.get(0);
                    if (!name.equalsIgnoreCase(shouldLogistics.getName())) {
                        shouldLogistics.setName(name);
                        officeService.save(shouldLogistics);
                    }
                }
                scOrder.setShouldLogistics(shouldLogistics);
            }
        }


        Office realLogistics = scOrder.getRealLogistics();
        if (null != realLogistics) {
            String name = realLogistics.getName();
            if (StringUtils.isNotBlank(name)) {
                Office paramOffice = new Office();
                paramOffice.setName(name);
                List<Office> officeList = officeService.findList(paramOffice);
                if (null == officeList || officeList.isEmpty()) {
                    realLogistics.setParent(new Office("e684ba5b88ae4b56b34a0625d9d372a8")); // 物流分类
                    realLogistics.setArea(new Area("a9beb8c645ff448d89e71f96dc97bc09")); // 中国
                    realLogistics.setType("2"); // 类别：物流
                    realLogistics.setGrade("3"); // 级别：三级
                    realLogistics.setUseable("1"); // 是否可用：是
                    officeService.save(realLogistics);
                } else {
                    assert officeList.size() == 1;
                    realLogistics = officeList.get(0);
                    if (!name.equalsIgnoreCase(realLogistics.getName())) {
                        realLogistics.setName(name);
                        officeService.save(realLogistics);
                    }
                }
                scOrder.setRealLogistics(realLogistics);
            }
        }

        // 默认发货日期为天
        Date deliverDate = scOrder.getDeliverDate();
        if (null == deliverDate) {
            scOrder.setDeliverDate(DateUtil.nextDate(new Date()));
        }

        // 仅仅保存订单信息
        scOrder.setCreateDate(new Date());
        super.save(scOrder);

        //  如果有装箱单，则保存
        for (ScBox scBox : scOrder.getScBoxList()) {
            // 保存装箱单前，必须关联订单
            scBox.setOrder(scOrder);

            // 默认采用订单上的注释
            if (StringUtils.isBlank(scBox.getRemarks())) {
                scBox.setRemarks(scOrder.getRemarks());
            }

            // 保存或更新规格信息
            ScProduction production = scBox.getProduction();
            if (null != production && StringUtils.isNotBlank(production.getName())) {
                List<ScProduction> productionList = scProductionService.findList(production);
                if (null == productionList || productionList.isEmpty()) {
                    production.setId(null); // 如果id不为null，则会是修改，这里必须是添加
                    production.setLastUnitPrice(scBox.getSinglePrice());
                    scProductionService.save(production);
                } else {
//                    assert productionList.size() == 1;
                    ScProduction scProduction = productionList.get(0);
                    production.setId(scProduction.getId());
                    production.setLastUnitPrice(scBox.getSinglePrice());
                    scProductionService.save(production);
                }
            }

            // 保存或更新调拨工厂
            Office allotFactory = scBox.getAllotFactory();
            if (null != allotFactory) {
                String name = allotFactory.getName();
                if (StringUtils.isNotBlank(name)) {
                    Office paramOffice = new Office();
                    paramOffice.setName(name);
                    List<Office> officeList = officeService.findListByName(name);
                    if (null == officeList || officeList.isEmpty()) {
                        allotFactory.setParent(new Office("9330c28235614c8eb5ed146486612a07")); // 调拨工厂分类
                        allotFactory.setArea(new Area("a9beb8c645ff448d89e71f96dc97bc09")); // 中国
                        allotFactory.setType("1"); // 类别：物流
                        allotFactory.setGrade("3"); // 级别：三级
                        allotFactory.setUseable("1"); // 是否可用：是
                        officeService.save(allotFactory);
                    } else {
                        assert officeList.size() == 1;
                        allotFactory = officeList.get(0);
                        if (!name.equalsIgnoreCase(allotFactory.getName())) {
                            allotFactory.setName(name);
                            officeService.save(allotFactory);
                        }
                    }
                    scBox.setAllotFactory(allotFactory);
                }
            }

            // 生成装箱单编号
//            scBoxService.preAddGenBoxNo(scBox, scOrder.getId());

            // 如果订单备注填写了数据，并且箱子没有填写数据，则采用订单备注
            if (StringUtils.isNotBlank(scOrder.getRemarks())) {
                if (StringUtils.isBlank(scBox.getRemarks())) {
                    scBox.setRemarks(scOrder.getRemarks());
                }
            }
            // 保存装箱单，并更新订单汇总信息
            scBoxService.save(scBox);
        }

        if (0 != num) { // 生成了序列号，并且订单确实保存成功了
            Office.putSerialNumberStatic(officeId, ++num);
        }
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(ScOrder scOrder) {
        super.delete(scOrder);
        scOrder.getScBoxList().forEach(scBox -> scBoxService.delete(new ScBox(scBox.getId())));
    }

    /**
     * 查询选中订单的打印预览的内容
     *
     * @param ids
     * @param printAdjusting
     * @return
     */
    @Transactional(readOnly = false)
    public List<ScBoxItem> findForPrintByOrderIds(String[] ids, String printAdjusting) {
        return super.mapper.findForPrintByOrderIds(ids, printAdjusting);
    }

    @Transactional(readOnly = false)
    public List<ScBoxItem> findForPrintByBoxIds(String[] ids, String printAdjusting) {
        return super.mapper.findForPrintByBoxIds(ids, printAdjusting);
    }

    @Transactional(readOnly = false)
    public List<ScBoxItem> findForPrintByBoxItemIds(String[] ids, String printAdjusting) {
        return super.mapper.findForPrintByBoxItemIds(ids, printAdjusting);
    }

    @Transactional(readOnly = true)
    public List<ScOrder> findReportData(ScOrder scOrder) {
        return this.findList(scOrder);
    }

    @Transactional(readOnly = true)
    public String autoCompleteAgentName(String customId) {
        String officeId = UserUtils.getOfficeDirectly().getId();
        return this.mapper.autoCompleteAgentName(customId,officeId);
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> autoCompleteAgentName2(String customId, String agentName) {
        String officeId = UserUtils.getOfficeDirectly().getId();
        return this.mapper.autoCompleteAgentName2(customId, agentName,officeId);
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> autoCompleteOffice(String customId, String type, String logisticsName) {
        return this.mapper.autoCompleteOffice(customId, type, logisticsName);
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> autoCompleteProductionName(String customId, String productionName) {
        String officeId = null;
        if (!UserUtils.getUser().isAdmin()) {
            officeId = UserUtils.getOfficeDirectly().getId();
        }
        return this.mapper.autoCompleteProductionName(officeId, customId, productionName);
    }

    @Transactional(readOnly = true)
    public Double findLogisticsPrice(String customId, String productionId, Integer weight) {
        return this.mapper.findLogisticsPrice(customId, productionId, weight);
    }

    @Transactional(readOnly = false)
    public LinkedHashMap<String, Object> scanCodeFromPc(String boxItemId) {
        LinkedHashMap<String, Object> map = new LinkedHashMap<>();

        // 1. 根据箱子编号，保存生产开始时间，生产人无法获取（需要从列表中去掉）
        ScBoxItem scBoxItem = scBoxItemService.get(boxItemId);
        Integer process = scBoxItem.getProcess();
        if (process == 2) {// 3 表示生产中
            map.put("success", 1); // success 绿色样式
            map.put("msg", "开始生产中");
            scBoxItem.setProcess(3);
            scBoxItem.setProductionDate(new Date());
            scBoxItemService.save(scBoxItem);
            // 修改订单状态为：生产中
            String boxId = scBoxItem.getBox().getId();
            ScBox scBox = scBoxService.get(boxId);
            String orderId = scBox.getOrder().getId();
            ScOrder scOrder = scOrderService.get(orderId);
            scOrder.setStatus(4);
            scOrderService.save(scOrder);
        } else if (process < 2) {
            map.put("success", 3); // error 错误样式
            map.put("msg", "还未打印装箱单，不允许扫码");
        } else { // >2
            map.put("success", 2); // warn 警告样式
            map.put("msg", "已生产，无需二次扫码");
        }

        // 2. 返回相关数据，用于界面提示
        String boxId = scBoxItem.getBox().getId();
        ScBox scBox = scBoxService.get(boxId);
        scBox.setScBoxItemList(null);

        String orderId = scBox.getOrder().getId();
        ScOrder scOrder = this.get(orderId);
        scOrder.setScBoxList(null);

        map.put("box", scBox);
        map.put("boxItem", scBoxItem);
        map.put("order", scOrder);
        return map;
    }

    public List<OutOrder> findForOutPrintByOrderIds(String[] idArray, String spec) {
        List<OutOrder> boxList = this.mapper.findForOutPrintByOrderIds(idArray, spec);
//        int i = 0;
//        for (OutOrder box : boxList) {
//            box.setNum(++i);
//        }
        return boxList;
    }

    public List<OutOrder> findForOutPrintByBoxIds(String[] idArray) {
        return this.mapper.findForOutPrintByBoxIds(idArray);
    }

    public List<OutOrder> findForOutPrintByBoxItemIds(String[] idArray) {
        return this.mapper.findForOutPrintByBoxItemIds(idArray);
    }

    /**
     * 包装人员扫码处理
     *
     * @param boxItemId
     * @return
     */
    @Transactional(readOnly = false)
    public LinkedHashMap<String, Object> scanCodeFromPackager(String boxItemId) {
        LinkedHashMap<String, Object> map = new LinkedHashMap<>();
        User user = UserUtils.getUser();
        Date now = new Date();

//        1. 判断是否已经生产完毕，否则给予不允许包装提示
        ScBoxItem scBoxItem = scBoxItemService.get(boxItemId);
        if (null == scBoxItem.getProductionDate()) {
//            map.put("type", 1); // error 错误样式
//            map.put("hint", "还未生产，不允许包装人员扫码");
//            return map;
            scBoxItem.setProductionUser(user);
            scBoxItem.setProductionDate(now);
        }

//        2. 如果没有扫码
        boolean isPackagerRole = false;
        List<Role> roleList = user.getRoleList();
        for (Role role : roleList) {
            if (role.getName().contains("包装")) {
                isPackagerRole = true;
            }
        }
//        3. 如果是包装人员角色，判断是否已经上传照片
        if (isPackagerRole) {
//            if (scBoxItem.getProcess() == 4) { // 4 表示包装完毕
//                map.put("type", 3); // error 错误样式
//                map.put("hint", "此件已包装，是否再次扫码？");
//                map.put("boxItemId", boxItemId);
//                return map;
//            }

            //        4. 判断是否已经扫码，如果已经扫码，则返回并给予提示
            if (StringUtils.isNotBlank(scBoxItem.getPhotos())) {
                map.put("type", 3); // error 错误样式
                map.put("hint", "此件已经有照片，是否上传新的照片？");
                map.put("boxItemId", boxItemId);
                return map;
            } else {

//        6. 到此允许扫码，保存扫码人员、扫码时间信息
                scBoxItem.setProcess(4);
                scBoxItem.setPackageUser(user);
                scBoxItem.setPackageDate(now);
                scBoxItemService.save(scBoxItem);

                // 修改订单状态为：已包装
                String boxId = scBoxItem.getBox().getId();
                ScBox scBox = scBoxService.get(boxId);
                String orderId = scBox.getOrder().getId();

                List<Map<String, Object>> maps = scOrderService.executeSelectSql("with t as (select sbi.id, sbi.process\n" +
                        "           from sc_box_item sbi\n" +
                        "                    left join sc_box sb on sbi.box_id = sb.id\n" +
                        "                    left join sc_order so on sb.order_id = so.id\n" +
                        "           where so.id = " + orderId + "),\n" +
                        "     t1 as (select count(t.id) as count\n" +
                        "            from t),\n" +
                        "     t2 as (select count(t.id) as count\n" +
                        "            from t\n" +
                        "            where t.process >= 4)\n" +
                        "select (t1.count - t2.count) as count\n" +
                        "from t2,\n" +
                        "     t1");
                int count = -1;
                try {
                    count = Integer.parseInt(maps.get(0).get("count").toString());
                } catch (Exception e) {
                }

                if (count == 0) { // 全部已包装
                    ScOrder scOrder = scOrderService.get(orderId);
                    scOrder.setStatus(6);
                    scOrderService.save(scOrder);
//                }else{
//                    ScOrder scOrder = scOrderService.get(orderId);
//                    scOrder.setStatus(5);
//                    scOrderService.save(scOrder);
                }

                map.put("type", 2);
                map.put("hint", "扫码成功，请拍照上传");
                map.put("boxItemId", boxItemId);
                return map;
            }
        } else {
//        5. 如果不是包装人员，则直接打开webview展示扫码内容
            map.put("type", 1); // error 错误样式
            map.put("hint", "您不是包装人员，没有操作权限，仅能查看");
            return map;
        }
    }

    /**
     * 快递员角色扫码处理
     *
     * @param boxItemId
     * @return
     */
    @Transactional(readOnly = false)
    public LinkedHashMap<String, Object> scanCodeFromCourier(String boxItemId) {
        LinkedHashMap<String, Object> map = new LinkedHashMap<>();
//        1. 判断是否已经包装完毕，否则给予不允许取件提示
        ScBoxItem scBoxItem = scBoxItemService.get(boxItemId);
        if (scBoxItem.getProcess() < 4) { // 4 表示包装完毕
            map.put("type", 11); // error 错误样式
            map.put("hint", "还未包装完毕，不允许快递人员扫码取货");
            return map;
        }
        if (scBoxItem.getProcess() > 4) { // 4 表示包装完毕
            map.put("type", 11); // error 错误样式
            map.put("hint", "此件已被取，再次扫码无效");
            return map;
        }

//        2. 是否已经扫码过了，或者被其他快递员、快递公司扫码了，如果已经扫码，则返回并给予提示
        User logisticsUser = scBoxItem.getLogisticsUser();
        if (null != logisticsUser && StringUtils.isNotBlank(logisticsUser.getId())) {
            map.put("type", 12); // error 错误样式
            logisticsUser = UserUtils.get(logisticsUser.getId());
            String name = logisticsUser.getCompany().getName();
            map.put("hint", "您不能扫码，已经被" + name + "取件");
            return map;
        }
//        3. 如果没有扫码，则保存快递人员和扫码时间信息
        scBoxItem.setProcess(5);
        scBoxItem.setLogisticsUser(UserUtils.getUser());
        scBoxItem.setLogisticsDate(new Date());
        scBoxItemService.save(scBoxItem);

        // 修改订单状态为：已发货
        String boxId = scBoxItem.getBox().getId();
        ScBox scBox = scBoxService.get(boxId);
        String orderId = scBox.getOrder().getId();
        ScOrder scOrder = scOrderService.get(orderId);
        scOrder.setStatus(8);
        scOrderService.save(scOrder);

//        4. 返回签收成功信息
        map.put("type", 13);
        map.put("hint", "扫码成功，请取件");
        map.put("boxItemId", boxItemId);
        return map;
    }

    @Transactional(readOnly = false)
    public void executePrintBoxOrder(String ids) {
        String userId = UserUtils.getUser().getId();
        String dateTime = DateUtils.getDateTime();
        scBoxItemService.executeUpdateSql("UPDATE sc_box_item sbi set sbi.process=2, sbi.print_user_id = '" + userId + "',sbi.print_date='" + dateTime + "' WHERE sbi.id in (" + ids + ")");

        // 修改订单状态为：已打印
        if (StringUtils.isNotBlank(ids)) {
            String[] split = ids.split(",");
            for (String boxItemId : split) {
                ScBoxItem scBoxItem = scBoxItemService.get(boxItemId);
                ScBox scBox = scBoxService.get(scBoxItem.getBox().getId());
                ScOrder scOrder = scOrderService.get(scBox.getOrder().getId());
                scOrder.setStatus(2); // 2 表示已打印
                scOrderService.saveOwner(scOrder);
            }
        }
    }
}