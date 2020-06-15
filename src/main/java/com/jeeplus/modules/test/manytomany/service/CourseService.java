/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.test.manytomany.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.test.manytomany.entity.Course;
import com.jeeplus.modules.test.manytomany.mapper.CourseMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 课程Service
 *
 * @author lgf
 * @version 2018-06-12
 */
@Service
@Transactional(readOnly = true)
public class CourseService extends CrudService<CourseMapper, Course> {

    @Override
    public Course get(String id) {
        return super.get(id);
    }

    @Override
    public List<Course> findList(Course course) {
        return super.findList(course);
    }

    @Override
    public Page<Course> findPage(Page<Course> page, Course course) {
        return super.findPage(page, course);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(Course course) {
        super.save(course);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(Course course) {
        super.delete(course);
    }

}