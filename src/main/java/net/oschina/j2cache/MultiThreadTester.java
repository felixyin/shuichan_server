package net.oschina.j2cache;

import org.apache.commons.lang3.concurrent.BasicThreadFactory;

import java.util.Random;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;

/**
 * 对 J2Cache 进行多线程测试
 */
public class MultiThreadTester {

    public static void main(String[] args) {
        CacheChannel cache = J2Cache.getChannel();

//        ExecutorService threadPool = Executors.newCachedThreadPool();
        //org.apache.commons.lang3.concurrent.BasicThreadFactory
        ScheduledExecutorService threadPool = new ScheduledThreadPoolExecutor(1,
                new BasicThreadFactory.Builder().namingPattern("tester-schedule-pool-%d").daemon(true).build());


        for(int i=0;i<100;i++) {
            final int seq = i;
            threadPool.execute(() -> {
                Random seed = new Random(System.currentTimeMillis());
                String name = "Thread-" + seq;
                for(int j=0;j<100;j++) {
                    long ct = System.currentTimeMillis();
                    String rand = String.valueOf(seed.nextInt());
                    cache.set("Users", rand, seed.nextDouble());
                    System.out.printf("%s -> %s (%dms)\n", name, cache.get("Users", rand).getValue(), (System.currentTimeMillis()-ct));
                }
            });
        }
    }

}
