<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<html>
<head>
    <title>包装箱管理</title>
    <meta name="decorator" content="ani"/>
    <style>
        .width-label{
            width: 12%;
        }
        .width-value{
           width: 21%;
        }
    </style>
    <script type="text/javascript">

        /**
         * 计算总计货物价格
         */
        function calTotalPrice() {
            var singlePrice = parseInt($('#singlePrice').val()) || 0;
            var count = parseInt($('#count').val()) || 0;
            var weight = parseInt($('#weight').val()) || 0;
            var result = singlePrice * count * weight;
            if ($.isNumeric(result)) {
                $('#totalPrice').val(result);
            } else {
                $('#totalPrice').val(0);
            }
        }

        /**
         * 计算物流总价
         */
        function calLogisticsTotalPrice() {
            var logisticsPrice = parseInt($('#logisticsPrice').val());
            var count = parseInt($('#count').val());
            var result = logisticsPrice * count;
            if ($.isNumeric(result)) {
                $('#logisticsTotalPrice').val(result);
            } else {
                $('#logisticsTotalPrice').val(0);
            }
        }

        $(document).ready(function () {
            // 计算总计货物价格
            $('#singlePrice,#weight').keyup(calTotalPrice);
            // 计算总计快递费
            $('#logisticsPrice').keyup(calLogisticsTotalPrice);
            // 数量改变，两个价格都计算
            $('#count').keyup(function () {
                calTotalPrice();
                calLogisticsTotalPrice();
            });
        });

        function save(isRefreshThis) {
            var isValidate = jp.validateForm('#inputForm');//校验表单
            if (!isValidate) {
                jp.warning('表单验证失败，请检查表单输入项！');
                return false;
            } else {
                jp.loading();
                jp.post("${ctx}/box/scBox/save", $('#inputForm').serialize(), function (data) {
                    if (data.success) {
                        jp.success('装箱单已保存，自动生成每个箱子成功！');
                        // jp.getParent().location.reload();
                        // jp.getParent().refresh();
                        parent.refresh();
                        <%--jp.go('${ctx}/box/scBox/form/view?id=' + data.msg);--%>
                        if (isRefreshThis) {
                            window.location.reload();
                        } else {
                            var dialogIndex = parent.layer.getFrameIndex(window.name); // 获取窗口索引
                            parent.layer.close(dialogIndex);
                        }
                    } else {
                        jp.error(data.msg);
                    }
                })
            }
            return false;
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

        /**
         * 选择规格后自动设置 每斤价格
         * @param item
         */
        function selectSpecCallback(item) {
            // 设置每斤价格
            $('#singlePrice').val(item.lastUnitPrice);
            calTotalPrice();
        }

    </script>
</head>
<body class="bg-white">

<div class="wrapper wrapper-content">
    <form:form id="inputForm" modelAttribute="scBox" action="${ctx}/box/scBox/save" method="post" class="form-horizontal">
        <form:hidden path="id"/>
        <form:hidden path="order.id"/>
        <table class="table table-bordered">
            <tbody>
            <tr>
                <td class="width-label active"><label class="pull-right">装箱单号：</label></td>
                <td class="width-value">
                    <form:input path="no" readonly="true" htmlEscape="false" class="form-control " title="自动生成，规则：日期+客户拼音缩写+三位序号"/>
                </td>
                <td class="width-label active"><label class="pull-right"><font color="red">*</font>规格：</label></td>
                <td class="width-value">
                    <sys:gridselect url="${ctx}/production/scProduction/data" id="production" name="production.id" value="${scBox.production.id}"
                                    labelName="production.name" labelValue="${scBox.production.name}"
                                    title="选择规格" cssClass="form-control required" fieldLabels="规格|每斤价格" fieldKeys="name|lastUnitPrice" searchLabels="规格|每斤价格"
                                    searchKeys="name|lastUnitPrice" callback="selectSpecCallback" addUrl="${ctx}/production/scProduction/form"
                    ></sys:gridselect>
                </td>
                <td class="width-label active"><label class="pull-right"><font color="red">*</font>每箱重量（斤）：</label></td>
                <td class="width-value">
                    <form:input path="weight" id="weight" htmlEscape="false" class="form-control required isFloatGteZero" type="number" placeholder="必填"/>
                </td>
            </tr>
            <tr>
                <td class="width-label active"><label class="pull-right"><font color="red">*</font>数量（箱）：</label></td>
                <td class="width-value">
                    <form:input path="count" id="count" htmlEscape="false" class="form-control required isIntGtZero"  type="number" placeholder="必填"/>
                </td>
                <td class="width-label active"><label class="pull-right">每斤价格：</label></td>
                <td class="width-value">
                    <form:input path="singlePrice" id="singlePrice" htmlEscape="false" class="form-control  isFloatGteZero"  type="number"
                                placeholder="尽量填写，否则无法计算价格" title="默认查询产品列表中此产品的价格"/>
                </td>
                <td class="width-label active"><label class="pull-right">总计价格：</label></td>
                <td class="width-value">
                    <form:input path="totalPrice" id="totalPrice" htmlEscape="false" class="form-control  isFloatGteZero"  type="number"
                                placeholder="由系统自动计算，可修改" title="计算公式：每箱重量 * 每斤价格 * 箱子数量"/>
                </td>
            </tr>
            <tr>
                <td class="width-label active"><label class="pull-right">已发货总价：</label></td>
                <td class="width-value">
                    <form:input path="deliverTotalPrice" htmlEscape="false" class="form-control  isFloatGteZero"  type="number"
                                placeholder="由系统自动计算，可修改" title="计算公式：每箱重量 * 每斤价格 * 已发货箱子数量"/>
                </td>
                <td class="width-label active"><label class="pull-right">单箱快递费：</label></td>
                <td class="width-value">
                    <form:input path="logisticsPrice" id="logisticsPrice" htmlEscape="false" class="form-control  isFloatGteZero"  type="number" placeholder="尽量填写，否则无法计算价格"/>
                </td>
                <td class="width-label active"><label class="pull-right">总计快递费：</label></td>
                <td class="width-value">
                    <form:input path="logisticsTotalPrice" id="logisticsTotalPrice" htmlEscape="false" type="number"  class="form-control  isFloatGteZero"
                                placeholder="由系统自动计算，可修改"/>
                </td>
            </tr>
            <tr>
                <td class="width-label active"><label class="pull-right">调拨工厂：</label></td>
                <td class="width-value">
                    <sys:treeselect id="allotFactory" name="allotFactory.id" value="${scBox.allotFactory.id}" labelName="allotFactory.name"
                                    labelValue="${scBox.allotFactory.name}"
                                    title="部门" url="/sys/office/treeData?type=2" cssClass="form-control " allowClear="true" notAllowSelectParent="true"/>
                </td>
                    <%--                <td class="width-label active"><label class="pull-right"><font color="red">*</font>状态：</label></td>--%>
                    <%--                <td class="width-value">--%>
                    <%--                    <form:select path="status" class="form-control required">--%>
                    <%--                        <form:option value="" label=""/>--%>
                    <%--                        <form:options items="${fns:getDictList('status_box')}" itemLabel="label" itemValue="value" htmlEscape="false"/>--%>
                    <%--                    </form:select>--%>
                    <%--                </td>--%>
                <td class="width-label active"><label class="pull-right">备注信息：</label></td>
                <td class="width-value" colspan="3">
                    <form:input path="remarks" htmlEscape="false" class="form-control "/>
                </td>
            </tr>
            </tbody>
        </table>
<%--        <c:if test="${mode == 'add' || mode=='edit'}">--%>
<%--            <div class="row">--%>
<%--                <div class="col-lg-3"></div>--%>
<%--                <div class="col-lg-6">--%>
<%--                    <div class="form-group text-center">--%>
<%--                        <div>--%>
<%--                            <button type="button" class="btn btn-primary btn-block btn-lg btn-parsley" data-loading-text="正在保存..."--%>
<%--                                    onclick="return save()">保 存--%>
<%--                            </button>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </c:if>--%>
    </form:form>

    <div class="tabs-container">
        <ul class="nav nav-tabs">
            <li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">每箱：</a>
            </li>
        </ul>
        <div class="tab-content">
            <div id="tab-1" class="tab-pane fade in  active">
                <%@include file="../boxitem/scBoxItemList.jsp" %>
            </div>
        </div>
    </div>
</div>
</body>
</html>