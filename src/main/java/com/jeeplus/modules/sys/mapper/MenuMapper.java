/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.sys.mapper;

import com.jeeplus.core.persistence.BaseMapper;
import com.jeeplus.core.persistence.annotation.MyBatisMapper;
import com.jeeplus.modules.sys.entity.Menu;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 菜单MAPPER接口
 *
 * @author jeeplus
 * @version 2017-05-16
 */
@MyBatisMapper
public interface MenuMapper extends BaseMapper<Menu> {

    List<Menu> findByParentIdsLike(Menu menu);

    List<Menu> findByUserId(Menu menu);

    int updateParentIds(Menu menu);

    int updateSort(Menu menu);

    List<Menu> getChildren(String parentId);

    void deleteMenuRole(@Param(value = "menu_id") String menu_id);

    void deleteMenuDataRule(@Param(value = "menu_id") String menu_id);

    List<Menu> findAllDataRuleList(Menu menu);


}
