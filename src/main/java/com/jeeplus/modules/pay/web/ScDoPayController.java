/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.pay.web;

import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.internal.util.AlipaySignature;
import com.alipay.api.request.AlipayTradePagePayRequest;
import com.alipay.api.response.AlipayTradePagePayResponse;
import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.utils.PinYin4jUtils;
import com.jeeplus.common.utils.time.DateUtil;
import com.jeeplus.modules.pay.AlipayConfig;
import com.jeeplus.modules.pay.entity.ScPay;
import com.jeeplus.modules.sys.entity.Office;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;


/**
 * 产品购买Controller
 *
 * @author 尹彬
 * @version 2019-10-19
 */
@Controller
@RequestMapping(value = "${adminPath}/pay/doPay")
public class ScDoPayController extends ScPayController {

    /**
     * 产品购买列表页面
     */
    @RequiresPermissions("pay:scPay:list")
    @RequestMapping(value = {"list", ""})
    @Override
    public String list(ScPay scPay, Model model) {
        boolean admin = UserUtils.getUser().isAdmin();
        if (!admin) { // 管理员用来管理客户的账号、付款信息
            // 所属加工厂
            Office officeDirectly = UserUtils.getOfficeDirectly();
            ScPay scPayParam = new ScPay();
            scPayParam.setOffice(officeDirectly);
            model.addAttribute("scPay", scPayParam);
            List<ScPay> allList = scPayService.findAllList(scPayParam);
            for (ScPay pay : allList) {
                Integer returnSuccess = pay.getReturnSuccess();
                if (null != returnSuccess && (returnSuccess == 1 || returnSuccess == 3)) { // 非支付成功的那些数据属于垃圾数据，予以删除
                    model.addAttribute("scPay", pay);
                }
            }
            boolean activation = scPayService.isActivation(officeDirectly.getId());
            model.addAttribute("activation", activation);
            return "modules/pay/gotoPay";
        }
        model.addAttribute("scPay", scPay);
        return "modules/pay/scPayList";
    }


    @RequestMapping(value = "trial")
    public String trial(ScPay scPay, HttpServletResponse response) throws IOException {
        // 付款人
        User user = UserUtils.getUser();
        scPay.setUser(user);

        // 所属加工厂
        Office officeDirectly = UserUtils.getOfficeDirectly();
        scPay.setOffice(officeDirectly);

        // 订单编号
        String suffix = PinYin4jUtils.toPinYinHead(officeDirectly.getName());
        String date = DateUtils.getDate("yyyyMMddHHmmss");
        scPay.setTradeNo(date + suffix);

        // 清除之前未付款成功的数据
        ScPay scPayParam = new ScPay();
        scPayParam.setOffice(officeDirectly);
        List<ScPay> allList = scPayService.findAllList(scPayParam);
//        for (ScPay pay : allList) {
//            if (null == pay.getReturnSuccess() || pay.getReturnSuccess() != 1) { // 非支付成功的那些数据属于垃圾数据，予以删除
//                scPayService.delete(pay);
//            }
//        }

        scPay.setReturnNo("");
        scPay.setMoney("0");
        scPay.setReturnSuccess(3); // 3 免费试用
        scPay.setReturnMessage("免费试用");
        scPay.setPayDate(new Date());
        // 计算购买过期日期
        Date endDate = new Date();
        switch (scPay.getPayModel()) {
            case 1:
                endDate = DateUtil.addDays(endDate, 15);
                break;
            case 2:
                endDate = DateUtil.addMonths(endDate, 1);
                break;
            case 3:
                endDate = DateUtil.addMonths(endDate, 3);
                break;
            case 4:
                endDate = DateUtil.addMonths(endDate, 12);
                break;
            default:
        }
        scPay.setEndDate(endDate);
        scPayService.save(scPay);
        return "modules/pay/closePage";
    }

    @RequestMapping(value = "aliPay")
    public void aliPay(ScPay scPay, HttpServletResponse response) throws IOException {

        // 付款人
        User user = UserUtils.getUser();
        scPay.setUser(user);

        // 所属加工厂
        Office officeDirectly = UserUtils.getOfficeDirectly();
        scPay.setOffice(officeDirectly);

        // 订单编号
        String suffix = PinYin4jUtils.toPinYinHead(officeDirectly.getName());
        String date = DateUtils.getDate("yyyyMMddHHmmss");
        scPay.setTradeNo(date + suffix);

        String form = doPay(scPay);

        // 清除之前未付款成功的数据
        ScPay scPayParam = new ScPay();
        scPayParam.setOffice(officeDirectly);
        List<ScPay> allList = scPayService.findAllList(scPayParam);
        for (ScPay pay : allList) {
            if (null == pay.getReturnSuccess() || pay.getReturnSuccess() != 1) { // 非支付成功的那些数据属于垃圾数据，予以删除
                scPayService.delete(pay);
            }
        }

        scPayService.save(scPay);

        response.setContentType("text/html;charset=" + AlipayConfig.CHARSET);
        response.getWriter().write(form);//直接将完整的表单html输出到页面
        response.getWriter().flush();
        response.getWriter().close();
    }

  /*  @RequestMapping(value = "notifyForAli")
    public String notifyForAli(HttpServletRequest request, HttpServletResponse response, Model model) throws ServletException, IOException, AlipayApiException {

        //获取支付宝POST过来反馈信息
        Map<String, String> params = new HashMap<String, String>();
        Map<String, String[]> requestParams = request.getParameterMap();
        for (Iterator<String> iter = requestParams.keySet().iterator(); iter.hasNext(); ) {
            String name = (String) iter.next();
            String[] values = (String[]) requestParams.get(name);
            String valueStr = "";
            for (int i = 0; i < values.length; i++) {
                valueStr = (i == values.length - 1) ? valueStr + values[i]
                        : valueStr + values[i] + ",";
            }
            //乱码解决，这段代码在出现乱码时使用
            valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
            params.put(name, valueStr);
        }

        boolean signVerified = AlipaySignature.rsaCheckV1(params, AlipayConfig.ALIPAY_PUBLIC_KEY, AlipayConfig.CHARSET, AlipayConfig.SIGNTYPE); //调用SDK验证签名

        //——请在这里编写您的程序（以下代码仅作参考）——

//	实际验证过程建议商户务必添加以下校验：
//	1、需要验证该通知数据中的out_trade_no是否为商户系统中创建的订单号，
//	2、判断total_amount是否确实为该订单的实际金额（即商户订单创建时的金额），
//	3、校验通知中的seller_id（或者seller_email) 是否为out_trade_no这笔单据的对应的操作方（有的时候，一个商户可能有多个seller_id/seller_email）
//	4、验证app_id是否为该商户本身。

        if (signVerified) {//验证成功
            //商户订单号
            String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"), "UTF-8");

            //支付宝交易号
            String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"), "UTF-8");

            //交易状态
            String trade_status = new String(request.getParameter("trade_status").getBytes("ISO-8859-1"), "UTF-8");

            if (trade_status.equals("TRADE_FINISHED")) {
                //判断该笔订单是否在商户网站中已经做过处理
                //如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
                //如果有做过处理，不执行商户的业务程序

                //注意：
                //退款日期超过可退款期限后（如三个月可退款），支付宝系统发送该交易状态通知
            } else if (trade_status.equals("TRADE_SUCCESS")) {
                //判断该笔订单是否在商户网站中已经做过处理
                //如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
                //如果有做过处理，不执行商户的业务程序

                //注意：
                //付款完成后，支付宝系统发送该交易状态通知
            }

//            out.println("success");
            System.out.println("支付状态：" + trade_status);

            model.addAttribute("body", new ScPay());
            model.addAttribute("success", true);
            model.addAttribute("message", null);
        } else {//验证失败
//            out.println("fail");

            //调试用，写文本函数记录程序运行情况是否正常
            //String sWord = AlipaySignature.getSignCheckContentV1(params);
            //logResult(sWord);
            model.addAttribute("success", false);
            model.addAttribute("message", "支付失败：验签失败！");
        }

        //——请在这里编写您的程序（以上代码仅作参考）——

        return "modules/pay/alipay/notify_url.jsp";
    }
*/


    // 测试参数 ?charset=UTF-8&out_trade_no=20191019203621CSSCJGC1&method=alipay.trade.page.pay.return&total_amount=0.01&sign=ILhm3%2BL32VCwOPSj7VivZ8kzdpiMb6vC4BjgVaxTVulNYdyJEs2Py1159Jby3Avobdh%2F7hERhUs1QkbdO8%2FC0K55CgcFDmLyazT9NNiUFI3h5QpGUhtToGVdZpiPFv%2FvpcyMS06sFj%2Bwog%2BY9nibTWQ9j25JdP3dEuP14uokdmYmO14nN%2FWBE%2BYq%2B%2FzzeTWZBNRxBpfxnaJz4Qh0UYTip1qkottL2uIqsr%2Bvm%2B3udq21RcOym9b8vJiD77lEVCYEvx6WxgkGxSQnIHdJAzkE1qLGRg%2FNDWtJxIpeFeoWGZjpVlYKpYzMN1hdw%2BpEQvD4hCCQ9sgg54QC4HyqWJFPtg%3D%3D&trade_no=2019101922001479910509006029&auth_app_id=2019100968198469&version=1.0&app_id=2019100968198469&sign_type=RSA2&seller_id=2088531846622988&timestamp=2019-10-19+20%3A36%3A54
//    测试地址： http://192.168.3.34:8088/bak/a/pay/doPay/returnForAli?charset=UTF-8&out_trade_no=20191019203621CSSCJGC1&method=alipay.trade.page.pay.return&total_amount=0.01&sign=ILhm3%2BL32VCwOPSj7VivZ8kzdpiMb6vC4BjgVaxTVulNYdyJEs2Py1159Jby3Avobdh%2F7hERhUs1QkbdO8%2FC0K55CgcFDmLyazT9NNiUFI3h5QpGUhtToGVdZpiPFv%2FvpcyMS06sFj%2Bwog%2BY9nibTWQ9j25JdP3dEuP14uokdmYmO14nN%2FWBE%2BYq%2B%2FzzeTWZBNRxBpfxnaJz4Qh0UYTip1qkottL2uIqsr%2Bvm%2B3udq21RcOym9b8vJiD77lEVCYEvx6WxgkGxSQnIHdJAzkE1qLGRg%2FNDWtJxIpeFeoWGZjpVlYKpYzMN1hdw%2BpEQvD4hCCQ9sgg54QC4HyqWJFPtg%3D%3D&trade_no=2019101922001479910509006029&auth_app_id=2019100968198469&version=1.0&app_id=2019100968198469&sign_type=RSA2&seller_id=2088531846622988&timestamp=2019-10-19+20%3A36%3A54
    @RequestMapping(value = "returnForAli")
    public String returnForAli(HttpServletRequest request, HttpServletResponse response, Model model) throws ServletException, IOException, AlipayApiException {
        //获取支付宝GET过来反馈信息
        Map<String, String> params = new HashMap<String, String>();
        Map<String, String[]> requestParams = request.getParameterMap();
        for (Iterator<String> iter = requestParams.keySet().iterator(); iter.hasNext(); ) {
            String name = (String) iter.next();
            String[] values = (String[]) requestParams.get(name);
            String valueStr = "";
            for (int i = 0; i < values.length; i++) {
                valueStr = (i == values.length - 1) ? valueStr + values[i]
                        : valueStr + values[i] + ",";
            }
            //乱码解决，这段代码在出现乱码时使用
//            valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
            params.put(name, valueStr);
        }

        //商户订单号
        String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"), "UTF-8");

        //支付宝交易号
        String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"), "UTF-8");

        //付款金额
        String total_amount = new String(request.getParameter("total_amount").getBytes("ISO-8859-1"), "UTF-8");

        boolean signVerified = AlipaySignature.rsaCheckV1(params, AlipayConfig.ALIPAY_PUBLIC_KEY, AlipayConfig.CHARSET, AlipayConfig.SIGNTYPE); //调用SDK验证签名
        //——请在这里编写您的程序（以下代码仅作参考）——
        if (signVerified) {

//            out.println("trade_no:" + trade_no + "<br/>out_trade_no:" + out_trade_no + "<br/>total_amount:" + total_amount);
//            model.addAttribute("out_trade_no", out_trade_no);
//            model.addAttribute("trade_no", trade_no);
//            model.addAttribute("total_amount", total_amount);
//
//            model.addAttribute("pay_success", true);
//            model.addAttribute("pay_message", null);
            ScPay scPay = scPayService.findUniqueByProperty("trade_no", out_trade_no);
            if (null != scPay) {
                scPay.setUser(UserUtils.getUser());
                scPay.setOffice(UserUtils.getOfficeDirectly());
                scPay.setReturnNo(trade_no);
                scPay.setMoney(total_amount);
                scPay.setReturnSuccess(1); // 支付成功
                scPay.setReturnMessage("支付成功");
                scPay.setPayDate(new Date());
                // 计算购买过期日期
                Date endDate = new Date();
                switch (scPay.getPayModel()) {
                    case 1:
                        endDate = DateUtil.addMonths(endDate, 1);
                        break;
                    case 2:
                        endDate = DateUtil.addMonths(endDate, 3);
                        break;
                    case 3:
                        endDate = DateUtil.addMonths(endDate, 12);
                        break;
                    case 4:
                        endDate = DateUtil.addMonths(endDate, 999999);
                        break;
                    default:
                }
                scPay.setEndDate(endDate);
                scPayService.save(scPay);
            }
        } else {
            ScPay scPay = scPayService.findUniqueByProperty("trade_no", out_trade_no);
            if (null != scPay) {
                scPay.setUser(UserUtils.getUser());
                scPay.setOffice(UserUtils.getOfficeDirectly());
                scPay.setReturnNo(trade_no);
                scPay.setMoney(total_amount);
                scPay.setReturnSuccess(2); // 支付失败
//                scPay.setReturnSuccess(1); // 支付成功
                scPay.setReturnMessage("验签失败");
                scPay.setPayDate(new Date());
                scPayService.save(scPay);
            }
        }
        return "redirect:/a/pay/doPay/closePage";
    }

    private String doPay(ScPay scPay) {
        //        request.getParameter("")
        AlipayClient alipayClient = new DefaultAlipayClient(AlipayConfig.URL, AlipayConfig.APPID, AlipayConfig.RSA_PRIVATE_KEY, AlipayConfig.FORMAT, AlipayConfig.CHARSET, AlipayConfig.ALIPAY_PUBLIC_KEY, AlipayConfig.SIGNTYPE); //获得初始化的AlipayClient

        AlipayTradePagePayRequest alipayRequest = new AlipayTradePagePayRequest();//创建API对应的request

//      在公共参数中设置回跳和通知地址
        alipayRequest.setReturnUrl(AlipayConfig.RETURN_URL);
//        alipayRequest.setNotifyUrl(NOTIFY_URL);

        alipayRequest.setBizContent("{" +
                //商户订单号，商户网站订单系统中唯一订单号，必填
                "    \"out_trade_no\":\"" + scPay.getTradeNo() + "\"," +
                "   \"product_code\":\"FAST_INSTANT_TRADE_PAY\"," +
                //付款金额，必填
                "    \"total_amount\":" + scPay.getMoney() + "," +
                //订单名称，必填
                "    \"subject\":\"" + scPay.getSubject() + "\"" +
                //商品描述，可空
//                "    \"body\":\"" + scPay.getBody() + "\"" +
                "  }");//填充业务参数


        String form = "";
        try {
            AlipayTradePagePayResponse response = alipayClient.pageExecute(alipayRequest);//,"GET");
//            if (response.isSuccess()) {
//               form += "<h1>成功！！！</h1>";
//            }else{
//                form += "<h1>失败！！！</h1>";
//            }
            form += response.getBody(); //调用SDK生成表单

//            System.out.println(form);
            logger.info("=======================================");
            logger.info(form);
            // 剔除 自动提交
//            form = form.replace("<script>document.forms[0].submit();</script>","<button onclick='document.forms[0].submit();'>去支付</button>");
        } catch (AlipayApiException e) {
            e.printStackTrace();
            form += e.getErrMsg();
        }
        return form;
    }

    @RequestMapping(value = "checkPayed")
    @ResponseBody
    public boolean checkPayed(HttpServletRequest request, HttpServletResponse response, Model model) throws ServletException, IOException, AlipayApiException {
        boolean isActivation = false;
        boolean admin = UserUtils.getUser().isAdmin();
        if (!admin) { // 管理员用来管理客户的账号、付款信息
            // 所属加工厂
            Office officeDirectly = UserUtils.getOfficeDirectly();
            ScPay scPayParam = new ScPay();
            scPayParam.setOffice(officeDirectly);
            model.addAttribute("scPay", scPayParam);
            List<ScPay> allList = scPayService.findList(scPayParam);
//            ScPay scPay = null;
            for (ScPay pay : allList) {
                Integer returnSuccess = pay.getReturnSuccess();
                if (null != returnSuccess && (returnSuccess == 1 || returnSuccess == 3)) { // 非支付成功的那些数据属于垃圾数据，予以删除
//                    model.addAttribute("scPay", pay);
                    Date endDate = pay.getEndDate();
                    if (null != endDate && endDate.getTime() > System.currentTimeMillis()) {
                        isActivation = true;
                    }
//                    scPay = pay;
                }
            }
        }
        return isActivation;
    }

    @RequestMapping(value = "closePage")
    public String closePage(HttpServletRequest request, HttpServletResponse response, Model model) {
        return "modules/pay/closePage";
    }

}