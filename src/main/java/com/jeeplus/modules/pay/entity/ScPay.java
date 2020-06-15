/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.pay.entity;

import com.jeeplus.modules.sys.entity.Office;
import com.jeeplus.modules.sys.entity.User;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import com.jeeplus.core.persistence.DataEntity;
import com.jeeplus.common.utils.excel.annotation.ExcelField;

/**
 * 产品购买Entity
 * @author 尹彬
 * @version 2019-10-20
 */
public class ScPay extends DataEntity<ScPay> {
	
	private static final long serialVersionUID = 1L;
	private String tradeNo;		// 订单编号
	private String subject;		// 订单名称
	private String body;		// 商品描述
	private Integer payModel;		// 套餐
	private Integer payType;		// 支付方式
	private Office office;		// 加工厂
	private User user;		// 支付账号
	private String money;		// 支付金额
	private Date payDate;		// 支付时间
	private Date endDate;		// 截止日期
	private String returnNo;		// 支付平台编号
	private Integer returnSuccess;		// 支付状态
	private String returnMessage;		// 支付消息
	private String beginMoney;		// 开始 支付金额
	private String endMoney;		// 结束 支付金额
	private Date beginEndDate;		// 开始 截止日期
	private Date endEndDate;		// 结束 截止日期
	
	public ScPay() {
		super();
	}

	public ScPay(String id){
		super(id);
	}

	@ExcelField(title="订单编号", align=2, sort=6)
	public String getTradeNo() {
		return tradeNo;
	}

	public void setTradeNo(String tradeNo) {
		this.tradeNo = tradeNo;
	}
	
	@ExcelField(title="订单名称", align=2, sort=7)
	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}
	
	@ExcelField(title="商品描述", align=2, sort=8)
	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}
	
	@ExcelField(title="套餐", dictType="pay_model", align=2, sort=9)
	public Integer getPayModel() {
		return payModel;
	}

	public void setPayModel(Integer payModel) {
		this.payModel = payModel;
	}
	
	@ExcelField(title="支付方式", dictType="pay_type", align=2, sort=10)
	public Integer getPayType() {
		return payType;
	}

	public void setPayType(Integer payType) {
		this.payType = payType;
	}
	
	@ExcelField(title="加工厂", fieldType=Office.class, value="office.name", align=2, sort=11)
	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}
	
	@ExcelField(title="支付账号", fieldType=User.class, value="user.name", align=2, sort=12)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@ExcelField(title="支付金额", align=2, sort=13)
	public String getMoney() {
		return money;
	}

	public void setMoney(String money) {
		this.money = money;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="支付时间", align=2, sort=14)
	public Date getPayDate() {
		return payDate;
	}

	public void setPayDate(Date payDate) {
		this.payDate = payDate;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="截止日期", align=2, sort=15)
	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	
	@ExcelField(title="支付平台编号", align=2, sort=16)
	public String getReturnNo() {
		return returnNo;
	}

	public void setReturnNo(String returnNo) {
		this.returnNo = returnNo;
	}
	
	@ExcelField(title="支付状态", dictType="pay_return_success", align=2, sort=17)
	public Integer getReturnSuccess() {
		return returnSuccess;
	}

	public void setReturnSuccess(Integer returnSuccess) {
		this.returnSuccess = returnSuccess;
	}
	
	@ExcelField(title="支付消息", align=2, sort=18)
	public String getReturnMessage() {
		return returnMessage;
	}

	public void setReturnMessage(String returnMessage) {
		this.returnMessage = returnMessage;
	}
	
	public String getBeginMoney() {
		return beginMoney;
	}

	public void setBeginMoney(String beginMoney) {
		this.beginMoney = beginMoney;
	}
	
	public String getEndMoney() {
		return endMoney;
	}

	public void setEndMoney(String endMoney) {
		this.endMoney = endMoney;
	}
		
	public Date getBeginEndDate() {
		return beginEndDate;
	}

	public void setBeginEndDate(Date beginEndDate) {
		this.beginEndDate = beginEndDate;
	}
	
	public Date getEndEndDate() {
		return endEndDate;
	}

	public void setEndEndDate(Date endEndDate) {
		this.endEndDate = endEndDate;
	}
		
}