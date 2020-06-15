/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.production.entity;

import com.google.common.collect.Lists;
import com.jeeplus.core.persistence.TreeEntity;
import com.jeeplus.modules.sys.entity.Office;

import java.util.List;

/**
 * 产品Entity
 *
 * @author 尹彬
 * @version 2019-08-18
 */
public class ScProductionCategory extends TreeEntity<ScProductionCategory> {

    private static final long serialVersionUID = 1L;
    private Office office;        // 所属公司

    private List<ScProduction> scProductionList = Lists.newArrayList();        // 子表列表

    public ScProductionCategory() {
        super();
        this.setIdType(IDTYPE_AUTO);
    }

    public ScProductionCategory(String id) {
        super(id);
        this.setIdType(IDTYPE_AUTO);
    }

    public Office getOffice() {
        return office;
    }

    public void setOffice(Office office) {
        this.office = office;
    }

    @Override
    public ScProductionCategory getParent() {
        return parent;
    }

    @Override
    public void setParent(ScProductionCategory parent) {
        this.parent = parent;

    }

    public List<ScProduction> getScProductionList() {
        return scProductionList;
    }

    public void setScProductionList(List<ScProduction> scProductionList) {
        this.scProductionList = scProductionList;
    }

    @Override
    public String getParentId() {
        return parent != null && parent.getId() != null ? parent.getId() : "0";
    }
}