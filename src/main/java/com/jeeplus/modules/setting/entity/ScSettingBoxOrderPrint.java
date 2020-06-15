/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.setting.entity;


import com.jeeplus.common.utils.CacheUtils;
import com.jeeplus.core.persistence.DataEntity;
import com.jeeplus.common.utils.excel.annotation.ExcelField;
import com.jeeplus.modules.sys.utils.UserUtils;

/**
 * 装箱单打印设置Entity
 * @author 尹彬
 * @version 2019-12-17
 */
public class ScSettingBoxOrderPrint extends DataEntity<ScSettingBoxOrderPrint> {
	
	private static final long serialVersionUID = 1L;
	//    type: "1",
	private String printType = "1";  // 1 标签打印  2 A4打印
	//    border: "1",
	private String border = "1";
	//    tableHead: "1",
	private String tableHead = "1";
	//    jin: "1",
	private String jin = "1";
	//    logistics: "1",
	private String logistics = "1";
	//    shift: "1",
	private String shift = "1";
	//    count: "1",
	private String count = "1";
	//    receiverBold: "on",
	private String receiverBold = "on";
	//    receiverNewline: "on",
	private String receiverNewline = "on";
	//    receiverFontsize: "38",
	private String receiverFontsize = "45";
	//    remarksFontsize: "35",
	private String remarksFontsize = "40";
	//    pageWidth: "0",
	private int pageWidth = 0;
	//    pageHeight: "0",
	private int pageHeight = 0;
	//    remarksOffset: "0",
	private int remarksOffset = 6;
	//    printAdjusting: "on"
	private String printAdjusting = "on";


	public ScSettingBoxOrderPrint() {
		super();
		this.setIdType(IDTYPE_AUTO);
	}

	public ScSettingBoxOrderPrint(String id){
		super(id);
	}

	@ExcelField(title="打印方式", align=2, sort=7)
	public String getPrintType() {
		return printType;
	}

	public void setPrintType(String printType) {
		this.printType = printType;
	}
	
	@ExcelField(title="打印边框", align=2, sort=8)
	public String getBorder() {
		return border;
	}

	public void setBorder(String border) {
		this.border = border;
	}
	
	@ExcelField(title="打印表头", align=2, sort=9)
	public String getTableHead() {
		return tableHead;
	}

	public void setTableHead(String tableHead) {
		this.tableHead = tableHead;
	}
	
	@ExcelField(title="打印斤数", align=2, sort=10)
	public String getJin() {
		return jin;
	}

	public void setJin(String jin) {
		this.jin = jin;
	}
	
	@ExcelField(title="打印物流公司", align=2, sort=11)
	public String getLogistics() {
		return logistics;
	}

	public void setLogistics(String logistics) {
		this.logistics = logistics;
	}
	
	@ExcelField(title="打印班次", align=2, sort=12)
	public String getShift() {
		return shift;
	}

	public void setShift(String shift) {
		this.shift = shift;
	}
	
	@ExcelField(title="打印数量", align=2, sort=13)
	public String getCount() {
		return count;
	}

	public void setCount(String count) {
		this.count = count;
	}
	
	@ExcelField(title="收件信息加粗", align=2, sort=14)
	public String getReceiverBold() {
		return receiverBold;
	}

	public void setReceiverBold(String receiverBold) {
		this.receiverBold = receiverBold;
	}
	
	@ExcelField(title="地址和姓名换行", align=2, sort=15)
	public String getReceiverNewline() {
		return receiverNewline;
	}

	public void setReceiverNewline(String receiverNewline) {
		this.receiverNewline = receiverNewline;
	}
	
	@ExcelField(title="收件信息字体", align=2, sort=16)
	public String getReceiverFontsize() {
		return receiverFontsize;
	}

	public void setReceiverFontsize(String receiverFontsize) {
		this.receiverFontsize = receiverFontsize;
	}
	
	@ExcelField(title="备注字体", align=2, sort=17)
	public String getRemarksFontsize() {
		return remarksFontsize;
	}

	public void setRemarksFontsize(String remarksFontsize) {
		this.remarksFontsize = remarksFontsize;
	}
	
	@ExcelField(title="页面宽度", align=2, sort=18)
	public Integer getPageWidth() {
		return pageWidth;
	}

	public void setPageWidth(Integer pageWidth) {
		this.pageWidth = pageWidth;
	}
	
	@ExcelField(title="页面高度", align=2, sort=19)
	public Integer getPageHeight() {
		return pageHeight;
	}

	public void setPageHeight(Integer pageHeight) {
		this.pageHeight = pageHeight;
	}
	
	@ExcelField(title="备注起始位置", align=2, sort=20)
	public Integer getRemarksOffset() {
		return remarksOffset;
	}

	public void setRemarksOffset(Integer remarksOffset) {
		this.remarksOffset = remarksOffset;
	}
	
	@ExcelField(title="打印调货的装箱单", align=2, sort=21)
	public String getPrintAdjusting() {
		return printAdjusting;
	}

	public void setPrintAdjusting(String printAdjusting) {
		this.printAdjusting = printAdjusting;
	}
	
}