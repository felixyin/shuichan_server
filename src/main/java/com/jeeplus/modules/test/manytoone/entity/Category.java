/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.test.manytoone.entity;

import com.jeeplus.core.persistence.TreeEntity;

/**
 * 商品类型Entity
 *
 * @author liugf
 * @version 2018-06-12
 */
public class Category extends TreeEntity<Category> {

    private static final long serialVersionUID = 1L;


    public Category() {
        super();
    }

    public Category(String id) {
        super(id);
    }

    @Override
    public Category getParent() {
        return parent;
    }

    @Override
    public void setParent(Category parent) {
        this.parent = parent;

    }

    @Override
    public String getParentId() {
        return parent != null && parent.getId() != null ? parent.getId() : "0";
    }
}