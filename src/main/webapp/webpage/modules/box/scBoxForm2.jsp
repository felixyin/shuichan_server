<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<html>
<head>
    <title>包装箱管理</title>
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
                jp.post("${ctx}/box/scBox/save", $('#inputForm').serialize(), function (data) {
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
    <table class="table table-bordered">
    <tbody>
    <tr>
        <td class="width-15 active"><label class="pull-right">装箱单号：</label></td>
        <td class="width-35">
            <form:input path="no" htmlEscape="false"    class="form-control "/>
        </td>
        <td class="width-15 active"><label class="pull-right"><font color="red">*</font>规格：</label></td>
        <td class="width-35">
            <form:input path="spec" htmlEscape="false"    class="form-control required"/>
        </td>
    </tr>
    <tr>
        <td class="width-15 active"><label class="pull-right"><font color="red">*</font>每箱重量（斤）：</label></td>
        <td class="width-35">
            <form:input path="weight" htmlEscape="false"    class="form-control required isFloatGtZero"/>
        </td>
        <td class="width-15 active"><label class="pull-right"><font color="red">*</font>数量（箱）：</label></td>
        <td class="width-35">
            <form:input path="count" htmlEscape="false"    class="form-control required isIntGtZero"/>
        </td>
    </tr>
    <tr>
        <td class="width-15 active"><label class="pull-right">每斤价格：</label></td>
        <td class="width-35">
            <form:input path="singlePrice" htmlEscape="false"    class="form-control "/>
        </td>
        <td class="width-15 active"><label class="pull-right">总计价格：</label></td>
        <td class="width-35">
            <form:input path="totalPrice" htmlEscape="false"    class="form-control "/>
        </td>
    </tr>
    <tr>
        <td class="width-15 active"><label class="pull-right">已发货总价：</label></td>
        <td class="width-35">
            <form:input path="deliverTotalPrice" htmlEscape="false"    class="form-control "/>
        </td>
        <td class="width-15 active"><label class="pull-right">单箱快递费：</label></td>
        <td class="width-35">
            <form:input path="logisticsPrice" htmlEscape="false"    class="form-control "/>
        </td>
    </tr>
    <tr>
        <td class="width-15 active"><label class="pull-right">总计快递费：</label></td>
        <td class="width-35">
            <form:input path="logisticsTotalPrice" htmlEscape="false"    class="form-control "/>
        </td>
        <td class="width-15 active"><label class="pull-right">调拨工厂：</label></td>
        <td class="width-35">
            <sys:treeselect id="allotFactory" name="allotFactory.id" value="${scBox.allotFactory.id}" labelName="allotFactory.name" labelValue="${scBox.allotFactory.name}"
                            title="部门" url="/sys/office/treeData?type=2" cssClass="form-control " allowClear="true" notAllowSelectParent="true"/>
        </td>
    </tr>
    <tr>
        <td class="width-15 active"><label class="pull-right"><font color="red">*</font>状态：</label></td>
        <td class="width-35">
            <form:select path="status" class="form-control required">
                <form:option value="" label=""/>
                <form:options items="${fns:getDictList('status_box')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
            </form:select>
        </td>
        <td class="width-15 active"><label class="pull-right">备注信息：</label></td>
        <td class="width-35">
            <form:input path="remarks" htmlEscape="false"    class="form-control "/>
        </td>
    </tr>
    </tbody>
</table>
    <div class="tabs-container">
        <ul class="nav nav-tabs">
            <li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">每箱：</a>
            </li>
        </ul>
        <div class="tab-content">
            <div id="tab-1" class="tab-pane fade in  active">
                <a class="btn btn-white btn-sm" onclick="addRow('#scBoxItemList', scBoxItemRowIdx, scBoxItemTpl);scBoxItemRowIdx = scBoxItemRowIdx + 1;"
                   title="新增"><i class="fa fa-plus"></i> 新增</a>
                <table class="table table-striped table-bordered table-condensed">
                    <thead>
                    <tr>
                        <th class="hide"></th>
                        <th><font color="red">*</font>生成编号</th>
                        <th><font color="red">*</font>第几箱</th>
                        <th>进度</th>
                        <th>打印者</th>
                        <th>打印时间</th>
                        <th>生产者</th>
                        <th>生产时间</th>
                        <th>包装者</th>
                        <th>包装时间</th>
                        <th>包装照片</th>
                        <th>快递员</th>
                        <th>取件时间</th>
                        <th>备注信息</th>
                        <th width="10">&nbsp;</th>
                    </tr>
                    </thead>
                    <tbody id="scBoxItemList">
                    </tbody>
                </table>
                <script type="text/template" id="scBoxItemTpl">//<!--
				<tr id="scBoxItemList{{idx}}">
					<td class="hide">
						<input id="scBoxItemList{{idx}}_id" name="scBoxItemList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
						<input id="scBoxItemList{{idx}}_delFlag" name="scBoxItemList[{{idx}}].delFlag" type="hidden" value="0"/>
					</td>
					
					<td>
						<input id="scBoxItemList{{idx}}_serialNum" name="scBoxItemList[{{idx}}].serialNum" type="text" value="{{row.serialNum}}"    class="form-control required"/>
					</td>
					
					
					<td>
						<input id="scBoxItemList{{idx}}_few" name="scBoxItemList[{{idx}}].few" type="text" value="{{row.few}}"    class="form-control required isIntGtZero"/>
					</td>
					
					
					<td>
						<select id="scBoxItemList{{idx}}_process" name="scBoxItemList[{{idx}}].process" data-value="{{row.process}}" class="form-control m-b  ">
							<option value=""></option>
							<c:forEach items="${fns:getDictList('process_box_item')}" var="dict">
								<option value="${dict.value}">${dict.label}</option>
							</c:forEach>
						</select>
					</td>
					
					
					<td  class="max-width-250">
						<sys:userselect id="scBoxItemList{{idx}}_printUser" name="scBoxItemList[{{idx}}].printUser.id" value="{{row.printUser.id}}" labelName="scBoxItemList{{idx}}.printUser.name" labelValue="{{row.printUser.name}}"
							    cssClass="form-control "/>
					</td>
					
					
					<td>
						<div class='input-group form_datetime' id="scBoxItemList{{idx}}_printDate">
		                    <input type='text'  name="scBoxItemList[{{idx}}].printDate" class="form-control "  value="{{row.printDate}}"/>
		                    <span class="input-group-addon">
		                        <span class="glyphicon glyphicon-calendar"></span>
		                    </span>
		                </div>						            
					</td>
					
					
					<td  class="max-width-250">
						<sys:userselect id="scBoxItemList{{idx}}_productionUser" name="scBoxItemList[{{idx}}].productionUser.id" value="{{row.productionUser.id}}" labelName="scBoxItemList{{idx}}.productionUser.name" labelValue="{{row.productionUser.name}}"
							    cssClass="form-control "/>
					</td>
					
					
					<td>
						<div class='input-group form_datetime' id="scBoxItemList{{idx}}_productionDate">
		                    <input type='text'  name="scBoxItemList[{{idx}}].productionDate" class="form-control "  value="{{row.productionDate}}"/>
		                    <span class="input-group-addon">
		                        <span class="glyphicon glyphicon-calendar"></span>
		                    </span>
		                </div>						            
					</td>
					
					
					<td  class="max-width-250">
						<sys:userselect id="scBoxItemList{{idx}}_packageUser" name="scBoxItemList[{{idx}}].packageUser.id" value="{{row.packageUser.id}}" labelName="scBoxItemList{{idx}}.packageUser.name" labelValue="{{row.packageUser.name}}"
							    cssClass="form-control "/>
					</td>
					
					
					<td>
						<div class='input-group form_datetime' id="scBoxItemList{{idx}}_packageDate">
		                    <input type='text'  name="scBoxItemList[{{idx}}].packageDate" class="form-control "  value="{{row.packageDate}}"/>
		                    <span class="input-group-addon">
		                        <span class="glyphicon glyphicon-calendar"></span>
		                    </span>
		                </div>						            
					</td>
					
					
					<td>
									<sys:fileUpload path="scBoxItemList{{idx}}_photos"  value="{{row.photos}}" type="file" uploadPath="/box/scBox"/>
					</td>
					
					
					<td  class="max-width-250">
						<sys:userselect id="scBoxItemList{{idx}}_logisticsUser" name="scBoxItemList[{{idx}}].logisticsUser.id" value="{{row.logisticsUser.id}}" labelName="scBoxItemList{{idx}}.logisticsUser.name" labelValue="{{row.logisticsUser.name}}"
							    cssClass="form-control "/>
					</td>
					
					
					<td>
						<div class='input-group form_datetime' id="scBoxItemList{{idx}}_logisticsDate">
		                    <input type='text'  name="scBoxItemList[{{idx}}].logisticsDate" class="form-control "  value="{{row.logisticsDate}}"/>
		                    <span class="input-group-addon">
		                        <span class="glyphicon glyphicon-calendar"></span>
		                    </span>
		                </div>						            
					</td>
					
					
					<td>
						<input id="scBoxItemList{{idx}}_remarks" name="scBoxItemList[{{idx}}].remarks" type="text" value="{{row.remarks}}"    class="form-control "/>
					</td>
					
					<td class="text-center" width="10">
						{{#delBtn}}<span class="close" onclick="delRow(this, '#scBoxItemList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
					</td>
				</tr>//-->
                </script>
                <script type="text/javascript">
                    var scBoxItemRowIdx = 0, scBoxItemTpl = $("#scBoxItemTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                    $(document).ready(function () {
                        var data = ${fns:toJson(scBox.scBoxItemList)};
                        for (var i = 0; i < data.length; i++) {
                            addRow('#scBoxItemList', scBoxItemRowIdx, scBoxItemTpl, data[i]);
                            scBoxItemRowIdx = scBoxItemRowIdx + 1;
                        }
                    });
                </script>
            </div>
        </div>
    </div>
</form:form>
</body>
</html>