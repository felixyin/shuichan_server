<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<html>
<head>
    <title>包装箱管理</title>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8">
    <meta name="decorator" content="ani"/>
    <%@include file="/webpage/include/bootstraptable.jsp" %>
    <%@include file="/webpage/include/treeview.jsp" %>
    <%@include file="scBoxList_js.jsp" %>
</head>
<body>

<div class="wrapper wrapper-content">
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">包装箱列表</h3>
        </div>
        <div class="panel-body">

            <!-- 搜索 -->
            <div id="search-collapse" class="collapse">
                <div class="accordion-inner">
                    <form:form id="searchForm" modelAttribute="scBox" class="form form-horizontal well clearfix">
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="装箱单号：">装箱单号：</label>
                            <form:input path="no" htmlEscape="false" maxlength="64" class=" form-control"/>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="规格：">规格：</label>
                            <sys:gridselect url="${ctx}/production/scProduction/data" id="production" name="production.id" value="${scBox.production.id}" labelName="production.name" labelValue="${scBox.production.name}"
                                            title="选择规格" cssClass="form-control required" fieldLabels="规格|每斤价格" fieldKeys="name|lastUnitPrice" searchLabels="规格|每斤价格" searchKeys="name|lastUnitPrice" ></sys:gridselect>
                        </div>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="每箱重量（斤）：">每箱重量（斤）：</label>
                            <form:input path="weight" htmlEscape="false" class=" form-control"/>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="数量（箱）：">数量（箱）：</label>
                            <form:input path="count" htmlEscape="false" class=" form-control"/>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="调拨工厂：">调拨工厂：</label>
                            <sys:treeselect id="allotFactory" name="allotFactory.id" value="${scBox.allotFactory.id}" labelName="allotFactory.name"
                                            labelValue="${scBox.allotFactory.name}"
                                            title="部门" url="/sys/office/treeData?type=2" cssClass="form-control" allowClear="true" notAllowSelectParent="true"/>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="状态：">状态：</label>
                            <form:select path="status" class="form-control m-b">
                                <form:option value="" label=""/>
                                <form:options items="${fns:getDictList('status_box')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                            </form:select>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <label class="label-item single-overflow pull-left" title="备注信息：">备注信息：</label>
                            <form:input path="remarks" htmlEscape="false" maxlength="255" class=" form-control"/>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <div style="margin-top:26px">
                                <a id="search" class="btn btn-primary btn-rounded  btn-bordered btn-sm"><i class="fa fa-search"></i> 查询</a>
                                <a id="reset" class="btn btn-primary btn-rounded  btn-bordered btn-sm"><i class="fa fa-refresh"></i> 重置</a>
                            </div>
                        </div>
                    </form:form>
                </div>
            </div>

            <!-- 工具栏 -->
            <div id="toolbar">
                <shiro:hasPermission name="box:scBox:add">
                    <button id="add" class="btn btn-primary" onclick="add()">
                        <i class="glyphicon glyphicon-plus"></i> 新建
                    </button>
                </shiro:hasPermission>
                <shiro:hasPermission name="box:scBox:edit">
                    <button id="edit" class="btn btn-success" disabled onclick="edit()">
                        <i class="glyphicon glyphicon-edit"></i> 修改
                    </button>
                </shiro:hasPermission>
                <shiro:hasPermission name="box:scBox:del">
                    <button id="remove" class="btn btn-danger" disabled onclick="deleteAll()">
                        <i class="glyphicon glyphicon-remove"></i> 删除
                    </button>
                </shiro:hasPermission>
                <shiro:hasPermission name="box:scBox:import">
                    <button id="btnImport" class="btn btn-info"><i class="fa fa-folder-open-o"></i> 导入</button>
                </shiro:hasPermission>
                <shiro:hasPermission name="box:scBox:export">
                    <button id="export" class="btn btn-warning">
                        <i class="fa fa-file-excel-o"></i> 导出
                    </button>
                </shiro:hasPermission>
                <shiro:hasPermission name="box:scBox:view">
                    <button id="view" class="btn btn-default" disabled onclick="view()">
                        <i class="fa fa-search-plus"></i> 查看
                    </button>
                </shiro:hasPermission>
            </div>

            <!-- 表格 -->
            <table id="scBoxTable" data-toolbar="#toolbar"></table>

            <!-- context menu -->
            <ul id="context-menu" class="dropdown-menu">
                <shiro:hasPermission name="box:scBox:view">
                    <li data-item="view"><a>查看</a></li>
                </shiro:hasPermission>
                <shiro:hasPermission name="box:scBox:edit">
                    <li data-item="edit"><a>编辑</a></li>
                </shiro:hasPermission>
                <shiro:hasPermission name="box:scBox:del">
                    <li data-item="delete"><a>删除</a></li>
                </shiro:hasPermission>
                <li data-item="action1"><a>取消</a></li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>