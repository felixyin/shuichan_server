/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.oa.mapper;

import com.jeeplus.core.persistence.BaseMapper;
import com.jeeplus.core.persistence.annotation.MyBatisMapper;
import com.jeeplus.modules.oa.entity.OaNotifyRecord;

import java.util.List;

/**
 * 通知通告记录MAPPER接口
 *
 * @author jeeplus
 * @version 2017-05-16
 */
@MyBatisMapper
public interface OaNotifyRecordMapper extends BaseMapper<OaNotifyRecord> {

    /**
     * 插入通知记录
     *
     * @param oaNotifyRecordList
     * @return
     */
    int insertAll(List<OaNotifyRecord> oaNotifyRecordList);

    /**
     * 根据通知ID删除通知记录
     *
     * @param oaNotifyId 通知ID
     * @return
     */
    int deleteByOaNotifyId(String oaNotifyId);

}