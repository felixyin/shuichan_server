/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.pay.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.pay.entity.ScPay;
import com.jeeplus.modules.pay.mapper.ScPayMapper;
import com.jeeplus.modules.sys.entity.Office;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * 产品购买Service
 *
 * @author 尹彬
 * @version 2019-10-20
 */
@Service
@Transactional(readOnly = true)
public class ScPayService extends CrudService<ScPayMapper, ScPay> {

    @Override
    public ScPay get(String id) {
        return super.get(id);
    }

    @Override
    public List<ScPay> findList(ScPay scPay) {
        return super.findList(scPay);
    }

    @Override
    public Page<ScPay> findPage(Page<ScPay> page, ScPay scPay) {
        return super.findPage(page, scPay);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(ScPay scPay) {
        super.save(scPay);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(ScPay scPay) {
        super.delete(scPay);
    }

    /**
     * 检查 水产加工厂是否 购买的产品在有效期
     *
     * @param office
     * @return
     */
    public boolean isActivation(Office office) {
        return isActivation(office.getId());
    }

    /**
     * 检查 水产加工厂是否 购买的产品在有效期
     *
     * @param officeId
     * @return
     */
    public boolean isActivation(String officeId) {
//        ScPay pay = new ScPay();
//        pay.setOffice(office);
//		List<ScPay> allList = this.findAllList(pay);
//		for (ScPay scPay : allList) {
//			if(null != scPay && scPay.getReturnSuccess() == 1)	{
//				Date endDate = scPay.getEndDate();
//			s	Date nowDate = new Date();
//				if(DateUtil.)
//			}
//		}
//        List<Map<String, Object>> maps = mapper.execSelectSql("select count(1) as `count` from sc_pay p where p.office_id='" + officeId + "' and p.end_date > now() and p.return_success = 1 or p.return_success =3");
        List<Map<String, Object>> maps = mapper.execSelectSql("select count(1) as `count` from sc_pay p where p.office_id='" + officeId + "' and p.end_date > now() and (p.return_success = 1 or p.return_success =3)");
        Map<String, Object> stringObjectMap = maps.get(0);
        int count = Integer.parseInt(stringObjectMap.get("count").toString());
        return count == 1;
    }
}