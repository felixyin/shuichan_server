package com.jeeplus.modules.order.task;

import com.jeeplus.common.utils.SpringContextHolder;
import com.jeeplus.modules.monitor.entity.Task;
import org.quartz.DisallowConcurrentExecution;

@DisallowConcurrentExecution
public class ResetSerialNumberTask extends Task {

    @Override
    public void run() {
        System.out.println("每天重置每个工厂的装箱单打印序号为001");
        SpringContextHolder.getBean(ResetSeriaNumberService.class).runTask();
    }


}

