<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<html>
<head>
    <title>用户设置管理</title>
    <meta name="decorator" content="ani"/>
    <script type="text/javascript">

        $(document).ready(function () {

        });

        function save() {
            var isValidate = jp.validateForm('#inputForm');//校验表单
            if (!isValidate) {
                return false;
            } else {
                jp.loading();
                jp.post("${ctx}/setting/scSetting/save", $('#inputForm').serialize(), function (data) {
                    if (data.success) {
                        jp.getParent().refresh();
                        var dialogIndex = parent.layer.getFrameIndex(window.name); // 获取窗口索引
                        parent.layer.close(dialogIndex);
                        jp.success(data.msg)

                    } else {
                        jp.error(data.msg);
                    }
                })
            }

        }
    </script>
</head>
<body class="bg-white">
<form:form id="inputForm" modelAttribute="scSetting" class="form-horizontal">
    <form:hidden path="id"/>
    <table class="table table-bordered">
        <tbody>
        <tr>
            <td class="width-15 active"><label class="pull-right">自动登录：</label></td>
            <td class="width-35">
                <form:input path="autoLogin" htmlEscape="false" class="form-control "/>
            </td>
            <td class="width-15 active"><label class="pull-right">显示提示：</label></td>
            <td class="width-35">
                <form:input path="showToast" htmlEscape="false" class="form-control "/>
            </td>
        </tr>
        <tr>
            <td class="width-15 active"><label class="pull-right">连续扫码：</label></td>
            <td class="width-35">
                <form:input path="continueScan" htmlEscape="false" class="form-control "/>
            </td>
            <td class="width-15 active"><label class="pull-right">摇一摇扫码：</label></td>
            <td class="width-35">
                <form:input path="snakeScan" htmlEscape="false" class="form-control "/>
            </td>
        </tr>
        <tr>
            <td class="width-15 active"><label class="pull-right">扫码后自动刷新：</label></td>
            <td class="width-35">
                <form:input path="scanRefresh" htmlEscape="false" class="form-control "/>
            </td>
            <td class="width-15 active"><label class="pull-right">显示自己的扫码历史：</label></td>
            <td class="width-35">
                <form:input path="ownerHistory" htmlEscape="false" class="form-control "/>
            </td>
        </tr>
        <tr>
            <td class="width-15 active"><label class="pull-right">备注信息：</label></td>
            <td class="width-35">
                <form:textarea path="remarks" htmlEscape="false" rows="4" class="form-control "/>
            </td>
            <td class="width-15 active"></td>
            <td class="width-35"></td>
        </tr>
        </tbody>
    </table>
</form:form>
</body>
</html>