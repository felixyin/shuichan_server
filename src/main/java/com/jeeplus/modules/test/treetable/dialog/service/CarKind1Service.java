/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.test.treetable.dialog.service;

import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.core.service.TreeService;
import com.jeeplus.modules.test.treetable.dialog.entity.CarKind1;
import com.jeeplus.modules.test.treetable.dialog.mapper.CarKind1Mapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 车系Service
 *
 * @author lgf
 * @version 2018-06-12
 */
@Service
@Transactional(readOnly = true)
public class CarKind1Service extends TreeService<CarKind1Mapper, CarKind1> {

    @Override
    public CarKind1 get(String id) {
        return super.get(id);
    }

    @Override
    public List<CarKind1> findList(CarKind1 carKind1) {
        if (StringUtils.isNotBlank(carKind1.getParentIds())) {
            carKind1.setParentIds("," + carKind1.getParentIds() + ",");
        }
        return super.findList(carKind1);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(CarKind1 carKind1) {
        super.save(carKind1);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(CarKind1 carKind1) {
        super.delete(carKind1);
    }

}