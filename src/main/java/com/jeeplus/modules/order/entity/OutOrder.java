package com.jeeplus.modules.order.entity;

import com.jeeplus.core.persistence.DataEntity;

public class OutOrder extends DataEntity<OutOrder> {
    /*
    sc.username,
    sc.address,
    sc.phone,
    sp.`name` AS spec,
    sum( sb.`count` ) AS `count`
    */

    private String username;
    private String address;
    private String phone;
    private String spec;
    private int count;
    private int okCount;
    private String officeName;

    public int getOkCount() {
        return okCount;
    }

    public void setOkCount(int okCount) {
        this.okCount = okCount;
    }

    public String getOfficeName() {
        return officeName;
    }

    public void setOfficeName(String officeName) {
        this.officeName = officeName;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getSpec() {
        return spec;
    }

    public void setSpec(String spec) {
        this.spec = spec;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }
}
