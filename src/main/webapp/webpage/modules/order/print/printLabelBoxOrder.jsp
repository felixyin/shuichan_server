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
    <meta name="viewport"
          content="width=device-width,initial-scale=1.0,maximum-scale=5.0,minimum-scale=0.2,user-scalable=yes">
    <%--    <meta name="decorator" content="blank"/>--%>
    <title>装箱单打印预览</title>
<%--    <%@ include file="/webpage/include/anihead.jsp"%>--%>
    <link rel="stylesheet" href="${ctxStatic}/plugin/bootstrap-3.3.7/css/bootstrap.min.css"/>
    <style>
        @page {
            margin: 0 !important;
        }
        body{
            padding: 0!important;
            margin: 0!important;
        }
        .a4-endwise {
            padding: 5px 2px;
            width: ${setting.pageWidth*1 + 440}px;
            height: ${setting.pageHeight*1 + 850}px;
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
            display: none;
            width: 90px !important;
            text-align: right;
            font-weight: normal;
            height: 50px;
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
            font-size: 1.8em!important;
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
            font-size: ${setting.receiverFontsize}px !important;
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
    <script src="${ctxStatic}/plugin/jquery/jquery-3.3.1.min.js"></script>
    <script src="${ctxStatic}/common/js/scangun.js"></script>
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
            <div class=" a4-endwise">
                <div class="content">
                    <c:if test="${setting.tableHead eq '1'}">
                        <div class="head">
                                <%--   <img src="${ctxStatic}/common/images/logo.jpg" class="logo"/>--%>
<%--                            <span>--%>
<%--                                    ${bi.box.order.factory.name}--%>
<%--                            </span>--%>
                            <span style="float:right;font-size: 25px;">
<%--                            <fmt:formatDate value="${bi.box.order.createDate}" pattern="yyyy-MM-dd"/>--%>
                                 ${bi.serialNum}
                        </span>
                        </div>
<%--                        <div style="border-top:1px #000 solid;margin-top: 8px;"></div>--%>
                    </c:if>
                   <%--
                    <div style="padding-top: 8px;">
                        编号：${bi.serialNum}
                    </div>--%>
                    <br>
                        <%--<center>
                            <span style="font-size: 45px!important;">装&nbsp;&nbsp;&nbsp;&nbsp;箱&nbsp&nbsp;&nbsp;&nbsp;单</span>
                        </center>--%>
<%--                    <br>--%>
                    <table class="table table-bordered">
                        <tbody>
                            <%-- <tr>
                                 <th class="th">编号&nbsp;</th>
                                 <td colspan="2">&nbsp;&nbsp;${bi.serialNum}</td>
                             </tr>--%>
                        <tr >
                            <th class="th">收件信息</th>
                            <td colspan="2" class="receiver-class">
                                <div style="font-size: 0.9em!important; margin-left: 20px!important;">
                                        ${bi.box.order.custom.address}
                                    <c:if test="${!(bi.box.order.custom.username eq '')}">
                                        &nbsp;${bi.box.order.custom.username}
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="th">收件电话&nbsp;</th>
                            <td colspan="2" style="font-weight: bold">&nbsp;&nbsp;${bi.box.order.custom.phone} </td>

                        </tr>
                        <tr>
                            <th class="th">规格&nbsp;</th>
                            <td style="font-weight: bold;letter-spacing:4px;"> &nbsp;&nbsp;${bi.box.production.name}</td>
                            <td rowspan="6" style="vertical-align:middle;text-align: center;width: 43%;">
                                    <%--                            <img style="width: 100%"--%>
                                    <%--                                 src="http://gongchang.qdbak.com${ctx}/tools/TwoDimensionCodeController/createTwoDimensionCodeStream.do?url=http://gongchang.qdbak.com${ctx}/order/scOrder/scanBoxOrder?boxId=${bi.id}&device=pc">--%>

                                <img style="width: 100%"
                                     src="http://${hostAndPort}${ctx}/tools/TwoDimensionCodeController/createTwoDimensionCodeStream2.do?url=http://${hostAndPort}${ctx}/order/scOrder/scanBoxOrder?boxItemId=${bi.id}&device=pc">
                                <script>
                                    console.log('http://${hostAndPort}${ctx}/order/scOrder/scanBoxOrder?boxItemId=${bi.id}&device=pc');
                                </script>
                            </td>
                        </tr>
                        <c:set value="0" var="sum"/>
                        <c:choose>
                            <c:when test="${setting.jin eq '1'}">
                                <tr>
                                    <th class="th">斤数&nbsp;</th>
                                    <td  style="font-weight: bold;letter-spacing:4px;">&nbsp;&nbsp;${bi.box.weight}斤</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:set value="${sum + 1}" var="sum"/>
                            </c:otherwise>
                        </c:choose>
                        <c:choose>
                            <c:when test="${setting.count eq '1'}">
                                <tr>
                                    <th class="th">箱号&nbsp;</th>
                                    <td>&nbsp;&nbsp;No.: ${bi.box.count}-${bi.few}</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:set value="${sum + 1}" var="sum"/>
                            </c:otherwise>
                        </c:choose>
                        <c:choose>
                            <c:when test="${setting.logistics== '1' and bi.box.order.shouldLogistics.name !=null}">
                                <tr>
                                    <th class="th">物流&nbsp;</th>
                                    <td>&nbsp;&nbsp;${bi.box.order.shouldLogistics.name}</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:set value="${sum + 1}" var="sum"/>
                            </c:otherwise>
                        </c:choose>
                        <c:choose>
                            <c:when test="${setting.shift== '1'}">
                                <tr>
                                    <th class="th">班次&nbsp;</th>
                                    <td>&nbsp;&nbsp;${fns:getDictLabel(bi.box.order.shift, "logistics_shift", "无")}</td>
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

                </div>
                <div class="remarks-position">
                    <center>
                        <h1>备注</h1>
                        <span style="font-size: ${setting.remarksFontsize}px!important;">${bi.box.remarks}</span>
                    </center>
                </div>
            </div>
            <%--endprint--%>
        </c:forEach>
    </c:otherwise>
</c:choose>

<script>
    function executePrint() {
        var ids = '${boxItemIdsStr}';
        if (ids) {
            $.post('http://${hostAndPort}${ctx}/order/scOrder/executePrintBoxOrder', {ids: ids}, function (result) {
               alert('已经成功保存打印人员和打印时间，请选择打印机后，点击『打印』按钮！');
                window.print();
            });
        } else {
            alert('出现问题导致无法打印，请联系管理员！');
        }
    }
</script>
</body>
</html>
