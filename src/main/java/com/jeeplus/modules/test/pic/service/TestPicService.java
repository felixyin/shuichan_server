/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.test.pic.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.test.pic.entity.TestPic;
import com.jeeplus.modules.test.pic.mapper.TestPicMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 图片管理Service
 *
 * @author lgf
 * @version 2018-06-12
 */
@Service
@Transactional(readOnly = true)
public class TestPicService extends CrudService<TestPicMapper, TestPic> {

    @Override
    public TestPic get(String id) {
        return super.get(id);
    }

    @Override
    public List<TestPic> findList(TestPic testPic) {
        return super.findList(testPic);
    }

    @Override
    public Page<TestPic> findPage(Page<TestPic> page, TestPic testPic) {
        return super.findPage(page, testPic);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(TestPic testPic) {
        super.save(testPic);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(TestPic testPic) {
        super.delete(testPic);
    }

}