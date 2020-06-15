/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.order.mapper;

import com.jeeplus.core.persistence.BaseMapper;
import com.jeeplus.core.persistence.annotation.MyBatisMapper;
import com.jeeplus.modules.boxitem.entity.ScBoxItem;
import com.jeeplus.modules.order.entity.OutOrder;
import com.jeeplus.modules.order.entity.ScOrder;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 订单MAPPER接口
 *
 * @author 尹彬
 * @version 2019-08-09
 */
@MyBatisMapper
public interface ScOrderMapper extends BaseMapper<ScOrder> {

    List<ScBoxItem> findForPrintByOrderIds(@Param("ids") String[] ids, @Param("printAdjusting") String printAdjusting);

    List<ScBoxItem> findForPrintByBoxIds(@Param("ids") String[] ids, @Param("printAdjusting") String printAdjusting);

    List<ScBoxItem> findForPrintByBoxItemIds(@Param("ids") String[] ids, @Param("printAdjusting") String printAdjusting);

    String autoCompleteAgentName(@Param("customId") String customId, @Param("officeId") String officeId);

    List<Map<String, Object>> autoCompleteAgentName2(@Param("customId") String customId, @Param("agentName") String agentName, @Param("officeId") String officeId);

    List<Map<String, Object>> autoCompleteOffice(@Param("customId") String customId, @Param("type") String type, @Param("officeName") String officeName);

    List<Map<String, Object>> autoCompleteProductionName(@Param("officeId") String officeId,@Param("customId") String customId, @Param("productionName") String productionName);

    Double findLogisticsPrice(@Param("customId") String customId, @Param("productionId") String productionId, @Param("weight") Integer weight);

    List<OutOrder> findForOutPrintByOrderIds(@Param("ids") String[] ids, @Param("spec") String spec);

    List<Map<String, Object>> findTodoListForCourier(@Param("spec") String spec, @Param("factoryId") String factoryId,@Param("logisitId") String logisitId);

    List<Map<String, Object>> findHistoryListForCourier(@Param("spec") String spec, @Param("dateStr") String dateStr,  @Param("factoryId") String factoryId,@Param("logisitId") String logisitId, @Param("isOnlyOwnerData") boolean isOnlyOwnerData, @Param("userId") String userId);

    List<OutOrder> findForOutPrintByBoxIds(@Param("ids") String[] ids);

    List<OutOrder> findForOutPrintByBoxItemIds(@Param("ids") String[] ids);

    List<Map<String, Object>> findHistoryListForPackager(@Param("isOnlyOwnerData") boolean isOnlyOwnerData, @Param("userId") String userId, @Param("dateStr") String dateStr, @Param("factoryId") String factoryId);

    List<Map<String, Object>> findTodoListForPackager(@Param("factoryId") String factoryId);
}