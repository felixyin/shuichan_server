/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.production.service;

import com.jeeplus.common.utils.PinYin4jUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.production.entity.ScProduction;
import com.jeeplus.modules.production.mapper.ScProductionMapper;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 产品Service
 *
 * @author 尹彬
 * @version 2019-08-18
 */
@Service
@Transactional(readOnly = true)
public class ScProductionService extends CrudService<ScProductionMapper, ScProduction> {
    @Override
    protected void preExecute(ScProduction entity) {
        if (!UserUtils.getUser().isAdmin()) {
            entity.setOffice(UserUtils.getOfficeDirectly());
        }
    }

    @Override
    public ScProduction get(String id) {
        return super.get(id);
    }

    @Override
    public List<ScProduction> findList(ScProduction scProduction) {
        return super.findList(scProduction);
    }

    @Override
    public Page<ScProduction> findPage(Page<ScProduction> page, ScProduction scProduction) {
        return super.findPage(page, scProduction);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(ScProduction scProduction) {
        String name = scProduction.getName();
        if (StringUtils.isNotBlank(name)) {
            scProduction.setPy(PinYin4jUtils.toPinYinAllLower(name));
            scProduction.setPyFirst(PinYin4jUtils.toPinYinHeadLower(name));
        }
        super.save(scProduction);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(ScProduction scProduction) {
        super.delete(scProduction);
    }

}