package com.jeeplus.modules.pay;

public class AlipayConfigTest {
    // 商户appid
    public static String APPID = "2016101300679550";
    // 私钥 pkcs8格式的
    public static String RSA_PRIVATE_KEY = "MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQClIxRlXXburGn5pT604jUU1sqa0PRDwHuH13Jy5lZxHjHpcGZT+4UG2f0o6grfqjkDYYJNmfqB1JMD+Brs9c/ZH79uWhE7emcAotIP+aBbDfWdb104XcTqFLjV8+y00GbtAYECswIKe+0AS2V6ng5Df6mVXQ62CLCkwkJ/do+oISEYT4IriOIUgHaXbu2r8hAK1X6W4fzOnh1HnTesKvD6Jr2K7zyDPWJVX9ATVfAApOyO6pontGedpkR/93lP7X96i81x+Xs8x4YWMdbMJIMLbXglLBc8bKJEjaidrRYgBoPSLXc2Tsd0DFthVJusTsGsPwDReQomdFa7FrRe773DAgMBAAECggEAfxdebRzfmZSsAuwANKobfCxKxZenRjVvXP6dIHzRbkF03FobBut+V+WRBtoJAFY7hrSW2i51M1JsyxM5dcFA87ORWtaKiKINf9nPnWfa1/kIXOAGeIkCMb08+7y9IfN6I1GS/obSPUte/WkJcrMN+zjXRRLXbZWGjWbMUtjmete2IbOcKqaXmFq+ftB4wyNhmq+A3tyj2KyMhY2sTiw7gWaYMh8ciqQRggZZg/PHYvd76zg1ZeOrak9NX68YNnKzVbdMxsCbtATf6tez2voJVJyNa+BTOl3q5DhbskiiXweLCnxn4j1niVd2h44ai8Lv+Sw46iAl0gUq/T3Xr1YJ4QKBgQDkpn8mqy385jTkreFGU6egF5280zhiVC5PFsAcvJcZL0PXHrc0SgIt+bUXSAecoGP/+XNRgUMWE/S+v4V6k8+Wzt+bRDhqzL/hpb/8RQYUB7zT6zjuxfHUllezKQjR6p9fCHnyaTsWNLLsijG7n1Q3XFVP0CmkytTUDaRqHd6siQKBgQC4472hHbvGnw03vhd3g9aRs7ozUpJk/E6/WXeN9/g/tgFLYbdNjoHivjGm/NYuT4Us7Y5s0/7Jlahtv+UO22hwbdGkDaEOOLQcBTXwPM2rjVlu9iRVnH1a6WfPqPA2pgJdC4YM2kl+hMxF0yn4ZMcoKSzkH8nWpzkphL8ebQ186wKBgH48Bbr9itgy6ETQUq0XBlZ2c1mKa3it7Rsw/kNfQzReSd/8Tz0JFwb286m01K7+RfdOawI2kSkhP2AIMNMpw9QIxp7cHSGphM45SjMmkGKCmxeMp9P7aLXrguOg5gOuuuomrdzNiBeMZLP+39Ir9rzRty/nRvZ6HOIt3fXQI92xAoGAEsfHXlNH3KARVqUvewtgQ0KPWmE7z5g1Y4hx9XDHvaj+LqsJVI5yMRcCsiSimOeo7mxe+Dz8d3uFNUi1urGcxTbSgaiEwI4P9XyuAu4aMh/Ugsnr3OpdbVuiGNzfMZ3hRZRDFJEjv/87RKhzbfDGrhSoo6968BviWY5LX4rSQOsCgYAqv8WEFi/ck0L2ERxoGB3Ce2mo5OQqcYDg8wV4PxdvZMaBl4+zNQ79KdIxrslilHJIuD5AEf4iAjzk8+Lyz8m/GFaHxBXVeW35cTRIC0bbmxHqLAaQ5++cfpciobe0X6CzLTNxy9e+kOC9cO1X00LFji2j5PxXVc3AtBrlFmnP3g==";
    // 服务器异步通知页面路径 需http://或者https://格式的完整路径，不能加?id=123这类自定义参数，必须外网可以正常访问
    public static String NOTIFY_URL = "http://gongchang.qdbak.com/bak/a/pay/doPay/notifyForAli";
    // 页面跳转同步通知页面路径 需http://或者https://格式的完整路径，不能加?id=123这类自定义参数，必须外网可以正常访问 商户可以自定义同步跳转地址
    public static String RETURN_URL = "http://gongchang.qdbak.com/bak/a/pay/doPay/returnForAli";
    // 请求网关地址
    public static String URL = "https://openapi.alipaydev.com/gateway.do";
    // 编码
    public static String CHARSET = "UTF-8";
    // 返回格式
    public static String FORMAT = "json";
    // 支付宝公钥
    public static String ALIPAY_PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApSMUZV127qxp+aU+tOI1FNbKmtD0Q8B7h9dycuZWcR4x6XBmU/uFBtn9KOoK36o5A2GCTZn6gdSTA/ga7PXP2R+/bloRO3pnAKLSD/mgWw31nW9dOF3E6hS41fPstNBm7QGBArMCCnvtAEtlep4OQ3+plV0OtgiwpMJCf3aPqCEhGE+CK4jiFIB2l27tq/IQCtV+luH8zp4dR503rCrw+ia9iu88gz1iVV/QE1XwAKTsjuqaJ7RnnaZEf/d5T+1/eovNcfl7PMeGFjHWzCSDC214JSwXPGyiRI2ona0WIAaD0i13Nk7HdAxbYVSbrE7BrD8A0XkKJnRWuxa0Xu+9wwIDAQAB";
    // RSA2
    public static String SIGNTYPE = "RSA2";
}
