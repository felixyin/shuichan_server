<%@ page contentType="text/html;charset=UTF-8" %>
<script type="text/javascript">

    // box的增加，需带有此参数
    var orderId = '${scOrder.id}';

    $(document).ready(function () {
        // 双击行，自动展开明细
        $(document).on('dblclick', '#scBoxTable>tbody>tr:not(".detail-view")', function () {
            $(this).find('.detail-icon').click();
        });

        $('#scBoxTable').bootstrapTable({

            //请求方法
            method: 'post',
            //类型json
            dataType: "json",
            contentType: "application/x-www-form-urlencoded",
            //显示检索按钮
            showSearch: true,
            //显示刷新按钮
            showRefresh: true,
            //显示切换手机试图按钮
            showToggle: true,
            //显示 内容列下拉框
            showColumns: true,
            //显示到处按钮
            showExport: true,
            //显示切换分页按钮
            showPaginationSwitch: true,
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
            //是否显示分页（*）
            pagination: true,
            //排序方式
            sortOrder: "asc",
            //初始化加载第一页，默认第一页
            pageNumber: 1,
            //每页的记录行数（*）
            pageSize: 10,
            //可供选择的每页的行数（*）
            pageList: [10, 25, 50, 100],
            //这个接口需要处理bootstrap table传递的固定参数,并返回特定格式的json数据
            <%--url: "${ctx}/box/scBox/data?id=${scOrder.id}",--%>
            url: "${ctx}/box/scBox/data",
            //默认值为 'limit',传给服务端的参数为：limit, offset, search, sort, order Else
            //queryParamsType:'',
            ////查询参数,每次调用是会带上这个参数，可自定义
            queryParams: function (params) {
                var searchParam = $("#searchForm").serializeJSON();
                searchParam['order.id'] = orderId ? orderId : '-000';
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
                    editBox(row.id);
                } else if ($el.data("item") == "view") {
                    viewBox(row.id);
                } else if ($el.data("item") == "delete") {
                    jp.confirm('确认要删除该包装箱记录吗？', function () {
                        jp.loading();
                        jp.get("${ctx}/box/scBox/delete?id=" + row.id, function (data) {
                            if (data.success) {
                                $('#scBoxTable').bootstrapTable('refresh');
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
                    field: 'no',
                    title: '装箱单号',
                    sortable: true,
                    sortName: 'no'
                    , formatter: function (value, row, index) {
                        value = jp.unescapeHTML(value);
                        <c:choose>
                        <c:when test="${fns:hasPermission('box:scBox:edit')}">
                        return "<a href='javascript:editBox(\"" + row.id + "\")'>" + value + "</a>";
                        </c:when>
                        <c:when test="${fns:hasPermission('box:scBox:view')}">
                        return "<a href='javascript:viewBox(\"" + row.id + "\")'>" + value + "</a>";
                        </c:when>
                        <c:otherwise>
                        return value;
                        </c:otherwise>
                        </c:choose>
                    }

                }
                , {
                    field: 'production.name',
                    title: '规格',
                    sortable: true,
                    sortName: 'production.name'

                }
                , {
                    field: 'weight',
                    title: '每箱重量（斤）',
                    sortable: true,
                    sortName: 'weight'

                }
                , {
                    field: 'count',
                    title: '数量（箱）',
                    sortable: true,
                    sortName: 'count'

                }
                , {
                    field: 'singlePrice',
                    title: '每斤价格',
                    sortable: true,
                    sortName: 'singlePrice'

                }
                , {
                    field: 'totalPrice',
                    title: '总计价格',
                    sortable: true,
                    sortName: 'totalPrice'

                }
                , {
                    field: 'deliverTotalPrice',
                    title: '已发货总价',
                    sortable: true,
                    sortName: 'deliverTotalPrice'

                }
                , {
                    field: 'logisticsPrice',
                    title: '单箱快递费',
                    sortable: true,
                    sortName: 'logisticsPrice'

                }
                , {
                    field: 'logisticsTotalPrice',
                    title: '总计快递费',
                    sortable: true,
                    sortName: 'logisticsTotalPrice'

                }
                , {
                    field: 'allotFactory.name',
                    title: '调拨工厂',
                    sortable: true,
                    sortName: 'allotFactory.name'

                }
                , {
                    field: 'status',
                    title: '状态',
                    sortable: true,
                    sortName: 'status',
                    formatter: function (value, row, index) {
                        return jp.getDictLabel(${fns:toJson(fns:getDictList('status_box'))}, value, "-");
                    }

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
            $('#scBoxTable').bootstrapTable("toggleView");
        }

        $('#scBoxTable').on('check.bs.table uncheck.bs.table load-success.bs.table ' +
            'check-all.bs.table uncheck-all.bs.table', function () {
            $('#remove').prop('disabled', !$('#scBoxTable').bootstrapTable('getSelections').length);
            $('#view,#edit').prop('disabled', $('#scBoxTable').bootstrapTable('getSelections').length != 1);
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
                    jp.downloadFile('${ctx}/box/scBox/import/template');
                },
                btn2: function (index, layero) {
                    var iframeWin = layero.find('iframe')[0]; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
                    iframeWin.contentWindow.importExcel('${ctx}/box/scBox/import', function (data) {
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
            var sortName = $('#scBoxTable').bootstrapTable("getOptions", "none").sortName;
            var sortOrder = $('#scBoxTable').bootstrapTable("getOptions", "none").sortOrder;
            var values = "";
            for (var key in searchParam) {
                values = values + key + "=" + searchParam[key] + "&";
            }
            if (sortName != undefined && sortOrder != undefined) {
                values = values + "orderBy=" + sortName + " " + sortOrder;
            }

            jp.downloadFile('${ctx}/box/scBox/export?' + values);
        })
        $("#search").click("click", function () {// 绑定查询按扭
            $('#scBoxTable').bootstrapTable('refresh');
        });

        $("#reset").click("click", function () {// 绑定查询按扭
            $("#searchForm  input").val("");
            $("#searchForm  select").val("");
            $("#searchForm  .select-item").html("");
            $('#scBoxTable').bootstrapTable('refresh');
        });


    });

    function getIdSelections() {
        return $.map($("#scBoxTable").bootstrapTable('getSelections'), function (row) {
            return row.id
        });
    }

    function deleteAllBox() {

        jp.confirm('确认要删除该包装箱记录吗？', function () {
            jp.loading();
            jp.get("${ctx}/box/scBox/deleteAll?ids=" + getIdSelections(), function (data) {
                if (data.success) {
                    $('#scBoxTable').bootstrapTable('refresh');
                    jp.success(data.msg);
                } else {
                    jp.error(data.msg);
                }
            })

        })
    }

    function refresh() {
        $('#scBoxTable').bootstrapTable('refresh');
    }

    function addBox(oId) {
        var url = "${ctx}/box/scBox/form/add?orderId=" + (oId ? oId : orderId);
        jp.openSaveAndCloseDialog('新增包装箱', url, '90%', '90%');
        return false;
    }

    function editBox(id) {//没有权限时，不显示确定按钮
        if (id == undefined) {
            id = getIdSelections();
        }
        jp.openSaveAndCloseDialog('编辑包装箱', "${ctx}/box/scBox/form/edit?id=" + id, '90%', '90%');
    }

    function viewBox(id) {//没有权限时，不显示确定按钮
        if (id == undefined) {
            id = getIdSelections();
        }
        jp.openViewDialog('查看包装箱', "${ctx}/box/scBox/form/view?id=" + id, '90%', '90%');
    }

    function detailFormatter(index, row) {
        var htmltpl = $("#scBoxChildrenTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
        var html = Mustache.render(htmltpl, {
            idx: row.id
        });
        $.get("${ctx}/box/scBox/detail?id=" + row.id, function (scBox) {
            var scBoxChild1RowIdx = 0, scBoxChild1Tpl = $("#scBoxChild1Tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
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

    function addRow(list, idx, tpl, row) {
        $(list).append(Mustache.render(tpl, {
            idx: idx, delBtn: true, row: row
        }));
    }

</script>
<script type="text/template" id="scBoxChildrenTpl">//<!--
	<div class="tabs-container">
		<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-{{idx}}-1" aria-expanded="true">每箱</a></li>
		</ul>
		<div class="tab-content">
				 <div id="tab-{{idx}}-1" class="tab-pane fade in active">
						<table class="ani table">
						<thead>
							<tr>
								<th>生成编号</th>
								<th>第几箱</th>
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
							</tr>
						</thead>
						<tbody id="scBoxChild-{{idx}}-1-List">
						</tbody>
					</table>
				</div>
		</div>//-->
</script>
<script type="text/template" id="scBoxChild1Tpl">//<!--
				<tr>
					<td>
						{{row.serialNum}}
					</td>
					<td>
						{{row.few}}
					</td>
					<td>
						{{row.dict.process}}
					</td>
					<td>
						{{row.printUser.name}}
					</td>
					<td>
						{{row.printDate}}
					</td>
					<td>
						{{row.productionUser.name}}
					</td>
					<td>
						{{row.productionDate}}
					</td>
					<td>
						{{row.packageUser.name}}
					</td>
					<td>
						{{row.packageDate}}
					</td>
					<td>
						{{row.photos}}
					</td>
					<td>
						{{row.logisticsUser.name}}
					</td>
					<td>
						{{row.logisticsDate}}
					</td>
					<td>
						{{row.remarks}}
					</td>
				</tr>//-->
</script>
