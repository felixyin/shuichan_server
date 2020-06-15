<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>电脑网站支付return_url</title>
</head>
<c:choose>
    <c:when test="${success}">
        <h2>支付失败！</h2>
        <br/>
        ${message}
    </c:when>
    <c:otherwise>
        <h2>支付成功！</h2>
        <ul style="list-style: none;">
            <li>商户订单号：${out_trade_no}</li>
            <li>支付宝交易号：${trade_no}</li>
            <li>付款金额：${total_amount}</li>
        </ul>
    </c:otherwise>
</c:choose>
<body>
</body>
</html>