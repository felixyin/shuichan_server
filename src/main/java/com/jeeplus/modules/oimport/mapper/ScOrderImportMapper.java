/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.oimport.mapper;

import com.jeeplus.core.persistence.BaseMapper;
import com.jeeplus.core.persistence.annotation.MyBatisMapper;
import com.jeeplus.modules.oimport.entity.ScOrderImport;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 导入订单MAPPER接口
 *
 * @author 尹彬
 * @version 2019-08-20
 */
@MyBatisMapper
public interface ScOrderImportMapper extends BaseMapper<ScOrderImport> {

    List<Map<String, Object>> autoCompleteCustom(@Param("phone") String phone, @Param("username") String username, @Param("address") String address, @Param("officeId") String officeId);

}