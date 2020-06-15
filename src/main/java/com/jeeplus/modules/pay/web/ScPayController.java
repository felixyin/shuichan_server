/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.pay.web;

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
import com.jeeplus.modules.pay.entity.ScPay;
import com.jeeplus.modules.pay.service.ScPayService;

/**
 * 产品购买Controller
 * @author 尹彬
 * @version 2019-10-20
 */
@Controller
@RequestMapping(value = "${adminPath}/pay/scPay")
public class ScPayController extends BaseController {

	@Autowired
	protected ScPayService scPayService;
	
	@ModelAttribute
	public ScPay get(@RequestParam(required=false) String id) {
		ScPay entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = scPayService.get(id);
		}
		if (entity == null){
			entity = new ScPay();
		}
		return entity;
	}
	
	/**
	 * 产品购买列表页面
	 */
	@RequiresPermissions("pay:scPay:list")
	@RequestMapping(value = {"list", ""})
	public String list(ScPay scPay, Model model) {
		model.addAttribute("scPay", scPay);
		return "modules/pay/scPayList";
	}
	
		/**
	 * 产品购买列表数据
	 */
	@ResponseBody
	@RequiresPermissions("pay:scPay:list")
	@RequestMapping(value = "data")
	public Map<String, Object> data(ScPay scPay, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ScPay> page = scPayService.findPage(new Page<ScPay>(request, response), scPay); 
		return getBootstrapData(page);
	}

	/**
	 * 查看，增加，编辑产品购买表单页面
	 */
	@RequiresPermissions(value={"pay:scPay:view","pay:scPay:add","pay:scPay:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(ScPay scPay, Model model) {
		model.addAttribute("scPay", scPay);
		return "modules/pay/scPayForm";
	}

	/**
	 * 保存产品购买
	 */
	@ResponseBody
	@RequiresPermissions(value={"pay:scPay:add","pay:scPay:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public AjaxJson save(ScPay scPay, Model model) throws Exception{
		AjaxJson j = new AjaxJson();
		/**
		 * 后台hibernate-validation插件校验
		 */
		String errMsg = beanValidator(scPay);
		if (StringUtils.isNotBlank(errMsg)){
			j.setSuccess(false);
			j.setMsg(errMsg);
			return j;
		}
		//新增或编辑表单保存
		scPayService.save(scPay);//保存
		j.setSuccess(true);
		j.setMsg("保存产品购买成功");
		return j;
	}
	
	/**
	 * 删除产品购买
	 */
	@ResponseBody
	@RequiresPermissions("pay:scPay:del")
	@RequestMapping(value = "delete")
	public AjaxJson delete(ScPay scPay) {
		AjaxJson j = new AjaxJson();
		scPayService.delete(scPay);
		j.setMsg("删除产品购买成功");
		return j;
	}
	
	/**
	 * 批量删除产品购买
	 */
	@ResponseBody
	@RequiresPermissions("pay:scPay:del")
	@RequestMapping(value = "deleteAll")
	public AjaxJson deleteAll(String ids) {
		AjaxJson j = new AjaxJson();
		String idArray[] =ids.split(",");
		for(String id : idArray){
			scPayService.delete(scPayService.get(id));
		}
		j.setMsg("删除产品购买成功");
		return j;
	}
	
	/**
	 * 导出excel文件
	 */
	@ResponseBody
	@RequiresPermissions("pay:scPay:export")
    @RequestMapping(value = "export")
    public AjaxJson exportFile(ScPay scPay, HttpServletRequest request, HttpServletResponse response) {
		AjaxJson j = new AjaxJson();
		try {
            String fileName = "产品购买"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<ScPay> page = scPayService.findPage(new Page<ScPay>(request, response, -1), scPay);
    		new ExportExcel("产品购买", ScPay.class).setDataList(page.getList()).write(response, fileName).dispose();
    		j.setSuccess(true);
    		j.setMsg("导出成功！");
    		return j;
		} catch (Exception e) {
			j.setSuccess(false);
			j.setMsg("导出产品购买记录失败！失败信息："+e.getMessage());
		}
			return j;
    }

	/**
	 * 导入Excel数据

	 */
	@ResponseBody
	@RequiresPermissions("pay:scPay:import")
    @RequestMapping(value = "import")
   	public AjaxJson importFile(@RequestParam("file")MultipartFile file, HttpServletResponse response, HttpServletRequest request) {
		AjaxJson j = new AjaxJson();
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<ScPay> list = ei.getDataList(ScPay.class);
			for (ScPay scPay : list){
				try{
					scPayService.save(scPay);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条产品购买记录。");
			}
			j.setMsg( "已成功导入 "+successNum+" 条产品购买记录"+failureMsg);
		} catch (Exception e) {
			j.setSuccess(false);
			j.setMsg("导入产品购买失败！失败信息："+e.getMessage());
		}
		return j;
    }
	
	/**
	 * 下载导入产品购买数据模板
	 */
	@ResponseBody
	@RequiresPermissions("pay:scPay:import")
    @RequestMapping(value = "import/template")
     public AjaxJson importFileTemplate(HttpServletResponse response) {
		AjaxJson j = new AjaxJson();
		try {
            String fileName = "产品购买数据导入模板.xlsx";
    		List<ScPay> list = Lists.newArrayList(); 
    		new ExportExcel("产品购买数据", ScPay.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			j.setSuccess(false);
			j.setMsg( "导入模板下载失败！失败信息："+e.getMessage());
		}
		return j;
    }

}