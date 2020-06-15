/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.logicom.web;

import com.google.common.collect.Lists;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.excel.ExportExcel;
import com.jeeplus.common.utils.excel.ImportExcel;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.modules.logicom.entity.ScLogisticsCompany;
import com.jeeplus.modules.logicom.service.ScLogisticsCompanyService;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import java.util.List;
import java.util.Map;

/**
 * 物流公司Controller
 *
 * @author 尹彬
 * @version 2019-08-16
 */
@Controller
@RequestMapping(value = "${adminPath}/logicom/scLogisticsCompany")
public class ScLogisticsCompanyController extends BaseController {

    @Autowired
    private ScLogisticsCompanyService scLogisticsCompanyService;

    @ModelAttribute
    public ScLogisticsCompany get(@RequestParam(required = false) String id) {
        ScLogisticsCompany entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = scLogisticsCompanyService.get(id);
        }
        if (entity == null) {
            entity = new ScLogisticsCompany();
        }
        return entity;
    }

    /**
     * 物流公司列表页面
     */
    @RequiresPermissions("logicom:scLogisticsCompany:list")
    @RequestMapping(value = {"list", ""})
    public String list(ScLogisticsCompany scLogisticsCompany, Model model) {
        model.addAttribute("scLogisticsCompany", scLogisticsCompany);
        return "modules/logicom/scLogisticsCompanyList";
    }

    /**
     * 物流公司列表数据
     */
    @ResponseBody
    @RequiresPermissions("logicom:scLogisticsCompany:list")
    @RequestMapping(value = "data")
    public Map<String, Object> data(ScLogisticsCompany scLogisticsCompany, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<ScLogisticsCompany> page = scLogisticsCompanyService.findPage(new Page<ScLogisticsCompany>(request, response), scLogisticsCompany);
        return getBootstrapData(page);
    }

    /**
     * 查看，增加，编辑物流公司表单页面
     */
    @RequiresPermissions(value = {"logicom:scLogisticsCompany:view", "logicom:scLogisticsCompany:add", "logicom:scLogisticsCompany:edit"}, logical = Logical.OR)
    @RequestMapping(value = "form")
    public String form(ScLogisticsCompany scLogisticsCompany, Model model) {
        model.addAttribute("scLogisticsCompany", scLogisticsCompany);
        return "modules/logicom/scLogisticsCompanyForm";
    }

    /**
     * 保存物流公司
     */
    @ResponseBody
    @RequiresPermissions(value = {"logicom:scLogisticsCompany:add", "logicom:scLogisticsCompany:edit"}, logical = Logical.OR)
    @RequestMapping(value = "save")
    public AjaxJson save(ScLogisticsCompany scLogisticsCompany, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
        /**
         * 后台hibernate-validation插件校验
         */
        String errMsg = beanValidator(scLogisticsCompany);
        if (StringUtils.isNotBlank(errMsg)) {
            j.setSuccess(false);
            j.setMsg(errMsg);
            return j;
        }
        //新增或编辑表单保存
        scLogisticsCompanyService.save(scLogisticsCompany);//保存
        j.setSuccess(true);
        j.setMsg("保存物流公司成功");
        return j;
    }

    /**
     * 删除物流公司
     */
    @ResponseBody
    @RequiresPermissions("logicom:scLogisticsCompany:del")
    @RequestMapping(value = "delete")
    public AjaxJson delete(ScLogisticsCompany scLogisticsCompany) {
        AjaxJson j = new AjaxJson();
        scLogisticsCompanyService.delete(scLogisticsCompany);
        j.setMsg("删除物流公司成功");
        return j;
    }

    /**
     * 批量删除物流公司
     */
    @ResponseBody
    @RequiresPermissions("logicom:scLogisticsCompany:del")
    @RequestMapping(value = "deleteAll")
    public AjaxJson deleteAll(String ids) {
        AjaxJson j = new AjaxJson();
        String[] idArray = ids.split(",");
        for (String id : idArray) {
            scLogisticsCompanyService.delete(scLogisticsCompanyService.get(id));
        }
        j.setMsg("删除物流公司成功");
        return j;
    }

    /**
     * 导出excel文件
     */
    @ResponseBody
    @RequiresPermissions("logicom:scLogisticsCompany:export")
    @RequestMapping(value = "export")
    public AjaxJson exportFile(ScLogisticsCompany scLogisticsCompany, HttpServletRequest request, HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "物流公司" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
            Page<ScLogisticsCompany> page = scLogisticsCompanyService.findPage(new Page<ScLogisticsCompany>(request, response, -1), scLogisticsCompany);
            new ExportExcel("物流公司", ScLogisticsCompany.class).setDataList(page.getList()).write(response, fileName).dispose();
            j.setSuccess(true);
            j.setMsg("导出成功！");
            return j;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导出物流公司记录失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    @ResponseBody
    @RequestMapping(value = "detail")
    public ScLogisticsCompany detail(String id) {
        return scLogisticsCompanyService.get(id);
    }


    /**
     * 导入Excel数据
     */
    @ResponseBody
    @RequiresPermissions("logicom:scLogisticsCompany:import")
    @RequestMapping(value = "import")
    public AjaxJson importFile(@RequestParam("file") MultipartFile file, HttpServletResponse response, HttpServletRequest request) {
        AjaxJson j = new AjaxJson();
        try {
            int successNum = 0;
            int failureNum = 0;
            StringBuilder failureMsg = new StringBuilder();
            ImportExcel ei = new ImportExcel(file, 1, 0);
            List<ScLogisticsCompany> list = ei.getDataList(ScLogisticsCompany.class);
            for (ScLogisticsCompany scLogisticsCompany : list) {
                try {
                    scLogisticsCompanyService.save(scLogisticsCompany);
                    successNum++;
                } catch (ConstraintViolationException ex) {
                    failureNum++;
                } catch (Exception ex) {
                    failureNum++;
                }
            }
            if (failureNum > 0) {
                failureMsg.insert(0, "，失败 " + failureNum + " 条物流公司记录。");
            }
            j.setMsg("已成功导入 " + successNum + " 条物流公司记录" + failureMsg);
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入物流公司失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 下载导入物流公司数据模板
     */
    @ResponseBody
    @RequiresPermissions("logicom:scLogisticsCompany:import")
    @RequestMapping(value = "import/template")
    public AjaxJson importFileTemplate(HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "物流公司数据导入模板.xlsx";
            List<ScLogisticsCompany> list = Lists.newArrayList();
            new ExportExcel("物流公司数据", ScLogisticsCompany.class, 1).setDataList(list).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入模板下载失败！失败信息：" + e.getMessage());
        }
        return j;
    }


}