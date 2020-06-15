/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.app.service;

import com.jeeplus.common.config.Global;
import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.modules.box.service.ScBoxService;
import com.jeeplus.modules.boxitem.entity.ScBoxItem;
import com.jeeplus.modules.boxitem.service.ScBoxItemService;
import com.jeeplus.modules.custom.service.ScCustomService;
import com.jeeplus.modules.order.entity.OutOrder;
import com.jeeplus.modules.order.mapper.ScOrderMapper;
import com.jeeplus.modules.production.service.ScProductionService;
import com.jeeplus.modules.setting.entity.ScSetting;
import com.jeeplus.modules.setting.entity.ScSettingOutOrderPrint;
import com.jeeplus.modules.setting.service.ScSettingOutOrderPrintService;
import com.jeeplus.modules.setting.service.ScSettingService;
import com.jeeplus.modules.sys.entity.Office;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.service.OfficeService;
import com.jeeplus.modules.sys.service.SystemService;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 手机app接口 Service
 *
 * @author 尹彬
 * @version 2019-08-09
 */
@Service
@Transactional(readOnly = false)
public class ScAppService {
    @Resource
    private ScCustomService scCustomService;
    @Resource
    private ScBoxService scBoxService;
    @Resource
    private ScBoxItemService scBoxItemService;
    @Resource
    private OfficeService officeService;
    @Resource
    private ScProductionService scProductionService;
    @Resource
    private SystemService systemService;
    @Resource
    private ScOrderMapper scOrderMapper;
    @Resource
    private ScSettingService scSettingService;
    @Autowired
    private ScSettingOutOrderPrintService scSettingOutOrderPrintService;


    /**
     * app用户修改用户基本信息
     *
     * @param user
     * @return
     */
    public boolean saveUserInfo(User user) {
        try {
            User currentUser = UserUtils.getUser();
            if (StringUtils.isNotBlank(user.getName())) {
                if (user.getName() != null) {
                    currentUser.setName(user.getName());
                }
                if (user.getLoginName() != null) {
                    currentUser.setLoginName(user.getLoginName());
                }
                if (user.getMobile() != null) {
                    currentUser.setMobile(user.getMobile());
                }
                systemService.updateUserInfo(currentUser);

                if (user.getPassword() != null && StringUtils.isNotBlank(user.getPassword())) {
                    systemService.updatePasswordById(currentUser.getId(), currentUser.getLoginName(), user.getPassword());
                }
                //			if(user.getPhoto() !=null )
                //				currentUser.setPhoto(user.getPhoto());
            }
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 包装人员上传照片
     *
     * @param boxItemId
     * @param dbPath
     */
    public void savePhotoInfo(String boxItemId, String dbPath) {
        String userId = UserUtils.getUser().getId();
        String dateTime = DateUtils.getDateTime();

        // 如果已经上传过，则此次为覆盖，首先删除之前上传的文件
        ScBoxItem scBoxItem = scBoxItemService.get(boxItemId);
        String photos = scBoxItem.getPhotos();
        if (StringUtils.isNotBlank(photos)) {
            dateTime = DateUtils.formatDateTime(scBoxItem.getPackageDate());
            try {
                File f = new File(Global.getConfig("userfiles.basedir") + photos);
                if (f.exists()) {
                    f.delete();
                }
            } catch (Exception e) {
            }
        }

        // 保存照片路径
        scBoxItemService.executeUpdateSql("UPDATE sc_box_item sbi set sbi.process=4, sbi.package_user_id = '" + userId + "',sbi.package_date='" + dateTime + "',sbi.photos = '" + dbPath + "' WHERE sbi.id = " + boxItemId);
    }


    /**
     * 包装员代办任务列表
     *
     * @return
     */
    public List<Map<String, Object>> findTodoListForPackager() {
        String factoryId = UserUtils.getOfficeDirectly().getId();
        return scOrderMapper.findTodoListForPackager(factoryId);
    }

    /**
     * 包装员历史任务列表
     *
     * @return
     */
    public List<Map<String, Object>> findHistoryListForPackager(String dateStr) {
        String factoryId = UserUtils.getOfficeDirectly().getId();
        if (StringUtils.isBlank(dateStr)) {
            dateStr = DateUtils.getDate();
        }
        ScSetting scSetting = loadSetting();
        boolean isOnlyOwnerData = scSetting.getOwnerHistory() == 1;
        User user = UserUtils.getUser();
        return scOrderMapper.findHistoryListForPackager(isOnlyOwnerData, user.getId(), dateStr, factoryId);
    }

    /**
     * 快递员代办任务列表
     *
     * @param factoryId 按工厂分组
     * @return
     */
    public List<Map<String, Object>> findTodoListForCourier(String factoryId) {
        String logisitId = UserUtils.getOfficeDirectly().getId(); // 所属快递公司
        ScSettingOutOrderPrint setting = scSettingOutOrderPrintService.loadSettingOutOrderPrint();
        setting.setSpec("0");
        System.out.println(factoryId);
        System.out.println(logisitId);
        return scOrderMapper.findTodoListForCourier(setting.getSpec(),factoryId, logisitId);
    }

    /**
     * 包装员历史任务列表
     * @param dateStr 按天过滤
     * @param factoryId 按工厂分组
     * @return
     */
    public List<Map<String, Object>> findHistoryListForCourier(String dateStr, String factoryId) {
        if (StringUtils.isBlank(dateStr)) {
            dateStr = DateUtils.getDate();
        }
        String officeId = UserUtils.getOfficeDirectly().getId();
        ScSettingOutOrderPrint setting = scSettingOutOrderPrintService.loadSettingOutOrderPrint();

        ScSetting scSetting = loadSetting();
        boolean isOnlyOwnerData = scSetting.getOwnerHistory() == 1;
        String logisitId = officeId; // UserUtils.getOfficeDirectly().getId(); // 所属快递公司
        return scOrderMapper.findHistoryListForCourier(setting.getSpec(), dateStr, factoryId, logisitId,isOnlyOwnerData, UserUtils.getUser().getId());
    }

    public List<Map<String, String>> findAllOffice() {
        List<Map<String, String>> list = new ArrayList<>();
        List<Office> officeAllList = UserUtils.getOfficeAllList();
        for (Office office : officeAllList) {
            if ("1".equals(office.getType())) {
                Map<String, String> map = new HashMap<>();
                map.put("id", office.getId());
                map.put("name", office.getName());
                list.add(map);
            }
        }
        return list;
    }

    public ScSetting loadSetting() {
        ScSetting scSetting = new ScSetting();
        User user = UserUtils.getUser();
        scSetting.setCreateBy(user);
        List<ScSetting> list = scSettingService.findList(scSetting);
        if (null != list && !list.isEmpty()) {
            scSetting = list.get(0);
        }
        scSetting.setCreateBy(null);
        scSetting.setCreateDate(null);
        scSetting.setUpdateBy(null);
        scSetting.setUpdateDate(null);
        scSetting.setRemarks(null);
        return scSetting;
    }

    public void saveSetting(ScSetting scSetting) {
        ScSetting scSettingParam = new ScSetting();
        User user = UserUtils.getUser();
        scSettingParam.setCreateBy(user);
        List<ScSetting> list = scSettingService.findList(scSettingParam);
        if (null != list && !list.isEmpty()) {
            scSettingParam = list.get(0);
        }
        scSettingParam.setAutoLogin(scSetting.getAutoLogin());
        scSettingParam.setShowToast(scSetting.getShowToast());
        scSettingParam.setContinueScan(scSetting.getContinueScan());
        scSettingParam.setSnakeScan(scSetting.getSnakeScan());
        scSettingParam.setScanRefresh(scSetting.getScanRefresh());
        scSettingParam.setOwnerHistory(scSetting.getOwnerHistory());
        scSettingService.save(scSettingParam);
    }
}