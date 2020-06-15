/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.sys.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.sys.entity.DataRule;
import com.jeeplus.modules.sys.mapper.DataRuleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 数据权限Service
 *
 * @author lgf
 * @version 2017-04-02
 */
@Service
@Transactional(readOnly = true)
public class DataRuleService extends CrudService<DataRuleMapper, DataRule> {
    @Autowired
    private DataRuleMapper dataRuleMapper;

    @Override
    public DataRule get(String id) {
        return super.get(id);
    }

    @Override
    public List<DataRule> findList(DataRule dataRule) {
        return super.findList(dataRule);
    }

    @Override
    public Page<DataRule> findPage(Page<DataRule> page, DataRule dataRule) {
        return super.findPage(page, dataRule);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(DataRule dataRule) {
        super.save(dataRule);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(DataRule dataRule) {
        //解除数据权限角色关联
        dataRuleMapper.deleteRoleDataRule(dataRule);
        super.delete(dataRule);

    }


}