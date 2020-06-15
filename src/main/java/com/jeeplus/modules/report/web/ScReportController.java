/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.report.web;

import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.modules.order.entity.ScOrder;
import com.jeeplus.modules.order.web.ScOrderController;
import com.jeeplus.modules.report.service.ScReportService;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 统计分析Controller
 *
 * @author 尹彬
 * @version 2019-08-09
 */
@Controller
@RequestMapping(value = "${adminPath}/report/scReport")
public class ScReportController extends ScOrderController {

    @Resource
    private ScReportService scReportService;

    /**
     * 订单列表页面
     */
    @Override
    @RequiresPermissions("report:scReport:list")
    @RequestMapping(value = {"list", ""})
    public String list(ScOrder scOrder, Model model) {
        scOrder.setCreateDate(new Date());
        model.addAttribute("scOrder", scOrder);
        return "modules/report/scOrderList";
    }

    /**
     * 订单列表数据
     */
    @Override
    @ResponseBody
    @RequiresPermissions("report:scReport:list")
    @RequestMapping(value = "data")
    public Map<String, Object> data(ScOrder scOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<ScOrder> page = scOrderService.findPage2(new Page<ScOrder>(request, response), scOrder);
        return getBootstrapData(page);
    }

    /**
     * 查看，增加，编辑订单表单页面
     */
    @Override
    @RequiresPermissions(value = {"report:scReport:view", "report:scReport:add", "report:scReport:edit"}, logical = Logical.OR)
    @RequestMapping(value = "form/{mode}")
    public String form(@PathVariable String mode, ScOrder scOrder, Model model) {
        model.addAttribute("mode", mode);
        model.addAttribute("scOrder", scOrder);
        return "modules/report/scOrderForm";
    }

    /**
     * 出货统计页面
     */
    @RequiresPermissions("report:scReport:goToChuHuoReportPage")
    @RequestMapping(value = {"goToChuHuoReportPage"})
    public String goToChuHuoReportPage(Model model) {
        model.addAttribute("beginDate", new Date());
        return "modules/report/scChuHuoList";
    }

    /**
     * 出货统计列表
     */
    @ResponseBody
    @RequiresPermissions("report:scReport:findChuHuoReportList")
    @RequestMapping(value = "findChuHuoReportList")
    public Map<String, Object> findChuHuoReportList(String specName, String beginDate, String endDate, String orderBy) {
        String date = DateUtils.getDate();
        if(StringUtils.isBlank(beginDate)){
            beginDate = date;
        }
        if (StringUtils.isBlank(endDate)) {
            endDate = date;
        }
        List<Map<String, Object>> page = scReportService.findChuHuoReportList(specName, beginDate, endDate, orderBy);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("rows", page);
        map.put("total", page.size());
        return map;
    }

    /**
     * 出货统计列表
     */
    @ResponseBody
    @RequiresPermissions("report:scReport:findChuHuoItemList")
    @RequestMapping(value = "findChuHuoItemList")
    public Map<String, Object> findChuHuoItemList(String specId, Integer daiYiStatus, String beginDate, String endDate, String orderBy) {
        List<Map<String, Object>> page = scReportService.findChuHuoItemList(specId, daiYiStatus, beginDate, endDate, orderBy);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("rows", page);
        map.put("total", page.size());
        return map;
    }


    /**
     * 下单统计页面
     */
    @RequiresPermissions("report:scReport:goToXiaDanReportPage")
    @RequestMapping(value = {"goToXiaDanReportPage"})
    public String goToXiaDanReportPage(Model model) {
        model.addAttribute("beginDate", new Date());
        return "modules/report/scXiaDanList";
    }


    /**
     * 出货统计列表
     */
    @ResponseBody
    @RequiresPermissions("report:scReport:findXiaDanReportList")
    @RequestMapping(value = "findXiaDanReportList")
    public Map<String, Object> findXiaDanReportList(String specName, String agentName, String beginDate, String endDate, String orderBy) {
        String date = DateUtils.getDate();
        if(StringUtils.isBlank(beginDate)){
            beginDate = date;
        }
        if (StringUtils.isBlank(endDate)) {
            endDate = date;
        }
        List<Map<String, Object>> page = scReportService.findXiaDanReportList(specName, agentName, beginDate, endDate, orderBy);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("rows", page);
        map.put("total", page.size());
        return map;
    }

    /**
     * 出货统计  子列表
     */
    @ResponseBody
    @RequiresPermissions("report:scReport:findXiaDanItemList")
    @RequestMapping(value = "findXiaDanItemList")
    public Map<String, Object> findXiaDanItemList(String specId, String specName, String agentName, Integer daiYiStatus, String beginDate, String endDate, String orderBy) {
        List<Map<String, Object>> page = scReportService.findXiaDanItemList(specId, specName, agentName, daiYiStatus, beginDate, endDate, orderBy);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("rows", page);
        map.put("total", page.size());
        return map;
    }

    /**
     * 财务页面
     */
    @RequiresPermissions("report:scReport:goToCaiWuReportPage")
    @RequestMapping(value = {"goToCaiWuReportPage"})
    public String goToCaiWuReportPage(Model model) {
        model.addAttribute("beginDate", new Date());
        return "modules/report/scCaiWuList";
    }

    /**
     * 财务统计
     */
    @ResponseBody
    @RequiresPermissions("report:scReport:findCaiWuReportList")
    @RequestMapping(value = "findCaiWuReportList")
    public Map<String, Object> findCaiWuReportList(String agentName, String beginDate, String endDate, String payStatus, String orderBy) {
        String date = DateUtils.getDate();
        if(StringUtils.isBlank(beginDate)){
            beginDate = date;
        }
        if (StringUtils.isBlank(endDate)) {
            endDate = date;
        }
        List<Map<String, Object>> page = scReportService.findCaiWuList(agentName, beginDate, endDate, payStatus, orderBy);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("rows", page);
        map.put("total", page.size());
        return map;
    }


    /**
     * 财务统计 子列表
     */
    @ResponseBody
    @RequiresPermissions("report:scReport:findCaiWuItemReportList")
    @RequestMapping(value = "findCaiWuItemReportList")
    public Map<String, Object> findCaiWuItemReportList(String agentName, String date, String endDate, String orderBy) {
        List<Map<String, Object>> page = scReportService.findCaiWuItemList(agentName, date, orderBy);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("rows", page);
        map.put("total", page.size());
        return map;
    }

    /**
     * 保存某代理人某天的实付金额
     *
     * @param agent_name
     * @param deliver_date
     * @param real_pay_price
     * @return
     */
    @ResponseBody
    @RequiresPermissions("report:scReport:saveRealPayPrice")
    @RequestMapping(value = "saveRealPayPrice")
    public boolean saveRealPayPrice(String agent_name, String deliver_date, Float real_pay_price) {
        return scReportService.saveRealPayPrice(agent_name, deliver_date, real_pay_price);
    }


    /**
     * 工厂物流统计 页面
     */
    @RequiresPermissions("report:scReport:goToFactoryWuLiuReportPage")
    @RequestMapping(value = {"goToFactoryWuLiuReportPage"})
    public String goToFactoryWuLiuReportPage(Model model) {
        model.addAttribute("beginDate", new Date());
        return "modules/report/scFactoryWuLiuList";
    }

    /**
     * 工厂物流统计
     */
    @ResponseBody
    @RequiresPermissions("report:scReport:findFactoryWuLiuReportList")
    @RequestMapping(value = "findFactoryWuLiuReportList")
    public Map<String, Object> findFactoryWuLiuReportList(String logisticsName, String beginDate, String endDate, String payStatus, String orderBy) {
        String date = DateUtils.getDate();
        if(StringUtils.isBlank(beginDate)){
            beginDate = date;
        }
        if (StringUtils.isBlank(endDate)) {
            endDate = date;
        }
        List<Map<String, Object>> page = scReportService.findFactoryWuLiuList(logisticsName, beginDate, endDate, payStatus, orderBy);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("rows", page);
        map.put("total", page.size());
        return map;
    }

    /**
     * 工厂物流统计 子列表
     */
    @ResponseBody
    @RequiresPermissions("report:scReport:findFactoryWuLiuItemReportList")
    @RequestMapping(value = "findFactoryWuLiuItemReportList")
    public Map<String, Object> findFactoryWuLiuItemReportList(String logisticsName, String date, String payStatus, String orderBy) {
        List<Map<String, Object>> page = scReportService.findFactoryWuLiuItemList(logisticsName, date, payStatus, orderBy);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("rows", page);
        map.put("total", page.size());
        return map;
    }


    /**
     * 工厂物流统计 页面
     */
    @RequiresPermissions("report:scReport:goToWuLiuReportPage")
    @RequestMapping(value = {"goToWuLiuReportPage"})
    public String goToWuLiuReportPage(Model model) {
        model.addAttribute("beginDate", new Date());
        return "modules/report/scWuLiuList";
    }

    /**
     * 工厂物流统计
     */
    @ResponseBody
    @RequiresPermissions("report:scReport:findWuLiuReportList")
    @RequestMapping(value = "findWuLiuReportList")
    public Map<String, Object> findWuLiuReportList(String logisticsName, String beginDate, String endDate, String payStatus, String diaoStatus, String orderBy) {
        String date = DateUtils.getDate();
        if(StringUtils.isBlank(beginDate)){
            beginDate = date;
        }
        if (StringUtils.isBlank(endDate)) {
            endDate = date;
        }
        List<Map<String, Object>> page = scReportService.findWuLiuList(logisticsName, beginDate, endDate, payStatus, diaoStatus, orderBy);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("rows", page);
        map.put("total", page.size());
        return map;
    }

    /**
     * 工厂物流统计 子列表
     */
    @ResponseBody
    @RequiresPermissions("report:scReport:findWuLiuItemReportList")
    @RequestMapping(value = "findWuLiuItemReportList")
    public Map<String, Object> findWuLiuItemReportList(String logisticsName, String date, String payStatus,String diaoStatus,  String orderBy) {
        List<Map<String, Object>> page = scReportService.findWuLiuItemList(logisticsName, date, payStatus, diaoStatus,orderBy);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("rows", page);
        map.put("total", page.size());
        return map;
    }


    /**
     * 保存某代理人某天的实付金额
     *
     * @return
     */
    @ResponseBody
    @RequiresPermissions("report:scReport:saveFactoryWuLiuPayPrice")
    @RequestMapping(value = "saveFactoryWuLiuPayPrice")
    public boolean saveFactoryWuLiuPayPrice(String factory_id, String logistics_id, String logistics_date, Float real_pay_price) {
        return scReportService.saveWuLiuPayPrice(factory_id, logistics_id, logistics_date, real_pay_price);
    }

    /**
     * 保存某代理人某天的实付金额
     *
     * @return
     */
    @ResponseBody
    @RequiresPermissions("report:scReport:saveWuLiuPayPrice")
    @RequestMapping(value = "saveWuLiuPayPrice")
    public boolean saveWuLiuPayPrice(String factory_id, String logistics_id, String logistics_date, Float real_pay_price) {
        return scReportService.saveWuLiuPayPrice(factory_id, logistics_id, logistics_date, real_pay_price);
    }

}