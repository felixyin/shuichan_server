/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.box.entity;

import com.google.common.collect.Lists;
import com.jeeplus.common.utils.excel.annotation.ExcelField;
import com.jeeplus.core.persistence.DataEntity;
import com.jeeplus.modules.boxitem.entity.ScBoxItem;
import com.jeeplus.modules.order.entity.ScOrder;
import com.jeeplus.modules.production.entity.ScProduction;
import com.jeeplus.modules.sys.entity.Office;

import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * 包装箱Entity
 *
 * @author 尹彬
 * @version 2019-08-11
 */
public class ScBox extends DataEntity<ScBox> {

    private static final long serialVersionUID = 1L;
    private ScOrder order;        // 订单
    private String no;        // 装箱单号
    private ScProduction production;        // 规格
    private Double weight = 0D;        // 每箱重量（斤）
    private Integer count = 1;        // 数量（箱）
    private Double singlePrice = 0D;        // 每斤价格
    private Double totalPrice = 0D;        // 总计价格
    private Double deliverTotalPrice = 0D;        // 已发货总价
    private Double logisticsPrice = 0D;        // 单箱快递费
    private Double logisticsTotalPrice = 0D;        // 总计快递费
    private Office allotFactory;        // 调拨工厂
    private Integer status;        // 状态
    private Double beginWeight;        // 开始 每箱重量（斤）
    private Double endWeight;        // 结束 每箱重量（斤）
    private Integer beginCount;        // 开始 数量（箱）
    private Integer endCount;        // 结束 数量（箱）
    private List<ScBoxItem> scBoxItemList = Lists.newArrayList();        // 子表列表

    public ScBox() {
        super();
        this.setIdType(IDTYPE_AUTO);
    }

    public ScBox(String id) {
        super(id);
    }

    public ScBox(ScOrder scOrder) {
        this.order = scOrder;
    }

    @ExcelField(title = "订单", align = 2, sort = 5)
    public ScOrder getOrder() {
        return order;
    }

    public void setOrder(ScOrder order) {
        this.order = order;
    }

    @ExcelField(title = "装箱单号", align = 2, sort = 6)
    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    @NotNull(message = "规格不能为空")
    @ExcelField(title = "规格", fieldType = ScProduction.class, value = "production.name", align = 2, sort = 7)
    public ScProduction getProduction() {
        return production;
    }

    public void setProduction(ScProduction production) {
        this.production = production;
    }

    @NotNull(message = "每箱重量（斤）不能为空")
    @ExcelField(title = "每箱重量（斤）", align = 2, sort = 8)
    public Double getWeight() {
        if (null == weight) {
            return 0D;
        }
        return weight;
    }

    public void setWeight(Double weight) {
        this.weight = weight;
    }

    @NotNull(message = "数量（箱）不能为空")
    @ExcelField(title = "数量（箱）", align = 2, sort = 9)
    public Integer getCount() {
        if (null == count) {
            return 0;
        }
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }

    @ExcelField(title = "每斤价格", align = 2, sort = 10)
    public Double getSinglePrice() {
        if (null == singlePrice) {
            return 0D;
        }
        return singlePrice;
    }

    public void setSinglePrice(Double singlePrice) {
        this.singlePrice = singlePrice;
    }

    @ExcelField(title = "总计价格", align = 2, sort = 11)
    public Double getTotalPrice() {
        if (null == totalPrice) {
            return 0D;
        }
        return totalPrice;
    }

    public void setTotalPrice(Double totalPrice) {
        this.totalPrice = totalPrice;
    }

    @ExcelField(title = "已发货总价", align = 2, sort = 12)
    public Double getDeliverTotalPrice() {
        if (null == deliverTotalPrice) {
            return 0D;
        }
        return deliverTotalPrice;
    }

    public void setDeliverTotalPrice(Double deliverTotalPrice) {
        this.deliverTotalPrice = deliverTotalPrice;
    }

    @ExcelField(title = "单箱快递费", align = 2, sort = 13)
    public Double getLogisticsPrice() {
        if (null == logisticsPrice) {
            return 0D;
        }
        return logisticsPrice;
    }

    public void setLogisticsPrice(Double logisticsPrice) {
        this.logisticsPrice = logisticsPrice;
    }

    @ExcelField(title = "总计快递费", align = 2, sort = 14)
    public Double getLogisticsTotalPrice() {
        if (null == logisticsTotalPrice) {
            return 0D;
        }
        return logisticsTotalPrice;
    }

    public void setLogisticsTotalPrice(Double logisticsTotalPrice) {
        this.logisticsTotalPrice = logisticsTotalPrice;
    }

    @ExcelField(title = "调拨工厂", fieldType = Office.class, value = "allotFactory.name", align = 2, sort = 15)
    public Office getAllotFactory() {
        return allotFactory;
    }

    public void setAllotFactory(Office allotFactory) {
        this.allotFactory = allotFactory;
    }

    //	@NotNull(message="状态不能为空")
    @ExcelField(title = "状态", dictType = "status_box", align = 2, sort = 11)
    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
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

    public List<ScBoxItem> getScBoxItemList() {
        return scBoxItemList;
    }

    public void setScBoxItemList(List<ScBoxItem> scBoxItemList) {
        this.scBoxItemList = scBoxItemList;
    }
}