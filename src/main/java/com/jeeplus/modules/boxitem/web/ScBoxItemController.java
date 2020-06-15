/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.boxitem.web;

import com.google.common.collect.Lists;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.excel.ExportExcel;
import com.jeeplus.common.utils.excel.ImportExcel;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.modules.boxitem.entity.ScBoxItem;
import com.jeeplus.modules.boxitem.service.ScBoxItemService;
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
 * 每箱Controller
 *
 * @author 尹彬
 * @version 2019-08-14
 */
@Controller
@RequestMapping(value = "${adminPath}/boxitem/scBoxItem")
public class ScBoxItemController extends BaseController {

    @Resource
    private ScBoxItemService scBoxItemService;

    @ModelAttribute
    public ScBoxItem get(@RequestParam(required = false) String id) {
        ScBoxItem entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = scBoxItemService.get(id);
        }
        if (entity == null) {
            entity = new ScBoxItem();
        }
        return entity;
    }

    /**
     * 每箱列表页面
     */
    @RequiresPermissions("boxitem:scBoxItem:list")
    @RequestMapping(value = {"list", ""})
    public String list(ScBoxItem scBoxItem, Model model) {
        model.addAttribute("scBoxItem", scBoxItem);
        return "modules/boxitem/scBoxItemList2";
    }

    /**
     * 每箱列表数据
     */
    @ResponseBody
    @RequiresPermissions("boxitem:scBoxItem:list")
    @RequestMapping(value = "data")
    public Map<String, Object> data(ScBoxItem scBoxItem, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<ScBoxItem> page = scBoxItemService.findPage(new Page<ScBoxItem>(request, response), scBoxItem);
        return getBootstrapData(page);
    }

    /**
     * 查看，增加，编辑每箱表单页面
     */
    @RequiresPermissions(value = {"boxitem:scBoxItem:view", "boxitem:scBoxItem:add", "boxitem:scBoxItem:edit"}, logical = Logical.OR)
    @RequestMapping(value = "form")
    public String form(ScBoxItem scBoxItem, Model model) {
        model.addAttribute("scBoxItem", scBoxItem);
        return "modules/boxitem/scBoxItemForm";
    }

    /**
     * 保存每箱
     */
    @ResponseBody
    @RequiresPermissions(value = {"boxitem:scBoxItem:add", "boxitem:scBoxItem:edit"}, logical = Logical.OR)
    @RequestMapping(value = "save")
    public AjaxJson save(ScBoxItem scBoxItem, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
        /**
         * 后台hibernate-validation插件校验
         */
        String errMsg = beanValidator(scBoxItem);
        if (StringUtils.isNotBlank(errMsg)) {
            j.setSuccess(false);
            j.setMsg(errMsg);
            return j;
        }
        //新增或编辑表单保存
        scBoxItemService.save(scBoxItem);//保存
        j.setSuccess(true);
        j.setMsg("保存每箱成功");
        return j;
    }

    /**
     * 删除每箱
     */
    @ResponseBody
    @RequiresPermissions("boxitem:scBoxItem:del")
    @RequestMapping(value = "delete")
    public AjaxJson delete(ScBoxItem scBoxItem) {
        AjaxJson j = new AjaxJson();
        scBoxItemService.delete(scBoxItem);
        j.setMsg("删除每箱成功");
        return j;
    }

    /**
     * 批量删除每箱
     */
    @ResponseBody
    @RequiresPermissions("boxitem:scBoxItem:del")
    @RequestMapping(value = "deleteAll")
    public AjaxJson deleteAll(String ids) {
        AjaxJson j = new AjaxJson();
        String[] idArray = ids.split(",");
        for (String id : idArray) {
            scBoxItemService.delete(scBoxItemService.get(id));
        }
        j.setMsg("删除每箱成功");
        return j;
    }

    /**
     * 导出excel文件
     */
    @ResponseBody
    @RequiresPermissions("boxitem:scBoxItem:export")
    @RequestMapping(value = "export")
    public AjaxJson exportFile(ScBoxItem scBoxItem, HttpServletRequest request, HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "每箱" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
            Page<ScBoxItem> page = scBoxItemService.findPage(new Page<ScBoxItem>(request, response, -1), scBoxItem);
            new ExportExcel("每箱", ScBoxItem.class).setDataList(page.getList()).write(response, fileName).dispose();
            j.setSuccess(true);
            j.setMsg("导出成功！");
            return j;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导出每箱记录失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 导入Excel数据
     */
    @ResponseBody
    @RequiresPermissions("boxitem:scBoxItem:import")
    @RequestMapping(value = "import")
    public AjaxJson importFile(@RequestParam("file") MultipartFile file, HttpServletResponse response, HttpServletRequest request) {
        AjaxJson j = new AjaxJson();
        try {
            int successNum = 0;
            int failureNum = 0;
            StringBuilder failureMsg = new StringBuilder();
            ImportExcel ei = new ImportExcel(file, 1, 0);
            List<ScBoxItem> list = ei.getDataList(ScBoxItem.class);
            for (ScBoxItem scBoxItem : list) {
                try {
                    scBoxItemService.save(scBoxItem);
                    successNum++;
                } catch (ConstraintViolationException ex) {
                    failureNum++;
                } catch (Exception ex) {
                    failureNum++;
                }
            }
            if (failureNum > 0) {
                failureMsg.insert(0, "，失败 " + failureNum + " 条每箱记录。");
            }
            j.setMsg("已成功导入 " + successNum + " 条每箱记录" + failureMsg);
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入每箱失败！失败信息：" + e.getMessage());
        }
        return j;
    }

    /**
     * 下载导入每箱数据模板
     */
    @ResponseBody
    @RequiresPermissions("boxitem:scBoxItem:import")
    @RequestMapping(value = "import/template")
    public AjaxJson importFileTemplate(HttpServletResponse response) {
        AjaxJson j = new AjaxJson();
        try {
            String fileName = "每箱数据导入模板.xlsx";
            List<ScBoxItem> list = Lists.newArrayList();
            new ExportExcel("每箱数据", ScBoxItem.class, 1).setDataList(list).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            j.setSuccess(false);
            j.setMsg("导入模板下载失败！失败信息：" + e.getMessage());
        }
        return j;
    }

}