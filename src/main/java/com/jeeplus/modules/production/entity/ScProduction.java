/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.production.entity;

import com.jeeplus.common.utils.excel.annotation.ExcelField;
import com.jeeplus.core.persistence.DataEntity;
import com.jeeplus.modules.sys.entity.Office;

/**
 * 产品Entity
 *
 * @author 尹彬
 * @version 2019-08-18
 */
public class ScProduction extends DataEntity<ScProduction> {

    private static final long serialVersionUID = 1L;
    private ScProductionCategory productionCategory;        // 分类 父类
    private String name;        // 品名（规格）
    private Double lastUnitPrice;        // 每斤价格
    private Office office;        // 所属工厂
    private Double beginLastUnitPrice;        // 开始 每斤价格
    private Double endLastUnitPrice;        // 结束 每斤价格
    private String pyFirst;
    private String py;

    public ScProduction() {
        super();
        this.setIdType(IDTYPE_AUTO);
    }

    public ScProduction(String id) {
        super(id);
    }

    public ScProduction(ScProductionCategory productionCategory) {
        this.productionCategory = productionCategory;
    }

    public ScProductionCategory getProductionCategory() {
        return productionCategory;
    }

    public void setProductionCategory(ScProductionCategory productionCategory) {
        this.productionCategory = productionCategory;
    }

    @ExcelField(title = "品名（规格）", align = 2, sort = 2)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @ExcelField(title = "每斤价格", align = 2, sort = 3)
    public Double getLastUnitPrice() {
        return lastUnitPrice;
    }

    public void setLastUnitPrice(Double lastUnitPrice) {
        this.lastUnitPrice = lastUnitPrice;
    }

    @ExcelField(title = "所属工厂", fieldType = Office.class, value = "office.name", align = 2, sort = 4)
    public Office getOffice() {
        return office;
    }

    public void setOffice(Office office) {
        this.office = office;
    }

    public Double getBeginLastUnitPrice() {
        return beginLastUnitPrice;
    }

    public void setBeginLastUnitPrice(Double beginLastUnitPrice) {
        this.beginLastUnitPrice = beginLastUnitPrice;
    }

    public Double getEndLastUnitPrice() {
        return endLastUnitPrice;
    }

    public void setEndLastUnitPrice(Double endLastUnitPrice) {
        this.endLastUnitPrice = endLastUnitPrice;
    }

    public String getPyFirst() {
        return pyFirst;
    }

    public void setPyFirst(String pyFirst) {
        this.pyFirst = pyFirst;
    }

    public String getPy() {
        return py;
    }

    public void setPy(String py) {
        this.py = py;
    }
}