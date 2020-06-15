<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>订单管理</title>
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
                jp.post("${ctx}/order/scOrder/save",$('#inputForm').serialize(),function(data){
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
		<form:form id="inputForm" modelAttribute="scOrder" action="${ctx}/order/scOrder/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<table class="table table-bordered">
		   <tbody>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>代理人：</label></td>
					<td class="width-35">
						<form:input path="agentName" htmlEscape="false"    class="form-control required"/>
					</td>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>客户：</label></td>
					<td class="width-35">
						<sys:gridselect url="${ctx}/custom/scCustom/data" id="custom" name="custom.id" value="${scOrder.custom.id}" labelName="custom.username" labelValue="${scOrder.custom.username}"
							 title="选择客户" cssClass="form-control required" fieldLabels="姓名|电话|地址" fieldKeys="username|phone|address" searchLabels="姓名|电话" searchKeys="username|phone" ></sys:gridselect>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>物流公司：</label></td>
					<td class="width-35">
						<sys:treeselect id="logistics" name="logistics.id" value="${scOrder.logistics.id}" labelName="logistics.name" labelValue="${scOrder.logistics.name}"
							title="部门" url="/sys/office/treeData?type=2" cssClass="form-control required" allowClear="true" notAllowSelectParent="true"/>
					</td>
					<td class="width-15 active"><label class="pull-right">物流班次：</label></td>
					<td class="width-35">
						<form:select path="shift" class="form-control ">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('logistics_shift')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>所属加工厂：</label></td>
					<td class="width-35">
						<sys:treeselect id="factory" name="factory.id" value="${scOrder.factory.id}" labelName="factory.name" labelValue="${scOrder.factory.name}"
							title="部门" url="/sys/office/treeData?type=2" cssClass="form-control required" allowClear="true" notAllowSelectParent="true"/>
					</td>
					<td class="width-15 active"><label class="pull-right">状态：</label></td>
					<td class="width-35">
						<form:select path="status" class="form-control ">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('status_order')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">备注信息：</label></td>
					<td class="width-35">
						<form:textarea path="remarks" htmlEscape="false" rows="4"    class="form-control "/>
					</td>
					<td class="width-15 active"></td>
		   			<td class="width-35" ></td>
		  		</tr>
		 	</tbody>
		</table>

		<div class="tabs-container">
            <ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">箱子：</a>
                </li>
            </ul>
            <div class="tab-content">
				<div id="tab-1" class="tab-pane fade in  active">
			<a class="btn btn-white btn-sm" onclick="addRow('#scBoxList', scBoxRowIdx, scBoxTpl);scBoxRowIdx = scBoxRowIdx + 1;" title="新增"><i class="fa fa-plus"></i> 新增</a>
			<table class="table table-striped table-bordered table-condensed">
				<thead>
					<tr>
						<th class="hide"></th>
						<th width="60">详情</th>
						<th width="120"><font color="red">*</font>规格</th>
						<th width="100"><font color="red">*</font>每箱重量（斤）</th>
						<th width="100"><font color="red">*</font>数量（箱）</th>
						<th width="150">调拨工厂</th>
						<th width="80"><font color="red">*</font>状态</th>
						<th>备注信息</th>
						<th width="10">&nbsp;</th>
					</tr>
				</thead>
				<tbody id="scBoxList">
				</tbody>
			</table>
			<script type="text/jsp" id="scBoxTpl">//<!--
				<tr id="scBoxList{{idx}}">
					<td class="hide">
						<input id="scBoxList{{idx}}_id" name="scBoxList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
						<input id="scBoxList{{idx}}_delFlag" name="scBoxList[{{idx}}].delFlag" type="hidden" value="0"/>
					</td>

					<td class="text-center">
						<a class="" onclick="showDetailDialog('{{row.id}}');">详情</a>
					</td>

					<td>
						<input id="scBoxList{{idx}}_spec" name="scBoxList[{{idx}}].spec" type="text" value="{{row.spec}}"    class="form-control required"/>
					</td>


					<td>
						<input id="scBoxList{{idx}}_weight" name="scBoxList[{{idx}}].weight" type="text" value="{{row.weight}}"    class="form-control required isFloatGtZero"/>
					</td>


					<td>
						<input id="scBoxList{{idx}}_count" name="scBoxList[{{idx}}].count" type="text" value="{{row.count}}"    class="form-control required isIntGtZero"/>
					</td>
					<td  class="max-width-250">
						<sys:treeselect id="scBoxList{{idx}}_allotFactory" name="scBoxList[{{idx}}].allotFactory.id" value="{{row.allotFactory.id}}" labelName="scBoxList{{idx}}.allotFactory.name" labelValue="{{row.allotFactory.name}}"
							title="部门" url="/sys/office/treeData?type=2" cssClass="form-control  " allowClear="true" notAllowSelectParent="true"/>
					</td>
					<td>
						<select id="scBoxList{{idx}}_status" name="scBoxList[{{idx}}].status" data-value="{{row.status}}" class="form-control m-b  required">
							<option value=""></option>
							<c:forEach items="${fns:getDictList('status_box')}" var="dict">
								<option value="${dict.value}">${dict.label}</option>
							</c:forEach>
						</select>
					</td>
					<td>
						<input id="scBoxList{{idx}}_remarks" name="scBoxList[{{idx}}].remarks" type="text" value="{{row.remarks}}"    class="form-control "/>
					</td>

					<td class="text-center" width="10">
						{{#delBtn}}<span class="close" onclick="delRow(this, '#scBoxList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
					</td>
				</tr>
				//-->
			</script>
			<script type="text/javascript">
				var scBoxRowIdx = 0, scBoxTpl = $("#scBoxTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
				$(document).ready(function() {
					var data = ${fns:toJson(scOrder.scBoxList)};
					for (var i=0; i<data.length; i++){
						addRow('#scBoxList', scBoxRowIdx, scBoxTpl, data[i]);
						scBoxRowIdx = scBoxRowIdx + 1;
					}
				});
			</script>
			</div>
		</div>
		</div>
		</form:form>
</body>
</html>