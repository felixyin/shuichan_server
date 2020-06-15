<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<%--<%@include file="/webpage/include/bootstraptable.jsp" %>--%>
<%--<%@include file="/webpage/include/treeview.jsp" %>--%>
<%@include file="scBoxList_js.jsp" %>

<c:if test="${scOrder.id != null && scOrder.id != ''}">
    <legend>包装箱列表</legend>
    <div class="panel panel-primary">
        <div class="panel-body">

            <!-- 工具栏 -->
            <div id="toolbar">
                <shiro:hasPermission name="order:scOrder:printBoxOrder">
                    <div class="btn-group">
                        <button type="button" class="btn btn-primary" onclick="return printBoxOrder(2)">打印装箱单</button>
                        <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span class="caret"></span>
                            <span class="sr-only">Toggle Dropdown</span>
                        </button>
                        <ul class="dropdown-menu">
                            <li><a href="#" onclick="return setPrintBoxOrder()">设置打印内容</a></li>
                                <%--                            <li role="separator" class="divider"></li>--%>
                        </ul>
                    </div>
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
</c:if>
<%@include file="../order/print/printBoxOrderSetting_js.jsp" %>