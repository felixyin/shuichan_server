/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.tools.mapper;

import com.jeeplus.core.persistence.BaseMapper;
import com.jeeplus.core.persistence.annotation.MyBatisMapper;
import com.jeeplus.modules.tools.entity.SysDataSource;

/**
 * 多数据源MAPPER接口
 *
 * @author liugf
 * @version 2017-07-27
 */
@MyBatisMapper
public interface SysDataSourceMapper extends BaseMapper<SysDataSource> {

    SysDataSource getByEnname(String enname);

}