/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.setting.entity;


import com.jeeplus.common.utils.excel.annotation.ExcelField;
import com.jeeplus.core.persistence.DataEntity;

/**
 * 用户设置Entity
 *
 * @author 尹彬
 * @version 2019-09-25
 */
public class ScSetting extends DataEntity<ScSetting> {

    private static final long serialVersionUID = 1L;
    private Integer autoLogin = 1;        // 自动登录
    private Integer showToast = 0;        // 显示提示
    private Integer continueScan = 1;        // 连续扫码
    private Integer snakeScan = 0;        // 摇一摇扫码
    private Integer scanRefresh = 1;        // 扫码后自动刷新
    private Integer ownerHistory = 0;        // 显示自己的扫码历史

    public ScSetting() {
        super();
        this.setIdType(IDTYPE_AUTO);
    }

    public ScSetting(String id) {
        super(id);
    }

    @ExcelField(title = "自动登录", align = 2, sort = 6)
    public Integer getAutoLogin() {
        return autoLogin;
    }

    public void setAutoLogin(Integer autoLogin) {
        this.autoLogin = autoLogin;
    }

    @ExcelField(title = "显示提示", align = 2, sort = 7)
    public Integer getShowToast() {
        return showToast;
    }

    public void setShowToast(Integer showToast) {
        this.showToast = showToast;
    }

    @ExcelField(title = "连续扫码", align = 2, sort = 8)
    public Integer getContinueScan() {
        return continueScan;
    }

    public void setContinueScan(Integer continueScan) {
        this.continueScan = continueScan;
    }

    @ExcelField(title = "摇一摇扫码", align = 2, sort = 9)
    public Integer getSnakeScan() {
        return snakeScan;
    }

    public void setSnakeScan(Integer snakeScan) {
        this.snakeScan = snakeScan;
    }

    @ExcelField(title = "扫码后自动刷新", align = 2, sort = 10)
    public Integer getScanRefresh() {
        return scanRefresh;
    }

    public void setScanRefresh(Integer scanRefresh) {
        this.scanRefresh = scanRefresh;
    }

    @ExcelField(title = "显示自己的扫码历史", align = 2, sort = 11)
    public Integer getOwnerHistory() {
        return ownerHistory;
    }

    public void setOwnerHistory(Integer ownerHistory) {
        this.ownerHistory = ownerHistory;
    }

}