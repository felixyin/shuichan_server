<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<html>
<head>
    <title>订单管理</title>
    <meta name="decorator" content="ani"/>
    <%@include file="/webpage/include/bootstraptable.jsp" %>
    <%@include file="/webpage/include/treeview.jsp" %>
    <script type="text/javascript">

        $(document).ready(function () {
            jp.ajaxForm("#inputForm", function (data) {
                if (data.success) {
                    jp.success('订单保存成功，请添加包装箱。');
                    jp.go("${ctx}/order/scOrder/form/edit?id=" + data.msg);
                } else {
                    jp.error(data.msg);
                    $("#inputForm").find("button:submit").button("reset");
                }
            });

        });

        function save() {
            var isValidate = jp.validateForm('#inputForm');//校验表单
            if (!isValidate) {
                return false;
            } else {
                jp.loading();
                jp.post("${ctx}/order/scOrder/save", $('#inputForm').serialize(), function (data) {
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

        function addRow(list, idx, tpl, row) {
            $(list).append(Mustache.render(tpl, {
                idx: idx, delBtn: true, row: row
            }));
            $(list + idx).find("select").each(function () {
                $(this).val($(this).attr("data-value"));
            });
            $(list + idx).find("input[type='checkbox'], input[type='radio']").each(function () {
                var ss = $(this).attr("data-value").split(',');
                for (var i = 0; i < ss.length; i++) {
                    if ($(this).val() == ss[i]) {
                        $(this).attr("checked", "checked");
                    }
                }
            });
            $(list + idx).find(".form_datetime").each(function () {
                $(this).datetimepicker({
                    format: "YYYY-MM-DD HH:mm:ss"
                });
            });
        }

        function delRow(obj, prefix) {
            var id = $(prefix + "_id");
            var delFlag = $(prefix + "_delFlag");
            if (id.val() == "") {
                $(obj).parent().parent().remove();
            } else if (delFlag.val() == "0") {
                delFlag.val("1");
                $(obj).html("&divide;").attr("title", "撤销删除");
                $(obj).parent().parent().addClass("error");
            } else if (delFlag.val() == "1") {
                delFlag.val("0");
                $(obj).html("&times;").attr("title", "删除");
                $(obj).parent().parent().removeClass("error");
            }
        }
    </script>
</head>
<body class="bg-white">

<div class="wrapper wrapper-content">
<%--    <a class="panelButton btn btn-primary" href="${ctx}/report/scReport"><i class="fa fa-reply"></i>返回</a>--%>

    <form:form id="inputForm" modelAttribute="scOrder" action="${ctx}/order/scOrder/save" method="post" class="form-horizontal">
        <%--    <fieldset>--%>
        <legend>订单信息表单</legend>
        <form:hidden path="id"/>
        <table class="table table-bordered">
            <tbody>
            <tr>
                <td class="width-15 active"><label class="pull-right"><font color="red">*</font>代理人：</label></td>
                <td class="width-35">
                        ${scOrder.agentName}
                </td>
                <td class="width-15 active"><label class="pull-right"><font color="red">*</font>客户：</label></td>
                <td class="width-35">
                        ${scOrder.custom.username}
                </td>
            </tr>
            <tr>
                <td class="width-15 active"><label class="pull-right"><font color="red">*</font>指定物流公司：</label></td>
                <td class="width-35">
                        ${scOrder.shouldLogistics.name}
                </td>
                <td class="width-15 active"><label class="pull-right">物流班次：</label></td>
                <td class="width-35">
                        ${fns:getDictLabel(scOrder.shift, 'logistics_shift', '')}
                </td>
            </tr>
            <tr>
                <td class="width-15 active"><label class="pull-right"><font color="red">*</font>所属加工厂：</label></td>
                <td class="width-35">
                        ${scOrder.factory.name}
                </td>
                <td class="width-15 active"><label class="pull-right">实取物流公司：</label></td>
                <td class="width-35">
                        ${scOrder.realLogistics.name}
                </td>
            </tr>
            <tr>
                <td class="width-15 active"><label class="pull-right">货物总价：</label></td>
                <td class="width-35">
                        ${scOrder.goodsOrderPrice}
                </td>
                <td class="width-15 active"><label class="pull-right">已发货总价：</label></td>
                <td class="width-35">
                        ${scOrder.deliverOrderPrice}
                </td>
            </tr>
            <tr>
                <td class="width-15 active"><label class="pull-right">物流总价：</label></td>
                <td class="width-35">
                        ${scOrder.logisticsOrderPrice}
                </td>
                <td class="width-15 active"><label class="pull-right">客户应付：</label></td>
                <td class="width-35">
                        ${scOrder.willPayPrice}
                </td>
            </tr>
            <tr>
                <td class="width-15 active"><label class="pull-right">客户实付：</label></td>
                <td class="width-35">
                        ${scOrder.realPayPrice}
                </td>
                <td class="width-15 active"><label class="pull-right">要求发货时间：</label></td>
                <td class="width-35">
                    <div class='input-group form_datetime' id='deliverDate'>
                            ${fns:formatDateTime(scOrder.deliverDate)}
                    </div>
                </td>
            </tr>
            <tr>
                <td class="width-15 active"><label class="pull-right">明天未发作废：</label></td>
                <td class="width-35">
                        ${fns:getDictLabel(scOrder.tomorrowCancellation,'tomorrow_cancellation','')}
                </td>
                <td class="width-15 active"><label class="pull-right">状态：</label></td>
                <td class="width-35">
                        ${fns:getDictLabel(scOrder.status,'status_order','')}
                </td>
            </tr>
            <tr>
                <td class="width-15 active"><label class="pull-right">备注信息：</label></td>
                <td class="width-35">
                    ${scOrder.remarks}
                </td>
                <td class="width-15 active"></td>
                <td class="width-35"></td>
            </tr>
            </tbody>
        </table>
        <c:if test="${mode == 'add' || mode=='edit'}">
            <div class="row">
                <div class="col-lg-3"></div>
                <div class="col-lg-6">
                    <div class="form-group text-center">
                        <div>
                            <button class="btn btn-primary btn-block btn-lg btn-parsley" data-loading-text="正在提交...">提 交</button>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </form:form>

    <div class="container-fluid">
        <%@include file="scBoxList.jsp" %>
    </div>

</div>
</body>
</html>