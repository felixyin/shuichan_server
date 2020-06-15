package com.jeeplus.modules.monitor.task;

import com.jeeplus.modules.monitor.entity.Task;
import org.quartz.DisallowConcurrentExecution;

@DisallowConcurrentExecution
public class TestTask extends Task {

    @Override
    public void run() {
        System.out.println("这是测试任务TestTask。");

    }

}
