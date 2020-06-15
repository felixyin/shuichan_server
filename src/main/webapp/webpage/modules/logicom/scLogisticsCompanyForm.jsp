<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>物流公司管理</title>
	<meta name="decorator" content="ani"/>
	<script type="text/javascript">

		$(document).ready(function() {
		});

		function save() {
            var isValidate = jp.validateForm('#inputForm');//校验表单
            if(!isValidate){
                return false;
			}else{
                jp.loading();
                jp.post("${ctx}/logicom/scLogisticsCompany/save",$('#inputForm').serialize(),function(data){
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
		function addRow(list, idx, tpl, row){
			$(list).append(Mustache.render(tpl, {
				idx: idx, delBtn: true, row: row
			}));
			$(list+idx).find("select").each(function(){
				$(this).val($(this).attr("data-value"));
			});
			$(list+idx).find("input[type='checkbox'], input[type='radio']").each(function(){
				var ss = $(this).attr("data-value").split(',');
				for (var i=0; i<ss.length; i++){
					if($(this).val() == ss[i]){
						$(this).attr("checked","checked");
					}
				}
			});
			$(list+idx).find(".form_datetime").each(function(){
				 $(this).datetimepicker({
					 format: "YYYY-MM-DD HH:mm:ss"
			    });
			});
		}
		function delRow(obj, prefix){
			var id = $(prefix+"_id");
			var delFlag = $(prefix+"_delFlag");
			if (id.val() == ""){
				$(obj).parent().parent().remove();
			}else if(delFlag.val() == "0"){
				delFlag.val("1");
				$(obj).html("&divide;").attr("title", "撤销删除");
				$(obj).parent().parent().addClass("error");
			}else if(delFlag.val() == "1"){
				delFlag.val("0");
				$(obj).html("&times;").attr("title", "删除");
				$(obj).parent().parent().removeClass("error");
			}
		}
	</script>
</head>
<body class="bg-white">
		<form:form id="inputForm" modelAttribute="scLogisticsCompany" action="${ctx}/logicom/scLogisticsCompany/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<table class="table table-bordered">
		   <tbody>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>物流名称：</label></td>
					<td class="width-35">
						<form:input path="name" htmlEscape="false"    class="form-control required"/>
					</td>
					<td class="width-15 active"><label class="pull-right">备注信息：</label></td>
					<td class="width-35">
						<form:textarea path="remarks" htmlEscape="false" rows="4"    class="form-control "/>
					</td>
				</tr>
		 	</tbody>
		</table>
		<div class="tabs-container">
            <ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">物流价格：</a>
                </li>
				<li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false">快递员：</a>
                </li>
            </ul>
            <div class="tab-content">
				<div id="tab-1" class="tab-pane fade in  active">
			<a class="btn btn-white btn-sm" onclick="addRow('#scLogisticsPriceList', scLogisticsPriceRowIdx, scLogisticsPriceTpl);scLogisticsPriceRowIdx = scLogisticsPriceRowIdx + 1;" title="新增"><i class="fa fa-plus"></i> 新增</a>
			<table class="table table-striped table-bordered table-condensed">
				<thead>
					<tr>
						<th class="hide"></th>
						<th><font color="red">*</font>箱大于几斤</th>
						<th><font color="red">*</font>箱小于几斤</th>
						<th><font color="red">*</font>配送费</th>
						<th>备注信息</th>
						<th width="10">&nbsp;</th>
					</tr>
				</thead>
				<tbody id="scLogisticsPriceList">
				</tbody>
			</table>
			<script type="text/template" id="scLogisticsPriceTpl">//<!--
				<tr id="scLogisticsPriceList{{idx}}">
					<td class="hide">
						<input id="scLogisticsPriceList{{idx}}_id" name="scLogisticsPriceList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
						<input id="scLogisticsPriceList{{idx}}_delFlag" name="scLogisticsPriceList[{{idx}}].delFlag" type="hidden" value="0"/>
					</td>
					
					<td>
						<input id="scLogisticsPriceList{{idx}}_gtJin" name="scLogisticsPriceList[{{idx}}].gtJin" type="text" value="{{row.gtJin}}"    class="form-control required isIntGteZero"/>
					</td>
					
					
					<td>
						<input id="scLogisticsPriceList{{idx}}_ltJin" name="scLogisticsPriceList[{{idx}}].ltJin" type="text" value="{{row.ltJin}}"    class="form-control required isIntGtZero"/>
					</td>
					
					
					<td>
						<input id="scLogisticsPriceList{{idx}}_price" name="scLogisticsPriceList[{{idx}}].price" type="text" value="{{row.price}}"    class="form-control required isFloatGtZero"/>
					</td>
					
					
					<td>
						<input id="scLogisticsPriceList{{idx}}_remarks" name="scLogisticsPriceList[{{idx}}].remarks" type="text" value="{{row.remarks}}"    class="form-control "/>
					</td>
					
					<td class="text-center" width="10">
						{{#delBtn}}<span class="close" onclick="delRow(this, '#scLogisticsPriceList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
					</td>
				</tr>//-->
			</script>
			<script type="text/javascript">
				var scLogisticsPriceRowIdx = 0, scLogisticsPriceTpl = $("#scLogisticsPriceTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
				$(document).ready(function() {
					var data = ${fns:toJson(scLogisticsCompany.scLogisticsPriceList)};
					for (var i=0; i<data.length; i++){
						addRow('#scLogisticsPriceList', scLogisticsPriceRowIdx, scLogisticsPriceTpl, data[i]);
						scLogisticsPriceRowIdx = scLogisticsPriceRowIdx + 1;
					}
				});
			</script>
			</div>
				<div id="tab-2" class="tab-pane fade">
			<a class="btn btn-white btn-sm" onclick="addRow('#scLogisticsUserList', scLogisticsUserRowIdx, scLogisticsUserTpl);scLogisticsUserRowIdx = scLogisticsUserRowIdx + 1;" title="新增"><i class="fa fa-plus"></i> 新增</a>
			<table class="table table-striped table-bordered table-condensed">
				<thead>
					<tr>
						<th class="hide"></th>
						<th><font color="red">*</font>登录用户</th>
						<th><font color="red">*</font>状态</th>
						<th>备注信息</th>
						<th width="10">&nbsp;</th>
					</tr>
				</thead>
				<tbody id="scLogisticsUserList">
				</tbody>
			</table>
			<script type="text/template" id="scLogisticsUserTpl">//<!--
				<tr id="scLogisticsUserList{{idx}}">
					<td class="hide">
						<input id="scLogisticsUserList{{idx}}_id" name="scLogisticsUserList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
						<input id="scLogisticsUserList{{idx}}_delFlag" name="scLogisticsUserList[{{idx}}].delFlag" type="hidden" value="0"/>
					</td>
					
					<td  class="max-width-250">
						<sys:userselect id="scLogisticsUserList{{idx}}_user" name="scLogisticsUserList[{{idx}}].user.id" value="{{row.user.id}}" labelName="scLogisticsUserList{{idx}}.user.name" labelValue="{{row.user.name}}"
							    cssClass="form-control required"/>
					</td>
					
					
					<td>
						<select id="scLogisticsUserList{{idx}}_status" name="scLogisticsUserList[{{idx}}].status" data-value="{{row.status}}" class="form-control m-b  required">
							<option value=""></option>
							<c:forEach items="${fns:getDictList('logi_com_user_status')}" var="dict">
								<option value="${dict.value}">${dict.label}</option>
							</c:forEach>
						</select>
					</td>
					
					
					<td>
						<textarea id="scLogisticsUserList{{idx}}_remarks" name="scLogisticsUserList[{{idx}}].remarks" rows="4"    class="form-control ">{{row.remarks}}</textarea>
					</td>
					
					<td class="text-center" width="10">
						{{#delBtn}}<span class="close" onclick="delRow(this, '#scLogisticsUserList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
					</td>
				</tr>//-->
			</script>
			<script type="text/javascript">
				var scLogisticsUserRowIdx = 0, scLogisticsUserTpl = $("#scLogisticsUserTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
				$(document).ready(function() {
					var data = ${fns:toJson(scLogisticsCompany.scLogisticsUserList)};
					for (var i=0; i<data.length; i++){
						addRow('#scLogisticsUserList', scLogisticsUserRowIdx, scLogisticsUserTpl, data[i]);
						scLogisticsUserRowIdx = scLogisticsUserRowIdx + 1;
					}
				});
			</script>
			</div>
		</div>
		</div>
		</form:form>
</body>
</html>