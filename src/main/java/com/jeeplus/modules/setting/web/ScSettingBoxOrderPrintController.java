/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.setting.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.common.collect.Lists;
import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.config.Global;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.excel.ExportExcel;
import com.jeeplus.common.utils.excel.ImportExcel;
import com.jeeplus.modules.setting.entity.ScSettingBoxOrderPrint;
import com.jeeplus.modules.setting.service.ScSettingBoxOrderPrintService;

/**
 * 装箱单打印设置Controller
 * @author 尹彬
 * @version 2019-12-17
 */
@Controller
@RequestMapping(value = "${adminPath}/setting/scSettingBoxOrderPrint")
public class ScSettingBoxOrderPrintController extends BaseController {

	@Autowired
	private ScSettingBoxOrderPrintService scSettingBoxOrderPrintService;
	
	@ModelAttribute
	public ScSettingBoxOrderPrint get(@RequestParam(required=false) String id) {
		ScSettingBoxOrderPrint entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = scSettingBoxOrderPrintService.get(id);
		}
		if (entity == null){
			entity = new ScSettingBoxOrderPrint();
		}
		return entity;
	}
	
	/**
	 * 装箱单打印设置列表页面
	 */
	@RequiresPermissions("setting:scSettingBoxOrderPrint:list")
	@RequestMapping(value = {"list", ""})
	public String list(ScSettingBoxOrderPrint scSettingBoxOrderPrint, Model model) {
		model.addAttribute("scSettingBoxOrderPrint", scSettingBoxOrderPrint);
		return "modules/setting/scSettingBoxOrderPrintList";
	}
	
		/**
	 * 装箱单打印设置列表数据
	 */
	@ResponseBody
	@RequiresPermissions("setting:scSettingBoxOrderPrint:list")
	@RequestMapping(value = "data")
	public Map<String, Object> data(ScSettingBoxOrderPrint scSettingBoxOrderPrint, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ScSettingBoxOrderPrint> page = scSettingBoxOrderPrintService.findPage(new Page<ScSettingBoxOrderPrint>(request, response), scSettingBoxOrderPrint); 
		return getBootstrapData(page);
	}

	/**
	 * 查看，增加，编辑装箱单打印设置表单页面
	 */
	@RequiresPermissions(value={"setting:scSettingBoxOrderPrint:view","setting:scSettingBoxOrderPrint:add","setting:scSettingBoxOrderPrint:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(ScSettingBoxOrderPrint scSettingBoxOrderPrint, Model model) {
		model.addAttribute("scSettingBoxOrderPrint", scSettingBoxOrderPrint);
		return "modules/setting/scSettingBoxOrderPrintForm";
	}

	/**
	 * 保存装箱单打印设置
	 */
	@ResponseBody
	@RequiresPermissions(value={"setting:scSettingBoxOrderPrint:add","setting:scSettingBoxOrderPrint:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public AjaxJson save(ScSettingBoxOrderPrint scSettingBoxOrderPrint, Model model) throws Exception{
		AjaxJson j = new AjaxJson();
		/**
		 * 后台hibernate-validation插件校验
		 */
		String errMsg = beanValidator(scSettingBoxOrderPrint);
		if (StringUtils.isNotBlank(errMsg)){
			j.setSuccess(false);
			j.setMsg(errMsg);
			return j;
		}
		//新增或编辑表单保存
		scSettingBoxOrderPrintService.save(scSettingBoxOrderPrint);//保存
		j.setSuccess(true);
		j.setMsg("保存装箱单打印设置成功");
		return j;
	}
	
	/**
	 * 删除装箱单打印设置
	 */
	@ResponseBody
	@RequiresPermissions("setting:scSettingBoxOrderPrint:del")
	@RequestMapping(value = "delete")
	public AjaxJson delete(ScSettingBoxOrderPrint scSettingBoxOrderPrint) {
		AjaxJson j = new AjaxJson();
		scSettingBoxOrderPrintService.delete(scSettingBoxOrderPrint);
		j.setMsg("删除装箱单打印设置成功");
		return j;
	}
	
	/**
	 * 批量删除装箱单打印设置
	 */
	@ResponseBody
	@RequiresPermissions("setting:scSettingBoxOrderPrint:del")
	@RequestMapping(value = "deleteAll")
	public AjaxJson deleteAll(String ids) {
		AjaxJson j = new AjaxJson();
		String idArray[] =ids.split(",");
		for(String id : idArray){
			scSettingBoxOrderPrintService.delete(scSettingBoxOrderPrintService.get(id));
		}
		j.setMsg("删除装箱单打印设置成功");
		return j;
	}
	
	/**
	 * 导出excel文件
	 */
	@ResponseBody
	@RequiresPermissions("setting:scSettingBoxOrderPrint:export")
    @RequestMapping(value = "export")
    public AjaxJson exportFile(ScSettingBoxOrderPrint scSettingBoxOrderPrint, HttpServletRequest request, HttpServletResponse response) {
		AjaxJson j = new AjaxJson();
		try {
            String fileName = "装箱单打印设置"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<ScSettingBoxOrderPrint> page = scSettingBoxOrderPrintService.findPage(new Page<ScSettingBoxOrderPrint>(request, response, -1), scSettingBoxOrderPrint);
    		new ExportExcel("装箱单打印设置", ScSettingBoxOrderPrint.class).setDataList(page.getList()).write(response, fileName).dispose();
    		j.setSuccess(true);
    		j.setMsg("导出成功！");
    		return j;
		} catch (Exception e) {
			j.setSuccess(false);
			j.setMsg("导出装箱单打印设置记录失败！失败信息："+e.getMessage());
		}
			return j;
    }

	/**
	 * 导入Excel数据

	 */
	@ResponseBody
	@RequiresPermissions("setting:scSettingBoxOrderPrint:import")
    @RequestMapping(value = "import")
   	public AjaxJson importFile(@RequestParam("file")MultipartFile file, HttpServletResponse response, HttpServletRequest request) {
		AjaxJson j = new AjaxJson();
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<ScSettingBoxOrderPrint> list = ei.getDataList(ScSettingBoxOrderPrint.class);
			for (ScSettingBoxOrderPrint scSettingBoxOrderPrint : list){
				try{
					scSettingBoxOrderPrintService.save(scSettingBoxOrderPrint);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条装箱单打印设置记录。");
			}
			j.setMsg( "已成功导入 "+successNum+" 条装箱单打印设置记录"+failureMsg);
		} catch (Exception e) {
			j.setSuccess(false);
			j.setMsg("导入装箱单打印设置失败！失败信息："+e.getMessage());
		}
		return j;
    }
	
	/**
	 * 下载导入装箱单打印设置数据模板
	 */
	@ResponseBody
	@RequiresPermissions("setting:scSettingBoxOrderPrint:import")
    @RequestMapping(value = "import/template")
     public AjaxJson importFileTemplate(HttpServletResponse response) {
		AjaxJson j = new AjaxJson();
		try {
            String fileName = "装箱单打印设置数据导入模板.xlsx";
    		List<ScSettingBoxOrderPrint> list = Lists.newArrayList(); 
    		new ExportExcel("装箱单打印设置数据", ScSettingBoxOrderPrint.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			j.setSuccess(false);
			j.setMsg( "导入模板下载失败！失败信息："+e.getMessage());
		}
		return j;
    }

}