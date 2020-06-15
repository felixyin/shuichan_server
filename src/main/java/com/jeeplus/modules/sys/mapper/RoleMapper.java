/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.sys.mapper;

import com.jeeplus.core.persistence.BaseMapper;
import com.jeeplus.core.persistence.annotation.MyBatisMapper;
import com.jeeplus.modules.sys.entity.Role;

/**
 * 角色MAPPER接口
 *
 * @author jeeplus
 * @version 2016-12-05
 */
@MyBatisMapper
public interface RoleMapper extends BaseMapper<Role> {

    Role getByName(Role role);

    Role getByEnname(Role role);

    /**
     * 维护角色与菜单权限关系
     *
     * @param role
     * @return
     */
    int deleteRoleMenu(Role role);

    int insertRoleMenu(Role role);

    /**
     * 维护角色与数据权限关系
     *
     * @param role
     * @return
     */
    int deleteRoleDataRule(Role role);

    int insertRoleDataRule(Role role);

}
