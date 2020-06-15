/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.production.service;

import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.core.service.TreeService;
import com.jeeplus.modules.production.entity.ScProductionCategory;
import com.jeeplus.modules.production.mapper.ScProductionCategoryMapper;
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
public class ScProductionCategoryService extends TreeService<ScProductionCategoryMapper, ScProductionCategory> {

    @Override
    public ScProductionCategory get(String id) {
        return super.get(id);
    }

    @Override
    public List<ScProductionCategory> findList(ScProductionCategory scProductionCategory) {
        if (!UserUtils.getUser().isAdmin()) {
            scProductionCategory.setOffice(UserUtils.getOfficeDirectly());
        }
        if (StringUtils.isNotBlank(scProductionCategory.getParentIds())) {
            scProductionCategory.setParentIds("," + scProductionCategory.getParentIds() + ",");
        }
        return super.findList(scProductionCategory);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(ScProductionCategory scProductionCategory) {
        if (!UserUtils.getUser().isAdmin()) {
            scProductionCategory.setOffice(UserUtils.getOfficeDirectly());
        }
        super.save(scProductionCategory);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(ScProductionCategory scProductionCategory) {
        super.delete(scProductionCategory);
    }

}