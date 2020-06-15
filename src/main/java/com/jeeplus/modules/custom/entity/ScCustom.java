/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.custom.entity;

import com.jeeplus.common.utils.excel.annotation.ExcelField;
import com.jeeplus.core.persistence.DataEntity;
import com.jeeplus.modules.sys.entity.Office;

/**
 * 客户Entity
 *
 * @author 尹彬
 * @version 2019-08-16
 */
public class ScCustom extends DataEntity<ScCustom> {

    private static final long serialVersionUID = 1L;
    private String username;        // 姓名
    private String usernamePy;        // 姓名拼音
    private String usernamePyFirst;        // 拼音首字母
    private String phone;        // 电话
    private String address;        // 地址
    private Office office;        // 所属加工厂

    public ScCustom() {
        super();
        this.setIdType(IDTYPE_AUTO);
    }

    public ScCustom(String id) {
        super(id);
    }

    @ExcelField(title = "姓名", align = 2, sort = 5)
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    @ExcelField(title = "姓名拼音", align = 2, sort = 6)
    public String getUsernamePy() {
        return usernamePy;
    }

    public void setUsernamePy(String usernamePy) {
        this.usernamePy = usernamePy;
    }

    @ExcelField(title = "拼音首字母", align = 2, sort = 7)
    public String getUsernamePyFirst() {
        return usernamePyFirst;
    }

    public void setUsernamePyFirst(String usernamePyFirst) {
        this.usernamePyFirst = usernamePyFirst;
    }

    @ExcelField(title = "电话", align = 2, sort = 8)
    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    @ExcelField(title = "地址", align = 2, sort = 9)
    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @ExcelField(title = "所属加工厂", fieldType = Office.class, value = "office.name", align = 2, sort = 10)
    public Office getOffice() {
        return office;
    }

    public void setOffice(Office office) {
        this.office = office;
    }

}