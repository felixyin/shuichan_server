/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.setting.entity;


import com.jeeplus.core.persistence.DataEntity;
import com.jeeplus.common.utils.excel.annotation.ExcelField;

/**
 * 出货单打印设置Entity
 * @author 尹彬
 * @version 2019-12-17
 */
public class ScSettingOutOrderPrint extends DataEntity<ScSettingOutOrderPrint> {
	
	private static final long serialVersionUID = 1L;

	//    logistics: "1",
	private String logistics = "1";
	//    shift: "1",
	private String shift = "1";
	//    num: "1",
	private String num = "1";
	//    name: "1",
	private String name = "1";
	//    address: "1",
	private String address = "1";
	//    phone: "1",
	private String phone = "1";
	//    spec: "1",
	private String spec = "1";
	//    count: "1",
	private String count = "1";
	
	public ScSettingOutOrderPrint() {
		super();
		this.setIdType(IDTYPE_AUTO);
	}

	public ScSettingOutOrderPrint(String id){
		super(id);
	}

	@ExcelField(title="打印物流公司", align=2, sort=7)
	public String getLogistics() {
		return logistics;
	}

	public void setLogistics(String logistics) {
		this.logistics = logistics;
	}
	
	@ExcelField(title="打印班次", align=2, sort=8)
	public String getShift() {
		return shift;
	}

	public void setShift(String shift) {
		this.shift = shift;
	}
	
	@ExcelField(title="打印序号", align=2, sort=9)
	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}
	
	@ExcelField(title="打印规格", align=2, sort=10)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@ExcelField(title="打印地址", align=2, sort=11)
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	
	@ExcelField(title="打印手机号", align=2, sort=12)
	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}
	
	@ExcelField(title="打印规格", align=2, sort=13)
	public String getSpec() {
		return spec;
	}

	public void setSpec(String spec) {
		this.spec = spec;
	}
	
	@ExcelField(title="打印数量", align=2, sort=14)
	public String getCount() {
		return count;
	}

	public void setCount(String count) {
		this.count = count;
	}
	
}