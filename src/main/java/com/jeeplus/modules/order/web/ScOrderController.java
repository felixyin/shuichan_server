/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.order.web;

import com.google.common.collect.Lists;
import com.jeeplus.common.config.Global;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.common.json.PrintJSON;
import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.excel.ExportExcel;
import com.jeeplus.common.utils.excel.ImportExcel;
import com.jeeplus.common.utils.text.Charsets;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.modules.boxitem.entity.ScBoxItem;
import com.jeeplus.modules.oimport.entity.ScOrderImport;
import com.jeeplus.modules.order.entity.*;
import com.jeeplus.modules.order.service.ScOrderService;
import com.jeeplus.modules.pay.service.ScPayService;
import com.jeeplus.modules.setting.entity.ScSettingBoxOrderPrint;
import com.jeeplus.modules.setting.entity.ScSettingOutOrderPrint;
import com.jeeplus.modules.setting.service.ScSettingBoxOrderPrintService;
import com.jeeplus.modules.setting.service.ScSettingOutOrderPrintService;
import com.jeeplus.modules.sys.entity.Office;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.*;

//import org.jxls.common.Context;
//import org.jxls.util.JxlsHelper;

/**
 * 订单Controller
 *
 * @author 尹彬
 * @version 2019-08-09
 */
@Controller
@RequestMapping(value = "${adminPath}/order/scOrder")
public class ScOrderController extends BaseController {

    @Resource
    protected ScOrderService scOrderService;

    @Resource
    private ScPayService scPayService;

    @ModelAttribute
    public ScOrder get(@RequestParam(required = false) String id) {
        ScOrder entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = scOrderService.get(id);
        }
        if (entity == null) {
            entity = new ScOrder();
        }
        return entity;
    }

    /**
     * 订单列表页面
     */
    @RequiresPermissions("order:scOrder:list")
    @RequestMapping(value = {"list", ""})
    public String list(ScOrder scOrder, Model model) {
        model.addAttribute("scOrder", scOrder);
        SettingTable fromCache = SettingTable.getFromCache();
        model.addAttribute("settingTable", fromCache);
        return "modules/order/scOrderList";
    }

    /**
     * 订单列表数据
     */
    @ResponseBody
    @RequiresPermissions("order:scOrder:list")
    @RequestMapping(value = "data")
    public Map<String, Object> data(ScOrder scOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
        /*if (null == scOrder.getCreateDate()) {
            Date nowDate = new Date();
            scOrder.setCreateDate(nowDate);
            scOrder.setBeginCreateDate(nowDate);
            scOrder.setEndCreateDate(nowDate);
        }*/
        Date now = new Date();
        if (null == scOrder.getBeginCreateDate()) {
            scOrder.setBeginCreateDate(now);
        }
        if (null == scOrder.getEndCreateDate()) {
            scOrder.setEndCreateDate(now);
        }
        Page<ScOrder> page = scOrderService.findPage(new Page<ScOrder>(request, response), scOrder);
        return getBootstrapData(page);
    }

    /**
     * 查看，增加，编辑订单表单页面
     */
    @RequiresPermissions(value = {"order:scOrder:view", "order:scOrder:add", "order:scOrder:edit"}, logical = Logical.OR)
    @RequestMapping(value = "form/{mode}")
    public String form(@PathVariable String mode, ScOrder scOrder, Model model) {
        // 默认加工厂为当前用户登录的工厂
        if ("add".equalsIgnoreCase(mode)) {
            scOrder.setShift(4); // 班次为：随时取
            scOrder.setStatus(1); // 状态为：已下单
            scOrder.setTomorrowCancellation(1); // 作废并不创建新订单
            scOrder.setFactory(UserUtils.getOfficeDirectly());
            return "modules/order/scOrderQuickForm";
        }
        model.addAttribute("mode", mode);
        model.addAttribute("scOrder", scOrder);
        return "modules/order/scOrderForm";
    }


    /**
     * 保存订单
     */
    @ResponseBody
    @RequiresPermissions(value = {"order:scOrder:add", "order:scOrder:edit"}, logical = Logical.OR)
    @RequestMapping(value = "save")
    public AjaxJson save(ScOrder scOrder, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
        /**
         * 后台hibernate-validation插件校验
         */
        String errMsg = beanValidator(scOrder);
        if (StringUtils.isNotBlank(errMsg)) {
            j.setSuccess(false);
            j.setMsg(errMsg);
            return j;
        }
        //新增或编辑表单保存
        scOrderService.save(scOrder);//保存
        j.setSuccess(true);
        j.setMsg(scOrder.getId());
        return j;
    }

    /**
     * 保存订单 和 包装箱
     */
    @ResponseBody
    @RequiresPermissions(value = {"order:scOrder:add", "order:scOrder:edit"}, logical = Logical.OR)
    @RequestMapping(value = "saveAll")
    public AjaxJson saveAll(ScOrder scOrder, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
        /**
         * 后台hibernate-validation插件校验
         */
        String errMsg = beanValidator(scOrder);
        if (StringUtils.isNotBlank(errMsg)) {
            j.setSuccess(false);
            j.setMsg(errMsg);
            return j;
        }
        //新增或编辑表单保存
        scOrderService.saveAll(scOrder);//保存
        j.setSuccess(true);
        j.setMsg(scOrder.getId());
        return j;
    }

    /**
     * 保存订单 和 包装箱
     */
    @ResponseBody
    @RequiresPermissions(value = {"order:scOrder:add", "order:scOrder:edit"}, logical = Logical.OR)
    @RequestMapping(value = "saveOrder")
    public AjaxJson saveOrder(ScOrder scOrder, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
        /**
         * 后台hibernate-validation插件校验
         */
        String errMsg = beanValidator(scOrder);
        if (StringUtils.isNotBlank(errMsg)) {
            j.setSuccess(false);
            j.setMsg(errMsg);
            return j;
        }
        scOrderService.saveOrder(scOrder);
        //新增或编辑表单保存
        j.setSuccess(true);
        j.setMsg(scOrder.getId());
        return j;
    }

    /**
     * 删除订单
     */
    @ResponseBody
    @RequiresPermissions("order:scOrder:del")
    @RequestMapping(value = "delete")
    public AjaxJson delete(ScOrder scOrder) {
        AjaxJson j = new AjaxJson();
        scOrderService.delete(scOrder);
        j.setMsg("删除订单成功");
        return j;
    }

    /**
     * 批量删除订单
     */
    @ResponseBody
    @RequiresPermissions("order:scOrder:del")
    @RequestMapping(value = "deleteAll")
    public AjaxJson deleteAll(String ids) {
        AjaxJson j = new AjaxJson();
        String[] idArray = ids.split(",");
        for (String id : idArray) {
            if (StringUtils.isBlank(id)) {
                continue;
            }
            scOrderService.delete(scOrderService.get(id));
        }
        j.setMsg("删除订单成功");
        return j;
    }

    /**
     * 导出excel文件
     */
    @ResponseBody
    @RequiresPermissions("order:scOrder:export")
    @RequestMapping(value = "_export")
    public AjaxJson _exportFile(ScOrder scOrder, HttpServletRequest request, HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "订单" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
            Page<ScOrder> page = scOrderService.findPage(new Page<ScOrder>(request, response, -1), scOrder);
            new ExportExcel("订单", ScOrder.class).setDataList(page.getList()).write(response, fileName).dispose();
            j.setSuccess(true);
            j.setMsg("导出成功！");
            return j;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导出订单记录失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 导出excel文件
     *//*
    @RequiresPermissions("order:scOrder:export")
    @RequestMapping(value = "export")
    public void exportFile(ScOrder scOrder, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String fileSuffix = "";
        Date deliverDate = scOrder.getDeliverDate();

        if (null != deliverDate) {
            fileSuffix = DateUtils.formatDate(deliverDate, "YYYY年MM月DD日-");
        }
        String fileName = "导出订单-" + fileSuffix + DateUtils.getDate("ddHHmmss") + ".xlsx";

        response.reset();
        response.setContentType("application/octet-stream; charset=utf-8");
        response.setHeader("Content-Disposition", "attachment; filename=" + Encodes.urlEncode(fileName));

//         1、根据搜索条件查询数据
        List<ScOrder> scOrderList = scOrderService.findReportData(scOrder);

//         2、导入模板，下载
        Context context = new Context();
        context.putVar("soList", scOrderList);
        context.putVar("monthStr", fileSuffix);
        JxlsHelper.getInstance().processTemplate(this.getClass().getResourceAsStream("/template1.xlsx"), response.getOutputStream(), context);
    }*/
    @ResponseBody
    @RequestMapping(value = "detail")
    public ScOrder detail(String id) {
        return scOrderService.get(id);
    }


    /**
     * 导入Excel数据
     */
    @ResponseBody
    @RequiresPermissions("order:scOrder:import")
    @RequestMapping(value = "import")
    public AjaxJson importFile(@RequestParam("file") MultipartFile file, HttpServletResponse response, HttpServletRequest request) {
        AjaxJson j = new AjaxJson();
        try {
            int successNum = 0;
            int failureNum = 0;
            StringBuilder failureMsg = new StringBuilder();
            ImportExcel ei = new ImportExcel(file, 1, 0);
            List<ScOrder> list = ei.getDataList(ScOrder.class);
            for (ScOrder scOrder : list) {
                try {
                    scOrderService.save(scOrder);
                    successNum++;
                } catch (ConstraintViolationException ex) {
                    failureNum++;
                } catch (Exception ex) {
                    failureNum++;
                }
            }
            if (failureNum > 0) {
                failureMsg.insert(0, "，失败 " + failureNum + " 条订单记录。");
            }
            j.setMsg("已成功导入 " + successNum + " 条订单记录" + failureMsg);
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入订单失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 下载导入订单数据模板
     */
    @ResponseBody
    @RequiresPermissions("order:scOrder:import")
    @RequestMapping(value = "import/template")
    public AjaxJson importFileTemplate(HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "订单数据导入模板.xlsx";
            List<ScOrder> list = Lists.newArrayList();
            new ExportExcel("订单数据", ScOrderImport.class, 1).setDataList(list).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入模板下载失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 打印装箱单
     */
    @RequiresPermissions(value = {"order:scOrder:printBoxOrder"})
    @RequestMapping(value = "printBoxOrder")
    public String printBoxOrder(String ids, Integer type, Model model) {
        // 从缓存中取出设置，如果没有则初始化装箱单设置
        ScSettingBoxOrderPrint setting = scSettingBoxOrderPrintService.loadSettingBoxOrderPrint();

        model.addAttribute("setting", setting);

        System.out.println(type);

        if (StringUtils.isNotBlank(ids)) {
            String[] idArray = ids.split(",");

            // 查询装箱单打印需要的数据，用于显示打印预览界面
            switch (type) {
                case 1:
                    List<ScBoxItem> boxItemList = scOrderService.findForPrintByOrderIds(idArray, setting.getPrintAdjusting());
                    model.addAttribute("boxItemList", boxItemList);
                    setBoxItemIdsStr(model, boxItemList);
                    break;
                case 2:
                    List<ScBoxItem> scOrderList2 = scOrderService.findForPrintByBoxIds(idArray, setting.getPrintAdjusting());
                    model.addAttribute("boxItemList", scOrderList2);
                    setBoxItemIdsStr(model, scOrderList2);
                    break;
                case 3:
                    List<ScBoxItem> scOrderList3 = scOrderService.findForPrintByBoxItemIds(idArray, setting.getPrintAdjusting());
                    model.addAttribute("boxItemList", scOrderList3);
                    setBoxItemIdsStr(model, scOrderList3);
                    break;
                default:
                    System.out.println("--");
            }
            model.addAttribute("hostAndPort", Global.getConfig("hostAndPort"));
        }

        String printType = setting.getPrintType();
        if ("1".equalsIgnoreCase(printType)) {
            return "modules/order/print/printLabelBoxOrder";
        } else {
            return "modules/order/print/printBoxOrder";
        }
    }

    private void setBoxItemIdsStr(Model model, List<ScBoxItem> boxItemList) {
        List<String> boxItemIds = new ArrayList<>();
        for (ScBoxItem scBoxItem : boxItemList) {
            boxItemIds.add(scBoxItem.getId());
        }
        String boxItemIdsStr = StringUtils.join(boxItemIds, ",");
        model.addAttribute("boxItemIdsStr", boxItemIdsStr);
    }

    @ResponseBody
    @RequiresPermissions("order:scOrder:printBoxOrder")
    @RequestMapping(value = "executePrintBoxOrder")
    public AjaxJson executePrintBoxOrder(String ids) {
        AjaxJson j = new AjaxJson();
        try {
            if (StringUtils.isNotBlank(ids)) {
                scOrderService.executePrintBoxOrder(ids);
            }
            j.setSuccess(true);
            j.setMsg("保存打印人和打印时间成功！");
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("保存打印人和打印时间失败：" + e.getMessage());
        }
        return j;
    }


    /**
     * 打印出货单
     */
    @RequiresPermissions(value = {"order:scOrder:printOutOrder"})
    @RequestMapping(value = "printOutOrder")
    public String printOutOrder(String ids, Integer type, String shouldLogistics, String shift, Model model) {
        // 从缓存中取出设置，如果没有则初始化装箱单设置
        ScSettingOutOrderPrint setting = scSettingOutOrderPrintService.loadSettingOutOrderPrint();
        model.addAttribute("setting", setting);
        model.addAttribute("ids", ids);
        model.addAttribute("shouldLogistics", shouldLogistics);
        model.addAttribute("shift", shift);
        model.addAttribute("nowDate", DateUtils.getDate());
        return "modules/order/printout/printOutOrder";
    }

    /**
     * 订单列表数据
     */
    @ResponseBody
    @RequiresPermissions("order:scOrder:printOutOrder")
    @RequestMapping(value = "outOrderData")
    public Map<String, Object> outOrderData(String ids, HttpServletRequest request, HttpServletResponse response, Model model) {
        String[] idArray = ids.split(",");
        Page<OutOrder> page1 = new Page<>(request, response);
        page1.setPageSize(1000000);
        ScSettingOutOrderPrint setting = scSettingOutOrderPrintService.loadSettingOutOrderPrint();
        Page<OutOrder> page = scOrderService.findPageForOurOrder(page1, idArray, setting.getSpec());
        return getBootstrapData(page);
    }

    /**
     * 手机扫描装箱单二维码，分两种情况：微信、手机APP
     */
//    @RequiresPermissions(value = {"order:scOrder:scanBoxOrder"})
    @RequestMapping(value = "scanBoxOrder")
    public void scanBoxOrder(String boxItemId, String device, HttpServletResponse response, HttpServletRequest request) throws ServletException, IOException {
        System.out.println(boxItemId + ":" + device);

        // todo 该用直接传参的方式区分 不同设备
        if ("pc".equalsIgnoreCase(device)) { // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 扫描枪扫码
            LinkedHashMap<String, Object> map = scOrderService.scanCodeFromPc(boxItemId);
            AjaxJson j = new AjaxJson();
            j.setMsg("ok");
            j.setBody(map);
            PrintJSON.write(response, j.getJsonStr());
        } else if ("app".equalsIgnoreCase(device)) { // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> app 扫码
            // 区分包装人员、快递人员
//            List<Role> roleList = UserUtils.getRoleList();
//            for (Role role : roleList) {
//            }
            Office officeDirectly = UserUtils.getOfficeDirectly();
            if ("1".equals(officeDirectly.getType())) { // 加工厂  包装人员扫码
                LinkedHashMap<String, Object> map = scOrderService.scanCodeFromPackager(boxItemId);
                AjaxJson j = new AjaxJson();
                j.setMsg("ok");
                j.setBody(map);
                PrintJSON.write(response, j.getJsonStr());
            } else if ("2".equals(officeDirectly.getType())) { // 物流公司 快递人员扫码
                LinkedHashMap<String, Object> map = scOrderService.scanCodeFromCourier(boxItemId);
                AjaxJson j = new AjaxJson();
                j.setMsg("ok");
                j.setBody(map);
                PrintJSON.write(response, j.getJsonStr());
            }
        } else { // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 微信、QQ等其他应用
            // 从缓存中取出设置，如果没有则初始化装箱单设置
            ScSettingBoxOrderPrint setting = scSettingBoxOrderPrintService.loadSettingBoxOrderPrint();
            request.setAttribute("setting", setting);

            String[] idArray = new String[]{boxItemId};
            List<ScBoxItem> scOrderList3 = scOrderService.findForPrintByBoxItemIds(idArray, setting.getPrintAdjusting());
            request.setAttribute("boxItemList", scOrderList3);
            request.getRequestDispatcher("/webpage/modules/order/print/scanBoxOrder.jsp").forward(request, response);
        }
    }


    /**
     * 跳转 打印装箱单 设置
     */
    @RequiresPermissions(value = {"order:scOrder:printBoxOrder"})
    @RequestMapping(value = "settingBoxOrder")
    public String settingBoxOrder(Model model) {
        return "modules/order/print/settingBoxOrder";
    }

    /**
     * 跳转 打印装箱单 设置
     */
    @RequiresPermissions(value = {"order:scOrder:printOutOrder"})
    @RequestMapping(value = "settingOutOrder")
    public String settingOutOrder(Model model) {
        return "modules/order/printout/settingOutOrder";
    }

    @Autowired
    private ScSettingBoxOrderPrintService scSettingBoxOrderPrintService;

    @Autowired
    private ScSettingOutOrderPrintService scSettingOutOrderPrintService;

    /**
     * 保存 打印装箱单 设置
     */
    @ResponseBody
    @RequiresPermissions(value = {"order:scOrder:printBoxOrder"})
    @RequestMapping(value = "saveSettingBoxOrderPrint")
    public AjaxJson saveSettingBoxOrderPrint(ScSettingBoxOrderPrint settingBoxOrderPrint, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
//        System.out.println(settingBoxOrderPrint);
        // 保存到缓存服务器，不需要存储数据库
//        SettingBoxOrderPrint.setToCache(settingBoxOrderPrint);
        scSettingBoxOrderPrintService.saveSettingBoxOrderPrint(settingBoxOrderPrint);

        j.setSuccess(true);
        j.setMsg("保存装箱单打印设置成功");
        return j;
    }

    /**
     * 保存 打印装箱单 设置
     */
    @ResponseBody
    @RequiresPermissions(value = {"order:scOrder:printBoxOrder"})
    @RequestMapping(value = "loadSettingBoxOrderPrint")
    public AjaxJson loadSettingBoxOrderPrint( Model model) throws Exception {
        AjaxJson j = new AjaxJson();
//        System.out.println(settingBoxOrderPrint);
        // 保存到缓存服务器，不需要存储数据库
//        SettingBoxOrderPrint fromCache = SettingBoxOrderPrint.getFromCache();
        ScSettingBoxOrderPrint scSettingBoxOrderPrint = scSettingBoxOrderPrintService.loadSettingBoxOrderPrint();

        j.setSuccess(true);
        LinkedHashMap<String, Object> map = new LinkedHashMap<>();
        map.put("setting", scSettingBoxOrderPrint);
        j.setBody(map);
        j.setMsg("查询装箱单打印设置成功");
        return j;
    }

    /**
     * 保存 出货单 设置
     */
    @ResponseBody
    @RequiresPermissions(value = {"order:scOrder:printOutOrder"})
    @RequestMapping(value = "saveSettingOutOrderPrint")
    public AjaxJson saveSettingOutOrderPrint(ScSettingOutOrderPrint settingOutOrderPrint, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
//        System.out.println(settingBoxOrderPrint);
        // 保存到缓存服务器，不需要存储数据库
//        SettingOutOrderPrint.setToCache(settingOutOrderPrint);
        scSettingOutOrderPrintService.saveSettingOutOrderPrint(settingOutOrderPrint);

        j.setSuccess(true);
        j.setMsg("保存装箱单打印设置成功");
        return j;
    }

    /**
     * 保存 出货单 设置
     */
    @ResponseBody
    @RequiresPermissions(value = {"order:scOrder:printOutOrder"})
    @RequestMapping(value = "loadSettingOutOrderPrint")
    public AjaxJson loadSettingOutOrderPrint(Model model) throws Exception {
        AjaxJson j = new AjaxJson();
//        System.out.println(settingBoxOrderPrint);
        // 保存到缓存服务器，不需要存储数据库
//        SettingOutOrderPrint fromCache = SettingOutOrderPrint.getFromCache();
        ScSettingOutOrderPrint scSettingOutOrderPrint =  scSettingOutOrderPrintService.loadSettingOutOrderPrint();

        j.setSuccess(true);
        LinkedHashMap<String, Object> map = new LinkedHashMap<>();
        map.put("setting", scSettingOutOrderPrint);
        j.setBody(map);
        j.setMsg("保存出货单打印设置成功");
        return j;
    }

    /**
     * 根据选择的客户，从历史订单中获取代理人姓名
     */
    @ResponseBody
    @RequestMapping(value = "autoCompleteAgentName")
    public AjaxJson autoCompleteAgentName(String customId, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
        String agentName = scOrderService.autoCompleteAgentName(customId);
        j.setSuccess(true);
        j.setMsg(agentName);
        return j;
    }


    /**
     * 根据选择的客户，从历史订单中获取代理人姓名
     */
    @ResponseBody
    @RequestMapping(value = "autoCompleteAgentName2")
    public List<Map<String, Object>> autoCompleteAgentName2(String customId, String agentName, Model model) throws Exception {
        agentName = URLDecoder.decode(agentName, Charsets.UTF_8_NAME).trim();
        List<Map<String, Object>> list = scOrderService.autoCompleteAgentName2(customId, agentName);
        return list;
    }

    /**
     * 根据选择的客户，从历史订单中获取代理人姓名
     *
     * @param customId
     * @param type       1 表示工厂，2表示物流公司
     * @param officeName
     * @param model
     * @return
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "autoCompleteOffice")
    public List<Map<String, Object>> autoCompleteOffice(String customId, String type, String officeName, Model model) throws Exception {
        officeName = URLDecoder.decode(officeName, Charsets.UTF_8_NAME).trim();
        List<Map<String, Object>> list = scOrderService.autoCompleteOffice(customId, type, officeName);
//        // 当自动完成的是工厂，去掉当前工厂
//        if ("1".equals(type)) {
//            Office officeDirectly = UserUtils.getOfficeDirectly();
//            for (Map<String, Object> map: list) {
//
//            }
//        }
        return list;
    }

    /**
     * 根据选择的客户，从历史订单中获取规格
     */
    @ResponseBody
    @RequestMapping(value = "autoCompleteProductionName")
    public List<Map<String, Object>> autoCompleteProductionName(String customId, String productionName, Model model) throws Exception {
        productionName = URLDecoder.decode(productionName, Charsets.UTF_8_NAME).trim();
        List<Map<String, Object>> list = scOrderService.autoCompleteProductionName(customId, productionName);
        return list;
    }


    /**
     * 表格设置
     */
    @RequiresPermissions(value = {"order:scOrder:settingTable"})
    @RequestMapping(value = "settingTable")
    public String settingTable(Model model) {
        return "modules/order/setting/settingTable";
    }

    /**
     * 保存 表格  设置
     */
    @ResponseBody
    @RequiresPermissions(value = {"order:scOrder:settingTable"})
    @RequestMapping(value = "saveSettingTable")
    public AjaxJson saveSettingTable(SettingTable settingTable, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
//        System.out.println(settingTable);
        // 保存到缓存服务器，不需要存储数据库
        SettingTable.setToCache(settingTable);
        j.setSuccess(true);
        j.setMsg("保存表格设置成功");
        return j;
    }

    /**
     * 保存 表格  设置
     */
    @ResponseBody
    @RequiresPermissions(value = {"order:scOrder:settingTable"})
    @RequestMapping(value = "loadSettingTable")
    public AjaxJson loadSettingTable(Model model) throws Exception {
        AjaxJson j = new AjaxJson();
//        System.out.println(settingTable);
        // 保存到缓存服务器，不需要存储数据库
        SettingTable fromCache = SettingTable.getFromCache();
        j.setSuccess(true);
        LinkedHashMap<String, Object> map = new LinkedHashMap<>();
        map.put("setting", fromCache);
        j.setBody(map);
        j.setMsg("保存表格设置成功");
        return j;
    }

    /**
     * 从历史订单中获取此客户地址、规格、重量对应的单箱快递费用 ，规格可选
     */
    @ResponseBody
    @RequestMapping(value = "findLogisticsPrice")
    public AjaxJson findLogisticsPrice(String customId, String productionId, Integer weight, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
        Double logisticsPrice = scOrderService.findLogisticsPrice(customId, productionId, weight);
        if (null == logisticsPrice) {
            j.setMsg("");
        } else {
            j.setMsg(logisticsPrice + "");
        }
        j.setSuccess(true);
        return j;
    }

}