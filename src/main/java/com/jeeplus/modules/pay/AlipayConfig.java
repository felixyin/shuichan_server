package com.jeeplus.modules.pay;

import com.jeeplus.common.config.Global;

public class AlipayConfig {
    // 商户appid
    public static String APPID;
    // 私钥 pkcs8格式的
    public static String RSA_PRIVATE_KEY;
    // 服务器异步通知页面路径 需http://或者https://格式的完整路径，不能加?id=123这类自定义参数，必须外网可以正常访问
    public static String NOTIFY_URL ;
    // 页面跳转同步通知页面路径 需http://或者https://格式的完整路径，不能加?id=123这类自定义参数，必须外网可以正常访问 商户可以自定义同步跳转地址
//    public static String RETURN_URL = "http://gongchang.qdbak.com/bak/a/pay/doPay/returnForAli";
    public static String RETURN_URL ;
    // 请求网关地址
    public static String URL ;
    // 编码
    public static String CHARSET ;
    // 返回格式
    public static String FORMAT ;
    // 支付宝公钥
    public static String ALIPAY_PUBLIC_KEY ;

    // RSA2
    public static String SIGNTYPE ;

    static {
        // 从配置文件初始化所有 阿里云支付 参数
        APPID = Global.getConfig("alipay.appid");
        RSA_PRIVATE_KEY = Global.getConfig("alipay.rsa.private.key");
        NOTIFY_URL = Global.getConfig("alipay.notify.url");
        RETURN_URL = Global.getConfig("alipay.return.url");
        URL = Global.getConfig("alipay.url");
        CHARSET = Global.getConfig( "alipay.charset");
        FORMAT = Global.getConfig("alipay.format");
        ALIPAY_PUBLIC_KEY = Global.getConfig("alipay.public.key");
        SIGNTYPE = Global.getConfig("alipay.sign.type");
    }
}
