/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.production.web;

import com.google.common.collect.Lists;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.excel.ExportExcel;
import com.jeeplus.common.utils.excel.ImportExcel;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.modules.production.entity.ScProduction;
import com.jeeplus.modules.production.entity.ScProductionCategory;
import com.jeeplus.modules.production.service.ScProductionService;
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
 * 产品Controller
 *
 * @author 尹彬
 * @version 2019-08-18
 */
@Controller
@RequestMapping(value = "${adminPath}/production/scProduction")
public class ScProductionController extends BaseController {

    @Resource
    private ScProductionService scProductionService;

    @ModelAttribute
    public ScProduction get(@RequestParam(required = false) String id) {
        ScProduction entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = scProductionService.get(id);
        }
        if (entity == null) {
            entity = new ScProduction();
        }
        return entity;
    }

    /**
     * 产品列表页面
     */
    @RequiresPermissions("production:scProduction:list")
    @RequestMapping(value = {"list", ""})
    public String list(ScProduction scProduction, Model model) {
        model.addAttribute("scProduction", scProduction);
        return "modules/production/scProductionList";
    }

    /**
     * 产品列表数据
     */
    @ResponseBody
    @RequiresPermissions("production:scProduction:list")
    @RequestMapping(value = "data")
    public Map<String, Object> data(ScProduction scProduction, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<ScProduction> page = scProductionService.findPage(new Page<ScProduction>(request, response), scProduction);
        return getBootstrapData(page);
    }

    /**
     * 查看，增加，编辑产品表单页面
     */
    @RequiresPermissions(value = {"production:scProduction:view", "production:scProduction:add", "production:scProduction:edit"}, logical = Logical.OR)
    @RequestMapping(value = "form")
    public String form(ScProduction scProduction, Model model) {
        scProduction.setProductionCategory(new ScProductionCategory("4")); // 4 海鲜id
        model.addAttribute("scProduction", scProduction);
        return "modules/production/scProductionForm";
    }

    /**
     * 保存产品
     */
    @ResponseBody
    @RequiresPermissions(value = {"production:scProduction:add", "production:scProduction:edit"}, logical = Logical.OR)
    @RequestMapping(value = "save")
    public AjaxJson save(ScProduction scProduction, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
        /**
         * 后台hibernate-validation插件校验
         */
        String errMsg = beanValidator(scProduction);
        if (StringUtils.isNotBlank(errMsg)) {
            j.setSuccess(false);
            j.setMsg(errMsg);
            return j;
        }
        //新增或编辑表单保存
        scProductionService.save(scProduction);//保存
        j.setSuccess(true);
        j.setMsg("保存产品成功");
        return j;
    }

    /**
     * 删除产品
     */
    @ResponseBody
    @RequiresPermissions("production:scProduction:del")
    @RequestMapping(value = "delete")
    public AjaxJson delete(ScProduction scProduction) {
        AjaxJson j = new AjaxJson();
        scProductionService.delete(scProduction);
        j.setMsg("删除产品成功");
        return j;
    }

    /**
     * 批量删除产品
     */
    @ResponseBody
    @RequiresPermissions("production:scProduction:del")
    @RequestMapping(value = "deleteAll")
    public AjaxJson deleteAll(String ids) {
        AjaxJson j = new AjaxJson();
        String[] idArray = ids.split(",");
        for (String id : idArray) {
            scProductionService.delete(scProductionService.get(id));
        }
        j.setMsg("删除产品成功");
        return j;
    }

    /**
     * 导出excel文件
     */
    @ResponseBody
    @RequiresPermissions("production:scProduction:export")
    @RequestMapping(value = "export")
    public AjaxJson exportFile(ScProduction scProduction, HttpServletRequest request, HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "产品" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
            Page<ScProduction> page = scProductionService.findPage(new Page<ScProduction>(request, response, -1), scProduction);
            new ExportExcel("产品", ScProduction.class).setDataList(page.getList()).write(response, fileName).dispose();
            j.setSuccess(true);
            j.setMsg("导出成功！");
            return j;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导出产品记录失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 导入Excel数据
     */
    @ResponseBody
    @RequiresPermissions("production:scProduction:import")
    @RequestMapping(value = "import")
    public AjaxJson importFile(@RequestParam("file") MultipartFile file, HttpServletResponse response, HttpServletRequest request) {
        AjaxJson j = new AjaxJson();
        try {
            int successNum = 0;
            int failureNum = 0;
            StringBuilder failureMsg = new StringBuilder();
            ImportExcel ei = new ImportExcel(file, 1, 0);
            List<ScProduction> list = ei.getDataList(ScProduction.class);
            for (ScProduction scProduction : list) {
                try {
                    scProductionService.save(scProduction);
                    successNum++;
                } catch (ConstraintViolationException ex) {
                    failureNum++;
                } catch (Exception ex) {
                    failureNum++;
                }
            }
            if (failureNum > 0) {
                failureMsg.insert(0, "，失败 " + failureNum + " 条产品记录。");
            }
            j.setMsg("已成功导入 " + successNum + " 条产品记录" + failureMsg);
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入产品失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 下载导入产品数据模板
     */
    @ResponseBody
    @RequiresPermissions("production:scProduction:import")
    @RequestMapping(value = "import/template")
    public AjaxJson importFileTemplate(HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "产品数据导入模板.xlsx";
            List<ScProduction> list = Lists.newArrayList();
            new ExportExcel("产品数据", ScProduction.class, 1).setDataList(list).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入模板下载失败！失败信息：" + e.getMessage());
        }
        return j;
    }

}