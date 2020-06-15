/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.iim.mapper;

import com.jeeplus.core.persistence.BaseMapper;
import com.jeeplus.core.persistence.annotation.MyBatisMapper;
import com.jeeplus.modules.iim.entity.MailBox;

/**
 * 发件箱MAPPER接口
 *
 * @author jeeplus
 * @version 2015-11-15
 */
@MyBatisMapper
public interface MailBoxMapper extends BaseMapper<MailBox> {

    int getCount(MailBox entity);

}