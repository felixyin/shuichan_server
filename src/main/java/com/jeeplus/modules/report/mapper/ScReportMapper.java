/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.report.mapper;

import com.jeeplus.core.persistence.BaseMapper;
import com.jeeplus.core.persistence.annotation.MyBatisMapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 产品购买MAPPER接口
 *
 * @author 尹彬
 * @version 2019-10-20
 */
@MyBatisMapper
public interface ScReportMapper extends BaseMapper<Map<String, Object>> {

    List<Map<String, Object>> findXiaDanReportList(
            @Param("officeId") String officeId,
            @Param("specName") String specName,
            @Param("agentName") String agentName,
            @Param("beginDate") String beginDate,
            @Param("endDate") String endDate,
            @Param("orderBy") String orderBy);

    List<Map<String, Object>> findXiaDanItemList(
            @Param("specId") String specId,
            @Param("specName") String specName,
            @Param("agentName") String agentName,
            @Param("daiYiStatus") Integer daiYiStatus,
            @Param("beginDate") String beginDate,
            @Param("endDate") String endDate,
            @Param("orderBy") String orderBy);

    List<Map<String, Object>> findChuHuoReportList(
            @Param("officeId") String officeId,
            @Param("specName") String specName,
            @Param("beginDate") String beginDate,
            @Param("endDate") String endDate,
            @Param("orderBy") String orderBy);

    List<Map<String, Object>> findChuHuoItemList(
            @Param("officeId") String officeId,
            @Param("specId") String specId,
            @Param("daiYiStatus") Integer daiYiStatus,
            @Param("beginDate") String beginDate,
            @Param("endDate") String endDate,
            @Param("orderBy") String orderBy);

    List<Map<String, Object>> findCaiWuList(
            @Param("officeId") String officeId,
            @Param("agentName") String agentName,
            @Param("beginDate") String beginDate,
            @Param("endDate") String endDate,
            @Param("payStatus") String payStatus,
            @Param("orderBy") String orderBy);

    List<Map<String, Object>> findCaiWuItemList(
            @Param("officeId") String officeId,
            @Param("agentName") String agentName,
            @Param("date") String date,
            @Param("orderBy") String orderBy);

    int saveOrUpdateRealPayPrice(
            @Param("officeId") String officeId,
            @Param("agent_name") String agent_name,
            @Param("deliver_date") String deliver_date,
            @Param("real_pay_price") Float real_pay_price,
            @Param("payUserId") String payUserId,
            @Param("payDate")String payDate);

    List<Map<String, Object>> findFactoryWuLiuList(
            @Param("officeId") String officeId,
            @Param("logisticsName") String logisticsName,
            @Param("beginDate") String beginDate,
            @Param("endDate") String endDate,
            @Param("payStatus") String payStatus,
            @Param("orderBy") String orderBy);

    List<Map<String, Object>> findFactoryWuLiuItemList(
            @Param("officeId") String officeId,
            @Param("logisticsName") String logisticsName,
            @Param("date") String date,
            @Param("payStatus") String payStatus,
            @Param("orderBy") String orderBy);

    List<Map<String, Object>> findWuLiuList(
            @Param("officeId") String officeId,
            @Param("factoryName") String factoryName,
            @Param("beginDate") String beginDate,
            @Param("endDate") String endDate,
            @Param("payStatus") String payStatus,
            @Param("diaoStatus")  String diaoStatus,
            @Param("orderBy") String orderBy);

    List<Map<String, Object>> findWuLiuItemList(
            @Param("officeId") String officeId,
            @Param("factoryName") String factoryName,
            @Param("date") String date,
            @Param("payStatus") String payStatus,
            @Param("diaoStatus")  String diaoStatus,
            @Param("orderBy") String orderBy);

    int saveOrUpdateWuLiuPayPrice(
            @Param("officeId") String officeId,
            @Param("factory_id") String factory_id,
            @Param("logistics_id") String logistics_id,
            @Param("logistics_date") String logistics_date,
            @Param("real_pay_price") Float real_pay_price,
            @Param("payUserId") String payUserId,
            @Param("payDate")String payDate);

}