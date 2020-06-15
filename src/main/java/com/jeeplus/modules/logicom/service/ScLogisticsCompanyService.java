/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.logicom.service;

import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.logicom.entity.ScLogisticsCompany;
import com.jeeplus.modules.logicom.entity.ScLogisticsPrice;
import com.jeeplus.modules.logicom.entity.ScLogisticsUser;
import com.jeeplus.modules.logicom.mapper.ScLogisticsCompanyMapper;
import com.jeeplus.modules.logicom.mapper.ScLogisticsPriceMapper;
import com.jeeplus.modules.logicom.mapper.ScLogisticsUserMapper;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 物流公司Service
 *
 * @author 尹彬
 * @version 2019-08-16
 */
@Service
@Transactional(readOnly = true)
public class ScLogisticsCompanyService extends CrudService<ScLogisticsCompanyMapper, ScLogisticsCompany> {

    @Autowired
    private ScLogisticsPriceMapper scLogisticsPriceMapper;
    @Autowired
    private ScLogisticsUserMapper scLogisticsUserMapper;

    @Override
    protected void preExecute(ScLogisticsCompany entity) {
        if (!UserUtils.getUser().isAdmin()) {
            entity.setOffice(UserUtils.getOfficeDirectly());
        }
    }

    @Override
    public ScLogisticsCompany get(String id) {
        ScLogisticsCompany scLogisticsCompany = super.get(id);
        scLogisticsCompany.setScLogisticsPriceList(scLogisticsPriceMapper.findList(new ScLogisticsPrice(scLogisticsCompany)));
        scLogisticsCompany.setScLogisticsUserList(scLogisticsUserMapper.findList(new ScLogisticsUser(scLogisticsCompany)));
        return scLogisticsCompany;
    }

    @Override
    public List<ScLogisticsCompany> findList(ScLogisticsCompany scLogisticsCompany) {
        return super.findList(scLogisticsCompany);
    }

    @Override
    public Page<ScLogisticsCompany> findPage(Page<ScLogisticsCompany> page, ScLogisticsCompany scLogisticsCompany) {
        return super.findPage(page, scLogisticsCompany);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(ScLogisticsCompany scLogisticsCompany) {
        super.save(scLogisticsCompany);
        for (ScLogisticsPrice scLogisticsPrice : scLogisticsCompany.getScLogisticsPriceList()) {
            if (scLogisticsPrice.getId() == null) {
                continue;
            }
            if (ScLogisticsPrice.DEL_FLAG_NORMAL.equals(scLogisticsPrice.getDelFlag())) {
                if (StringUtils.isBlank(scLogisticsPrice.getId())) {
                    scLogisticsPrice.preInsert();
                    scLogisticsPriceMapper.insert(scLogisticsPrice);
                } else {
                    scLogisticsPrice.preUpdate();
                    scLogisticsPriceMapper.update(scLogisticsPrice);
                }
            } else {
                scLogisticsPriceMapper.delete(scLogisticsPrice);
            }
        }
        for (ScLogisticsUser scLogisticsUser : scLogisticsCompany.getScLogisticsUserList()) {
            if (scLogisticsUser.getId() == null) {
                continue;
            }
            if (ScLogisticsUser.DEL_FLAG_NORMAL.equals(scLogisticsUser.getDelFlag())) {
                if (StringUtils.isBlank(scLogisticsUser.getId())) {
                    scLogisticsUser.setLogisticsCompany(scLogisticsCompany);
                    scLogisticsUser.preInsert();
                    scLogisticsUserMapper.insert(scLogisticsUser);
                } else {
                    scLogisticsUser.preUpdate();
                    scLogisticsUserMapper.update(scLogisticsUser);
                }
            } else {
                scLogisticsUserMapper.delete(scLogisticsUser);
            }
        }
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(ScLogisticsCompany scLogisticsCompany) {
        super.delete(scLogisticsCompany);
        scLogisticsPriceMapper.delete(new ScLogisticsPrice(scLogisticsCompany));
        scLogisticsUserMapper.delete(new ScLogisticsUser(scLogisticsCompany));
    }

}