/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.custom.web;

import com.google.common.collect.Lists;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.excel.ExportExcel;
import com.jeeplus.common.utils.excel.ImportExcel;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.modules.custom.entity.ScCustom;
import com.jeeplus.modules.custom.service.ScCustomService;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import java.util.List;
import java.util.Map;

/**
 * 客户Controller
 *
 * @author 尹彬
 * @version 2019-08-16
 */
@Controller
@RequestMapping(value = "${adminPath}/custom/scCustom")
public class ScCustomController extends BaseController {

    @Resource
    private ScCustomService scCustomService;

    @ModelAttribute
    public ScCustom get(@RequestParam(required = false) String id) {
        ScCustom entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = scCustomService.get(id);
        }
        if (entity == null) {
            entity = new ScCustom();
        }
        return entity;
    }

    /**
     * 客户列表页面
     */
    @RequiresPermissions("custom:scCustom:list")
    @RequestMapping(value = {"list", ""})
    public String list(ScCustom scCustom, Model model) {
        model.addAttribute("scCustom", scCustom);
        return "modules/custom/scCustomList";
    }

    /**
     * 客户列表数据
     */
    @ResponseBody
    @RequiresPermissions("custom:scCustom:list")
    @RequestMapping(value = "data")
    public Map<String, Object> data(ScCustom scCustom, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<ScCustom> page = scCustomService.findPage(new Page<ScCustom>(request, response), scCustom);
        return getBootstrapData(page);
    }

    /**
     * 查看，增加，编辑客户表单页面
     */
    @RequiresPermissions(value = {"custom:scCustom:view", "custom:scCustom:add", "custom:scCustom:edit"}, logical = Logical.OR)
    @RequestMapping(value = "form")
    public String form(ScCustom scCustom, Model model) {
        model.addAttribute("scCustom", scCustom);
        return "modules/custom/scCustomForm";
    }

    /**
     * 保存客户
     */
    @ResponseBody
    @RequiresPermissions(value = {"custom:scCustom:add", "custom:scCustom:edit"}, logical = Logical.OR)
    @RequestMapping(value = "save")
    public AjaxJson save(ScCustom scCustom, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
        /**
         * 后台hibernate-validation插件校验
         */
        String errMsg = beanValidator(scCustom);
        if (StringUtils.isNotBlank(errMsg)) {
            j.setSuccess(false);
            j.setMsg(errMsg);
            return j;
        }
        //新增或编辑表单保存
        scCustomService.save(scCustom);//保存
        j.setSuccess(true);
        j.setMsg("保存客户成功");
        return j;
    }

    /**
     * 删除客户
     */
    @ResponseBody
    @RequiresPermissions("custom:scCustom:del")
    @RequestMapping(value = "delete")
    public AjaxJson delete(ScCustom scCustom) {
        AjaxJson j = new AjaxJson();
        scCustomService.delete(scCustom);
        j.setMsg("删除客户成功");
        return j;
    }

    /**
     * 批量删除客户
     */
    @ResponseBody
    @RequiresPermissions("custom:scCustom:del")
    @RequestMapping(value = "deleteAll")
    public AjaxJson deleteAll(String ids) {
        AjaxJson j = new AjaxJson();
        String[] idArray = ids.split(",");
        for (String id : idArray) {
            scCustomService.delete(scCustomService.get(id));
        }
        j.setMsg("删除客户成功");
        return j;
    }

    /**
     * 导出excel文件
     */
    @ResponseBody
    @RequiresPermissions("custom:scCustom:export")
    @RequestMapping(value = "export")
    public AjaxJson exportFile(ScCustom scCustom, HttpServletRequest request, HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "客户" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
            Page<ScCustom> page = scCustomService.findPage(new Page<ScCustom>(request, response, -1), scCustom);
            new ExportExcel("客户", ScCustom.class).setDataList(page.getList()).write(response, fileName).dispose();
            j.setSuccess(true);
            j.setMsg("导出成功！");
            return j;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导出客户记录失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 导入Excel数据
     */
    @ResponseBody
    @RequiresPermissions("custom:scCustom:import")
    @RequestMapping(value = "import")
    public AjaxJson importFile(@RequestParam("file") MultipartFile file, HttpServletResponse response, HttpServletRequest request) {
        AjaxJson j = new AjaxJson();
        try {
            int successNum = 0;
            int failureNum = 0;
            StringBuilder failureMsg = new StringBuilder();
            ImportExcel ei = new ImportExcel(file, 1, 0);
            List<ScCustom> list = ei.getDataList(ScCustom.class);
            for (ScCustom scCustom : list) {
                try {
                    scCustomService.save(scCustom);
                    successNum++;
                } catch (ConstraintViolationException ex) {
                    failureNum++;
                } catch (Exception ex) {
                    failureNum++;
                }
            }
            if (failureNum > 0) {
                failureMsg.insert(0, "，失败 " + failureNum + " 条客户记录。");
            }
            j.setMsg("已成功导入 " + successNum + " 条客户记录" + failureMsg);
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入客户失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 下载导入客户数据模板
     */
    @ResponseBody
    @RequiresPermissions("custom:scCustom:import")
    @RequestMapping(value = "import/template")
    public AjaxJson importFileTemplate(HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "客户数据导入模板.xlsx";
            List<ScCustom> list = Lists.newArrayList();
            new ExportExcel("客户数据", ScCustom.class, 1).setDataList(list).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入模板下载失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    @ResponseBody
    @RequestMapping(value = "getById")
    public ScCustom getById(ScCustom custom) {
        return custom;
    }

}