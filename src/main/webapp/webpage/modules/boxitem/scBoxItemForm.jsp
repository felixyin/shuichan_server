<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>每箱管理</title>
	<meta name="decorator" content="ani"/>
	<script type="text/javascript">

		$(document).ready(function() {

	        $('#printDate').datetimepicker({
				 format: "YYYY-MM-DD HH:mm:ss"
		    });
	        $('#productionDate').datetimepicker({
				 format: "YYYY-MM-DD HH:mm:ss"
		    });
	        $('#packageDate').datetimepicker({
				 format: "YYYY-MM-DD HH:mm:ss"
		    });
	        $('#logisticsDate').datetimepicker({
				 format: "YYYY-MM-DD HH:mm:ss"
		    });
		});
		function save() {
            var isValidate = jp.validateForm('#inputForm');//校验表单
            if(!isValidate){
                return false;
			}else{
                jp.loading();
                jp.post("${ctx}/boxitem/scBoxItem/save",$('#inputForm').serialize(),function(data){
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
		<form:form id="inputForm" modelAttribute="scBoxItem" class="form-horizontal">
		<form:hidden path="id"/>	
		<table class="table table-bordered">
		   <tbody>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>生成编号：</label></td>
					<td class="width-35">
						<form:input path="serialNum" htmlEscape="false"    class="form-control required"/>
					</td>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>第几箱：</label></td>
					<td class="width-35">
						<form:input path="few" htmlEscape="false"    class="form-control required isIntGtZero"/>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">进度：</label></td>
					<td class="width-35">
						<form:select path="process" class="form-control ">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('process_box_item')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</td>
					<td class="width-15 active"><label class="pull-right">打印者：</label></td>
					<td class="width-35">
						<sys:userselect id="printUser" name="printUser.id" value="${scBoxItem.printUser.id}" labelName="printUser.name" labelValue="${scBoxItem.printUser.name}"
							    cssClass="form-control "/>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">打印时间：</label></td>
					<td class="width-35">
						<div class='input-group form_datetime' id='printDate'>
							<input type='text'  name="printDate" class="form-control "  value="<fmt:formatDate value="${scBoxItem.printDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
							<span class="input-group-addon">
								<span class="glyphicon glyphicon-calendar"></span>
							</span>
						</div>
					</td>
					<td class="width-15 active"><label class="pull-right">生产者：</label></td>
					<td class="width-35">
						<sys:userselect id="productionUser" name="productionUser.id" value="${scBoxItem.productionUser.id}" labelName="productionUser.name" labelValue="${scBoxItem.productionUser.name}"
							    cssClass="form-control "/>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">生产时间：</label></td>
					<td class="width-35">
						<div class='input-group form_datetime' id='productionDate'>
							<input type='text'  name="productionDate" class="form-control "  value="<fmt:formatDate value="${scBoxItem.productionDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
							<span class="input-group-addon">
								<span class="glyphicon glyphicon-calendar"></span>
							</span>
						</div>
					</td>
					<td class="width-15 active"><label class="pull-right">包装者：</label></td>
					<td class="width-35">
						<sys:userselect id="packageUser" name="packageUser.id" value="${scBoxItem.packageUser.id}" labelName="packageUser.name" labelValue="${scBoxItem.packageUser.name}"
							    cssClass="form-control "/>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">包装时间：</label></td>
					<td class="width-35">
						<div class='input-group form_datetime' id='packageDate'>
							<input type='text'  name="packageDate" class="form-control "  value="<fmt:formatDate value="${scBoxItem.packageDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
							<span class="input-group-addon">
								<span class="glyphicon glyphicon-calendar"></span>
							</span>
						</div>
					</td>
					<td class="width-15 active"><label class="pull-right">包装照片：</label></td>
					<td class="width-35">
						<sys:fileUpload path="photos"  value="${scBoxItem.photos}" type="file" uploadPath="/boxitem/scBoxItem"/>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">快递员：</label></td>
					<td class="width-35">
						<sys:userselect id="logisticsUser" name="logisticsUser.id" value="${scBoxItem.logisticsUser.id}" labelName="logisticsUser.name" labelValue="${scBoxItem.logisticsUser.name}"
							    cssClass="form-control "/>
					</td>
					<td class="width-15 active"><label class="pull-right">取件时间：</label></td>
					<td class="width-35">
						<div class='input-group form_datetime' id='logisticsDate'>
							<input type='text'  name="logisticsDate" class="form-control "  value="<fmt:formatDate value="${scBoxItem.logisticsDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
							<span class="input-group-addon">
								<span class="glyphicon glyphicon-calendar"></span>
							</span>
						</div>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">备注信息：</label></td>
					<td class="width-35">
						<form:input path="remarks" htmlEscape="false"    class="form-control "/>
					</td>
					<td class="width-15 active"></td>
		   			<td class="width-35" ></td>
		  		</tr>
		 	</tbody>
		</table>
	</form:form>
</body>
</html>