/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.order.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.google.common.collect.Lists;
import com.jeeplus.common.utils.excel.annotation.ExcelField;
import com.jeeplus.core.persistence.DataEntity;
import com.jeeplus.modules.box.entity.ScBox;
import com.jeeplus.modules.custom.entity.ScCustom;
import com.jeeplus.modules.sys.entity.Office;

import java.util.Date;
import java.util.List;

/**
 * 订单Entity
 *
 * @author 尹彬
 * @version 2019-08-09
 */
public class ScOrder extends DataEntity<ScOrder> {

    private static final long serialVersionUID = 1L;
    private String no;        // 订单号
    private String agentName;        // 代理人
    private ScCustom custom;        // 客户
    private Office shouldLogistics;        // 指定物流公司
    private Integer shift;        // 物流班次
    private Office factory;        // 所属加工厂
    private Office realLogistics;        // 实取物流公司
    private Double goodsOrderPrice = 0D;        // 货物总价
    private Double deliverOrderPrice = 0D;        // 已发货总价
    private Double logisticsOrderPrice = 0D;        // 物流总价
    private Double willPayPrice = 0D;        // 客户应付
    private Double realPayPrice = 0D;        // 客户实付
    private Date deliverDate;        // 要求发货时间
    private Integer tomorrowCancellation;        // 明天未发作废
    private Integer status;        // 状态
    private String logisticsRemarks; // 物流备注
    private Date beginDeliverDate;        // 开始 要求发货时间
    private Date endDeliverDate;        // 结束 要求发货时间
    private Date beginCreateDate;        // 开始 创建时间
    private Date endCreateDate;        // 结束 创建时间
    private Date createDate; // 统计报表用，查询某一天的全部的订单
    private List<ScBox> scBoxList = Lists.newArrayList();        // 子表列表

    public ScOrder() {
        super();
        this.setIdType(IDTYPE_AUTO);
    }

    public ScOrder(String id) {
        super(id);
    }

    @ExcelField(title = "订单号", align = 2, sort = 0)
    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    @ExcelField(title = "代理人", align = 2, sort = 1)
    public String getAgentName() {
        return agentName;
    }

    public void setAgentName(String agentName) {
        this.agentName = agentName;
    }

    //    @NotNull(message = "客户不能为空")
    @ExcelField(title = "客户", fieldType = ScCustom.class, value = "custom.username", align = 2, sort = 2)
    public ScCustom getCustom() {
        return custom;
    }

    public void setCustom(ScCustom custom) {
        this.custom = custom;
    }

    @ExcelField(title = "物流班次", dictType = "logistics_shift", align = 2, sort = 4)
    public Integer getShift() {
        return shift;
    }

    public void setShift(Integer shift) {
        this.shift = shift;
    }

    // 所属加工厂，默认是当前excel导入时登陆的用户对应的加工厂，不需要用户手动填写
//    @ExcelField(title = "所属加工厂", fieldType = Office.class, value = "factory.name", align = 2, sort = 5)
    public Office getFactory() {
        return factory;
    }

    public void setFactory(Office factory) {
        this.factory = factory;
    }

    @ExcelField(title = "实取物流公司", fieldType = Office.class, value = "realLogistics.name", align = 2, sort = 6)
    public Office getRealLogistics() {
        return realLogistics;
    }

    public void setRealLogistics(Office realLogistics) {
        this.realLogistics = realLogistics;
    }

    @ExcelField(title = "货物总价", align = 2, sort = 7)
    public Double getGoodsOrderPrice() {
        return goodsOrderPrice;
    }

    public void setGoodsOrderPrice(Double goodsOrderPrice) {
        this.goodsOrderPrice = goodsOrderPrice;
    }

    @ExcelField(title = "已发货总价", align = 2, sort = 8)
    public Double getDeliverOrderPrice() {
        return deliverOrderPrice;
    }

    public void setDeliverOrderPrice(Double deliverOrderPrice) {
        this.deliverOrderPrice = deliverOrderPrice;
    }

    @ExcelField(title = "物流总价", align = 2, sort = 9)
    public Double getLogisticsOrderPrice() {
        return logisticsOrderPrice;
    }

    public void setLogisticsOrderPrice(Double logisticsOrderPrice) {
        this.logisticsOrderPrice = logisticsOrderPrice;
    }

    @ExcelField(title = "客户应付", align = 2, sort = 10)
    public Double getWillPayPrice() {
        return willPayPrice;
    }

    public void setWillPayPrice(Double willPayPrice) {
        this.willPayPrice = willPayPrice;
    }

    @ExcelField(title = "客户实付", align = 2, sort = 11)
    public Double getRealPayPrice() {
        return realPayPrice;
    }

    public void setRealPayPrice(Double realPayPrice) {
        this.realPayPrice = realPayPrice;
    }

    @JsonFormat(pattern = "yyyy-MM-dd")
    @ExcelField(title = "要求发货时间", align = 2, sort = 12)
    public Date getDeliverDate() {
        return deliverDate;
    }

    public void setDeliverDate(Date deliverDate) {
        this.deliverDate = deliverDate;
    }

    @ExcelField(title = "明天未发作废", dictType = "tomorrow_cancellation", align = 2, sort = 13)
    public Integer getTomorrowCancellation() {
        return tomorrowCancellation;
    }

    public void setTomorrowCancellation(Integer tomorrowCancellation) {
        this.tomorrowCancellation = tomorrowCancellation;
    }

    @ExcelField(title = "状态", dictType = "status_order", align = 2, sort = 14)
    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Date getBeginDeliverDate() {
        return beginDeliverDate;
    }

    public void setBeginDeliverDate(Date beginDeliverDate) {
        this.beginDeliverDate = beginDeliverDate;
    }

    public Date getEndDeliverDate() {
        return endDeliverDate;
    }

    public void setEndDeliverDate(Date endDeliverDate) {
        this.endDeliverDate = endDeliverDate;
    }

    public Date getBeginCreateDate() {
        return beginCreateDate;
    }

    public void setBeginCreateDate(Date beginCreateDate) {
        this.beginCreateDate = beginCreateDate;
    }

    public Date getEndCreateDate() {
        return endCreateDate;
    }

    public void setEndCreateDate(Date endCreateDate) {
        this.endCreateDate = endCreateDate;
    }

    public List<ScBox> getScBoxList() {
        return scBoxList;
    }

    public void setScBoxList(List<ScBox> scBoxList) {
        this.scBoxList = scBoxList;
    }

    public String getLogisticsRemarks() {
        return logisticsRemarks;
    }

    public void setLogisticsRemarks(String logisticsRemarks) {
        this.logisticsRemarks = logisticsRemarks;
    }

    @ExcelField(title = "指定物流公司", fieldType = Office.class, value = "realLogistics.name", align = 2, sort = 6)
    public Office getShouldLogistics() {
        return shouldLogistics;
    }

    public void setShouldLogistics(Office shouldLogistics) {
        this.shouldLogistics = shouldLogistics;
    }

    @Override
    @JsonFormat(pattern = "yyyy-MM-dd")
    public Date getCreateDate() {
        return createDate;
    }

    @Override
    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }
}