package com.jeeplus.modules.order.entity;

import com.jeeplus.common.utils.CacheUtils;
import com.jeeplus.modules.sys.utils.UserUtils;

import java.io.Serializable;

public class SettingTable implements Serializable {

    private String boxExpanded = "0";
    private String boxItemExpanded = "0";

    public static SettingTable getFromCache() {
        SettingTable setting = new SettingTable();
        String key = UserUtils.getUser().getId() + "stable";
        Object o = CacheUtils.get(key);
        if (null == o) {
            CacheUtils.put(key, setting);
        } else {
            setting = (SettingTable) o;
        }
        return setting;
    }

    public static void setToCache(SettingTable settingBoxOrderPrint) {
        String key = UserUtils.getUser().getId() + "stable";
//        CacheUtils.remove(key);
        CacheUtils.put(key, settingBoxOrderPrint);
    }

    public String getBoxExpanded() {
        return boxExpanded;
    }

    public void setBoxExpanded(String boxExpanded) {
        this.boxExpanded = boxExpanded;
    }

    public String getBoxItemExpanded() {
        return boxItemExpanded;
    }

    public void setBoxItemExpanded(String boxItemExpanded) {
        this.boxItemExpanded = boxItemExpanded;
    }
}
