<%--
  Created by IntelliJ IDEA.
  User: fy
  Date: 2019-08-10
  Time: 11:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=5.0,minimum-scale=0.2,user-scalable=yes">
    <%--    <meta name="decorator" content="blank"/>--%>
    <title>此件信息</title>
    <link rel="stylesheet" href="${ctxStatic}/plugin/bootstrap-3.3.7/css/bootstrap.min.css"/>
    <style>
        @page {
            margin: 0 !important;
        }
        body{
            padding: 4px!important;
            margin: 4px 7px 4px 4px!important ;
        }
        .a4-endwise {
            padding: 5px 2px;
            width: 100%;
            <%--height: ${setting.pageHeight*1 + 850}px;--%>
            word-break: break-all;
            page-break-before: auto;
            page-break-after: always;
        }

        .print {
            position: fixed;
            top: 1%;
            right: 10%;
        }

        .table-bordered {
            border: 2px solid #b5b5b5;
            margin: 0 auto;
            /*width: 95%;*/
        }

        .th {
            width: 90px !important;
            text-align: right;
            font-weight: normal;
            /*height: 50px;*/
            min-height: 50px;
            /*line-height: 80px;*/
            vertical-align: middle !important;
            border: 2px solid #ddd !important;
        }

        tr {
            border: 2px solid #ddd !important;
        }

        *, span, div {
            font-size: 1em !important;
        }

        td {
            border: 2px solid #ddd !important;
            text-align: left;
            vertical-align: middle !important;
            padding: 2px 2px !important;
            font-size: 1em!important;
            line-height: 50px;
            letter-spacing:2px;
            /*word-break:keep-all;           !* 不换行 *!*/
            /*white-space:nowrap;          !* 不换行 *!*/
            overflow:hidden;               /* 内容超出宽度时隐藏超出部分的内容 */
            text-overflow:ellipsis;         /* 当对象内文本溢出时显示省略标记(...) ；需与overflow:hidden;一起使用。*/
        }

        .logo {
            width: 60px;
        }

        .head span {
            color: #787878 !important;
        }

        .receiver-class {
            /*height: 2.3em;*/
            /*word-wrap: break-word; word-break: normal;*/
            letter-spacing:normal;
            padding: 2px 2px!important;
            line-height: 1.2em!important;
            <%--font-size: ${setting.receiverFontsize}px !important;--%>
        <c:if test="${setting.receiverBold eq 'on'}"> font-weight: bold;
        </c:if>
        }

        .content {
            padding:0 0;
            /*      <c:if test="${setting.border eq '1'}"> border: 1px #000 solid;
        </c:if>*/
        }

        .remarks-position {
            width: 100%;
            margin-top: ${setting.remarksOffset * 10 + 90}px;
        }
    </style>
</head>
<body>

<%--
<a class="print" href="javascript:;" onclick="preview();">打印</a>
--%>

<c:choose>
    <c:when test="${empty boxItemList}">
        <h2 style="color: darkred;">您没有选择要打印的订单</h2>
    </c:when>
    <c:otherwise>
        <c:forEach items="${boxItemList}" var="bi">
            <%--startprint--%>
            <div class="container a4-endwise">
<%--                <c:if test="${setting.tableHead eq '1'}">--%>
                    <div class="head">
                            <%--                        <img src="${ctxStatic}/common/images/logo.jpg" class="logo"/>--%>
<%--                        <span>--%>
<%--                                ${bi.box.order.factory.name}--%>
<%--                        </span>--%>
                        <span style="float:right;font-size: 25px;">
                            <fmt:formatDate value="${bi.box.order.createDate}" pattern="yyyy-MM-dd"/>
                        </span>
                    </div>
                    <div style="border-top:1px #000 solid;margin-top: 20px;"></div>
<%--                </c:if>--%>
                <center>
                    <h1>装&nbsp;&nbsp;&nbsp;&nbsp;箱&nbsp&nbsp;&nbsp;&nbsp;单</h1>
                </center>
                <table class="table table-bordered">
                    <tbody>
                    <tr>
                        <th class="th">编号</th>
                        <td colspan="2">${bi.serialNum}</td>
                    </tr>
                    <tr>
                        <th class="th">收件信息</th>
                        <td colspan="2" class="receiver-class">
                                ${bi.box.order.custom.address}
                                    <br>
                                ${bi.box.order.custom.username}
                        </td>
                    </tr>
                    <tr>
                        <th class="th">收件电话</th>
                        <td>${bi.box.order.custom.phone} </td>
                    </tr>
<%--                    <tr>--%>
<%--                        <th class="th">生产时间</th>--%>
<%--                        <td> ${fns:formatDateTime(bi.productionDate)}</td>--%>
<%--                    </tr>--%>
<%--                    <tr>--%>
<%--                        <th class="th">包装时间</th>--%>
<%--                        <td> ${fns:formatDateTime(bi.packageDate)}</td>--%>
<%--                    </tr>--%>
<%--                    <tr>--%>
<%--                        <th class="th">取件时间</th>--%>
<%--                        <td> ${fns:formatDateTime(bi.logisticsDate)}</td>--%>
<%--                    </tr>--%>
<%--                    <tr>--%>
<%--                        <th class="th">状态</th>--%>
<%--                        <td> ${fns:getDictLabel(bi.process,'process_box_item','')}</td>--%>
<%--                    </tr>--%>
                    <tr>
                        <th class="th">规格</th>
                        <td> ${bi.box.production.name}</td>
                    </tr>
                    <c:set value="0" var="sum"/>
                    <c:choose>
                        <c:when test="${setting.jin eq '1'}">
                            <tr>
                                <th class="th">斤数</th>
                                <td>${bi.box.weight}斤</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:set value="${sum + 1}" var="sum"/>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${setting.count eq '1'}">
                            <tr>
                                <th class="th">箱号</th>
                                <td>第${bi.few}箱/总计${bi.box.count}箱</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:set value="${sum + 1}" var="sum"/>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${setting.logistics== '1'}">
                            <tr>
                                <th class="th">物流</th>
                                <td>${bi.box.order.realLogistics.name}</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:set value="${sum + 1}" var="sum"/>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${setting.shift== '1'}">
                            <tr>
                                <th class="th">班次</th>
                                <td>${fns:getDictLabel(bi.box.order.shift, "logistics_shift", "无")}</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:set value="${sum + 1}" var="sum"/>

                        </c:otherwise>
                    </c:choose>
                    <c:forEach begin="1" end="${sum}">
                        <tr>
                            <th class="th">&nbsp;</th>
                            <td></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

<%--                <div class="remarks-position">--%>
<%--                    <center>--%>
<%--                        <h2>备注</h2>--%>
<%--                        <span style="font-size: 35px;">${bi.box.remarks}</span>--%>
<%--                    </center>--%>
<%--                </div>--%>
                    <%--                    <p>--%>
                    <%--                        装箱单号： 201908111111<br/>--%>
                    <%--                        序号： ${box.id}<br>--%>
                    <%--                        规格： ${box.spec} <br>--%>
                    <%--                        重量： ${box.weight} <br>--%>
                    <%--                        数量： ${box.count} <br>--%>
                    <%--                        调拨工厂： ${box.allotFactory.name} <br>--%>
                    <%--                    <hr>--%>
                    <%--                    代理人：${op.agentName} <br>--%>
                    <%--                    客户姓名：${op.custom.username} <br>--%>
                    <%--                    客户手机：${op.custom.phone} <br>--%>
                    <%--                    客户地址：${op.custom.address} <br>--%>
                    <%--                    物流公司名称：${op.logistics.name} <br>--%>
                    <%--                    物流班次：${op.shift} <br>--%>
                    <%--                    所属工厂：${op.factory.name} <br>--%>
                    <%--                    订单状态：${op.status} <br>--%>
                    <%--                    <hr>--%>
            </div>
            <%--endprint--%>
        </c:forEach>
    </c:otherwise>
</c:choose>

</body>
</html>
