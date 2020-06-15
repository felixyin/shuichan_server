/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.test.note.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.test.note.entity.TestNote;
import com.jeeplus.modules.test.note.mapper.TestNoteMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 富文本测试Service
 *
 * @author liugf
 * @version 2018-06-12
 */
@Service
@Transactional(readOnly = true)
public class TestNoteService extends CrudService<TestNoteMapper, TestNote> {

    @Override
    public TestNote get(String id) {
        return super.get(id);
    }

    @Override
    public List<TestNote> findList(TestNote testNote) {
        return super.findList(testNote);
    }

    @Override
    public Page<TestNote> findPage(Page<TestNote> page, TestNote testNote) {
        return super.findPage(page, testNote);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(TestNote testNote) {
        super.save(testNote);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(TestNote testNote) {
        super.delete(testNote);
    }

}