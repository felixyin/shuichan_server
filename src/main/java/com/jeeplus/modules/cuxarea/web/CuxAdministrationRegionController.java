/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.cuxarea.web;

import com.google.common.collect.Lists;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.excel.ExportExcel;
import com.jeeplus.common.utils.excel.ImportExcel;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.modules.cuxarea.entity.CuxAdministrationRegion;
import com.jeeplus.modules.cuxarea.service.CuxAdministrationRegionService;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import java.util.List;
import java.util.Map;

/**
 * 导入用区域用Controller
 *
 * @author 尹彬
 * @version 2019-08-01
 */
@Controller
@RequestMapping(value = "${adminPath}/cuxarea/cuxAdministrationRegion")
public class CuxAdministrationRegionController extends BaseController {

    @Autowired
    private CuxAdministrationRegionService cuxAdministrationRegionService;

    @ModelAttribute
    public CuxAdministrationRegion get(@RequestParam(required = false) String id) {
        CuxAdministrationRegion entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = cuxAdministrationRegionService.get(id);
        }
        if (entity == null) {
            entity = new CuxAdministrationRegion();
        }
        return entity;
    }

    /**
     * 导入区域列表页面
     */
    @RequiresPermissions("cuxarea:cuxAdministrationRegion:list")
    @RequestMapping(value = {"list", ""})
    public String list(CuxAdministrationRegion cuxAdministrationRegion, Model model) {
        model.addAttribute("cuxAdministrationRegion", cuxAdministrationRegion);
        return "modules/cuxarea/cuxAdministrationRegionList";
    }

    /**
     * 导入区域列表数据
     */
    @ResponseBody
    @RequiresPermissions("cuxarea:cuxAdministrationRegion:list")
    @RequestMapping(value = "data")
    public Map<String, Object> data(CuxAdministrationRegion cuxAdministrationRegion, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<CuxAdministrationRegion> page = cuxAdministrationRegionService.findPage(new Page<CuxAdministrationRegion>(request, response), cuxAdministrationRegion);
        return getBootstrapData(page);
    }

    /**
     * 查看，增加，编辑导入区域表单页面
     */
    @RequiresPermissions(value = {"cuxarea:cuxAdministrationRegion:view", "cuxarea:cuxAdministrationRegion:add", "cuxarea:cuxAdministrationRegion:edit"}, logical = Logical.OR)
    @RequestMapping(value = "form/{mode}")
    public String form(@PathVariable String mode, CuxAdministrationRegion cuxAdministrationRegion, Model model) {
        model.addAttribute("cuxAdministrationRegion", cuxAdministrationRegion);
        model.addAttribute("mode", mode);
        return "modules/cuxarea/cuxAdministrationRegionForm";
    }

    /**
     * 保存导入区域
     */
    @ResponseBody
    @RequiresPermissions(value = {"cuxarea:cuxAdministrationRegion:add", "cuxarea:cuxAdministrationRegion:edit"}, logical = Logical.OR)
    @RequestMapping(value = "save")
    public AjaxJson save(CuxAdministrationRegion cuxAdministrationRegion, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
        /**
         * 后台hibernate-validation插件校验
         */
        String errMsg = beanValidator(cuxAdministrationRegion);
        if (StringUtils.isNotBlank(errMsg)) {
            j.setSuccess(false);
            j.setMsg(errMsg);
            return j;
        }
        //新增或编辑表单保存
        cuxAdministrationRegionService.save(cuxAdministrationRegion);//保存
        j.setSuccess(true);
        j.setMsg("保存导入区域成功");
        return j;
    }

    /**
     * 删除导入区域
     */
    @ResponseBody
    @RequiresPermissions("cuxarea:cuxAdministrationRegion:del")
    @RequestMapping(value = "delete")
    public AjaxJson delete(CuxAdministrationRegion cuxAdministrationRegion) {
        AjaxJson j = new AjaxJson();
        cuxAdministrationRegionService.delete(cuxAdministrationRegion);
        j.setMsg("删除导入区域成功");
        return j;
    }

    /**
     * 批量删除导入区域
     */
    @ResponseBody
    @RequiresPermissions("cuxarea:cuxAdministrationRegion:del")
    @RequestMapping(value = "deleteAll")
    public AjaxJson deleteAll(String ids) {
        AjaxJson j = new AjaxJson();
        String[] idArray = ids.split(",");
        for (String id : idArray) {
            cuxAdministrationRegionService.delete(cuxAdministrationRegionService.get(id));
        }
        j.setMsg("删除导入区域成功");
        return j;
    }

    /**
     * 导出excel文件
     */
    @ResponseBody
    @RequiresPermissions("cuxarea:cuxAdministrationRegion:export")
    @RequestMapping(value = "export")
    public AjaxJson exportFile(CuxAdministrationRegion cuxAdministrationRegion, HttpServletRequest request, HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "导入区域" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
            Page<CuxAdministrationRegion> page = cuxAdministrationRegionService.findPage(new Page<CuxAdministrationRegion>(request, response, -1), cuxAdministrationRegion);
            new ExportExcel("导入区域", CuxAdministrationRegion.class).setDataList(page.getList()).write(response, fileName).dispose();
            j.setSuccess(true);
            j.setMsg("导出成功！");
            return j;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导出导入区域记录失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 导入Excel数据
     */
    @ResponseBody
    @RequiresPermissions("cuxarea:cuxAdministrationRegion:import")
    @RequestMapping(value = "import")
    public AjaxJson importFile(@RequestParam("file") MultipartFile file, HttpServletResponse response, HttpServletRequest request) {
        AjaxJson j = new AjaxJson();
        try {
            int successNum = 0;
            int failureNum = 0;
            StringBuilder failureMsg = new StringBuilder();
            ImportExcel ei = new ImportExcel(file, 1, 0);
            List<CuxAdministrationRegion> list = ei.getDataList(CuxAdministrationRegion.class);
            for (CuxAdministrationRegion cuxAdministrationRegion : list) {
                try {
                    cuxAdministrationRegionService.save(cuxAdministrationRegion);
                    successNum++;
                } catch (ConstraintViolationException ex) {
                    failureNum++;
                } catch (Exception ex) {
                    failureNum++;
                }
            }
            if (failureNum > 0) {
                failureMsg.insert(0, "，失败 " + failureNum + " 条导入区域记录。");
            }
            j.setMsg("已成功导入 " + successNum + " 条导入区域记录" + failureMsg);
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入导入区域失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 下载导入导入区域数据模板
     */
    @ResponseBody
    @RequiresPermissions("cuxarea:cuxAdministrationRegion:import")
    @RequestMapping(value = "import/template")
    public AjaxJson importFileTemplate(HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "导入区域数据导入模板.xlsx";
            List<CuxAdministrationRegion> list = Lists.newArrayList();
            new ExportExcel("导入区域数据", CuxAdministrationRegion.class, 1).setDataList(list).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入模板下载失败！失败信息：" + e.getMessage());
        }
        return j;
    }


    /**
     * 导入数据
     */
    @ResponseBody
    @RequestMapping(value = "initData")
    public AjaxJson initData(Model model) throws Exception {
        AjaxJson j = new AjaxJson();
        cuxAdministrationRegionService.initData();//保存
        j.setSuccess(true);
        j.setMsg("保存导入区域成功");
        return j;
    }


}