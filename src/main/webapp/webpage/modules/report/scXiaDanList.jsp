<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<html>
<head>
    <title>订单管理</title>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8">
    <meta name="decorator" content="ani"/>
    <%@include file="/webpage/include/bootstraptable.jsp" %>
    <%@include file="/webpage/include/treeview.jsp" %>
    <style>
         .width-label{
            width: 15%;
        }
        .width-vlaue{
           width: 20%;
        }
           /*子列表 相对于 父列表缩进，显示出层级*/
        .tabs-container {
            margin-left: 50px !important;
        }   /*子列表 相对于 父列表缩进，显示出层级*/
        .tabs-container {
            margin-left: 50px !important;
        }/* 设置 包装箱、每箱 这个tab按钮，更加小巧*/
        .nav-tabs>li{
            padding-top: 0;
        }
         .nav-tabs>li> a {
             height: 30px;
             line-height: 30px;
             padding-top: 0 !important;
             padding-bottom: 0;
         }
    </style>
</head>
<body>
<div class="wrapper wrapper-content">
    <div class="panel panel-primary">
        <div class="panel-body">
            <!-- 搜索 -->
            <div id="search-collapse" class="collapse">
                <div class="accordion-inner">
                    <form:form id="searchForm" class="form clearfix">
                        <table class="table table-bordered" style="margin-bottom: 0;">
                            <tbody>
                            <tr>
                                <td class="width-label active" >
                                    <label for="agentName" class="pull-right" title="代理人：">代理人：</label>
                                </td>
                                <td class="width-value">
                                    <input name="agentName" type="text" id="agentName" maxlength="64" class=" form-control"/>
                                </td>
                                <td class="width-label active"><label class="pull-right">下单日期：</label></td>
                                <td class="width-value" colspan="3">
                                    <div class="col-xs-12 col-sm-5" style="padding-left: 0px;">
                                        <div class='input-group date' id='beginDate'>
                                            <input type='text' name="beginDate" id="beginDate_laji"
                                                   class="form-control" />
                                            <span class="input-group-addon">
					                       <span class="glyphicon glyphicon-calendar"></span>
					                   </span>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-1 text-center">
                                        ~
                                    </div>
                                    <div class="col-xs-12 col-sm-5">
                                        <div class='input-group date' id='endDate'>
                                            <input type='text' name="endDate" id="endDate_laji"
                                                   class="form-control"/>
                                            <span class="input-group-addon">
					                       <span class="glyphicon glyphicon-calendar"></span>
					                   </span>
                                        </div>
                                    </div>
                                </td>
                            </tr>

                            <tr>
                                <td class="width-label active">
                                    <label for="specName" class="pull-right" title="规格：">规格：</label>
                                </td>
                                <td class="width-value">
                                    <input name="specName" type="text" id="specName" maxlength="64" class=" form-control"/>
                                </td>
                                <td class="width-label active" colspan="4">
                                    <center>
                                        <a id="search" class="btn btn-primary btn-rounded  btn-bordered btn-sm"><i
                                                class="fa fa-search"></i>
                                            &nbsp;&nbsp;查&nbsp;&nbsp;&nbsp;&nbsp;询&nbsp;&nbsp;&nbsp;</a>&nbsp;&nbsp;&nbsp;
                                        <a id="reset" class="btn btn-warning btn-rounded  btn-bordered btn-sm"><i
                                                class="fa fa-refresh"></i> 重置</a>
                                        <a id="switchDetail" class="btn btn-success btn-rounded  btn-bordered btn-sm"><i
                                                class="fa fa-print"></i> 展开/合起</a>
                                        <a id="printPdf" class="btn btn-success btn-rounded  btn-bordered btn-sm"><i
                                                class="fa fa-print"></i> 导出PDF</a>
                                    </center>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </form:form>
                </div>
            </div>

            <!-- 工具栏 -->
            <div id="toolbar">
            </div>

            <!-- 表格 -->
            <table id="scOrderTable" data-toolbar="#toolbar"></table>

        </div>
    </div>
</div>
<%@include file="scXiaDanList_js.jsp" %>
<%@include file="../order/print/printBoxOrderSetting_js.jsp" %>
<%@include file="./print/printPdf_js.jsp" %>
</body>
</html>