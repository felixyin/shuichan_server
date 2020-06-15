<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<html>
<head>
    <title>订单管理</title>
    <meta name="decorator" content="ani"/>
    <%@include file="/webpage/include/bootstraptable.jsp" %>
    <%@include file="/webpage/include/treeview.jsp" %>
    <style>
        .width-label {
            width: 12%;
        }

        .width-value {
            width: 21%;
        }

    </style>
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
            $('#deliverDate').datetimepicker({
                format: "YYYY-MM-DD HH:mm"
            });
        });

        /**
         * ajax 获取代理人
         * @param data
         */
        function autoCompleteAgentName(data) {
            jp.post('${ctx}/order/scOrder/autoCompleteAgentName', {customId: data.id}, function (result) {
                if (result && result.success) {
                    if (result.msg) {
                        jp.info('自动设置代理人：' + result.msg);
                        $('#agentName').val(result.msg).attr('title', '自动设置代理人：' + result.msg);
                    } else {
                        $('#agentName').attr('title', '没有从历史订单记录中找到代理人，请手动填写');
                    }
                }
            });
        }

        function save(isRefreshThis) {
            var isValidate = jp.validateForm('#inputForm');//校验表单
            if (!isValidate) {
                jp.warning('表单验证失败，请检查表单输入项！');
                return false;
            } else {
                jp.loading();
                jp.post("${ctx}/order/scOrder/save", $('#inputForm').serialize(), function (data) {
                    if (data.success) {
                        jp.success('保存订单成功！');
                        jp.getParent().refresh();
                        if (isRefreshThis) {
                            window.location.reload();
                        } else {
                            var dialogIndex = parent.layer.getFrameIndex(window.name); // 获取窗口索引
                            parent.layer.close(dialogIndex);
                        }
                    } else {
                        jp.error('保存失败！');
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
    <%--    <a class="panelButton btn btn-primary" href="${ctx}/order/scOrder"><i class="fa fa-reply"></i>返回</a>--%>

    <form:form id="inputForm" modelAttribute="scOrder" action="${ctx}/order/scOrder/save" method="post" class="form-horizontal">
        <%--    <fieldset>--%>
        <legend>订单信息表单</legend>
        <form:hidden path="id"/>
        <span style="display: none;">
                    <form:hidden path="factory.id" value="${scOrder.factory.id}"/>
                        ${scOrder.factory.name}
                    <form:hidden path="realLogistics.id" value="${scOrder.realLogistics.id}"/>
                        ${scOrder.realLogistics.name}
            </span>
        <table class="table table-bordered">
            <tbody>
            <tr>
                <td class="width-label active"><label class="pull-right"><font color="red">*</font>客户：</label></td>
                <td class="width-value">
                    <sys:gridselect url="${ctx}/custom/scCustom/data"
                                    addUrl="${ctx}/custom/scCustom/form"
                                    id="custom" name="custom.id" value="${scOrder.custom.id}" labelName="custom.username"
                                    labelValue="${scOrder.custom.username}"
                                    title="选择客户" cssClass="form-control required" fieldLabels="姓名|电话|地址" fieldKeys="username|phone|address" searchLabels="姓名|电话"
                                    callback="autoCompleteAgentName"
                                    searchKeys="username|phone"></sys:gridselect>
                </td>
                <td class="width-label active"><label class="pull-right">代理人：</label></td>
                <td class="width-value">
                    <form:input path="agentName" id="agentName" htmlEscape="false" class="form-control" placeholder="可不填" title="默认查找所有历史记录，找到的此客户对应的代理人"/>
                </td>
                <td class="width-label active"><label class="pull-right">指定物流公司：</label></td>
                <td class="width-value">
                    <sys:treeselect id="shouldLogistics" name="shouldLogistics.id" value="${scOrder.shouldLogistics.id}" labelName="shouldLogistics.name"
                                    labelValue="${scOrder.shouldLogistics.name}"
                                    extId="9330c28235614c8eb5ed146486612a07"
                                    title="部门" url="/sys/office/treeData?type=2" cssClass="form-control " allowClear="true"
                                    notAllowSelectParent="true"/>
                </td>
            </tr>
            <tr>
                <td class="width-label active"><label class="pull-right">物流班次：</label></td>
                <td class="width-value">
                    <form:select path="shift" class="form-control ">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('logistics_shift')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </td>
                    <%--            <tr>--%>
                    <%--                <td class="width-label active"><label class="pull-right">所属加工厂：</label></td>--%>
                    <%--                <td class="width-value">--%>
                    <%--                    <sys:treeselect id="factory" name="factory.id" value="${scOrder.factory.id}" labelName="factory.name" labelValue="${scOrder.factory.name}"--%>
                    <%--                                    title="部门" url="/sys/office/treeData?type=2" cssClass="form-control required" allowClear="true"--%>
                    <%--                                    extId="e684ba5b88ae4b56b34a0625d9d372a8"--%>
                    <%--                                    notAllowSelectParent="true"/>--%>
                    <%--                </td>--%>
                    <%--                <td class="width-label active"><label class="pull-right">实取物流公司：</label></td>--%>
                    <%--                <td class="width-value">--%>
                    <%--                    <sys:treeselect id="realLogistics" name="realLogistics.id" value="${scOrder.realLogistics.id}" labelName="realLogistics.name"--%>
                    <%--                                    extId="9330c28235614c8eb5ed146486612a07"--%>
                    <%--                                    labelValue="${scOrder.realLogistics.name}"--%>
                    <%--                                    title="部门" url="/sys/office/treeData?type=2" cssClass="form-control " allowClear="true" notAllowSelectParent="true"/>--%>
                    <%--                </td>--%>
                    <%--            </tr>--%>
                <td class="width-label active"><label class="pull-right">货物总价：</label></td>
                <td class="width-value">
                    <form:input path="goodsOrderPrice" htmlEscape="false" class="form-control  isFloatGteZero" type="number" placeholder="自动计算得出，可修改"/>
                </td>
                <td class="width-label active"><label class="pull-right">已发货总价：</label></td>
                <td class="width-value">
                    <form:input path="deliverOrderPrice" htmlEscape="false" class="form-control  isFloatGteZero" type="number" placeholder="自动计算得出，可修改"/>
                </td>
            </tr>
            <tr>
                <td class="width-label active"><label class="pull-right">物流总价：</label></td>
                <td class="width-value">
                    <form:input path="logisticsOrderPrice" htmlEscape="false" class="form-control  isFloatGteZero" type="number" placeholder="自动计算得出，可修改"/>
                </td>
                <td class="width-label active"><label class="pull-right">客户应付：</label></td>
                <td class="width-value">
                    <form:input path="willPayPrice" htmlEscape="false" class="form-control  isFloatGteZero" type="number" placeholder="自动计算得出，可修改"/>
                </td>
                <td class="width-label active"><label class="pull-right">客户实付：</label></td>
                <td class="width-value">
                    <form:input path="realPayPrice" htmlEscape="false" class="form-control  isFloatGteZero" type="number" placeholder="收款后，填入"/>
                </td>
            </tr>
            <tr>
                <td class="width-label active"><label class="pull-right">要求发货时间：</label></td>
                <td class="width-value">
                    <div class='input-group form_datetime' id='deliverDate'>
                        <input type='text' name="deliverDate" class="form-control " placeholder="可不填"
                               value="<fmt:formatDate value="${scOrder.deliverDate}" pattern="yyyy-MM-dd HH:mm"/>"/>
                        <span class="input-group-addon">
								<span class="glyphicon glyphicon-calendar"></span>
							</span>
                    </div>
                </td>
                <td class="width-label active"><label class="pull-right">明天未发作废：</label></td>
                <td class="width-value">
                    <form:select path="tomorrowCancellation" class="form-control ">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('tomorrow_cancellation')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </td>
                <td class="width-label active"><label class="pull-right">状态：</label></td>
                <td class="width-value">
                    <form:select path="status" class="form-control ">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('status_order')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </td>
            </tr>
            <tr>
                <td class="width-label active"><label class="pull-right">备注信息：</label></td>
                <td class="width-value" colspan="5">
                    <form:textarea path="remarks" htmlEscape="false" rows="1" class="form-control " placeholder="可不填" title="订单下的包装箱默认采用此备注"/>
                </td>
            </tr>
            </tbody>
        </table>
        <%--  <c:if test="${mode == 'add' || mode=='edit'}">
              <c:choose>
                  <c:when test="${scOrder.id != null && scOrder.id != ''}">
                      <div class="row">
                          <div class="col-lg-3"></div>
                          <div class="col-lg-6">
                              <div class="form-group text-center">
                                  <div>
                                      <button class="btn btn-primary btn-block btn-lg btn-parsley" data-loading-text="正在保存...">保 存 修 改</button>
                                  </div>
                              </div>
                          </div>
                      </div>
                  </c:when>
                  <c:otherwise>
                      <shiro:hasPermission name="box:scBox:add">
                          <div class="row">
                              <div class="col-lg-3"></div>
                              <div class="col-lg-6">
                                  <div class="form-group text-center">
                                      <div>
                                          <button type="button" class="btn btn-primary btn-block btn-lg btn-parsley" onclick="save()">
                                              <i class="glyphicon glyphicon-plus"></i> 添加包装箱
                                          </button>
                                      </div>
                                  </div>
                              </div>
                          </div>
                      </shiro:hasPermission>
                  </c:otherwise>
              </c:choose>
          </c:if>--%>
    </form:form>

    <div class="container-fluid">
        <%@include file="../box/scBoxList.jsp" %>
    </div>

</div>
</body>
</html>