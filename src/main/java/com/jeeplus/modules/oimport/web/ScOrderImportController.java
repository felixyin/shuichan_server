/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.oimport.web;

import com.google.common.collect.Lists;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.excel.ExportExcel;
import com.jeeplus.common.utils.excel.ImportExcel;
import com.jeeplus.common.utils.number.NumberUtil;
import com.jeeplus.common.utils.text.Charsets;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.modules.oimport.entity.ScOrderImport;
import com.jeeplus.modules.oimport.service.ScOrderImportService;
import com.jeeplus.modules.sys.entity.Office;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.utils.UserUtils;
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
import java.net.URLDecoder;
import java.util.List;
import java.util.Map;

/**
 * 导入订单Controller
 *
 * @author 尹彬
 * @version 2019-08-20
 */
@Controller
@RequestMapping(value = "${adminPath}/oimport/scOrderImport")
public class ScOrderImportController extends BaseController {

    @Autowired
    private ScOrderImportService scOrderImportService;

    @ModelAttribute
    public ScOrderImport get(@RequestParam(required = false) String id) {
        ScOrderImport entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = scOrderImportService.get(id);
        }
        if (entity == null) {
            entity = new ScOrderImport();
        }
        return entity;
    }

    /**
     * 导入订单列表页面
     */
    @RequiresPermissions("oimport:scOrderImport:list")
    @RequestMapping(value = {"list", ""})
    public String list(ScOrderImport scOrderImport, Model model) {
        model.addAttribute("scOrderImport", scOrderImport);
        return "modules/oimport/scOrderImportList";
    }

    /**
     * 导入订单列表数据
     */
    @ResponseBody
    @RequiresPermissions("oimport:scOrderImport:list")
    @RequestMapping(value = "data")
    public Map<String, Object> data(ScOrderImport scOrderImport, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<ScOrderImport> page = scOrderImportService.findPage(new Page<ScOrderImport>(request, response), scOrderImport);
        return getBootstrapData(page);
    }

    /**
     * 查看，增加，编辑导入订单表单页面
     */
    @RequiresPermissions(value = {"oimport:scOrderImport:view", "oimport:scOrderImport:add", "oimport:scOrderImport:edit"}, logical = Logical.OR)
    @RequestMapping(value = "form")
    public String form(ScOrderImport scOrderImport, Model model) {
        model.addAttribute("scOrderImport", scOrderImport);
        return "modules/oimport/scOrderImportForm";
    }

    /**
     * 保存导入订单
     */
    @ResponseBody
    @RequiresPermissions(value = {"oimport:scOrderImport:add", "oimport:scOrderImport:edit"}, logical = Logical.OR)
    @RequestMapping(value = "save")
    public AjaxJson save(ScOrderImport scOrderImport, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
        /**
         * 后台hibernate-validation插件校验
         */
        String errMsg = beanValidator(scOrderImport);
        if (StringUtils.isNotBlank(errMsg)) {
            j.setSuccess(false);
            j.setMsg(errMsg);
            return j;
        }
        //新增或编辑表单保存
        scOrderImportService.save(scOrderImport);//保存
        j.setSuccess(true);
        j.setMsg("保存导入订单成功");
        return j;
    }

    /**
     * 删除导入订单
     */
    @ResponseBody
    @RequiresPermissions("oimport:scOrderImport:del")
    @RequestMapping(value = "delete")
    public AjaxJson delete(ScOrderImport scOrderImport) {
        AjaxJson j = new AjaxJson();
        scOrderImportService.delete(scOrderImport);
        j.setMsg("删除导入订单成功");
        return j;
    }

    /**
     * 批量删除导入订单
     */
    @ResponseBody
    @RequiresPermissions("oimport:scOrderImport:del")
    @RequestMapping(value = "deleteAll")
    public AjaxJson deleteAll(String ids) {
        AjaxJson j = new AjaxJson();
        String[] idArray = ids.split(",");
        for (String id : idArray) {
            scOrderImportService.delete(scOrderImportService.get(id));
        }
        j.setMsg("删除导入订单成功");
        return j;
    }

    /**
     * 导出excel文件
     */
    @ResponseBody
    @RequiresPermissions("oimport:scOrderImport:export")
    @RequestMapping(value = "export")
    public AjaxJson exportFile(ScOrderImport scOrderImport, HttpServletRequest request, HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "导入订单" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
            Page<ScOrderImport> page = scOrderImportService.findPage(new Page<ScOrderImport>(request, response, -1), scOrderImport);
            new ExportExcel("导入订单", ScOrderImport.class).setDataList(page.getList()).write(response, fileName).dispose();
            j.setSuccess(true);
            j.setMsg("导出成功！");
            return j;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导出导入订单记录失败！失败信息：" + e.getMessage());
        }
        return j;
    }


    /**
     * 导入Excel数据
     */
    @ResponseBody
//    @RequiresPermissions("oimport:scOrderImport:import")
    @RequestMapping(value = "import")
    public AjaxJson importFile(@RequestParam("file") MultipartFile file, HttpServletResponse response, HttpServletRequest request) {
        AjaxJson j = new AjaxJson();
        try {
            int successNum = 0;
            int failureNum = 0;
            StringBuilder failureMsg = new StringBuilder();
            ImportExcel ei = new ImportExcel(file, 1, 0);
            List<ScOrderImport> list = ei.getDataList(ScOrderImport.class);
            if (!list.isEmpty()) {
                // 清空当前登录用户之前填写的数据
                User user = UserUtils.getUser();
                scOrderImportService.executeDeleteSql("DELETE FROM sc_order_import WHERE user_id='" + user.getId() + "'");
                for (ScOrderImport scOrderImport : list) {
                    try {
                        scOrderImport.setUser(user);
                        scOrderImportService.save(scOrderImport);
                        successNum++;
                    } catch (ConstraintViolationException ex) {
                        failureNum++;
                    } catch (Exception ex) {
                        failureNum++;
                    }
                }
            }
            if (failureNum > 0) {
                failureMsg.insert(0, "，预处理失败 " + failureNum + " 条订单记录。");
            }
            j.setMsg("已预处理成功 " + successNum + " 条订单记录" + failureMsg);
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入导入订单失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 下载导入导入订单数据模板
     */
    @ResponseBody
//    @RequiresPermissions("oimport:scOrderImport:import")
    @RequestMapping(value = "import/template")
    public AjaxJson importFileTemplate(HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "导入订单数据导入模板.xlsx";
            List<ScOrderImport> list = Lists.newArrayList();
            new ExportExcel("导入订单数据", ScOrderImport.class, 1).setDataList(list).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入模板下载失败！失败信息：" + e.getMessage());
        }
        return j;
    }


    /**
     * 通过预订单数据 生成订单
     */
    @ResponseBody
//    @RequiresPermissions(value = "oimport:scOrderImport:import")
    @RequestMapping(value = "saveToOrder")
    public AjaxJson saveToOrder(Model model) throws Exception {
        //新增或编辑表单保存
        scOrderImportService.importToOrder();//保存
        AjaxJson j = new AjaxJson();
        j.setSuccess(true);
        j.setMsg("已成功生成订单");
        return j;
    }


    /**
     *
     */
    @ResponseBody
    @RequestMapping(value = "autoCompleteCustom")
    public List<Map<String, Object>> autoCompleteCustom(String phone, String username, String address) throws Exception {
        if (StringUtils.isNotBlank(phone)) {
            boolean number = NumberUtil.isNumber(phone);
            if (!number) {
                return null;
            }
            phone = URLDecoder.decode(phone, Charsets.UTF_8_NAME).trim();
        }
        if (StringUtils.isNotBlank(username)) {
            username = URLDecoder.decode(username, Charsets.UTF_8_NAME).trim();
        }
        if (StringUtils.isNotBlank(address)) {
            address = URLDecoder.decode(address, Charsets.UTF_8_NAME).trim();
        }
        String officeId = UserUtils.getOfficeDirectly().getId();
        return scOrderImportService.autoCompleteCustom(phone, username, address, officeId);
    }


}