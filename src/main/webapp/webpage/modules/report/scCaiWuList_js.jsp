<%@ page contentType="text/html;charset=UTF-8" %>

<%--<link rel="stylesheet" href="${ctxStatic}/plugin/bootstrap-table/extensions/fixed-columns/bootstrap-table-fixed-columns.min.css">--%>
<%--<script src="${ctxStatic}/plugin/bootstrap-table/bootstrap-table.js"></script>--%>
<%--<script src="${ctxStatic}/plugin/bootstrap-table/extensions/fixed-columns/bootstrap-table-fixed-columns.js"></script>--%>
<script>
    function validate_phone(value) {
        var tv = $.trim(value);
        if (tv == '') {
            jp.error('这是必填项');
            return '这是必填项';
        }
        if (!$.isNumeric(tv)) {
            jp.error('请填写手机号');
            return '请填写手机号';
        }
        if (!(/^1[3456789]\d{9}$/.test(value))) {
            jp.error('手机号码有误');
            return "手机号码有误";
        }
    }

    function validate_number(value) {
        var tv = $.trim(value);
        if (tv == '') {
            return '这是必填项';
        }
        if (!$.isNumeric(tv)) {
            return '请填写数字';
        }
        if (tv < 0 || tv > 1000000) {
            return '数值不正常';
        }
    };

    function validate_required(value) {
        var tv = $.trim(value);
        if (tv == '') {
            return '这是必填项';
        }
    }
</script>
<%@include file="scBoxList_js.jsp" %>
<script>

    function detailFormatter2(index, row) {
        var htmltpl = $("#scBoxChildrenTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
        var html = Mustache.render(htmltpl, {
            idx: row.id
        });
        $.get("${ctx}/box/scBox/detail?id=" + row.id, function (scBox) {
            var scBoxChild1RowIdx = 0,
                scBoxChild1Tpl = $("#scBoxChild1Tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
            var data1 = scBox.scBoxItemList;
            for (var i = 0; i < data1.length; i++) {
                data1[i].dict = {};
                data1[i].dict.process = jp.getDictLabel(${fns:toJson(fns:getDictList('process_box_item'))}, data1[i].process, "-");
                addRow('#scBoxChild-' + row.id + '-1-List', scBoxChild1RowIdx, scBoxChild1Tpl, data1[i]);
                scBoxChild1RowIdx = scBoxChild1RowIdx + 1;
            }


        })

        return html;
    }

    // 订单表格
    var $orderTable;
    $(document).ready(function () {
        $("#search-collapse").slideToggle();

        // 双击行，自动展开明细
        $(document).on('dblclick', 'tbody>tr:not(".detail-view")', function () {
            $(this).find('.detail-icon').click();
        });

        $orderTable = $('#scOrderTable');

        function onEditableShownForOrder(_field, _row, _rowIndex, _$el) {
            if (_row.agent_name === '汇总') { // 汇总行id 为 '-1'
                jp.warning('汇总行，无法保存金额！')
                return false;
            }
            return true;
        }

        function onEditableHiddenForOrder(_field, _row, _$el, _reason) {
            return true;
        }

        function onEditableSaveForOrder(_field, _row, _rowIndex, _oldValue, _$el) {
            // console.log('save', _field, _row, _rowIndex, _oldValue);
            // console.log('save', _$el);
            if (_row.agent_name === '汇总') { // 汇总行id 为 '-1'
                jp.warning('汇总行，无法保存金额！')
                return false;
            }
            // ajax 请求保存数据
            // console.log(data);
            jp.post('${ctx}/report/scReport/saveRealPayPrice', _row, function (result) {
                if (result) {
                    // ajax 查询订单数据，更新订单表格
                    jp.success('实付款保存成功');
                } else {
                    jp.error('保存失败，或超级管理员不允许修改客户的财务数据！');
                }
                $('#scOrderTable').bootstrapTable('refresh');
            });
        }


        $('#scOrderTable').bootstrapTable({

            //请求方法
            method: 'post',
            //类型json
            dataType: "json",
            contentType: "application/x-www-form-urlencoded",
            //显示检索按钮
            showSearch: false,
            //显示刷新按钮
            showRefresh: false,
            //显示切换手机试图按钮
            showToggle: false,
            //显示 内容列下拉框
            showColumns: false,
            //显示到处按钮
            showExport: false,
            //显示切换分页按钮
            showPaginationSwitch: false,
            //显示详情按钮
            detailView: true,
            //显示详细内容函数
            // detailFormatter: "onExpandRow", // todo 临时禁用，开发到这里的时候打开
            //最低显示2行
            minimumCountColumns: 2,
            //是否显示行间隔色
            striped: true,
            //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
            cache: false,
            // 固定列
            fixedColumns: true,
            fixedNumber: 2,
            //是否显示分页（*）
            pagination: true,
            //排序方式
            sortOrder: "asc",
            //初始化加载第一页，默认第一页
            pageNumber: 1,
            //每页的记录行数（*）
            pageSize: 100000,
            //可供选择的每页的行数（*）
            pageList: [100, 250, 500, 1000],
            //这个接口需要处理bootstrap table传递的固定参数,并返回特定格式的json数据
            url: "${ctx}/report/scReport/findCaiWuReportList",
            //默认值为 'limit',传给服务端的参数为：limit, offset, search, sort, order Else
            //queryParamsType:'',
            ////查询参数,每次调用是会带上这个参数，可自定义
            queryParams: function (params) {
                var searchParam = $("#searchForm").serializeJSON();
                searchParam.pageNo = params.limit === undefined ? "1" : params.offset / params.limit + 1;
                searchParam.pageSize = params.limit === undefined ? -1 : params.limit;
                searchParam.orderBy = params.sort === undefined ? "" : params.sort + " " + params.order;
                return searchParam;
            },
            //分页方式：client客户端分页，server服务端分页（*）
            sidePagination: "server",
            onExpandRow: onExpandRow,
            contextMenuTrigger: "right",//pc端 按右键弹出菜单
            contextMenuTriggerMobile: "press",//手机端 弹出菜单，click：单击， press：长按。
            contextMenu: '#context-menu',
            onContextMenuItem: function (row, $el) {
                if ($el.data("item") == "edit") {
                    edit(row.id);
                } else if ($el.data("item") == "view") {
                    view(row.id);
                } else if ($el.data("item") == "delete") {
                    jp.confirm('确认要删除该订单记录吗？', function () {
                        jp.loading();
                        jp.get("${ctx}/report/scReport/delete?id=" + row.id, function (data) {
                            if (data.success) {
                                $('#scOrderTable').bootstrapTable('refresh');
                                jp.success(data.msg);
                            } else {
                                jp.error(data.msg);
                            }
                        })

                    });

                }
            },

            onClickRow: function (row, $el) {
            },
            onShowSearch: function () {
                $("#search-collapse").slideToggle();
            },
            onEditableInit: function () {
                // console.log('init', arguments);
                return true;
            },
            onEditableShown: onEditableShownForOrder,
            onEditableHidden: onEditableHiddenForOrder,
            onEditableSave: onEditableSaveForOrder,
            columns: [
                {
                    field: 'deliver_date',
                    title: '日期',
                    sortable: true,
                    sortName: 'deliver_date'
                    , formatter: function (value, row, index) {
                        <%--value = jp.unescapeHTML(value);--%>
                        <%--if (!value) return '';--%>
                        <%--<c:choose>--%>
                        <%--<c:when test="${fns:hasPermission('order:scOrder:edit')}">--%>
                        <%--return "<a href='javascript:view(\"" + row.id + "\")'>" + value + "</a>";--%>
                        <%--</c:when>--%>
                        <%--<c:when test="${fns:hasPermission('order:scOrder:view')}">--%>
                        <%--return "<a href='javascript:view(\"" + row.id + "\")'>" + value + "</a>";--%>
                        <%--</c:when>--%>
                        <%--<c:otherwise>--%>
                        <%--return value;--%>
                        <%--</c:otherwise>--%>
                        <%--</c:choose>--%>
                        return value;
                    }
                }
                , {
                    field: 'agent_name',
                    title: '代理人',
                    sortable: true,
                    sortName: 'agent_name'
                }
                , {
                    field: 'will_pay_price',
                    title: '订单金额',
                    sortable: true,
                    sortName: 'will_pay_price'
                }
                , {
                    field: 'deliver_pay_price',
                    title: '包装&发货金额',
                    // width:'30%',
                    sortable: true,
                    sortName: 'deliver_pay_price'
                }
                , {
                    field: 'real_pay_price',
                    title: '实收金额',
                    sortable: true,
                    sortName: 'real_pay_price',
                    formatter: function (value, row, index) {
                        return value;
                    },
                    editable: {
                        mode: 'inline',
                        type: 'number',
                        showbuttons: false,
                        // validate: validate_required,
                        clear: false
                    }
                }
                , {
                    field: 'pay_user_name',
                    title: '收款人',
                    sortable: false,
                    sortName: 'pay_user_name',
                    formatter: function (value, row, index) {
                        if (row.real_pay_price === 0) {
                            return '';
                        }
                        return value;
                    }
                }
                , {
                    field: 'pay_date',
                    title: '收款时间',
                    sortable: false,
                    sortName: 'pay_date',
                    formatter: function (value, row, index) {
                        if (row.real_pay_price === 0) {
                            return '';
                        }
                        return value;
                    }
                },
                {
                    title: '操作',
                    formatter: function (value, row, index) {
                        if (row.deliver_date !== '-') {
                            return '<a href="javascript:void(0);" onclick="exportPayOrder(\'' + row.agent_name + '\', ' + index + ')">导出账单</a>';
                        } else {
                            return '';
                        }
                    }
                }
            ]
        });


        if (navigator.userAgent.match(/(iPhone|iPod|Android|ios)/i)) {//如果是移动端


            $('#scOrderTable').bootstrapTable("toggleView");
        }

        $('#scOrderTable').on('check.bs.table uncheck.bs.table load-success.bs.table ' +
            'check-all.bs.table uncheck-all.bs.table', function () {
            $('#remove').prop('disabled', !$('#scOrderTable').bootstrapTable('getSelections').length);
            $('#view,#edit').prop('disabled', $('#scOrderTable').bootstrapTable('getSelections').length != 1);
        });

        $("#btnImport").click(function () {
            jp.open({
                type: 2,
                area: [500, 200],
                auto: true,
                title: "导入数据",
                content: "${ctx}/tag/importExcel",
                btn: ['下载模板', '确定', '关闭'],
                btn1: function (index, layero) {
                    jp.downloadFile('${ctx}/report/scReport/import/template');
                },
                btn2: function (index, layero) {
                    var iframeWin = layero.find('iframe')[0]; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
                    iframeWin.contentWindow.importExcel('${ctx}/report/scReport/import', function (data) {
                        if (data.success) {
                            jp.success(data.msg);
                            refresh();
                        } else {
                            jp.error(data.msg);
                        }
                        jp.close(index);
                    });//调用保存事件
                    return false;
                },

                btn3: function (index) {
                    jp.close(index);
                }
            });
        });
        $("#export").click(function () {//导出Excel文件
            var searchParam = $("#searchForm").serializeJSON();
            searchParam.pageNo = 1;
            searchParam.pageSize = -1;
            var sortName = $('#scOrderTable').bootstrapTable("getOptions", "none").sortName;
            var sortOrder = $('#scOrderTable').bootstrapTable("getOptions", "none").sortOrder;
            var values = "";
            for (var key in searchParam) {
                values = values + key + "=" + searchParam[key] + "&";
            }
            if (sortName != undefined && sortOrder != undefined) {
                values = values + "orderBy=" + sortName + " " + sortOrder;
            }

            jp.downloadFile('${ctx}/report/scReport/export?' + values);
        })
        $("#search").click("click", function () {// 绑定查询按扭
            $('#scOrderTable').bootstrapTable('refresh');
        });

        $("#reset").click("click", function () {// 绑定查询按扭
            $("#searchForm  input").val("");
            $("#searchForm  select").find("option:selected").attr("selected", false).end().find("option").first().attr("selected", true);
            $("#searchForm  .select-item").html("");
            var dateStr = jp.dateFormat(new Date(), 'YYYY-M-d');
            if (dateStr) {
                $('#beginDate_laji,#endDate_laji').val(dateStr);
            }
            $('#scOrderTable').bootstrapTable('refresh');
        });

        $('#beginDeliverDate').datetimepicker({
            format: "YYYY-MM-DD HH:mm:ss"
        });
        $('#endDeliverDate').datetimepicker({
            format: "YYYY-MM-DD HH:mm:ss"
        });
        $('#createDate').datetimepicker({
            format: "YYYY-MM-DD"
        });

        fixDateTimepicker('beginDate', '${beginDate}');
        fixDateTimepicker('endDate', '${beginDate}');

    });
    $(function () {
        $(document.body).on('keyup', '.canEditSpec', function (evt) {
            console.log(evt.keyCode);
            if (evt.keyCode === 13) {
                evt.stopPropagation();
                evt.preventDefault();
                var v = $.trim($(this).text());
                if (!$.isNumeric(v)) {
                    jp.error('请填写数值！');
                    return;
                }

                console.log(v);
                alert(v);
                return;
            }
        });
    });

    function fixDateTimepicker(idStr, date) {
        $('#' + idStr).datetimepicker({
            format: "YYYY-MM-DD",
            defaultDate: new Date(),
        });
        /*var laji = $('#' + idStr + '_laji').get(0);
        var laji2 = '';
        setInterval(function () {
            if (laji2 != laji.value) {
                refresh();
                laji2 = laji.value;
            }
        }, 100);*/
    }

    function getIdSelections() {
        return $.map($("#scOrderTable").bootstrapTable('getSelections'), function (row) {
            return row.id
        });
    }

    function deleteAll() {

        jp.confirm('确认要删除该订单记录吗？', function () {
            jp.loading();
            jp.get("${ctx}/report/scReport/deleteAll?ids=" + getIdSelections(), function (data) {
                if (data.success) {
                    $('#scOrderTable').bootstrapTable('refresh');
                    jp.success(data.msg);
                } else {
                    jp.error(data.msg);
                }
            })

        })
    }

    //刷新列表
    function refresh() {
        $('#scOrderTable').bootstrapTable('refresh');
    }

    function add() {
        jp.go("${ctx}/report/scReport/form/add");
    }

    function edit(id) {//没有权限时，不显示确定按钮
        if (id == undefined) {
            id = getIdSelections();
        }
        jp.go("${ctx}/report/scReport/form/edit?id=" + id);
    }


    function view(id) {//没有权限时，不显示确定按钮
        if (id == undefined) {
            id = getIdSelections();
        }
        <%--jp.go("${ctx}/report/scReport/form/view?id=" + id);--%>
        jp.openViewDialog('查看订单详情', "${ctx}/report/scReport/form/view?id=" + id, '70%', '65%');
    }


    function detailFormatter(index, row) {
        if (row.agent_name === '汇总') { // 汇总行id 为 '-1'
            //jp.warning('汇总行，无法展开！')
            return;
        }
        var htmltpl = $("#scOrderChildrenTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
        var html = Mustache.render(htmltpl, {
            idx: (row.agent_name + row.deliver_date)
        });
        var beginDate = $('#beginDate_laji').val();
        var endDate = $('#endDate_laji').val();
        $.get("${ctx}/report/scReport/findCaiWuItemReportList?&date=" + row.deliver_date + '&agentName=' + row.agent_name, function (data) {
            var scOrderChild1RowIdx = 0,
                scOrderChild1Tpl = $("#scOrderChild1Tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");

            var data1 = data.rows;
            for (var i = 0; i < data1.length; i++) {
                addRow('#scOrderChild-' + (row.agent_name + row.deliver_date) + '-1-List', scOrderChild1RowIdx, scOrderChild1Tpl, data1[i]);
                scOrderChild1RowIdx = scOrderChild1RowIdx + 1;
            }
        });

        return html;
    }

    function addRow(list, idx, tpl, row) {
        $(list).append(Mustache.render(tpl, {
            idx: idx, delBtn: true, row: row
        }));
    }

    function printDeliveryOrder() {
        alert('打印出货单');
    }

    function setPrintDeliveryOrder() {
        alert('设置打印出货单');
    }

</script>
<script type="text/template" id="scOrderChildrenTpl">//<!--
	<div class="tabs-container">
		<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-{{idx}}-1" aria-expanded="true">规格明细</a></li>
		</ul>
		<div class="tab-content">
				 <div id="tab-{{idx}}-1" class="tab-pane fade in active">
						<table class="ani table">
						<thead>
							<tr>
							    <th>编号</th>
								<th>代理人</th>
								<th>电话</th>
								<th>姓名</th>
								<th>地址</th>
								<th>规格</th>
								<th>件数</th>
								<th>重量</th>
								<th>货物单价</th>
								<th>货物总价</th>
								<th>物流单价</th>
								<th>物流总价</th>
							</tr>
						</thead>
						<tbody id="scOrderChild-{{idx}}-1-List">
						</tbody>
					</table>
				</div>
		</div>//-->
</script>

<script type="text/template" id="scOrderChild1Tpl">//<!--
				<tr>
                    <td>
						{{row.id}}
					</td>
					<td>
						{{row.agent_name}}
					</td>
					<td>
						{{row.phone}}
					</td>
					<td>
						{{row.username}}
					</td>
					<td>
						{{row.address}}
					</td>
					<td>
						{{row.name}}
					</td>
					<td>
						{{row.count}}
					</td>
					<td>
						{{row.weight}}
					</td>
					<td class="canEditSpec" contenteditable="true" title="可修改">
						{{row.single_price}}
					</td>
					<td>
						{{row.total_price}}
					</td>
					<td>
						{{row.logistics_price}}
					</td>
					<td>
						{{row.logistics_total_price}}
					</td>
				</tr>//-->
</script>
