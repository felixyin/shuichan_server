/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.test.treetable.dialog.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.test.treetable.dialog.entity.Car1;
import com.jeeplus.modules.test.treetable.dialog.mapper.Car1Mapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 车辆Service
 *
 * @author lgf
 * @version 2018-06-12
 */
@Service
@Transactional(readOnly = true)
public class Car1Service extends CrudService<Car1Mapper, Car1> {

    @Override
    public Car1 get(String id) {
        return super.get(id);
    }

    @Override
    public List<Car1> findList(Car1 car1) {
        return super.findList(car1);
    }

    @Override
    public Page<Car1> findPage(Page<Car1> page, Car1 car1) {
        return super.findPage(page, car1);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(Car1 car1) {
        super.save(car1);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(Car1 car1) {
        super.delete(car1);
    }

}