/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.logicom.entity;

import com.jeeplus.common.utils.excel.annotation.ExcelField;
import com.jeeplus.core.persistence.DataEntity;
import com.jeeplus.modules.sys.entity.User;

import javax.validation.constraints.NotNull;

/**
 * 快递员Entity
 *
 * @author 尹彬
 * @version 2019-08-16
 */
public class ScLogisticsUser extends DataEntity<ScLogisticsUser> {

    private static final long serialVersionUID = 1L;
    private ScLogisticsCompany logisticsCompany;        // 所属物流公司 父类
    private User user;        // 登录用户
    private Integer status;        // 状态

    public ScLogisticsUser() {
        super();
        this.setIdType(IDTYPE_AUTO);
    }

    public ScLogisticsUser(String id) {
        super(id);
    }

    public ScLogisticsUser(ScLogisticsCompany logisticsCompany) {
        this.logisticsCompany = logisticsCompany;
    }

    public ScLogisticsCompany getLogisticsCompany() {
        return logisticsCompany;
    }

    public void setLogisticsCompany(ScLogisticsCompany logisticsCompany) {
        this.logisticsCompany = logisticsCompany;
    }

    @NotNull(message = "登录用户不能为空")
    @ExcelField(title = "登录用户", fieldType = User.class, value = "user.name", align = 2, sort = 2)
    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @NotNull(message = "状态不能为空")
    @ExcelField(title = "状态", dictType = "logi_com_user_status", align = 2, sort = 3)
    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

}