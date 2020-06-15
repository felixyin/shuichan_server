/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.sys.mapper;

import com.jeeplus.core.persistence.BaseMapper;
import com.jeeplus.core.persistence.annotation.MyBatisMapper;
import com.jeeplus.modules.sys.entity.DataRule;
import com.jeeplus.modules.sys.entity.User;

import java.util.List;

/**
 * 数据权限MAPPER接口
 *
 * @author lgf
 * @version 2017-04-02
 */
@MyBatisMapper
public interface DataRuleMapper extends BaseMapper<DataRule> {

    void deleteRoleDataRule(DataRule dataRule);

    List<DataRule> findByUserId(User user);
}