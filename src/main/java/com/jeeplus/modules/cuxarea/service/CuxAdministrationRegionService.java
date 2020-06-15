/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.cuxarea.service;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.cuxarea.entity.CuxAdministrationRegion;
import com.jeeplus.modules.cuxarea.mapper.CuxAdministrationRegionMapper;
import com.jeeplus.modules.sys.entity.Area;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.service.AreaService;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

/**
 * 导入用区域用Service
 *
 * @author 尹彬
 * @version 2019-08-01
 */
@Service
@Transactional(readOnly = true)
public class CuxAdministrationRegionService extends CrudService<CuxAdministrationRegionMapper, CuxAdministrationRegion> {

    @Resource
    private AreaService areaService;

    @Override
    public CuxAdministrationRegion get(String id) {
        return super.get(id);
    }

    @Override
    public List<CuxAdministrationRegion> findList(CuxAdministrationRegion cuxAdministrationRegion) {
        return super.findList(cuxAdministrationRegion);
    }

    @Override
    public Page<CuxAdministrationRegion> findPage(Page<CuxAdministrationRegion> page, CuxAdministrationRegion cuxAdministrationRegion) {
        return super.findPage(page, cuxAdministrationRegion);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(CuxAdministrationRegion cuxAdministrationRegion) {
        super.save(cuxAdministrationRegion);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(CuxAdministrationRegion cuxAdministrationRegion) {
        super.delete(cuxAdministrationRegion);
    }

    @Transactional(readOnly = false)
    public void initData() {
        System.out.println("-------------------->start!!");
        CuxAdministrationRegion cux1 = new CuxAdministrationRegion();
//		cux1.setRegionLevel("1");
        List<CuxAdministrationRegion> list = findList(cux1);
        System.out.println(list.size());

        // 清理数据
        areaService.clear();

        User user = UserUtils.getUser();

        // 保存根节点：中国
        Area topArea = new Area();
        topArea.setId("0");
        topArea.setParent(null);
        topArea.setCode("86");
        topArea.setType("1");
        topArea.setParentIds("");
        topArea.setName("中国");
        topArea.setSort(0);
        topArea.setCreateBy(user);
        topArea.setCreateDate(new Date());
        areaService.save(topArea);


        for (CuxAdministrationRegion cux2 : list) {
            String regionLevel = cux2.getRegionLevel();
            if ("1".equalsIgnoreCase(regionLevel)) {
                // 计数器
                int counter = 1;
                Area area = new Area();
                area.setParent(topArea);
                area.setName(cux2.getRegionName());
                area.setType("2");
                area.setCode(cux2.getRegionCode());
                area.setCreateDate(new Date());
                area.setCreateBy(user);
                area.setSort(counter++);
                areaService.save(area);
                for (CuxAdministrationRegion cux3 : list) {
                    String regionLevel2 = cux3.getRegionLevel();
                    // 计数器
                    if ("2".equalsIgnoreCase(regionLevel2) && cux3.getParentRegionCode().equalsIgnoreCase(cux2.getRegionCode())) {
                        int counter2 = 100;
                        Area area2 = new Area();
                        area2.setParent(area);
                        area2.setName(cux3.getRegionName());
                        area2.setType("3");
                        area2.setCode(cux3.getRegionCode());
                        area2.setCreateDate(new Date());
                        area2.setCreateBy(user);
                        area2.setSort(counter2++);
                        areaService.save(area2);
                        for (CuxAdministrationRegion cux4 : list) {
                            String regionLevel3 = cux4.getRegionLevel();
                            // 计数器
                            if ("3".equalsIgnoreCase(regionLevel3) && cux4.getParentRegionCode().equalsIgnoreCase(cux3.getRegionCode())) {
                                int counter3 = 10000;
                                Area area3 = new Area();
                                area3.setParent(area);
                                area3.setName(cux4.getRegionName());
                                area3.setType("4");
                                area3.setCode(cux4.getRegionCode());
                                area3.setCreateDate(new Date());
                                area3.setCreateBy(user);
                                area3.setSort(counter3++);
                                areaService.save(area3);
                            }
                        }
                    }
                }
            }
        }

        System.out.println("-------------------->start!!");
    }
}