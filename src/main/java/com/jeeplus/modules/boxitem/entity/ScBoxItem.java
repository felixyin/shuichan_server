/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.boxitem.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.jeeplus.common.utils.excel.annotation.ExcelField;
import com.jeeplus.core.persistence.DataEntity;
import com.jeeplus.modules.box.entity.ScBox;
import com.jeeplus.modules.sys.entity.User;

import javax.validation.constraints.NotNull;
import java.util.Date;

/**
 * 每箱Entity
 *
 * @author 尹彬
 * @version 2019-08-14
 */
public class ScBoxItem extends DataEntity<ScBoxItem> {

    private static final long serialVersionUID = 1L;
    private ScBox box;        // 所属箱子 父类
    private String serialNum;        // 生成编号
    private Integer few;        // 第几箱
    private Integer process;        // 进度
    private User printUser;        // 打印者
    private Date printDate;        // 打印时间
    private User productionUser;        // 生产者
    private Date productionDate;        // 生产时间
    private User packageUser;        // 包装者
    private Date packageDate;        // 包装时间
    private String photos;        // 包装照片
    private User logisticsUser;        // 快递员
    private Date logisticsDate;        // 取件时间
    private Date beginPrintDate;        // 开始 打印时间
    private Date endPrintDate;        // 结束 打印时间
    private Date beginProductionDate;        // 开始 生产时间
    private Date endProductionDate;        // 结束 生产时间
    private Date beginPackageDate;        // 开始 包装时间
    private Date endPackageDate;        // 结束 包装时间
    private Date beginLogisticsDate;        // 开始 取件时间
    private Date endLogisticsDate;        // 结束 取件时间

    public ScBoxItem() {
        super();
        this.setIdType(IDTYPE_AUTO);
    }

    public ScBoxItem(String id) {
        super(id);
    }

    public ScBoxItem(ScBox box) {
        this.box = box;
    }

    @NotNull(message = "所属箱子不能为空")
    public ScBox getBox() {
        return box;
    }

    public void setBox(ScBox box) {
        this.box = box;
    }

    @ExcelField(title = "生成编号", align = 2, sort = 7)
    public String getSerialNum() {
        return serialNum;
    }

    public void setSerialNum(String serialNum) {
        this.serialNum = serialNum;
    }

    @NotNull(message = "第几箱不能为空")
    @ExcelField(title = "第几箱", align = 2, sort = 8)
    public Integer getFew() {
        return few;
    }

    public void setFew(Integer few) {
        this.few = few;
    }

    @ExcelField(title = "进度", dictType = "process_box_item", align = 2, sort = 9)
    public Integer getProcess() {
        return process;
    }

    public void setProcess(Integer process) {
        this.process = process;
    }

    @ExcelField(title = "打印者", fieldType = User.class, value = "printUser.name", align = 2, sort = 10)
    public User getPrintUser() {
        return printUser;
    }

    public void setPrintUser(User printUser) {
        this.printUser = printUser;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @ExcelField(title = "打印时间", align = 2, sort = 11)
    public Date getPrintDate() {
        return printDate;
    }

    public void setPrintDate(Date printDate) {
        this.printDate = printDate;
    }

    @ExcelField(title = "生产者", fieldType = User.class, value = "productionUser.name", align = 2, sort = 12)
    public User getProductionUser() {
        return productionUser;
    }

    public void setProductionUser(User productionUser) {
        this.productionUser = productionUser;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @ExcelField(title = "生产时间", align = 2, sort = 13)
    public Date getProductionDate() {
        return productionDate;
    }

    public void setProductionDate(Date productionDate) {
        this.productionDate = productionDate;
    }

    @ExcelField(title = "包装者", fieldType = User.class, value = "packageUser.name", align = 2, sort = 14)
    public User getPackageUser() {
        return packageUser;
    }

    public void setPackageUser(User packageUser) {
        this.packageUser = packageUser;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @ExcelField(title = "包装时间", align = 2, sort = 15)
    public Date getPackageDate() {
        return packageDate;
    }

    public void setPackageDate(Date packageDate) {
        this.packageDate = packageDate;
    }

    @ExcelField(title = "包装照片", align = 2, sort = 16)
    public String getPhotos() {
        return photos;
    }

    public void setPhotos(String photos) {
        this.photos = photos;
    }

    @ExcelField(title = "快递员", fieldType = User.class, value = "logisticsUser.name", align = 2, sort = 17)
    public User getLogisticsUser() {
        return logisticsUser;
    }

    public void setLogisticsUser(User logisticsUser) {
        this.logisticsUser = logisticsUser;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @ExcelField(title = "取件时间", align = 2, sort = 18)
    public Date getLogisticsDate() {
        return logisticsDate;
    }

    public void setLogisticsDate(Date logisticsDate) {
        this.logisticsDate = logisticsDate;
    }

    public Date getBeginPrintDate() {
        return beginPrintDate;
    }

    public void setBeginPrintDate(Date beginPrintDate) {
        this.beginPrintDate = beginPrintDate;
    }

    public Date getEndPrintDate() {
        return endPrintDate;
    }

    public void setEndPrintDate(Date endPrintDate) {
        this.endPrintDate = endPrintDate;
    }

    public Date getBeginProductionDate() {
        return beginProductionDate;
    }

    public void setBeginProductionDate(Date beginProductionDate) {
        this.beginProductionDate = beginProductionDate;
    }

    public Date getEndProductionDate() {
        return endProductionDate;
    }

    public void setEndProductionDate(Date endProductionDate) {
        this.endProductionDate = endProductionDate;
    }

    public Date getBeginPackageDate() {
        return beginPackageDate;
    }

    public void setBeginPackageDate(Date beginPackageDate) {
        this.beginPackageDate = beginPackageDate;
    }

    public Date getEndPackageDate() {
        return endPackageDate;
    }

    public void setEndPackageDate(Date endPackageDate) {
        this.endPackageDate = endPackageDate;
    }

    public Date getBeginLogisticsDate() {
        return beginLogisticsDate;
    }

    public void setBeginLogisticsDate(Date beginLogisticsDate) {
        this.beginLogisticsDate = beginLogisticsDate;
    }

    public Date getEndLogisticsDate() {
        return endLogisticsDate;
    }

    public void setEndLogisticsDate(Date endLogisticsDate) {
        this.endLogisticsDate = endLogisticsDate;
    }

}