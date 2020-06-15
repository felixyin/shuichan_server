package com.jeeplus.modules.order.task;

import com.jeeplus.modules.sys.entity.Office;
import com.jeeplus.modules.sys.mapper.OfficeMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

@Service
@Transactional(readOnly = true)
public class ResetSeriaNumberService {

    @Resource
    private OfficeMapper officeMapper;

    public void runTask() {
        List<Office> allOffices = officeMapper.findAllList(new Office());
        for (Office allOffice : allOffices) {
            Office.newSerialNumberStatic(allOffice.getId());
        }
    }

}
