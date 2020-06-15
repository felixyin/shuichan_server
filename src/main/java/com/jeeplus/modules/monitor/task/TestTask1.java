package com.jeeplus.modules.monitor.task;

import com.jeeplus.modules.monitor.entity.Task;
import org.quartz.DisallowConcurrentExecution;

@DisallowConcurrentExecution
public class TestTask1 extends Task {

    @Override
    public void run() {
        System.out.println("这是另一个测试任务TestTask1。");

    }

}
