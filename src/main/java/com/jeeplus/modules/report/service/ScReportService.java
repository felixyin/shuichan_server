/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.report.service;

import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.core.service.BaseService;
import com.jeeplus.modules.report.mapper.ScReportMapper;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * 产品Service
 *
 * @author 尹彬
 * @version 2019-08-18
 */
@Service
@Transactional(readOnly = false)
public class ScReportService extends BaseService {

    @Resource
    private ScReportMapper scReportMapper;


    private String getCurrentOfficeId() {
        String officeId = null;
        if (!UserUtils.getUser().isAdmin()) {
            officeId = UserUtils.getOfficeDirectly().getId();
        }
        return officeId;
    }

    /**
     * 下单统计
     *
     * @param specName
     * @param agentName
     * @param beginDate
     * @param endDate
     * @param orderBy
     * @return
     */
    @Transactional(readOnly = false)
    public List<Map<String, Object>> findXiaDanReportList(String specName, String agentName, String beginDate, String endDate, String orderBy) {
        String officeId = getCurrentOfficeId();
        return scReportMapper.findXiaDanReportList(officeId, specName, agentName, beginDate, endDate, orderBy);
    }


    /**
     * 下单统计明细
     *
     * @param specId      主表 规格行id
     * @param agentName
     * @param daiYiStatus 1 表示已生产，否则未生产
     * @param beginDate
     * @param endDate
     * @param orderBy
     * @return
     */
    @Transactional(readOnly = false)
    public List<Map<String, Object>> findXiaDanItemList(String specId, String specName, String agentName, Integer daiYiStatus, String beginDate, String endDate, String orderBy) {
        return scReportMapper.findXiaDanItemList(specId, specName, agentName, daiYiStatus, beginDate, endDate, orderBy);
    }


    /**
     * 出货统计
     *
     * @param specName
     * @param beginDate
     * @param endDate
     * @param orderBy
     * @return
     */
    @Transactional(readOnly = false)
    public List<Map<String, Object>> findChuHuoReportList(String specName, String beginDate, String endDate, String orderBy) {
        String officeId = getCurrentOfficeId();
        return scReportMapper.findChuHuoReportList(officeId, specName, beginDate, endDate, orderBy);
    }

    /**
     * 出货统计明细
     *
     * @param specId
     * @param daiYiStatus
     * @param beginDate
     * @param endDate
     * @param orderBy
     * @return
     */
    @Transactional(readOnly = false)
    public List<Map<String, Object>> findChuHuoItemList(String specId, Integer daiYiStatus, String beginDate, String endDate, String orderBy) {
        String officeId = getCurrentOfficeId();
        return scReportMapper.findChuHuoItemList(officeId, specId, daiYiStatus, beginDate, endDate, orderBy);
    }

    /**
     * 财务统计主表
     *
     * @param agentName
     * @param beginDate
     * @param endDate
     * @param orderBy
     * @return
     */
    @Transactional(readOnly = false)
    public List<Map<String, Object>> findCaiWuList(String agentName, String beginDate, String endDate, String payStatus, String orderBy) {
        String officeId = getCurrentOfficeId();
        return scReportMapper.findCaiWuList(officeId, agentName, beginDate, endDate, payStatus, orderBy);
    }


    /**
     * 财务统计  子表
     *
     * @param agentName
     * @param date
     * @param orderBy
     * @return
     */
    @Transactional(readOnly = false)
    public List<Map<String, Object>> findCaiWuItemList(String agentName, String date, String orderBy) {
        String officeId = getCurrentOfficeId();
        return scReportMapper.findCaiWuItemList(officeId, agentName, date, orderBy);
    }

    /**
     * 工厂物流统计
     *
     * @param logisticsName
     * @param beginDate
     * @param endDate
     * @param payStatus
     * @param orderBy
     * @return
     */
    @Transactional(readOnly = false)
    public List<Map<String, Object>> findFactoryWuLiuList(String logisticsName, String beginDate, String endDate, String payStatus, String orderBy) {
        String officeId = getCurrentOfficeId();
        return scReportMapper.findFactoryWuLiuList(officeId, logisticsName, beginDate, endDate, payStatus, orderBy);
    }

    /**
     * 工厂物流统计  子列表
     *
     * @param logisticsName
     * @param date
     * @param payStatus
     * @param orderBy
     * @return
     */
    @Transactional(readOnly = false)
    public List<Map<String, Object>> findFactoryWuLiuItemList(String logisticsName, String date, String payStatus, String orderBy) {
        String officeId = getCurrentOfficeId();
        return scReportMapper.findFactoryWuLiuItemList(officeId, logisticsName, date, payStatus, orderBy);
    }

    /**
     * 工厂物流统计
     *
     * @param factoryName
     * @param beginDate
     * @param endDate
     * @param payStatus
     * @param orderBy
     * @return
     */
    @Transactional(readOnly = false)
    public List<Map<String, Object>> findWuLiuList(String factoryName, String beginDate, String endDate, String payStatus, String diaoStatus, String orderBy) {
        String officeId = getCurrentOfficeId();
        return scReportMapper.findWuLiuList(officeId, factoryName, beginDate, endDate, payStatus,diaoStatus, orderBy);
    }

    /**
     * 工厂物流统计  子列表
     *
     * @param factoryName
     * @param date
     * @param payStatus
     * @param orderBy
     * @return
     */
    @Transactional(readOnly = false)
    public List<Map<String, Object>> findWuLiuItemList(String factoryName, String date, String payStatus,String diaoStatus,  String orderBy) {
        String officeId = getCurrentOfficeId();
        return scReportMapper.findWuLiuItemList(officeId, factoryName, date, payStatus,diaoStatus, orderBy);
    }

    /**
     * 保存实付金额
     *
     * @param agent_name
     * @param deliver_date
     * @param real_pay_price
     * @return
     */
    @Transactional(readOnly = false)
    public boolean saveRealPayPrice(String agent_name, String deliver_date, Float real_pay_price) {
        User payUser = UserUtils.getUser();
        if (payUser.isAdmin()) {
            return false; // 超级管理员不允许修改用户的数据
        }
        String officeId = UserUtils.getOfficeDirectly().getId();
        String payDate = DateUtils.getDateTime();
        int rowCount = scReportMapper.saveOrUpdateRealPayPrice(officeId, agent_name, deliver_date, real_pay_price, payUser.getId(), payDate);
        System.err.println("\n\n\nroucount  ----------------- " + rowCount);
        return true;
    }

    /**
     * 物流公司修改 实付金额
     *
     * @param factory_id
     * @param logistics_id
     * @param logistics_date
     * @param real_pay_price
     * @return
     */
    @Transactional(readOnly = false)
    public boolean saveWuLiuPayPrice(String factory_id, String logistics_id, String logistics_date, Float real_pay_price) {
        User payUser = UserUtils.getUser();
        if (payUser.isAdmin()) {
            return false; // 超级管理员不允许修改用户的数据
        }
        String officeId = UserUtils.getOfficeDirectly().getId();
        String payDate = DateUtils.getDate();
        int rowCount = scReportMapper.saveOrUpdateWuLiuPayPrice(officeId, factory_id, logistics_id, logistics_date, real_pay_price,payUser.getId(),payDate);
        System.err.println("\n\n\nroucount  ----------------- " + rowCount);
        return rowCount == 1;
    }

}