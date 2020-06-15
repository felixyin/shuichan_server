/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.oimport.entity;

import com.jeeplus.common.utils.excel.annotation.ExcelField;
import com.jeeplus.core.persistence.DataEntity;
import com.jeeplus.modules.sys.entity.User;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;

/**
 * 导入订单Entity
 *
 * @author 尹彬
 * @version 2019-08-23
 */
public class ScOrderImport extends DataEntity<ScOrderImport> {

    private static final long serialVersionUID = 1L;
    private User user;        // user_id
    private String phone;        // 电话
    private String username;        // 姓名
    private String address;        // 地址
    private String agentName;        // 代理人
    private String logisticsName;        // 物流公司
    private String shiftName;        // 物流班次
    private String factoryName;        // 所属加工厂
    private String allotFactoryName;        // 调拨加工厂
    private String productionName;        // 品名（规格）
    private Double lastUnitPrice;        // 每斤价格
    private Double weight;        // 单箱重量（斤）
    private Integer count;        // 数量（箱）
    private Double logisticsPrice;        // 单箱快递费
    private Double beginWeight;        // 开始 单箱重量（斤）
    private Double endWeight;        // 结束 单箱重量（斤）
    private Integer beginCount;        // 开始 数量（箱）
    private Integer endCount;        // 结束 数量（箱）
    private Double beginLogisticsPrice;        // 开始 单箱快递费
    private Double endLogisticsPrice;        // 结束 单箱快递费

    public ScOrderImport() {
        super();
        this.setIdType(IDTYPE_AUTO);
    }

    public ScOrderImport(String id) {
        super(id);
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @ExcelField(title = "电话", align = 2, sort = 2)
    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    @ExcelField(title = "姓名", align = 2, sort = 3)
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    @ExcelField(title = "地址", align = 2, sort = 4)
    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @ExcelField(title = "代理人", align = 2, sort = 5)
    public String getAgentName() {
        return agentName;
    }

    public void setAgentName(String agentName) {
        this.agentName = agentName;
    }

    @ExcelField(title = "物流公司", align = 2, sort = 6)
    public String getLogisticsName() {
        return logisticsName;
    }

    public void setLogisticsName(String logisticsName) {
        this.logisticsName = logisticsName;
    }

    @ExcelField(title = "物流班次", align = 2, sort = 7)
    public String getShiftName() {
        return shiftName;
    }

    public void setShiftName(String shiftName) {
        this.shiftName = shiftName;
    }

    public String getFactoryName() {
        return factoryName;
    }

    public void setFactoryName(String factoryName) {
        this.factoryName = factoryName;
    }

    public String getAllotFactoryName() {
        return allotFactoryName;
    }

    public void setAllotFactoryName(String allotFactoryName) {
        this.allotFactoryName = allotFactoryName;
    }

    @ExcelField(title = "品名（规格）", align = 2, sort = 10)
    public String getProductionName() {
        return productionName;
    }

    public void setProductionName(String productionName) {
        this.productionName = productionName;
    }

    @NotNull(message = "每斤价格不能为空")
    @ExcelField(title = "每斤价格", align = 2, sort = 11)
    public Double getLastUnitPrice() {
        return lastUnitPrice;
    }

    public void setLastUnitPrice(Double lastUnitPrice) {
        this.lastUnitPrice = lastUnitPrice;
    }

    @NotNull(message = "单箱重量（斤）不能为空")
    @ExcelField(title = "单箱重量（斤）", align = 2, sort = 12)
    public Double getWeight() {
        return weight;
    }

    public void setWeight(Double weight) {
        this.weight = weight;
    }

    @NotNull(message = "数量（箱）不能为空")
    @ExcelField(title = "数量（箱）", align = 2, sort = 13)
    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }

    @ExcelField(title = "单箱快递费", align = 2, sort = 14)
    public Double getLogisticsPrice() {
        return logisticsPrice;
    }

    public void setLogisticsPrice(Double logisticsPrice) {
        this.logisticsPrice = logisticsPrice;
    }

    public Double getBeginWeight() {
        return beginWeight;
    }

    public void setBeginWeight(Double beginWeight) {
        this.beginWeight = beginWeight;
    }

    public Double getEndWeight() {
        return endWeight;
    }

    public void setEndWeight(Double endWeight) {
        this.endWeight = endWeight;
    }

    public Integer getBeginCount() {
        return beginCount;
    }

    public void setBeginCount(Integer beginCount) {
        this.beginCount = beginCount;
    }

    public Integer getEndCount() {
        return endCount;
    }

    public void setEndCount(Integer endCount) {
        this.endCount = endCount;
    }

    public Double getBeginLogisticsPrice() {
        return beginLogisticsPrice;
    }

    public void setBeginLogisticsPrice(Double beginLogisticsPrice) {
        this.beginLogisticsPrice = beginLogisticsPrice;
    }

    public Double getEndLogisticsPrice() {
        return endLogisticsPrice;
    }

    public void setEndLogisticsPrice(Double endLogisticsPrice) {
        this.endLogisticsPrice = endLogisticsPrice;
    }

    @Override
    @ExcelField(title = "备注", align = 2, sort = 15)
    @Length(min = 0, max = 255)
    public String getRemarks() {
        return remarks;
    }

    @Override
    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

}