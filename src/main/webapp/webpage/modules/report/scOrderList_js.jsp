<%@ page contentType="text/html;charset=UTF-8" %>

<%--<link rel="stylesheet" href="${ctxStatic}/plugin/bootstrap-table/extensions/fixed-columns/bootstrap-table-fixed-columns.min.css">--%>
<%--<script src="${ctxStatic}/plugin/bootstrap-table/bootstrap-table.js"></script>--%>
<%--<script src="${ctxStatic}/plugin/bootstrap-table/extensions/fixed-columns/bootstrap-table-fixed-columns.js"></script>--%>
<script>
    $(document).ready(function () {
        // 双击行，自动展开明细
        $(document).on('dblclick', '#scOrderTable>tbody>tr:not(".detail-view")', function () {
            $(this).find('.detail-icon').click();
        });

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
            detailFormatter: "detailFormatter",
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
            url: "${ctx}/report/scReport/data",
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
            columns: [{
                checkbox: true

            }
                , {
                    field: 'custom.username',
                    title: '客户',
                    sortable: true,
                    sortName: 'custom.username'
                    , formatter: function (value, row, index) {
                        value = jp.unescapeHTML(value);
                        if(!value)return '';
                        <c:choose>
                        <c:when test="${fns:hasPermission('order:scOrder:edit')}">
                        return "<a href='javascript:view(\"" + row.id + "\")'>" + value + "</a>";
                        </c:when>
                        <c:when test="${fns:hasPermission('order:scOrder:view')}">
                        return "<a href='javascript:view(\"" + row.id + "\")'>" + value + "</a>";
                        </c:when>
                        <c:otherwise>
                        return value;
                        </c:otherwise>
                        </c:choose>
                    }
                }
                , {
                    field: 'agentName',
                    title: '代理人',
                    sortable: true,
                    sortName: 'agentName'


                }

                , {
                    field: 'shouldLogistics.name',
                    title: '指定物流公司',
                    sortable: true,
                    sortName: 'shouldLogistics.name'

                }
                , {
                    field: 'shift',
                    title: '物流班次',
                    sortable: true,
                    sortName: 'shift',
                    formatter: function (value, row, index) {
                        return jp.getDictLabel(${fns:toJson(fns:getDictList('logistics_shift'))}, value, "-");
                    }

                }
                , {
                    field: 'factory.name',
                    title: '所属加工厂',
                    sortable: true,
                    sortName: 'factory.name'

                }
                , {
                    field: 'realLogistics.name',
                    title: '实取物流公司',
                    sortable: true,
                    sortName: 'realLogistics.name'

                }
                , {
                    field: 'goodsOrderPrice',
                    title: '货物总价',
                    sortable: true,
                    sortName: 'goodsOrderPrice'

                }
                , {
                    field: 'deliverOrderPrice',
                    title: '已发货总价',
                    sortable: true,
                    sortName: 'deliverOrderPrice'

                }
                , {
                    field: 'logisticsOrderPrice',
                    title: '物流总价',
                    sortable: true,
                    sortName: 'logisticsOrderPrice'

                }
                , {
                    field: 'willPayPrice',
                    title: '客户应付',
                    sortable: true,
                    sortName: 'willPayPrice'

                }
                , {
                    field: 'realPayPrice',
                    title: '客户实付',
                    sortable: true,
                    sortName: 'realPayPrice'

                }
                , {
                    field: 'deliverDate',
                    title: '要求发货时间',
                    sortable: true,
                    sortName: 'deliverDate',
                    formatter: function (value, row, index) {
                        if (row.status < 4) { // 未发货之前的状态
                            var deliverDate = moment(value).subtract(1, 'hours');
                            var nowDate = moment();
                            var diff = deliverDate.diff(nowDate, 'hours');

                            if (diff > 5) { // 当前时间里要求发货时间还有5小时以上
                                value = '<span class="alert-success" title="距离发货时间还有' + diff + '小时">' + value + '</span>';
                                return value;
                            } else if (diff > 1) {
                                value = '<span class="alert-warning" title="距离发货时间还有' + diff + '小时">' + value + '</span>';
                                return value;
                            } else if (diff < 0) {
                                value = '<span class="alert-danger" title="距离发货时间还有' + diff + '小时">' + value + '</span>';
                                return value;
                            }
                        }
                        return value;
                    }
                }
               <%--/*, {--%>
               <%--     field: 'tomorrowCancellation',--%>
               <%--     title: '明天未发作废',--%>
               <%--     sortable: true,--%>
               <%--     sortName: 'tomorrowCancellation',--%>
               <%--     formatter: function (value, row, index) {--%>
               <%--         return jp.getDictLabel(${fns:toJson(fns:getDictList('tomorrow_cancellation'))}, value, "-");--%>
               <%--     }--%>
               <%-- }*/--%>
                , {
                    field: 'status',
                    title: '状态',
                    sortable: true,
                    sortName: 'status',
                    formatter: function (value, row, index) {
                        return jp.getDictLabel(${fns:toJson(fns:getDictList('status_order'))}, value, "-");
                    }

                }
                , {
                    field: 'createBy.name',
                    title: '创建者',
                    sortable: true,
                    sortName: 'createBy.name'

                }
                , {
                    field: 'createDate',
                    title: '创建时间',
                    sortable: true,
                    sortName: 'createDate'

                }
                , {
                    field: 'remarks',
                    title: '备注信息',
                    sortable: true,
                    sortName: 'remarks'

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
            $("#searchForm  select").val("");
            $("#searchForm  .select-item").html("");
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
        // Fixme 需设置日期为当天
        // $('#createDate').datetimepicker("setDate", new Date());
        $('#beginCreateDate').datetimepicker({
            format: "YYYY-MM-DD HH:mm:ss"
        });
        $('#endCreateDate').datetimepicker({
            format: "YYYY-MM-DD HH:mm:ss"
        });

    });

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
        var htmltpl = $("#scOrderChildrenTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
        var html = Mustache.render(htmltpl, {
            idx: row.id
        });
        $.get("${ctx}/report/scReport/detail?id=" + row.id, function (scOrder) {
            var scOrderChild1RowIdx = 0, scOrderChild1Tpl = $("#scOrderChild1Tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
            var data1 = scOrder.scBoxList;
            for (var i = 0; i < data1.length; i++) {
                data1[i].dict = {};
                data1[i].dict.status = jp.getDictLabel(${fns:toJson(fns:getDictList('status_box'))}, data1[i].status, "-");
                addRow('#scOrderChild-' + row.id + '-1-List', scOrderChild1RowIdx, scOrderChild1Tpl, data1[i]);
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
				<li class="active"><a data-toggle="tab" href="#tab-{{idx}}-1" aria-expanded="true">箱子</a></li>
		</ul>
		<div class="tab-content">
				 <div id="tab-{{idx}}-1" class="tab-pane fade in active">
						<table class="ani table">
						<thead>
							<tr>
								<th>规格</th>
								<th>每箱重量（斤）</th>
								<th>数量（箱）</th>
								<th>调拨工厂</th>
								<th>状态</th>
								<th>备注信息</th>
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
						{{row.production.name}}
					</td>
					<td>
						{{row.weight}}
					</td>
					<td>
						{{row.count}}
					</td>
					<td>
						{{row.allotFactory.name}}
					</td>
					<td>
						{{row.dict.status}}
					</td>
					<td>
						{{row.remarks}}
					</td>
				</tr>//-->
</script>
