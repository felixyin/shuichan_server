/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.box.web;

import com.google.common.collect.Lists;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.excel.ExportExcel;
import com.jeeplus.common.utils.excel.ImportExcel;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.modules.box.entity.ScBox;
import com.jeeplus.modules.box.service.ScBoxService;
import com.jeeplus.modules.order.service.ScOrderService;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import java.util.List;
import java.util.Map;

/**
 * 包装箱Controller
 *
 * @author 尹彬
 * @version 2019-08-11
 */
@Controller
@RequestMapping(value = "${adminPath}/box/scBox")
public class ScBoxController extends BaseController {

    @Resource
    private ScBoxService scBoxService;

    @Resource
    private ScOrderService scOrderService;

    @ModelAttribute
    public ScBox get(@RequestParam(required = false) String id) {
        ScBox entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = scBoxService.get(id);
        }
        if (entity == null) {
            entity = new ScBox();
        }
        return entity;
    }

    /**
     * 包装箱列表页面
     */
    @RequiresPermissions("box:scBox:list")
    @RequestMapping(value = {"list", ""})
    public String list(ScBox scBox, Model model) {
        model.addAttribute("scBox", scBox);
        return "modules/box/scBoxList2";
    }

    /**
     * 包装箱列表数据
     */
    @ResponseBody
    @RequiresPermissions("box:scBox:list")
    @RequestMapping(value = "data")
    public Map<String, Object> data(ScBox scBox, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<ScBox> page = scBoxService.findPage(new Page<ScBox>(request, response), scBox);
        return getBootstrapData(page);
    }

    /**
     * 查看，增加，编辑包装箱表单页面
     */
    @RequiresPermissions(value = {"box:scBox:view", "box:scBox:add", "box:scBox:edit"}, logical = Logical.OR)
    @RequestMapping(value = "form/{mode}")
    public String form(@PathVariable String mode, String orderId, ScBox scBox, Model model) {
        model.addAttribute("mode", mode);
        // fixme  增加的情况，需要生成装箱单号，需要测试
//        ScBox scBox1 = scBoxService.preAddGenBoxNo(scBox, orderId);
//        model.addAttribute("scBox", scBox1);
        return "modules/box/scBoxForm";
    }

    /**
     * 保存包装箱
     */
    @ResponseBody
    @RequiresPermissions(value = {"box:scBox:add", "box:scBox:edit"}, logical = Logical.OR)
    @RequestMapping(value = "save")
    public AjaxJson save(ScBox scBox, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
        /**
         * 后台hibernate-validation插件校验
         */
        String errMsg = beanValidator(scBox);
        if (StringUtils.isNotBlank(errMsg)) {
            j.setSuccess(false);
            j.setMsg(errMsg);
            return j;
        }
        //新增或编辑表单保存
        scBoxService.save(scBox);//保存
        j.setSuccess(true);
        j.setMsg(scBox.getId());
        return j;
    }

    /**
     * 删除包装箱
     */
    @ResponseBody
    @RequiresPermissions("box:scBox:del")
    @RequestMapping(value = "delete")
    public AjaxJson delete(ScBox scBox) {
        AjaxJson j = new AjaxJson();
        scBoxService.delete(scBox);
        j.setMsg("删除包装箱成功");
        return j;
    }

    /**
     * 批量删除包装箱
     */
    @ResponseBody
    @RequiresPermissions("box:scBox:del")
    @RequestMapping(value = "deleteAll")
    public AjaxJson deleteAll(String ids) {
        AjaxJson j = new AjaxJson();
        String[] idArray = ids.split(",");
        for (String id : idArray) {
            scBoxService.delete(scBoxService.get(id));
        }
        j.setMsg("删除包装箱成功");
        return j;
    }

    /**
     * 导出excel文件
     */
    @ResponseBody
    @RequiresPermissions("box:scBox:export")
    @RequestMapping(value = "export")
    public AjaxJson exportFile(ScBox scBox, HttpServletRequest request, HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "包装箱" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
            Page<ScBox> page = scBoxService.findPage(new Page<ScBox>(request, response, -1), scBox);
            new ExportExcel("包装箱", ScBox.class).setDataList(page.getList()).write(response, fileName).dispose();
            j.setSuccess(true);
            j.setMsg("导出成功！");
            return j;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导出包装箱记录失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    @ResponseBody
    @RequestMapping(value = "detail")
    public ScBox detail(String id) {
        return scBoxService.get(id);
    }


    /**
     * 导入Excel数据
     */
    @ResponseBody
    @RequiresPermissions("box:scBox:import")
    @RequestMapping(value = "import")
    public AjaxJson importFile(@RequestParam("file") MultipartFile file, HttpServletResponse response, HttpServletRequest request) {
        AjaxJson j = new AjaxJson();
        try {
            int successNum = 0;
            int failureNum = 0;
            StringBuilder failureMsg = new StringBuilder();
            ImportExcel ei = new ImportExcel(file, 1, 0);
            List<ScBox> list = ei.getDataList(ScBox.class);
            for (ScBox scBox : list) {
                try {
                    scBoxService.save(scBox);
                    successNum++;
                } catch (ConstraintViolationException ex) {
                    failureNum++;
                } catch (Exception ex) {
                    failureNum++;
                }
            }
            if (failureNum > 0) {
                failureMsg.insert(0, "，失败 " + failureNum + " 条包装箱记录。");
            }
            j.setMsg("已成功导入 " + successNum + " 条包装箱记录" + failureMsg);
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入包装箱失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 下载导入包装箱数据模板
     */
    @ResponseBody
    @RequiresPermissions("box:scBox:import")
    @RequestMapping(value = "import/template")
    public AjaxJson importFileTemplate(HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "包装箱数据导入模板.xlsx";
            List<ScBox> list = Lists.newArrayList();
            new ExportExcel("包装箱数据", ScBox.class, 1).setDataList(list).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入模板下载失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 扫描装箱单二维码
     */
/*
    @RequestMapping(value = "scanBoxOrder")
    public String scanBoxOrder(ScBox scBox, Model model) {

        SettingBoxOrderPrint setting = SettingBoxOrderPrint.getFromCache();
        model.addAttribute("setting", setting);

        ScOrder scOrder = scBoxService.scanBoxOrder(scBox);
        model.addAttribute("scBoxOrderScan", scOrder);
        return "modules/order/print/scanBoxOrder";
    }
*/


}