/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.test.manytoone.service;

import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.core.service.TreeService;
import com.jeeplus.modules.test.manytoone.entity.Category;
import com.jeeplus.modules.test.manytoone.mapper.CategoryMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 商品类型Service
 *
 * @author liugf
 * @version 2018-06-12
 */
@Service
@Transactional(readOnly = true)
public class CategoryService extends TreeService<CategoryMapper, Category> {

    @Override
    public Category get(String id) {
        return super.get(id);
    }

    @Override
    public List<Category> findList(Category category) {
        if (StringUtils.isNotBlank(category.getParentIds())) {
            category.setParentIds("," + category.getParentIds() + ",");
        }
        return super.findList(category);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(Category category) {
        super.save(category);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(Category category) {
        super.delete(category);
    }

}