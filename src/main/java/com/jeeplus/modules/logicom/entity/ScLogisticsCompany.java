/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.logicom.entity;

import com.google.common.collect.Lists;
import com.jeeplus.common.utils.excel.annotation.ExcelField;
import com.jeeplus.core.persistence.DataEntity;
import com.jeeplus.modules.sys.entity.Office;

import java.util.List;

/**
 * 物流公司Entity
 *
 * @author 尹彬
 * @version 2019-08-16
 */
public class ScLogisticsCompany extends DataEntity<ScLogisticsCompany> {

    private static final long serialVersionUID = 1L;
    private String name;        // 物流名称
    private Office office;        // 所属工厂
    private List<ScLogisticsPrice> scLogisticsPriceList = Lists.newArrayList();        // 子表列表
    private List<ScLogisticsUser> scLogisticsUserList = Lists.newArrayList();        // 子表列表

    public ScLogisticsCompany() {
        super();
        this.setIdType(IDTYPE_AUTO);
    }

    public ScLogisticsCompany(String id) {
        super(id);
    }

    @ExcelField(title = "物流名称", align = 2, sort = 1)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @ExcelField(title = "所属工厂", fieldType = Office.class, value = "office.name", align = 2, sort = 2)
    public Office getOffice() {
        return office;
    }

    public void setOffice(Office office) {
        this.office = office;
    }

    public List<ScLogisticsPrice> getScLogisticsPriceList() {
        return scLogisticsPriceList;
    }

    public void setScLogisticsPriceList(List<ScLogisticsPrice> scLogisticsPriceList) {
        this.scLogisticsPriceList = scLogisticsPriceList;
    }

    public List<ScLogisticsUser> getScLogisticsUserList() {
        return scLogisticsUserList;
    }

    public void setScLogisticsUserList(List<ScLogisticsUser> scLogisticsUserList) {
        this.scLogisticsUserList = scLogisticsUserList;
    }
}