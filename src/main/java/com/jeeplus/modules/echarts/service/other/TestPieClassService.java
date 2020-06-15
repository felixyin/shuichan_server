/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.echarts.service.other;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.echarts.entity.other.TestPieClass;
import com.jeeplus.modules.echarts.mapper.other.TestPieClassMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 学生Service
 *
 * @author lgf
 * @version 2017-06-04
 */
@Service
@Transactional(readOnly = true)
public class TestPieClassService extends CrudService<TestPieClassMapper, TestPieClass> {

    @Override
    public TestPieClass get(String id) {
        return super.get(id);
    }

    @Override
    public List<TestPieClass> findList(TestPieClass testPieClass) {
        return super.findList(testPieClass);
    }

    @Override
    public Page<TestPieClass> findPage(Page<TestPieClass> page, TestPieClass testPieClass) {
        return super.findPage(page, testPieClass);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(TestPieClass testPieClass) {
        super.save(testPieClass);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(TestPieClass testPieClass) {
        super.delete(testPieClass);
    }

}