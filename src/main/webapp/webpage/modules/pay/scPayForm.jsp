<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>产品购买管理</title>
	<meta name="decorator" content="ani"/>
	<script type="text/javascript">

		$(document).ready(function() {
			$('#payDate').datetimepicker({
				format: "YYYY-MM-DD HH:mm"
			});
			$('#endDate').datetimepicker({
				format: "YYYY-MM-DD HH:mm"
			});
		});
		function save() {
            var isValidate = jp.validateForm('#inputForm');//校验表单
            if(!isValidate){
                return false;
			}else{
                jp.loading();
                jp.post("${ctx}/pay/scPay/save",$('#inputForm').serialize(),function(data){
                    if(data.success){
                        jp.getParent().refresh();
                        var dialogIndex = parent.layer.getFrameIndex(window.name); // 获取窗口索引
                        parent.layer.close(dialogIndex);
                        jp.success(data.msg)

                    }else{
                        jp.error(data.msg);
                    }
                })
			}

        }
	</script>
</head>
<body class="bg-white">
		<form:form id="inputForm" modelAttribute="scPay" class="form-horizontal">
		<form:hidden path="id"/>	
		<table class="table table-bordered">
		   <tbody>
				<tr>
					<td class="width-15 active"><label class="pull-right">订单编号：</label></td>
					<td class="width-35">
						<form:input path="tradeNo" htmlEscape="false"    class="form-control "/>
					</td>
					<td class="width-15 active"><label class="pull-right">订单名称：</label></td>
					<td class="width-35">
						<form:input path="subject" htmlEscape="false"    class="form-control "/>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">商品描述：</label></td>
					<td class="width-35">
						<form:textarea path="body" htmlEscape="false" rows="4"    class="form-control "/>
					</td>
					<td class="width-15 active"><label class="pull-right">套餐：</label></td>
					<td class="width-35">
						<form:select path="payModel" class="form-control ">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('pay_model')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">支付方式：</label></td>
					<td class="width-35">
						<form:select path="payType" class="form-control ">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('pay_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</td>
					<td class="width-15 active"><label class="pull-right">加工厂：</label></td>
					<td class="width-35">
						<sys:treeselect id="office" name="office.id" value="${scPay.office.id}" labelName="office.name" labelValue="${scPay.office.name}"
							title="部门" url="/sys/office/treeData?type=2" cssClass="form-control " allowClear="true" notAllowSelectParent="true"
										extId="e684ba5b88ae4b56b34a0625d9d372a8"/>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">支付账号：</label></td>
					<td class="width-35">
						<sys:userselect id="user" name="user.id" value="${scPay.user.id}" labelName="user.name" labelValue="${scPay.user.name}"
							    cssClass="form-control "/>
					</td>
					<td class="width-15 active"><label class="pull-right">支付金额：</label></td>
					<td class="width-35">
						<form:input path="money" htmlEscape="false"    class="form-control "/>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">支付时间：</label></td>
					<td class="width-35">
						<div class='input-group form_datetime' id='payDate'>
							<input type='text' name="payDate" class="form-control "
								   value="<fmt:formatDate value="${scPay.payDate}" pattern="yyyy-MM-dd HH:mm"/>"/>
							<span class="input-group-addon">
								<span class="glyphicon glyphicon-calendar"></span>
							</span>
						</div>
					</td>
					<td class="width-15 active"><label class="pull-right">截止日期：</label></td>
					<td class="width-35">
						<div class='input-group form_datetime' id='endDate'>
							<input type='text' name="endDate" class="form-control "
								   value="<fmt:formatDate value="${scPay.endDate}" pattern="yyyy-MM-dd HH:mm"/>"/>
							<span class="input-group-addon">
								<span class="glyphicon glyphicon-calendar"></span>
							</span>
						</div>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">支付平台编号：</label></td>
					<td class="width-35">
						<form:input path="returnNo" htmlEscape="false"    class="form-control "/>
					</td>
					<td class="width-15 active"><label class="pull-right">支付状态：</label></td>
					<td class="width-35">
						<form:select path="returnSuccess" class="form-control ">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('pay_return_success')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">支付消息：</label></td>
					<td class="width-35">
						<form:input path="returnMessage" htmlEscape="false"    class="form-control "/>
					</td>
					<td class="width-15 active"><label class="pull-right">备注信息：</label></td>
					<td class="width-35">
						<form:textarea path="remarks" htmlEscape="false" rows="4"    class="form-control "/>
					</td>
				</tr>
		 	</tbody>
		</table>
	</form:form>
</body>
</html>