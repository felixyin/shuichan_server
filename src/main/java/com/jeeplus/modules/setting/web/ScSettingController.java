/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.setting.web;

import com.google.common.collect.Lists;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.excel.ExportExcel;
import com.jeeplus.common.utils.excel.ImportExcel;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.modules.setting.entity.ScSetting;
import com.jeeplus.modules.setting.service.ScSettingService;
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
 * 用户设置Controller
 *
 * @author 尹彬
 * @version 2019-09-25
 */
@Controller
@RequestMapping(value = "${adminPath}/setting/scSetting")
public class ScSettingController extends BaseController {

    @Autowired
    private ScSettingService scSettingService;

    @ModelAttribute
    public ScSetting get(@RequestParam(required = false) String id) {
        ScSetting entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = scSettingService.get(id);
        }
        if (entity == null) {
            entity = new ScSetting();
        }
        return entity;
    }

    /**
     * 用户设置列表页面
     */
    @RequiresPermissions("setting:scSetting:list")
    @RequestMapping(value = {"list", ""})
    public String list(ScSetting scSetting, Model model) {
        model.addAttribute("scSetting", scSetting);
        return "modules/setting/scSettingList";
    }

    /**
     * 用户设置列表数据
     */
    @ResponseBody
    @RequiresPermissions("setting:scSetting:list")
    @RequestMapping(value = "data")
    public Map<String, Object> data(ScSetting scSetting, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<ScSetting> page = scSettingService.findPage(new Page<ScSetting>(request, response), scSetting);
        return getBootstrapData(page);
    }

    /**
     * 查看，增加，编辑用户设置表单页面
     */
    @RequiresPermissions(value = {"setting:scSetting:view", "setting:scSetting:add", "setting:scSetting:edit"}, logical = Logical.OR)
    @RequestMapping(value = "form")
    public String form(ScSetting scSetting, Model model) {
        model.addAttribute("scSetting", scSetting);
        return "modules/setting/scSettingForm";
    }

    /**
     * 保存用户设置
     */
    @ResponseBody
    @RequiresPermissions(value = {"setting:scSetting:add", "setting:scSetting:edit"}, logical = Logical.OR)
    @RequestMapping(value = "save")
    public AjaxJson save(ScSetting scSetting, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
        /**
         * 后台hibernate-validation插件校验
         */
        String errMsg = beanValidator(scSetting);
        if (StringUtils.isNotBlank(errMsg)) {
            j.setSuccess(false);
            j.setMsg(errMsg);
            return j;
        }
        //新增或编辑表单保存
        scSettingService.save(scSetting);//保存
        j.setSuccess(true);
        j.setMsg("保存用户设置成功");
        return j;
    }

    /**
     * 删除用户设置
     */
    @ResponseBody
    @RequiresPermissions("setting:scSetting:del")
    @RequestMapping(value = "delete")
    public AjaxJson delete(ScSetting scSetting) {
        AjaxJson j = new AjaxJson();
        scSettingService.delete(scSetting);
        j.setMsg("删除用户设置成功");
        return j;
    }

    /**
     * 批量删除用户设置
     */
    @ResponseBody
    @RequiresPermissions("setting:scSetting:del")
    @RequestMapping(value = "deleteAll")
    public AjaxJson deleteAll(String ids) {
        AjaxJson j = new AjaxJson();
        String idArray[] = ids.split(",");
        for (String id : idArray) {
            scSettingService.delete(scSettingService.get(id));
        }
        j.setMsg("删除用户设置成功");
        return j;
    }

    /**
     * 导出excel文件
     */
    @ResponseBody
    @RequiresPermissions("setting:scSetting:export")
    @RequestMapping(value = "export")
    public AjaxJson exportFile(ScSetting scSetting, HttpServletRequest request, HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "用户设置" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
            Page<ScSetting> page = scSettingService.findPage(new Page<ScSetting>(request, response, -1), scSetting);
            new ExportExcel("用户设置", ScSetting.class).setDataList(page.getList()).write(response, fileName).dispose();
            j.setSuccess(true);
            j.setMsg("导出成功！");
            return j;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导出用户设置记录失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 导入Excel数据
     */
    @ResponseBody
    @RequiresPermissions("setting:scSetting:import")
    @RequestMapping(value = "import")
    public AjaxJson importFile(@RequestParam("file") MultipartFile file, HttpServletResponse response, HttpServletRequest request) {
        AjaxJson j = new AjaxJson();
        try {
            int successNum = 0;
            int failureNum = 0;
            StringBuilder failureMsg = new StringBuilder();
            ImportExcel ei = new ImportExcel(file, 1, 0);
            List<ScSetting> list = ei.getDataList(ScSetting.class);
            for (ScSetting scSetting : list) {
                try {
                    scSettingService.save(scSetting);
                    successNum++;
                } catch (ConstraintViolationException ex) {
                    failureNum++;
                } catch (Exception ex) {
                    failureNum++;
                }
            }
            if (failureNum > 0) {
                failureMsg.insert(0, "，失败 " + failureNum + " 条用户设置记录。");
            }
            j.setMsg("已成功导入 " + successNum + " 条用户设置记录" + failureMsg);
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入用户设置失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 下载导入用户设置数据模板
     */
    @ResponseBody
    @RequiresPermissions("setting:scSetting:import")
    @RequestMapping(value = "import/template")
    public AjaxJson importFileTemplate(HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "用户设置数据导入模板.xlsx";
            List<ScSetting> list = Lists.newArrayList();
            new ExportExcel("用户设置数据", ScSetting.class, 1).setDataList(list).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入模板下载失败！失败信息：" + e.getMessage());
        }
        return j;
    }

}