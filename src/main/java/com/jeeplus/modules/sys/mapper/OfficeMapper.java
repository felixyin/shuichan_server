/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.sys.mapper;

import com.jeeplus.core.persistence.TreeMapper;
import com.jeeplus.core.persistence.annotation.MyBatisMapper;
import com.jeeplus.modules.sys.entity.Office;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 机构MAPPER接口
 *
 * @author jeeplus
 * @version 2017-05-16
 */
@MyBatisMapper
public interface OfficeMapper extends TreeMapper<Office> {

    Office getByCode(@Param("code") String code);

    List<Office> findListByName(@Param("name") String name);
}
