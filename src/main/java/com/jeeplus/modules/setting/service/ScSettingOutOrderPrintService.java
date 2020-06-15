/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.setting.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.setting.entity.ScSettingOutOrderPrint;
import com.jeeplus.modules.setting.mapper.ScSettingOutOrderPrintMapper;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 出货单打印设置Service
 *
 * @author 尹彬
 * @version 2019-12-17
 */
@Service
@Transactional(readOnly = true)
public class ScSettingOutOrderPrintService extends CrudService<ScSettingOutOrderPrintMapper, ScSettingOutOrderPrint> {

    public ScSettingOutOrderPrint get(String id) {
        return super.get(id);
    }

    public List<ScSettingOutOrderPrint> findList(ScSettingOutOrderPrint scSettingOutOrderPrint) {
        return super.findList(scSettingOutOrderPrint);
    }

    public Page<ScSettingOutOrderPrint> findPage(Page<ScSettingOutOrderPrint> page, ScSettingOutOrderPrint scSettingOutOrderPrint) {
        return super.findPage(page, scSettingOutOrderPrint);
    }

    @Transactional(readOnly = false)
    public void save(ScSettingOutOrderPrint scSettingOutOrderPrint) {
        super.save(scSettingOutOrderPrint);
    }

    @Transactional(readOnly = false)
    public void delete(ScSettingOutOrderPrint scSettingOutOrderPrint) {
        super.delete(scSettingOutOrderPrint);
    }

    @Transactional(readOnly = false)
    public void saveSettingOutOrderPrint(ScSettingOutOrderPrint settingOutOrderPrint) {
        User user = UserUtils.getUser();
        settingOutOrderPrint.setCreateBy(user);
        List<ScSettingOutOrderPrint> allList = this.findList(settingOutOrderPrint);
        if (null == allList || allList.isEmpty()) {
            this.save(settingOutOrderPrint);
        } else {
            ScSettingOutOrderPrint scSettingOutOrderPrint = allList.get(0);
            settingOutOrderPrint.setId(scSettingOutOrderPrint.getId());
            settingOutOrderPrint.setCreateBy(user);
            settingOutOrderPrint.setUpdateBy(user);
            settingOutOrderPrint.setUpdateDate(new Date());
            this.save(settingOutOrderPrint);
        }
    }

    @Transactional(readOnly = false)
    public ScSettingOutOrderPrint loadSettingOutOrderPrint() {
        ScSettingOutOrderPrint scSettingOutOrderPrint = new ScSettingOutOrderPrint();
        scSettingOutOrderPrint.setCreateBy(UserUtils.getUser());
        List<ScSettingOutOrderPrint> allList = this.findList(scSettingOutOrderPrint);
        if (null == allList || allList.isEmpty()) {
            return new ScSettingOutOrderPrint();
        } else {
            return allList.get(0);
        }
    }
}