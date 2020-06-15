/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.test.validation.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.test.validation.entity.TestValidation;
import com.jeeplus.modules.test.validation.mapper.TestValidationMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 测试校验功能Service
 *
 * @author lgf
 * @version 2018-06-12
 */
@Service
@Transactional(readOnly = true)
public class TestValidationService extends CrudService<TestValidationMapper, TestValidation> {

    @Override
    public TestValidation get(String id) {
        return super.get(id);
    }

    @Override
    public List<TestValidation> findList(TestValidation testValidation) {
        return super.findList(testValidation);
    }

    @Override
    public Page<TestValidation> findPage(Page<TestValidation> page, TestValidation testValidation) {
        return super.findPage(page, testValidation);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(TestValidation testValidation) {
        super.save(testValidation);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(TestValidation testValidation) {
        super.delete(testValidation);
    }

}