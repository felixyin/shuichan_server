/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.sys.entity;

import com.jeeplus.common.utils.CacheUtils;
import com.jeeplus.core.persistence.TreeEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * 机构Entity
 *
 * @author jeeplus
 * @version 2016-05-15
 */
public class Office extends TreeEntity<Office> {

    private static final long serialVersionUID = 1L;
    private Area area;        // 归属区域
    private String code;    // 机构编码
    private String type;    // 机构类型（1：公司；2：部门；3：小组）
    private String grade;    // 机构等级（1：一级；2：二级；3：三级；4：四级）
    private String address; // 联系地址
    private String zipCode; // 邮政编码
    private String master;    // 负责人
    private String phone;    // 电话
    private String fax;    // 传真
    private String email;    // 邮箱
    private String useable;//是否可用
    private User primaryPerson;//主负责人
    private User deputyPerson;//副负责人
    private List<String> childDeptList;//快速添加子部门

    // 自动完成使用
    private String pyFirst; // 拼音首字母
    private String py; // 拼音

    public Office() {
        super();
        this.type = "2";
    }

    public Office(String id) {
        super(id);
    }

    public static void newSerialNumberStatic(String officeId) {
        String key = "box-" + officeId;
        Object o = CacheUtils.get(key);
        if (null == o) {
            CacheUtils.remove(key);
        }
        CacheUtils.put(key, 1);
    }

    public static void putSerialNumberStatic(String officeId, int value) {
        String key = officeId;
        Object o = CacheUtils.get(key);
        if (null == o) {
            CacheUtils.put(key, 1);
        }
        CacheUtils.put(key, value);
    }

    public static int getSerialNumberStatic(String officeId) {
        String key = officeId;
        Object o = CacheUtils.get(key);
        if (null == o) {
            o = 1;
            CacheUtils.put(key, o);
        }
        return (int) o;
    }

    public List<String> getChildDeptList() {
        return childDeptList;
    }

    public void setChildDeptList(List<String> childDeptList) {
        this.childDeptList = childDeptList;
    }

    public String getUseable() {
        return useable;
    }

    public void setUseable(String useable) {
        this.useable = useable;
    }

    public User getPrimaryPerson() {
        return primaryPerson;
    }

    public void setPrimaryPerson(User primaryPerson) {
        this.primaryPerson = primaryPerson;
    }

    public User getDeputyPerson() {
        return deputyPerson;
    }

    public void setDeputyPerson(User deputyPerson) {
        this.deputyPerson = deputyPerson;
    }

    public Office getParent() {
        return parent;
    }

    public void setParent(Office parent) {
        this.parent = parent;
    }

    @NotNull
    public Area getArea() {
        return area;
    }

    public void setArea(Area area) {
        this.area = area;
    }

    @Length(min = 1, max = 1)
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @Length(min = 1, max = 1)
    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    @Length(min = 0, max = 255)
    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @Length(min = 0, max = 100)
    public String getZipCode() {
        return zipCode;
    }

    public void setZipCode(String zipCode) {
        this.zipCode = zipCode;
    }

    @Length(min = 0, max = 100)
    public String getMaster() {
        return master;
    }

    public void setMaster(String master) {
        this.master = master;
    }

    @Length(min = 0, max = 200)
    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    @Length(min = 0, max = 200)
    public String getFax() {
        return fax;
    }

    public void setFax(String fax) {
        this.fax = fax;
    }

    @Length(min = 0, max = 200)
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Length(min = 0, max = 100)
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @Override
    public String toString() {
        return name;
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