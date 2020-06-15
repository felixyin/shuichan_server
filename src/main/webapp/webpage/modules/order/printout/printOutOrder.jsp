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
    <%--    <link rel="stylesheet" href="${ctxStatic}/plugin/bootstrap-3.3.7/css/bootstrap.min.css"/>--%>
    <style>
        body {
            width: 1070px;
            overflow: auto!important;
        }

        .a4-endwise {
            /*padding: 50px 50px;*/
            width: 1065px;
            height: 1567px;
            word-break: break-all;
        }

        .a4-broadwise {
            width: 1565px;
            height: 1073px;
            border: 1px #000 solid;
            overflow: hidden;
            padding: 0;
            word-break: break-all;
        }

        .container {
            /*padding: 50px 50px;*/
        }

        .print {
            position: fixed;
            top: 1%;
            right: 10%;
        }
    </style>
    <meta name="decorator" content="ani"/>
    <%@ include file="/webpage/include/bootstraptable.jsp" %>
    <%@include file="/webpage/include/treeview.jsp" %>
    <%@include file="printOutOrder_js.jsp" %>
    <script src="${ctxStatic}/common/js/scangun.js"></script>
</head>
<body>
<!-- 表格 -->
<table id="scOrderImportTable" class="text-nowrap" data-toolbar="#toolbar"></table>

<%--
<a class="print" href="javascript:;" onclick="preview();">打印</a>
--%>

<div class=" a4-endwise">
    <div class="content">


        <center>
            <span style="font-size: 45px!important;">出&nbsp;&nbsp;&nbsp;&nbsp;货&nbsp&nbsp;&nbsp;&nbsp;单</span>
        </center>
        <br>
        <div class="head text-center">
            <c:if test="${setting.logistics eq '1'}">
                <span style="font-size: 25px;">
                    物流公司：<span contenteditable="true" title="点击可编辑">${shouldLogistics}</span>
                </span>
            </c:if>
            <c:if test="${setting.shift eq '1'}">
                <span style="margin-left:50px;font-size: 25px;">
                        物流班次：${fns:getDictLabel(shift,'logistics_shift','全部')}
                </span>
            </c:if>
            <span style="margin-left:50px;font-size: 25px;">
                        打印时间：${nowDate}
            </span>
        </div>
        <br>
        <!-- 表格 -->
        <div style="padding-left: 10px;padding-right: 40px!important;">
            <table id="outOrderTable" class="text-nowrap" ></table>
        </div>

        <br>
        <div style="border-top:1px #000 dashed ;margin-top: 20px;"></div>
        <div>
            <center>
                <h3>快递签收处</h3>
            </center>
            <h4 style="margin-left: 700px;">快递员签字：</h4>
            <h4 style="margin-left: 700px;">签收日期：</h4>
        </div>
    </div>
</div>

<script>
    function executePrint() {
        window.print();
    }
</script>
</body>
</html>
