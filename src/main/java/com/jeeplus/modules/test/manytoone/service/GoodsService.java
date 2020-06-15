/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.test.manytoone.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.test.manytoone.entity.Goods;
import com.jeeplus.modules.test.manytoone.mapper.GoodsMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 商品Service
 *
 * @author liugf
 * @version 2018-06-12
 */
@Service
@Transactional(readOnly = true)
public class GoodsService extends CrudService<GoodsMapper, Goods> {

    @Override
    public Goods get(String id) {
        return super.get(id);
    }

    @Override
    public List<Goods> findList(Goods goods) {
        return super.findList(goods);
    }

    @Override
    public Page<Goods> findPage(Page<Goods> page, Goods goods) {
        return super.findPage(page, goods);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(Goods goods) {
        super.save(goods);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(Goods goods) {
        super.delete(goods);
    }

}