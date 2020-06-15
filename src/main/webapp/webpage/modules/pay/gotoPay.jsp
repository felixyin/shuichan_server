<%--
  Created by IntelliJ IDEA.
  User: fy
  Date: 2019/10/19
  Time: 2:01 下午
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="ctx" value="${pageContext.request.contextPath}${fns:getAdminPath()}"/>
<c:set var="ctxStatic" value="${pageContext.request.contextPath}/static"/>
<html>
<head>
    <title>产品套餐</title>
    <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.min.css'>
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/pay/css/bootstrap-grid.min.css"/>
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/pay/css/htmleaf-demo.css">
    <!--[if IE]>
    <script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <![endif]-->
    <script src="${ctxStatic}/plugin/jquery/jquery-3.3.1.min.js"></script>
    <script>
        var flush = '${flush}';
        if (flush === '1') {
            window.jsObj.goToPay('${username}', '${password}');
            var cc = setInterval(function () {
                $.post('${ctx}/pay/doPay/checkPayed', {}, function (result) {
                    if (result) { // 支付成功
                        clearInterval(cc);
                        alert('您已支付成功！');
                        window.location.href = '${ctx}';
                    }
                });
            }, 1000);
        }
    </script>
</head>
<body>
<div class="htmleaf-container">
    <header class="htmleaf-header">
        <h3>请选择套餐，售前电话： ‭185 6150 6161（魏经理）</h3>
        <%--        <div class="htmleaf-links">--%>
        <%--            <a class="htmleaf-icon icon-htmleaf-home-outline" href="http://www.22vd.com/" title="创客云"--%>
        <%--               target="_blank"><span>创客云</span></a>--%>
        <%--            <a class="htmleaf-icon icon-htmleaf-arrow-forward-outline" href="https://www.22vd.com/43821.html"--%>
        <%--               title="返回下载" target="_blank"><span>返回下载</span></a>--%>
        <%--        </div>--%>
    </header>
    <div class="demo">
        <div class="container">
            <div class="row">
                <form:form id="inputForm" modelAttribute="scPay" action="${ctx}/pay/doPay/aliPay" method="post"
                           class="form-horizontal" cssStyle="display: none;">
                    <form:input id="subject" path="subject" value=""></form:input>
                    <form:input id="body" path="body" value=""></form:input>
                    <form:input id="payModel" path="payModel" value="1"></form:input>
                    <form:input id="payType" path="payType" value="1"></form:input>
                    <form:input id="money" path="money" value="100"></form:input>
                    <input type="submit" id="submitBtn">
                </form:form>
                <div class="col-md-3 col-sm-3">
                    <div class="pricingTable">
                        <div class="pricingTable-header">
                            <i class="fa fa-adjust"></i>
                            <div class="price-value"> ￥<span class="pirce">0.00</span><span class="month">15天</span>
                            </div>
                            <span class="pay-model" style="display: none">1</span>
                        </div>
                        <h3 class="heading">免费试用</h3>
                        <div class="pricing-content">
                            <ul id="payModelBody1">
                                <li><b>无限制 </b>管理端软件</li>
                                <li><b>无限制 </b>包装员端APP</li>
                                <li><b>无限制 </b>快递员端APP</li>
                                <li><b>10个</b>员工账号数量</li>
                                <li><b>收费 </b>技术支持</li>
                            </ul>
                        </div>
                        <div class="pricingTable-signup">
                            <c:choose>
                                <c:when test="${scPay.payModel==1 }">
                                    <c:choose>
                                        <c:when test="${activation}">
                                            <span>试用中</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span>试用过期</span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <a href="javascript:void(0);">试用</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-sm-3">
                    <div class="pricingTable green">
                        <div class="pricingTable-header">
                            <i class="fa fa-adjust"></i>
                            <div class="price-value"> ￥<span class="pirce">500.00</span><span class="month">每月</span>
                            </div>
                            <span class="pay-model" style="display: none">2</span>
                        </div>
                        <h3 class="heading">月套餐</h3>
                        <div class="pricing-content">
                            <ul>
                                <li><b>无限制 </b>管理端软件</li>
                                <li><b>无限制 </b>包装员端APP</li>
                                <li><b>无限制 </b>快递员端APP</li>
                                <li><b>20个</b>员工账号数量</li>
                                <li><b>免费 </b>技术支持</li>
                            </ul>
                        </div>
                        <div class="pricingTable-signup">
                            <c:choose>
                                <c:when test="${scPay.payModel==2 && activation}">
                                    <span>您已购买</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="javascript:void(0);">购买</a>
                                </c:otherwise>
                            </c:choose>
                        </div
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-3">
                <div class="pricingTable green">
                    <div class="pricingTable-header">
                        <i class="fa fa-adjust"></i>
                        <div class="price-value"> ￥<span class="pirce">1300.00</span><span class="month">每季度</span>
                        </div>
                        <span class="pay-model" style="display: none">3</span>
                    </div>
                    <h3 class="heading">季度套餐</h3>
                    <div class="pricing-content">
                        <ul>
                            <li><b>无限制 </b>管理端软件</li>
                            <li><b>无限制 </b>包装员端APP</li>
                            <li><b>无限制 </b>快递员端APP</li>
                            <li><b>50个</b>员工账号数量</li>
                            <li><b>免费 </b>电话技术支持</li>
                        </ul>
                    </div>
                    <div class="pricingTable-signup">
                        <c:choose>
                            <c:when test="${scPay.payModel==3 && activation}">
                                <span>您已购买</span>
                            </c:when>
                            <c:otherwise>
                                <a href="javascript:void(0);">购买</a>
                            </c:otherwise>
                        </c:choose>
                    </div
                </div>
            </div>
        </div>

        <div class="col-md-3 col-sm-3">
            <div class="pricingTable blue">
                <div class="pricingTable-header">
                    <i class="fa fa-adjust"></i>
                    <div class="price-value"> ￥<span class="pirce">4800.00</span><span class="month">每年</span>
                    </div>
                    <span class="pay-model" style="display: none">4</span>
                </div>
                <h3 class="heading">年度套餐</h3>
                <div class="pricing-content">
                    <ul>
                        <li><b>无限制 </b>管理端软件</li>
                        <li><b>无限制 </b>包装员端APP</li>
                        <li><b>无限制 </b>快递员端APP</li>
                        <li><b>100个 </b>员工账号数量</li>
                        <li><b>免费 </b>电话技术支持</li>
                        <li><b>免费 </b>2次现场技术支持</li>
                    </ul>
                </div>
                <div class="pricingTable-signup">
                    <c:choose>
                        <c:when test="${scPay.payModel==4 && activation}">
                            <span>您已购买</span>
                        </c:when>
                        <c:otherwise>
                            <a href="javascript:void(0);">购买</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

<%--        <div class="col-md-3 col-sm-3">--%>
<%--            <div class="pricingTable red">--%>
<%--                <div class="pricingTable-header">--%>
<%--                    <i class="fa fa-adjust"></i>--%>
<%--                    <div class="price-value"> ￥<span class="pirce">9000.00</span><span class="month">永久使用</span>--%>
<%--                    </div>--%>
<%--                    <span class="pay-model" style="display: none">4</span>--%>
<%--                </div>--%>
<%--                <h3 class="heading">高级会员</h3>--%>
<%--                <div class="pricing-content">--%>
<%--                    <ul>--%>
<%--                        <li><b>无限制 </b>管理端软件</li>--%>
<%--                        <li><b>无限制 </b>包装员端APP</li>--%>
<%--                        <li><b>无限制 </b>快递员端APP</li>--%>
<%--                        <li><b>200个 </b>员工账号数量</li>--%>
<%--                        <li><b>免费 </b>电话技术支持</li>--%>
<%--                        <li><b>免费 </b>现场技术支持</li>--%>
<%--                        <li><b>可以 </b>线下签订合同</li>--%>
<%--                    </ul>--%>
<%--                </div>--%>
<%--                <div class="pricingTable-signup">--%>
<%--                    <c:choose>--%>
<%--                        <c:when test="${scPay.payModel==4 && activation}">--%>
<%--                            <span>您已购买</span>--%>
<%--                        </c:when>--%>
<%--                        <c:otherwise>--%>
<%--                            <a href="javascript:void(0);">购买</a>--%>
<%--                        </c:otherwise>--%>
<%--                    </c:choose>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
        <%--
         <div class="col-md-3 col-sm-6">
             <div class="pricingTable green">
                 <div class="pricingTable-header">
                     <i class="fa fa-adjust"></i>
                     <div class="price-value"> ￥80000.00 <span class="month">支持二次售卖</span></div>
                 </div>
                 <h3 class="heading">特级会员</h3>
                 <div class="pricing-content">
                     <ul>
                         <li><b>无限制 </b>管理端软件</li>
                         <li><b>无限制 </b>包装员端APP</li>
                         <li><b>无限制 </b>快递员端APP</li>
                         <li><b>无限制 </b>员工账号数量</li>
                         <li><b>免费 </b>电话技术支持</li>
                         <li><b>免费 </b>现场技术支持</li>
                         <li><b>独立 </b>部署服务器</li>
                         <li><b>独立 </b>上架应用市场</li>
                         <li><b>提供 </b>二次开发服务</li>
                         <li><b>全部 </b>管理员账号权限</li>
                         <li><b>SASS模式 </b>支持二次售卖</li>
                     </ul>
                 </div>
                 <div class="pricingTable-signup">
                     <a href="#">购买</a>
                     &lt;%&ndash;                            <span>您已购买，还有x天到期</span>&ndash;%&gt;
                 </div>
             </div>
         </div>
         --%>
    </div>
</div>
</div>
</div>
<script type="text/javascript">
    $(function () {
        $('.pricingTable-signup').find('a').click(function () {
            var $parent = $(this).parents('.pricingTable');
            var body = $parent.find('ul>li').map(function () {
                return $(this).text();
            }).get().join(', ');
            var subject = $parent.find('.heading').text();
            var money = $parent.find('.pirce').text();
            var payModel = $parent.find('.pay-model').text();

            $('#subject').val(subject);
            $('#body').val(body);
            $('#payModel').val(payModel);
            $('#money').val(money);
            $('#payType').val(2); // 支付宝支付类型
            if (flush === '1') { // 打开系统默认浏览器，去支付
                window.jsObj.goToPay('${username}', '${password}');
                setInterval(function () {
                    $.post('${ctx}/pay/doPay/checkPayed', {}, function (result) {
                        if (result) { // 支付成功
                            window.location.href = '${ctx}';
                            alert('您已支付成功！');
                        }
                    });
                }, 1000);
            } else {
                if (money == 0) {
                    $('#inputForm').attr('action',"${ctx}/pay/doPay/trial")
                }
                $('#submitBtn').trigger('click');
            }
        });
    });
</script>
</body>
</html>
