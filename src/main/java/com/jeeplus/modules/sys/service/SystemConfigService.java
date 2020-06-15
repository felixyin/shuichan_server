/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.sys.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.sys.entity.SystemConfig;
import com.jeeplus.modules.sys.mapper.SystemConfigMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 系统配置Service
 *
 * @author liugf
 * @version 2016-02-07
 */
@Service
@Transactional(readOnly = true)
public class SystemConfigService extends CrudService<SystemConfigMapper, SystemConfig> {

    @Override
    public SystemConfig get(String id) {
        return super.get(id);
    }

    @Override
    public List<SystemConfig> findList(SystemConfig systemConfig) {
        return super.findList(systemConfig);
    }

    @Override
    public Page<SystemConfig> findPage(Page<SystemConfig> page, SystemConfig systemConfig) {
        return super.findPage(page, systemConfig);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(SystemConfig systemConfig) {
        super.save(systemConfig);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(SystemConfig systemConfig) {
        super.delete(systemConfig);
    }

}