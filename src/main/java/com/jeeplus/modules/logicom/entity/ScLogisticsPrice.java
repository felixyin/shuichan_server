/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.logicom.entity;

import com.jeeplus.common.utils.excel.annotation.ExcelField;
import com.jeeplus.core.persistence.DataEntity;

import javax.validation.constraints.NotNull;

/**
 * 物流价格Entity
 *
 * @author 尹彬
 * @version 2019-08-16
 */
public class ScLogisticsPrice extends DataEntity<ScLogisticsPrice> {

    private static final long serialVersionUID = 1L;
    private ScLogisticsCompany logisticsCompany;        // 物流公司
    private Integer gtJin;        // 箱大于几斤
    private Integer ltJin;        // 箱小于几斤
    private Double price;        // 配送费

    public ScLogisticsPrice() {
        super();
        this.setIdType(IDTYPE_AUTO);
    }

    public ScLogisticsPrice(String id) {
        super(id);
    }

    public ScLogisticsPrice(ScLogisticsCompany scLogisticsCompany) {
        this.logisticsCompany = scLogisticsCompany;
    }

    @ExcelField(title = "物流公司", align = 2, sort = 1)
    public ScLogisticsCompany getLogisticsCompany() {
        return logisticsCompany;
    }

    public void setLogisticsCompany(ScLogisticsCompany logisticsCompany) {
        this.logisticsCompany = logisticsCompany;
    }

    @NotNull(message = "箱大于几斤不能为空")
    @ExcelField(title = "箱大于几斤", align = 2, sort = 2)
    public Integer getGtJin() {
        return gtJin;
    }

    public void setGtJin(Integer gtJin) {
        this.gtJin = gtJin;
    }

    @NotNull(message = "箱小于几斤不能为空")
    @ExcelField(title = "箱小于几斤", align = 2, sort = 3)
    public Integer getLtJin() {
        return ltJin;
    }

    public void setLtJin(Integer ltJin) {
        this.ltJin = ltJin;
    }

    @NotNull(message = "配送费不能为空")
    @ExcelField(title = "配送费", align = 2, sort = 4)
    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

}