/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.test.tree.dialog.entity;

import com.jeeplus.core.persistence.TreeEntity;

/**
 * 组织机构Entity
 *
 * @author liugf
 * @version 2018-06-12
 */
public class TestTree1 extends TreeEntity<TestTree1> {

    private static final long serialVersionUID = 1L;


    public TestTree1() {
        super();
    }

    public TestTree1(String id) {
        super(id);
    }

    @Override
    public TestTree1 getParent() {
        return parent;
    }

    @Override
    public void setParent(TestTree1 parent) {
        this.parent = parent;

    }

    @Override
    public String getParentId() {
        return parent != null && parent.getId() != null ? parent.getId() : "0";
    }
}