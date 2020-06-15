/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.setting.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.setting.entity.ScSetting;
import com.jeeplus.modules.setting.mapper.ScSettingMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 用户设置Service
 *
 * @author 尹彬
 * @version 2019-09-25
 */
@Service
@Transactional(readOnly = true)
public class ScSettingService extends CrudService<ScSettingMapper, ScSetting> {

    @Override
    public ScSetting get(String id) {
        return super.get(id);
    }

    @Override
    public List<ScSetting> findList(ScSetting scSetting) {
        return super.findList(scSetting);
    }

    @Override
    public Page<ScSetting> findPage(Page<ScSetting> page, ScSetting scSetting) {
        return super.findPage(page, scSetting);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(ScSetting scSetting) {
        super.save(scSetting);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(ScSetting scSetting) {
        super.delete(scSetting);
    }

}