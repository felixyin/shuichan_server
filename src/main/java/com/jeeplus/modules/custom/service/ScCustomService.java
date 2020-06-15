/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.custom.service;

import com.jeeplus.common.utils.PinYin4jUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.custom.entity.ScCustom;
import com.jeeplus.modules.custom.mapper.ScCustomMapper;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 客户Service
 *
 * @author 尹彬
 * @version 2019-08-16
 */
@Service
@Transactional(readOnly = true)
public class ScCustomService extends CrudService<ScCustomMapper, ScCustom> {

    @Override
    public ScCustom get(String id) {
        return super.get(id);
    }

    @Override
    protected void preExecute(ScCustom entity) {
        // 设置所属工厂
        if (!UserUtils.getUser().isAdmin()) {
            entity.setOffice(UserUtils.getOfficeDirectly());
        }
    }

    @Override
    public List<ScCustom> findList(ScCustom scCustom) {
        return super.findList(scCustom);
    }

    @Override
    public Page<ScCustom> findPage(Page<ScCustom> page, ScCustom scCustom) {
        return super.findPage(page, scCustom);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(ScCustom scCustom) {
        // 生成拼音首字母，用于装箱单打印的编号
        if (StringUtils.isNotBlank(scCustom.getUsername())) {
            scCustom.setUsernamePy(PinYin4jUtils.toPinYinAll(scCustom.getUsername()));
            scCustom.setUsernamePyFirst(PinYin4jUtils.toPinYinHead(scCustom.getUsername()));
        }
        super.save(scCustom);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(ScCustom scCustom) {
        super.delete(scCustom);
    }

}