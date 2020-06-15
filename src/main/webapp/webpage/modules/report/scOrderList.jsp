<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<html>
<head>
    <title>订单管理</title>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8">
    <meta name="decorator" content="ani"/>
    <%@include file="/webpage/include/bootstraptable.jsp" %>
    <%@include file="/webpage/include/treeview.jsp" %>
</head>
<body>
<div class="wrapper wrapper-content">
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">统计分析</h3>
        </div>
        <div class="panel-body">
            <!-- 搜索 -->
            <div id="search-collapse" class="collapse">
                <div class="accordion-inner">
                    <form:form id="searchForm" modelAttribute="scOrder" class="form form-horizontal well clearfix">
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="代理人：">代理人：</label>
                            <form:input path="agentName" htmlEscape="false" maxlength="64"  class=" form-control"/>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="客户：">客户：</label>
                            <sys:gridselect url="${ctx}/custom/scCustom/data" id="custom" name="custom.id" value="${scOrder.custom.id}" labelName="custom.username" labelValue="${scOrder.custom.username}"
                                            title="选择客户" cssClass="form-control required" fieldLabels="姓名|电话|地址" fieldKeys="username|phone|address" searchLabels="姓名|电话|地址" searchKeys="username|phone|address" ></sys:gridselect>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="指定物流公司：">指定物流公司：</label>
                            <sys:treeselect id="shouldLogistics" name="shouldLogistics.id" value="${scOrder.shouldLogistics.id}" labelName="shouldLogistics.name" labelValue="${scOrder.shouldLogistics.name}"
                                            title="部门" url="/sys/office/treeData?type=2" cssClass="form-control" allowClear="true" notAllowSelectParent="true"/>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="物流班次：">物流班次：</label>
                            <form:select path="shift"  class="form-control m-b">
                                <form:option value="" label=""/>
                                <form:options items="${fns:getDictList('logistics_shift')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                            </form:select>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="所属加工厂：">所属加工厂：</label>
                            <sys:treeselect id="factory" name="factory.id" value="${scOrder.factory.id}" labelName="factory.name" labelValue="${scOrder.factory.name}"
                                            title="部门" url="/sys/office/treeData?type=2" cssClass="form-control" allowClear="true" notAllowSelectParent="true"/>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="实取物流公司：">实取物流公司：</label>
                            <sys:treeselect id="realLogistics" name="realLogistics.id" value="${scOrder.realLogistics.id}" labelName="realLogistics.name" labelValue="${scOrder.realLogistics.name}"
                                            title="部门" url="/sys/office/treeData?type=2" cssClass="form-control" allowClear="true" notAllowSelectParent="true"/>
                        </div>
<%--                        <div class="col-xs-12 col-sm-6 col-md-4">--%>
<%--                            <div class="form-group">--%>
<%--                                <label class="label-item single-overflow pull-left" title="要求发货时间：">&nbsp;要求发货时间：</label>--%>
<%--                                <div class="col-xs-12">--%>
<%--                                    <div class="col-xs-12 col-sm-5">--%>
<%--                                        <div class='input-group date' id='beginDeliverDate' style="left: -10px;" >--%>
<%--                                            <input type='text'  name="beginDeliverDate" class="form-control"  />--%>
<%--                                            <span class="input-group-addon">--%>
<%--					                       <span class="glyphicon glyphicon-calendar"></span>--%>
<%--					                   </span>--%>
<%--                                        </div>--%>
<%--                                    </div>--%>
<%--                                    <div class="col-xs-12 col-sm-1">--%>
<%--                                        ~--%>
<%--                                    </div>--%>
<%--                                    <div class="col-xs-12 col-sm-5">--%>
<%--                                        <div class='input-group date' id='endDeliverDate' style="left: -10px;" >--%>
<%--                                            <input type='text'  name="endDeliverDate" class="form-control" />--%>
<%--                                            <span class="input-group-addon">--%>
<%--					                       <span class="glyphicon glyphicon-calendar"></span>--%>
<%--					                   </span>--%>
<%--                                        </div>--%>
<%--                                    </div>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        --%>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <div class="form-group">
                                <label class="label-item single-overflow pull-left" title="要求发货时间：">统计日期：</label>
                                <div class="col-xs-12">
                                    <div class="col-xs-12 col-sm-12">
                                        <div class='input-group date' id='createDate' style="left: -10px;" >
                                            <input type='text'  name="createDate" class="form-control"  value="${scOrder.createDate}"/>
                                            <span class="input-group-addon">
					                       <span class="glyphicon glyphicon-calendar"></span>
					                   </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="明天未发作废：">明天未发作废：</label>
                            <form:select path="tomorrowCancellation"  class="form-control m-b">
                                <form:option value="" label=""/>
                                <form:options items="${fns:getDictList('tomorrow_cancellation')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                            </form:select>
                        </div>

                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="状态：">状态：</label>
                            <form:select path="status"  class="form-control m-b">
                                <form:option value="" label=""/>
                                <form:options items="${fns:getDictList('status_order')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                            </form:select>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="创建者：">创建者：</label>
                            <sys:userselect id="createBy" name="createBy.id" value="${scOrder.createBy.id}" labelName="createBy.name" labelValue="${scOrder.createBy.name}"
                                            cssClass="form-control required"/>
                        </div>
<%--                        --%>
<%--                        <div class="col-xs-12 col-sm-6 col-md-4">--%>
<%--                            <div class="form-group">--%>
<%--                                <label class="label-item single-overflow pull-left" title="创建时间：">&nbsp;创建时间：</label>--%>
<%--                                <div class="col-xs-12">--%>
<%--                                    <div class="col-xs-12 col-sm-5">--%>
<%--                                        <div class='input-group date' id='beginCreateDate' style="left: -10px;" >--%>
<%--                                            <input type='text'  name="beginCreateDate" class="form-control"  />--%>
<%--                                            <span class="input-group-addon">--%>
<%--					                       <span class="glyphicon glyphicon-calendar"></span>--%>
<%--					                   </span>--%>
<%--                                        </div>--%>
<%--                                    </div>--%>
<%--                                    <div class="col-xs-12 col-sm-1">--%>
<%--                                        ~--%>
<%--                                    </div>--%>
<%--                                    <div class="col-xs-12 col-sm-5">--%>
<%--                                        <div class='input-group date' id='endCreateDate' style="left: -10px;" >--%>
<%--                                            <input type='text'  name="endCreateDate" class="form-control" />--%>
<%--                                            <span class="input-group-addon">--%>
<%--					                       <span class="glyphicon glyphicon-calendar"></span>--%>
<%--					                   </span>--%>
<%--                                        </div>--%>
<%--                                    </div>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        --%>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="备注信息：">备注信息：</label>
                            <form:input path="remarks" htmlEscape="false" maxlength="255"  class=" form-control"/>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <div style="margin-top:26px">
                                <a  id="search" class="btn btn-primary btn-rounded  btn-bordered btn-sm"><i class="fa fa-search"></i> 查询</a>
                                <a  id="reset" class="btn btn-primary btn-rounded  btn-bordered btn-sm" ><i class="fa fa-refresh"></i> 重置</a>
                            </div>
                        </div>
                    </form:form>
                </div>
            </div>

            <!-- 工具栏 -->
            <div id="toolbar">
                <shiro:hasPermission name="order:scOrder:printBoxOrder">
                    <div class="btn-group">
                        <button type="button" class="btn btn-primary" onclick="printBoxOrder(1)">打印装箱单</button>
                        <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span class="caret"></span>
                            <span class="sr-only">Toggle Dropdown</span>
                        </button>
                        <ul class="dropdown-menu">
                            <li><a href="#" onclick="setPrintBoxOrder()">设置打印内容</a></li>
                                <%--                            <li role="separator" class="divider"></li>--%>
                        </ul>
                    </div>
                </shiro:hasPermission>
                <shiro:hasPermission name="order:scOrder:printDeliveryOrder">
                    <div class="btn-group">
                        <button type="button" class="btn btn-primary" onclick="printDeliveryOrder()">打印出货单</button>
                        <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span class="caret"></span>
                            <span class="sr-only">Toggle Dropdown</span>
                        </button>
                        <ul class="dropdown-menu">
                            <li><a href="#" onclick="setPrintDeliveryOrder()">设置打印内容</a></li>
                                <%--                            <li role="separator" class="divider"></li>--%>
                        </ul>
                    </div>
                </shiro:hasPermission>

            </div>

            <!-- 表格 -->
            <table id="scOrderTable" data-toolbar="#toolbar"></table>

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
<%@include file="../order/print/printBoxOrderSetting_js.jsp" %>
</body>
</html>