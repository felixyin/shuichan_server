/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.tools.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.tools.entity.TestInterface;
import com.jeeplus.modules.tools.mapper.TestInterfaceMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 接口Service
 *
 * @author lgf
 * @version 2016-01-07
 */
@Service
@Transactional(readOnly = true)
public class TestInterfaceService extends CrudService<TestInterfaceMapper, TestInterface> {

    @Override
    public TestInterface get(String id) {
        return super.get(id);
    }

    @Override
    public List<TestInterface> findList(TestInterface testInterface) {
        return super.findList(testInterface);
    }

    @Override
    public Page<TestInterface> findPage(Page<TestInterface> page, TestInterface testInterface) {
        return super.findPage(page, testInterface);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(TestInterface testInterface) {
        super.save(testInterface);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(TestInterface testInterface) {
        super.delete(testInterface);
    }

}