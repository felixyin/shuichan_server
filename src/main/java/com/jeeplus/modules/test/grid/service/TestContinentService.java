/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.test.grid.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.test.grid.entity.TestContinent;
import com.jeeplus.modules.test.grid.mapper.TestContinentMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 洲Service
 *
 * @author lgf
 * @version 2018-06-12
 */
@Service
@Transactional(readOnly = true)
public class TestContinentService extends CrudService<TestContinentMapper, TestContinent> {

    @Override
    public TestContinent get(String id) {
        return super.get(id);
    }

    @Override
    public List<TestContinent> findList(TestContinent testContinent) {
        return super.findList(testContinent);
    }

    @Override
    public Page<TestContinent> findPage(Page<TestContinent> page, TestContinent testContinent) {
        return super.findPage(page, testContinent);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(TestContinent testContinent) {
        super.save(testContinent);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(TestContinent testContinent) {
        super.delete(testContinent);
    }

}