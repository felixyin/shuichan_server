/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.cuxarea.entity;


import com.jeeplus.common.utils.excel.annotation.ExcelField;
import com.jeeplus.core.persistence.DataEntity;

/**
 * 导入用区域用Entity
 *
 * @author 尹彬
 * @version 2019-08-01
 */
public class CuxAdministrationRegion extends DataEntity<CuxAdministrationRegion> {

    private static final long serialVersionUID = 1L;
    private String regionCode;        // region_code
    private String regionName;        // region_name
    private String regionLevel;        // region_level
    private String parentRegionCode;        // parent_region_code

    public CuxAdministrationRegion() {
        super();
    }

    public CuxAdministrationRegion(String id) {
        super(id);
    }

    @ExcelField(title = "region_code", align = 2, sort = 0)
    public String getRegionCode() {
        return regionCode;
    }

    public void setRegionCode(String regionCode) {
        this.regionCode = regionCode;
    }

    @ExcelField(title = "region_name", align = 2, sort = 1)
    public String getRegionName() {
        return regionName;
    }

    public void setRegionName(String regionName) {
        this.regionName = regionName;
    }

    @ExcelField(title = "region_level", align = 2, sort = 2)
    public String getRegionLevel() {
        return regionLevel;
    }

    public void setRegionLevel(String regionLevel) {
        this.regionLevel = regionLevel;
    }

    @ExcelField(title = "parent_region_code", align = 2, sort = 3)
    public String getParentRegionCode() {
        return parentRegionCode;
    }

    public void setParentRegionCode(String parentRegionCode) {
        this.parentRegionCode = parentRegionCode;
    }

}