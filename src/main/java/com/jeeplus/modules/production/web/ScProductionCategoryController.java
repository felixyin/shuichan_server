/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.production.web;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.modules.production.entity.ScProductionCategory;
import com.jeeplus.modules.production.service.ScProductionCategoryService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * 产品Controller
 *
 * @author 尹彬
 * @version 2019-08-18
 */
@Controller
@RequestMapping(value = "${adminPath}/production/scProductionCategory")
public class ScProductionCategoryController extends BaseController {

    @Resource
    private ScProductionCategoryService scProductionCategoryService;

    @ModelAttribute
    public ScProductionCategory get(@RequestParam(required = false) String id) {
        ScProductionCategory entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = scProductionCategoryService.get(id);
        }
        if (entity == null) {
            entity = new ScProductionCategory();
        }
        return entity;
    }

    /**
     * 产品列表页面
     */
    @RequestMapping(value = {"list", ""})
    public String list(ScProductionCategory scProductionCategory, HttpServletRequest request, HttpServletResponse response, Model model) {

        return "modules/production/scProductionCategoryList";
    }

    /**
     * 查看，增加，编辑产品表单页面
     */
    @RequestMapping(value = "form")
    public String form(ScProductionCategory scProductionCategory, Model model) {
        if (scProductionCategory.getParent() != null && StringUtils.isNotBlank(scProductionCategory.getParent().getId())) {
            scProductionCategory.setParent(scProductionCategoryService.get(scProductionCategory.getParent().getId()));
            // 获取排序号，最末节点排序号+30
            if (StringUtils.isBlank(scProductionCategory.getId())) {
                ScProductionCategory scProductionCategoryChild = new ScProductionCategory();
                scProductionCategoryChild.setParent(new ScProductionCategory(scProductionCategory.getParent().getId()));
                List<ScProductionCategory> list = scProductionCategoryService.findList(scProductionCategory);
                if (list.size() > 0) {
                    scProductionCategory.setSort(list.get(list.size() - 1).getSort());
                    if (scProductionCategory.getSort() != null) {
                        scProductionCategory.setSort(scProductionCategory.getSort() + 30);
                    }
                }
            }
        }
        if (scProductionCategory.getSort() == null) {
            scProductionCategory.setSort(30);
        }
        model.addAttribute("scProductionCategory", scProductionCategory);
        return "modules/production/scProductionCategoryForm";
    }

    /**
     * 保存产品
     */
    @ResponseBody
    @RequestMapping(value = "save")
    public AjaxJson save(ScProductionCategory scProductionCategory, Model model) throws Exception {
        AjaxJson j = new AjaxJson();
        /**
         * 后台hibernate-validation插件校验
         */
        String errMsg = beanValidator(scProductionCategory);
        if (StringUtils.isNotBlank(errMsg)) {
            j.setSuccess(false);
            j.setMsg(errMsg);
            return j;
        }

        //新增或编辑表单保存
        scProductionCategoryService.save(scProductionCategory);//保存
        j.setSuccess(true);
        j.put("scProductionCategory", scProductionCategory);
        j.setMsg("保存产品成功");
        return j;
    }

    @ResponseBody
    @RequestMapping(value = "getChildren")
    public List<ScProductionCategory> getChildren(String parentId) {
        if ("-1".equals(parentId)) {//如果是-1，没指定任何父节点，就从根节点开始查找
            parentId = "0";
        }
        return scProductionCategoryService.getChildren(parentId);
    }

    /**
     * 删除产品
     */
    @ResponseBody
    @RequestMapping(value = "delete")
    public AjaxJson delete(ScProductionCategory scProductionCategory) {
        AjaxJson j = new AjaxJson();
        scProductionCategoryService.delete(scProductionCategory);
        j.setSuccess(true);
        j.setMsg("删除产品成功");
        return j;
    }

    @RequiresPermissions("user")
    @ResponseBody
    @RequestMapping(value = "treeData")
    public List<Map<String, Object>> treeData(@RequestParam(required = false) String extId, HttpServletResponse response) {
        List<Map<String, Object>> mapList = Lists.newArrayList();
        List<ScProductionCategory> list = scProductionCategoryService.findList(new ScProductionCategory());
        for (int i = 0; i < list.size(); i++) {
            ScProductionCategory e = list.get(i);
            if (StringUtils.isBlank(extId) || (extId != null && !extId.equals(e.getId()) && e.getParentIds().indexOf("," + extId + ",") == -1)) {
                Map<String, Object> map = Maps.newHashMap();
                map.put("id", e.getId());
                map.put("text", e.getName());
                if (StringUtils.isBlank(e.getParentId()) || "0".equals(e.getParentId())) {
                    map.put("parent", "#");
                    Map<String, Object> state = Maps.newHashMap();
                    state.put("opened", true);
                    map.put("state", state);
                } else {
                    map.put("parent", e.getParentId());
                }
                mapList.add(map);
            }
        }
        return mapList;
    }

}