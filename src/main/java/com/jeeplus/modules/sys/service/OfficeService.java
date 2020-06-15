/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.sys.service;

import com.jeeplus.common.utils.PinYin4jUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.core.service.TreeService;
import com.jeeplus.modules.sys.entity.Office;
import com.jeeplus.modules.sys.mapper.OfficeMapper;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 机构Service
 *
 * @author jeeplus
 * @version 2017-05-16
 */
@Service
@Transactional(readOnly = true)
public class OfficeService extends TreeService<OfficeMapper, Office> {

    @Autowired
    private OfficeMapper officeMapper;

    public List<Office> findAll() {
        return UserUtils.getOfficeList();
    }

    public List<Office> findList(Boolean isAll) {
        if (isAll != null && isAll) {
            return UserUtils.getOfficeAllList();
        } else {
            return UserUtils.getOfficeList();
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<Office> findList(Office office) {
        office.setParentIds(office.getParentIds() + "%");
        return officeMapper.findByParentIdsLike(office);
    }

    @Transactional(readOnly = true)
    public Office getByCode(String code) {
        return officeMapper.getByCode(code);
    }

    @Override
    public List<Office> getChildren(String parentId) {
        return officeMapper.getChildren(parentId);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(Office office) {
        String name = office.getName();
        if (StringUtils.isNotBlank(name)) {
            office.setPy(PinYin4jUtils.toPinYinAllLower(name));
            office.setPyFirst(PinYin4jUtils.toPinYinHeadLower(name));
        }
        super.save(office);
        UserUtils.removeCache(UserUtils.CACHE_OFFICE_LIST);

        // 如果发现没有此机构的 序号，则创建
        Office.getSerialNumberStatic(office.getId());
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(Office office) {
        // fixme 应该先判断机构下是否有用户，如果有，则不允许删除
        super.delete(office);
        UserUtils.removeCache(UserUtils.CACHE_OFFICE_LIST);
    }

    @Transactional(readOnly = true)
    public List<Office> findListByName(String name) {
        return this.mapper.findListByName(name);
    }
}
