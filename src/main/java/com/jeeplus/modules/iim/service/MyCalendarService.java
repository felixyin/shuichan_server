/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.iim.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.iim.entity.MyCalendar;
import com.jeeplus.modules.iim.mapper.MyCalendarMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


/**
 * 日历Service
 *
 * @author liugf
 * @version 2016-04-19
 */
@Service
@Transactional(readOnly = true)
public class MyCalendarService extends CrudService<MyCalendarMapper, MyCalendar> {

    @Override
    public MyCalendar get(String id) {
        return super.get(id);
    }

    @Override
    public List<MyCalendar> findList(MyCalendar myCalendar) {
        return super.findList(myCalendar);
    }

    @Override
    public Page<MyCalendar> findPage(Page<MyCalendar> page, MyCalendar myCalendar) {
        return super.findPage(page, myCalendar);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(MyCalendar myCalendar) {
        super.save(myCalendar);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(MyCalendar myCalendar) {
        super.delete(myCalendar);
    }

}