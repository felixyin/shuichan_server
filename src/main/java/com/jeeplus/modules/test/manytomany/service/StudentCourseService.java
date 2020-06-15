/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.test.manytomany.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.test.manytomany.entity.StudentCourse;
import com.jeeplus.modules.test.manytomany.mapper.StudentCourseMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 学生课程记录Service
 *
 * @author lgf
 * @version 2018-06-12
 */
@Service
@Transactional(readOnly = true)
public class StudentCourseService extends CrudService<StudentCourseMapper, StudentCourse> {

    @Override
    public StudentCourse get(String id) {
        return super.get(id);
    }

    @Override
    public List<StudentCourse> findList(StudentCourse studentCourse) {
        return super.findList(studentCourse);
    }

    @Override
    public Page<StudentCourse> findPage(Page<StudentCourse> page, StudentCourse studentCourse) {
        return super.findPage(page, studentCourse);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(StudentCourse studentCourse) {
        super.save(studentCourse);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(StudentCourse studentCourse) {
        super.delete(studentCourse);
    }

}