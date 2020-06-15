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
        /*子列表 相对于 父列表缩进，显示出层级*/
        .tabs-container {
            margin-left: 50px !important;
        }

        /* 设置 包装箱、每箱 这个tab按钮，更加小巧*/
        .active {
            padding-top: 0;
        }

        .active > a {
            height: 30px;
            line-height: 30px;
            padding-top: 4px !important;
            padding-bottom: 0;
        }

        /*去掉表格边框*/
        .fixed-table-container {
            border: 0 !important;
        }

        /*解决横向滚动条阻挡内容问题*/
        .fixed-table-body {
            padding-bottom: 14px !important;
        }

        /* Fixme 限制表格表头的高度*/
        .bootstrap-table .table thead > tr, .bootstrap-table .table thead > tr > th {
            height: 30px;
            max-height: 30px;
        }

        /* 去掉iframe页面内部的边框，不显示滚动条*/
        .wrapper-content {
            padding: 0 !important;
            overflow: hidden;
        }

        /*表单label宽度设置*/
        .width-label {
            width: 9%;
        }

        /*表单input的宽度设置 */
        .width-value {
            width: 12%;
        }

        /*下移工具栏显示位置*/
        #toolbar {
            padding-top: 10px !important;
        }

        /* 分页底部条*/
        .pagination-detail {
            margin-top: 0 !important;
            margin-bottom: 0 !important;
        }

        .form-control {
            height: 30px !important;
        }

        /* 查询表单 表格样式优化 */
        #searchForm .table td {
            vertical-align: middle !important;
            padding-top: 6px;
            padding-bottom: 5px;
        }

        /*每箱列表 表头增加补白*/
        .table-boxitem > thead > tr > th {
            padding-left: 10px !important;
            padding-bottom: 4px !important;
        }

        /**
        解决表头和内容不能对齐问题
         */
        .fht-cell:first-child {
            width: 19px !important;
        }

        .pagination-info{width: 0!important;}
    </style>
    <link href="${ctxs}/static/plugin/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet">
    <script src="${ctxs}/static/plugin/bootstrap-table/bootstrap-table.js"></script>
    <script src="${ctxs}/static/plugin/bootstrap-table/locale/bootstrap-table-zh-CN.js"></script>
    <script src="${ctxs}/static/plugin/bootstrap-table/extensions/export/bootstrap-table-export.js"></script>
    <script src="${ctxs}/static/plugin/bootstrapTable/tableExport.js"></script>
    <script src="${ctxs}/static/plugin/bootstrapTable/bootstrap-table-contextmenu.js"></script>
    <script src="${ctxs}/static/plugin/bootstrap-table/extensions/editable/bootstrap-table-editable.js"></script>
    <script src="${ctxs}/static/plugin/bootstrap3-editable/js/bootstrap-editable.js"></script>
</head>
<body style="overflow: hidden;">
<div class="wrapper wrapper-content">
    <div class="panel panel-primary">
        <%--        <div class="panel-heading">--%>
        <%--            <h3 class="panel-title">订单列表</h3>--%>
        <%--        </div>--%>
        <div class="panel-body" style="padding: 5px;">
            <!-- 搜索 -->
            <div id="search-collapse" style="margin-bottom: 2px;margin-top: 5px;">
                <form:form id="searchForm" modelAttribute="scOrder" class="form clearfix">
                    <table class="table table-bordered" style="margin-bottom: 0;">
                        <tbody>
                        <tr>
                            <td class="width-label active"><label class="pull-right">客户：</label></td>
                            <td class="width-value">
                                <form:input path="custom.username" htmlEscape="false" maxlength="64"
                                            class=" form-control"/>
                            </td>
                            <td class="width-label active"><label class="pull-right">电话：</label></td>
                            <td class="width-value">
                                <form:input path="custom.phone" htmlEscape="false" maxlength="64"
                                            class=" form-control"/>
                            </td>
                            <td class="width-label active"><label class="pull-right">代理人：</label></td>
                            <td class="width-value">
                                <form:input path="agentName" htmlEscape="false" maxlength="64" class=" form-control"/>
                            </td>
                            <td class="width-label active"><label class="pull-right">指定物流：</label></td>
                            <td class="width-value">
                                <form:input path="shouldLogistics.name" id="shouldLogistics" htmlEscape="false"
                                            maxlength="64"
                                            class=" form-control"/>
                            </td>

                        </tr>
                        <tr>
<%--                            <td class="width-label active"><label class="pull-right">实取物流：</label></td>--%>
<%--                            <td class="width-value">--%>
<%--                                <form:input path="realLogistics.name" htmlEscape="false" maxlength="64"--%>
<%--                                            class=" form-control"/>--%>
<%--                            </td>--%>
                            <td class="width-label active"><label class="pull-right">班次：</label></td>
                            <td class="width-value">
                                <form:select path="shift" id="shift" class="form-control m-b">
                                    <form:option value="" label=""/>
                                    <form:options items="${fns:getDictList('logistics_shift')}" itemLabel="label"
                                                  itemValue="value" htmlEscape="false"/>
                                </form:select>
                            </td>
                            <td class="width-label active"><label class="pull-right">下单日期：</label></td>
                            <td class="width-value" colspan="3">
                                <div class="col-xs-12 col-sm-5" style="padding-left: 0px;">
                                    <div class='input-group date' id='beginCreateDate'>
                                        <input type='text' name="beginCreateDate" id="beginCreateDate_laji"
                                               class="form-control" value="${beginCreateDate}"/>
                                        <span class="input-group-addon">
					                       <span class="glyphicon glyphicon-calendar"></span>
					                   </span>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-1 text-center">
                                    ~
                                </div>
                                <div class="col-xs-12 col-sm-5">
                                    <div class='input-group date' id='endCreateDate'>
                                        <input type='text' name="endCreateDate" id="endCreateDate_laji"
                                               class="form-control"/>
                                        <span class="input-group-addon">
					                       <span class="glyphicon glyphicon-calendar"></span>
					                   </span>
                                    </div>
                                </div>
                            </td>
    <td class="width-label active"><label class="pull-right">状态：</label></td>
    <td class="width-value">
        <form:select path="status" class="form-control m-b" id="status">
            <form:option value="" label=""/>
            <form:options items="${fns:getDictList('status_order')}" itemLabel="label"
                          itemValue="value" htmlEscape="false"/>
        </form:select>
    </td>
                        </tr>
                        <tr>


                            <td class="width-label active"><label class="pull-right">订单备注：</label></td>
                            <td class="width-value">
                                <form:input path="remarks" htmlEscape="false" maxlength="64" class=" form-control"/>
                            </td>
                            <td class="width-label active" colspan="6">
                                <center>
                                    <a id="search" class="btn btn-primary btn-rounded  btn-bordered btn-sm"><i
                                            class="fa fa-search"></i>
                                        &nbsp;&nbsp;查&nbsp;&nbsp;&nbsp;&nbsp;询&nbsp;&nbsp;&nbsp;</a>&nbsp;&nbsp;&nbsp;
                                    <a id="reset" class="btn btn-warning btn-rounded  btn-bordered btn-sm"><i
                                            class="fa fa-refresh"></i> 重置</a>
                                    <a id="switchDetail" class="btn btn-success btn-rounded  btn-bordered btn-sm"><i
                                            class="fa fa-print"></i> 展开/合起</a>
                                        <%--                  <a id="printPdf" class="btn btn-success btn-rounded  btn-bordered btn-sm"><i
                                                                 class="fa fa-print"></i> 导出PDF</a>--%>
                                </center>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </form:form>
            </div>

            <!-- 工具栏 -->
            <div id="toolbar">
                <shiro:hasPermission name="order:scOrder:add">
                    <button id="add" class="btn btn-primary" onclick="add()">
                        <i class="glyphicon glyphicon-plus"></i> 新建
                    </button>
                </shiro:hasPermission>
                <shiro:hasPermission name="order:scOrder:edit">
                    <button id="edit" class="btn btn-success" disabled onclick="edit()">
                        <i class="glyphicon glyphicon-edit"></i> 修改
                    </button>
                </shiro:hasPermission>
                <shiro:hasPermission name="order:scOrder:del">
                    <button id="remove" class="btn btn-danger" disabled onclick="deleteAll()">
                        <i class="glyphicon glyphicon-remove"></i> 删除
                    </button>
                </shiro:hasPermission>
                <shiro:hasPermission name="order:scOrder:import">
                    <button id="btnImport" class="btn btn-info"><i class="fa fa-folder-open-o"></i> 导入</button>
                </shiro:hasPermission>
                <%--                <shiro:hasPermission name="order:scOrder:export">--%>
                <%--                    <button id="export" class="btn btn-warning">--%>
                <%--                        <i class="fa fa-file-excel-o"></i> 导出--%>
                <%--                    </button>--%>
                <%--                </shiro:hasPermission>--%>
                <shiro:hasPermission name="order:scOrder:view">
                    <button id="view" class="btn btn-default" disabled onclick="view()">
                        <i class="fa fa-search-plus"></i> 查看
                    </button>
                </shiro:hasPermission>
                <shiro:hasPermission name="order:scOrder:printBoxOrder">
                    <div class="btn-group">
                        <button type="button" class="btn btn-primary" onclick="printBoxOrder(1)">打印装箱单</button>
                        <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown"
                                aria-haspopup="true" aria-expanded="false">
                            <span class="caret"></span>
                            <span class="sr-only">Toggle Dropdown</span>
                        </button>
                        <ul class="dropdown-menu">
                            <li><a href="#" onclick="setPrintBoxOrder()">设置打印内容</a></li>
                                <%--                            <li role="separator" class="divider"></li>--%>
                        </ul>
                    </div>
                </shiro:hasPermission>
                <shiro:hasPermission name="order:scOrder:printOutOrder">
                    <div class="btn-group">
                        <button type="button" class="btn btn-primary" onclick="printOutOrder(1)">打印出货单</button>
                        <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown"
                                aria-haspopup="true" aria-expanded="false">
                            <span class="caret"></span>
                            <span class="sr-only">Toggle Dropdown</span>
                        </button>
                        <ul class="dropdown-menu">
                            <li><a href="#" onclick="setPrintOutOrder()">设置打印内容</a></li>
                                <%--                            <li role="separator" class="divider"></li>--%>
                        </ul>
                    </div>
                </shiro:hasPermission>
                <shiro:hasPermission name="order:scOrder:settingTable">
                    <button type="button" class="btn btn-danger" onclick="settingTable()">
                        设置
                    </button>
                </shiro:hasPermission>

            </div>
            <!-- 表格 -->
            <table id="scOrderTable" class="text-nowrap" data-toolbar="#toolbar"></table>

            <!-- context menu -->
            <ul id="context-menu" class="dropdown-menu">
                <shiro:hasPermission name="order:scOrder:view">
                    <li data-item="view"><a>查看</a></li>
                </shiro:hasPermission>
                <shiro:hasPermission name="order:scOrder:edit">
                    <li data-item="edit"><a>编辑</a></li>
                </shiro:hasPermission>
                <shiro:hasPermission name="order:scOrder:del">
                    <li data-item="delete"><a>删除</a></li>
                </shiro:hasPermission>
                <li data-item="action1"><a>取消</a></li>
            </ul>
        </div>
    </div>
</div>
<%@include file="scOrderList_js.jsp" %>
<%@include file="print/printBoxOrderSetting_js.jsp" %>
<%@include file="printout/printOutOrderSetting_js.jsp" %>
<%@include file="../report/print/printPdf_js.jsp" %>
<script>
    $(function () {
        // 解决列表内容和表头不对齐问题，解决横向滚动条不显示的问题
        var height2 = $(window).height();
        $('.fixed-table-container').css('height', (height2 - 195));
        $(window).resize(function () {
            var height = $(window).height();
            console.log(height);
            $('.fixed-table-container').css('height', (height - 195));
            // $('.pagination-detail').css('background-color','gray')
        });
    });
</script>
</body>
</html>