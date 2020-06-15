<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>导入订单管理</title>
	<meta http-equiv="Content-type" content="text/html; charset=utf-8">
	<meta name="decorator" content="ani"/>
	<%@ include file="/webpage/include/bootstraptable.jsp"%>
	<%@include file="/webpage/include/treeview.jsp" %>
	<%@include file="scOrderImportList_js.jsp" %>
	<%--	<link href="${ctxs}/static/plugin/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet">--%>
	<%--	<script src="${ctxs}/static/plugin/bootstrap-table/bootstrap-table.js"></script>--%>
	<%--	<script src="${ctxs}/static/plugin/bootstrap-table/locale/bootstrap-table-zh-CN.js"></script>--%>
	<%--	<script src="${ctxs}/static/plugin/bootstrap-table/extensions/export/bootstrap-table-export.js"></script>--%>
	<%--	<script src="${ctxs}/static/plugin/bootstrapTable/tableExport.js"></script>--%>
	<%--	<script src="${ctxs}/static/plugin/bootstrapTable/bootstrap-table-contextmenu.js"></script>--%>
	<%--	<script src="${ctxs}/static/plugin/bootstrap-table/extensions/editable/bootstrap-table-editable.js"></script>--%>
	<%--	<script src="${ctxs}/static/plugin/bootstrap3-editable/js/bootstrap-editable.js"></script>--%>
</head>
<body>
	<div class="wrapper wrapper-content">
	<div class="panel panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">导入订单列表</h3>
	</div>
	<div class="panel-body">
	
	<!-- 搜索 -->
	<div id="search-collapse" class="collapse">
		<div class="accordion-inner">
			<form:form id="searchForm" modelAttribute="scOrderImport" class="form form-horizontal well clearfix">
			 <div class="col-xs-12 col-sm-6 col-md-4">
				<label class="label-item single-overflow pull-left" title="user_id：">user_id：</label>
				<sys:userselect id="user" name="user.id" value="${scOrderImport.user.id}" labelName="user.name" labelValue="${scOrderImport.user.name}"
							    cssClass="form-control "/>
			</div>
			 <div class="col-xs-12 col-sm-6 col-md-4">
				<label class="label-item single-overflow pull-left" title="电话：">电话：</label>
				<form:input path="phone" htmlEscape="false" maxlength="64"  class=" form-control"/>
			</div>
			 <div class="col-xs-12 col-sm-6 col-md-4">
				<label class="label-item single-overflow pull-left" title="姓名：">姓名：</label>
				<form:input path="username" htmlEscape="false" maxlength="64"  class=" form-control"/>
			</div>
			 <div class="col-xs-12 col-sm-6 col-md-4">
				<label class="label-item single-overflow pull-left" title="地址：">地址：</label>
				<form:input path="address" htmlEscape="false" maxlength="125"  class=" form-control"/>
			</div>
			 <div class="col-xs-12 col-sm-6 col-md-4">
				<label class="label-item single-overflow pull-left" title="代理人：">代理人：</label>
				<form:input path="agentName" htmlEscape="false" maxlength="64"  class=" form-control"/>
			</div>
			 <div class="col-xs-12 col-sm-6 col-md-4">
				<label class="label-item single-overflow pull-left" title="物流公司：">物流公司：</label>
				<form:input path="logisticsName" htmlEscape="false" maxlength="64"  class=" form-control"/>
			</div>
			 <div class="col-xs-12 col-sm-6 col-md-4">
				<label class="label-item single-overflow pull-left" title="物流班次：">物流班次：</label>
				<form:input path="shiftName" htmlEscape="false" maxlength="64"  class=" form-control"/>
			</div>
			 <div class="col-xs-12 col-sm-6 col-md-4">
				<label class="label-item single-overflow pull-left" title="调拨加工厂：">调拨加工厂：</label>
				<form:input path="allotFactoryName" htmlEscape="false" maxlength="64"  class=" form-control"/>
			</div>
			 <div class="col-xs-12 col-sm-6 col-md-4">
				<label class="label-item single-overflow pull-left" title="品名（规格）：">品名（规格）：</label>
				<form:input path="productionName" htmlEscape="false" maxlength="64"  class=" form-control"/>
			</div>
			 <div class="col-xs-12 col-sm-6 col-md-4">
				<label class="label-item single-overflow pull-left" title="每斤价格：">每斤价格：</label>
				<form:input path="lastUnitPrice" htmlEscape="false"  class=" form-control"/>
			</div>
			 <div class="col-xs-12 col-sm-6 col-md-4">
				<label class="label-item single-overflow pull-left" title="单箱重量（斤）：">单箱重量（斤）：</label>
				<form:input path="weight" htmlEscape="false"  class=" form-control"/>
			</div>
			 <div class="col-xs-12 col-sm-6 col-md-4">
				<label class="label-item single-overflow pull-left" title="数量（箱）：">数量（箱）：</label>
				<form:input path="count" htmlEscape="false" maxlength="11"  class=" form-control"/>
			</div>
			 <div class="col-xs-12 col-sm-6 col-md-4">
				<label class="label-item single-overflow pull-left" title="单箱快递费：">单箱快递费：</label>
				<form:input path="logisticsPrice" htmlEscape="false"  class=" form-control"/>
			</div>
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
<%--			<shiro:hasPermission name="oimport:scOrderImport:add">--%>
<%--				<button id="add" class="btn btn-primary" onclick="add()">--%>
<%--					<i class="glyphicon glyphicon-plus"></i> 新建--%>
<%--				</button>--%>
<%--			</shiro:hasPermission>--%>
<%--			<shiro:hasPermission name="oimport:scOrderImport:edit">--%>
<%--			    <button id="edit" class="btn btn-success" disabled onclick="edit()">--%>
<%--	            	<i class="glyphicon glyphicon-edit"></i> 修改--%>
<%--	        	</button>--%>
<%--			</shiro:hasPermission>--%>
			<shiro:hasPermission name="oimport:scOrderImport:del">
				<button id="remove" class="btn btn-danger" disabled onclick="deleteAll()">
	            	<i class="glyphicon glyphicon-remove"></i> 删除
	        	</button>
			</shiro:hasPermission>
<%--			<shiro:hasPermission name="oimport:scOrderImport:import">--%>
<%--				<button id="btnImport" class="btn btn-info"><i class="fa fa-folder-open-o"></i> 导入</button>--%>
<%--			</shiro:hasPermission>--%>
<%--			<shiro:hasPermission name="oimport:scOrderImport:export">--%>
<%--	        		<button id="export" class="btn btn-warning">--%>
<%--					<i class="fa fa-file-excel-o"></i> 导出--%>
<%--				</button>--%>
<%--			 </shiro:hasPermission>--%>
<%--	                 <shiro:hasPermission name="oimport:scOrderImport:view">--%>
<%--				<button id="view" class="btn btn-default" disabled onclick="view()">--%>
<%--					<i class="fa fa-search-plus"></i> 查看--%>
<%--				</button>--%>
<%--			</shiro:hasPermission>--%>
		    </div>
		
	<!-- 表格 -->
	<table id="scOrderImportTable" class="text-nowrap"   data-toolbar="#toolbar"></table>

    <!-- context menu -->
    <ul id="context-menu" class="dropdown-menu">
    	<shiro:hasPermission name="oimport:scOrderImport:view">
        <li data-item="view"><a>查看</a></li>
        </shiro:hasPermission>
    	<shiro:hasPermission name="oimport:scOrderImport:edit">
        <li data-item="edit"><a>编辑</a></li>
        </shiro:hasPermission>
        <shiro:hasPermission name="oimport:scOrderImport:del">
        <li data-item="delete"><a>删除</a></li>
        </shiro:hasPermission>
        <li data-item="action1"><a>取消</a></li>
    </ul>  
	</div>
	</div>
	</div>
</body>
</html>