<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>
<c:choose>
    <c:when test="${success}">
        <h2>支付失败！</h2>
        <br/>
        ${message}
    </c:when>
    <c:otherwise>
        <h2>支付成功！</h2>
        <ul style="list-style: none;">
            <li>商户订单号：${body}</li>
        </ul>
    </c:otherwise>
</c:choose>