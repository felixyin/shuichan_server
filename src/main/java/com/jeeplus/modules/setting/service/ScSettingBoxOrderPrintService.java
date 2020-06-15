/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.setting.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.setting.entity.ScSettingBoxOrderPrint;
import com.jeeplus.modules.setting.mapper.ScSettingBoxOrderPrintMapper;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 装箱单打印设置Service
 *
 * @author 尹彬
 * @version 2019-12-17
 */
@Service
@Transactional(readOnly = true)
public class ScSettingBoxOrderPrintService extends CrudService<ScSettingBoxOrderPrintMapper, ScSettingBoxOrderPrint> {

    public ScSettingBoxOrderPrint get(String id) {
        return super.get(id);
    }

    public List<ScSettingBoxOrderPrint> findList(ScSettingBoxOrderPrint scSettingBoxOrderPrint) {
        return super.findList(scSettingBoxOrderPrint);
    }

    public Page<ScSettingBoxOrderPrint> findPage(Page<ScSettingBoxOrderPrint> page, ScSettingBoxOrderPrint scSettingBoxOrderPrint) {
        return super.findPage(page, scSettingBoxOrderPrint);
    }

    @Transactional(readOnly = false)
    public void save(ScSettingBoxOrderPrint scSettingBoxOrderPrint) {
        super.save(scSettingBoxOrderPrint);
    }

    @Transactional(readOnly = false)
    public void delete(ScSettingBoxOrderPrint scSettingBoxOrderPrint) {
        super.delete(scSettingBoxOrderPrint);
    }

    @Transactional(readOnly = false)
    public void saveSettingBoxOrderPrint(ScSettingBoxOrderPrint settingBoxOrderPrint) {
        User user = UserUtils.getUser();
        settingBoxOrderPrint.setCreateBy(user);
        List<ScSettingBoxOrderPrint> allList = this.findList(settingBoxOrderPrint);
        if (null == allList || allList.isEmpty()) {
            this.save(settingBoxOrderPrint);
        } else {
            ScSettingBoxOrderPrint scSettingBoxOrderPrint = allList.get(0);
            settingBoxOrderPrint.setId(scSettingBoxOrderPrint.getId());
            settingBoxOrderPrint.setCreateBy(user);
            settingBoxOrderPrint.setUpdateBy(user);
            settingBoxOrderPrint.setUpdateDate(new Date());
            this.save(settingBoxOrderPrint);
        }
    }

    @Transactional(readOnly = false)
    public ScSettingBoxOrderPrint loadSettingBoxOrderPrint() {
        ScSettingBoxOrderPrint settingBoxOrderPrint = new ScSettingBoxOrderPrint();
        settingBoxOrderPrint.setCreateBy(UserUtils.getUser());
        List<ScSettingBoxOrderPrint> allList = this.findList(settingBoxOrderPrint);
        if (null == allList || allList.isEmpty()) {
            return new ScSettingBoxOrderPrint();
        } else {
            return allList.get(0);
        }
    }


}