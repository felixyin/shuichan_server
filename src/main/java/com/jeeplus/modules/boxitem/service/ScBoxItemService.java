/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.boxitem.service;

import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.boxitem.entity.ScBoxItem;
import com.jeeplus.modules.boxitem.mapper.ScBoxItemMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 每箱Service
 *
 * @author 尹彬
 * @version 2019-08-14
 */
@Service
@Transactional(readOnly = true)
public class ScBoxItemService extends CrudService<ScBoxItemMapper, ScBoxItem> {

    @Override
    public ScBoxItem get(String id) {
        return super.get(id);
    }

    @Override
    public List<ScBoxItem> findList(ScBoxItem scBoxItem) {
        return super.findList(scBoxItem);
    }

    @Override
    public Page<ScBoxItem> findPage(Page<ScBoxItem> page, ScBoxItem scBoxItem) {
        return super.findPage(page, scBoxItem);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(ScBoxItem scBoxItem) {
        if (StringUtils.isBlank(scBoxItem.getRemarks())) {
            scBoxItem.setRemarks(scBoxItem.getBox().getRemarks());
        }
        super.save(scBoxItem);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(ScBoxItem scBoxItem) {
        super.delete(scBoxItem);
    }

}