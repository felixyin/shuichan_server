/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.test.grid.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.test.grid.entity.TestCountry;
import com.jeeplus.modules.test.grid.mapper.TestCountryMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 国家Service
 *
 * @author lgf
 * @version 2018-04-10
 */
@Service
@Transactional(readOnly = true)
public class TestCountryService extends CrudService<TestCountryMapper, TestCountry> {

    @Override
    public TestCountry get(String id) {
        return super.get(id);
    }

    @Override
    public List<TestCountry> findList(TestCountry testCountry) {
        return super.findList(testCountry);
    }

    @Override
    public Page<TestCountry> findPage(Page<TestCountry> page, TestCountry testCountry) {
        return super.findPage(page, testCountry);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(TestCountry testCountry) {
        super.save(testCountry);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(TestCountry testCountry) {
        super.delete(testCountry);
    }

}