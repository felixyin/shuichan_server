/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.test.manytomany.entity;


import com.jeeplus.common.utils.excel.annotation.ExcelField;
import com.jeeplus.core.persistence.DataEntity;

/**
 * 学生Entity
 *
 * @author lgf
 * @version 2018-06-12
 */
public class Student extends DataEntity<Student> {

    private static final long serialVersionUID = 1L;
    private String name;        // 姓名

    public Student() {
        super();
    }

    public Student(String id) {
        super(id);
    }

    @ExcelField(title = "姓名", align = 2, sort = 1)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

}