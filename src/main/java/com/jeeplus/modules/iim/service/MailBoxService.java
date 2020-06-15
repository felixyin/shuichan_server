/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.iim.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.iim.entity.MailBox;
import com.jeeplus.modules.iim.entity.MailPage;
import com.jeeplus.modules.iim.mapper.MailBoxMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 收件箱Service
 *
 * @author jeeplus
 * @version 2015-11-13
 */
@Service
@Transactional(readOnly = true)
public class MailBoxService extends CrudService<MailBoxMapper, MailBox> {

    @Autowired
    private MailBoxMapper mailBoxMapper;

    @Override
    public MailBox get(String id) {
        return super.get(id);
    }

    @Override
    public List<MailBox> findList(MailBox mailBox) {
        return super.findList(mailBox);
    }

    public Page<MailBox> findPage(MailPage<MailBox> page, MailBox mailBox) {
        return super.findPage(page, mailBox);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(MailBox mailBox) {
        super.save(mailBox);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(MailBox mailBox) {
        super.delete(mailBox);
    }

    public int getCount(MailBox mailBox) {
        return mailBoxMapper.getCount(mailBox);
    }

}