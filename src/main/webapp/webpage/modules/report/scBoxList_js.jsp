<%@ page contentType="text/html;charset=UTF-8" %>

<script>
    let onExpandRow = function (index, row, $detail) {
        if (row.deliver_date === '-') {
            return;
        }
        // 订单表格
        var $orderTable = $('#scOrderTable');

        /* eslint no-use-before-define: ["error", { "functions": false }]*/
        var $boxTable = $detail.html('<div class="tabs-container">\n' +
            '\t\t<ul class="nav nav-tabs">\n' +
            '\t\t\t\t<li class="active"><a data-toggle="tab" href="#tab-' + index + '-box" aria-expanded="true">包装箱</a></li>\n' +
            '\t\t</ul>\n' +
            '\t\t<div class="tab-content">\n' +
            '\t\t\t\t <div id="tab-' + index + '-box" class="tab-pane fade in active">\n' +
            '\t\t\t\t\t\t<table class="text-nowrap table table-bordered table-hover ">\n' +
            '\t\t\t\t\t</table>\n' +
            '\t\t\t\t</div>\n' +
            '\t\t</div>').find('table');

        function onEditableShownForBox(_field, _row, _rowIndex, _$el) {
            // console.log('shown', _field, _row, _$el);
            // 宽度处理
            var $a = $(_$el[0]);
            var tdWidth = $a.parent().data('width');
            var $cssDiv = $a.siblings();
            var $input = $cssDiv.find('input');

            $cssDiv.css('width', tdWidth);
            $cssDiv.find('.control-group').css('width', tdWidth);
            $cssDiv.find('.editable-input').css('width', tdWidth);
            $cssDiv.find('.easy-autocomplete').css('width', tdWidth);
            $input.css('max-width', tdWidth + 'px');

            setTimeout(function () {
                $input.select();
                $a.parent().css('width', (tdWidth) + 'px');
            }, 10);

            return true;
        }

        function onEditableHiddenForBox(_field, _row, _$el, _reason) {
            console.log('hidden', _reason);
            return true;
        }

        function onEditableSaveForBox(_field, _row, _rowIndex, _oldValue, _$el) {
            console.log('save', _field, _row, _rowIndex, _oldValue);
            console.log('save', _$el);
            // var orderRow = $orderTable.bootstrapTable('getRowByUniqueId', index);

            delete _row.updateDate;
            var data = jp.jsonToFormData(_row);
            if ('weight' === _field || 'count' === _field || 'singlePrice' == _field) {
                data.totalPrice = (data.weight * data.count * data.singlePrice).toFixed(1);
            }
            if ('count' === _field || 'logisticsPrice' === _field) {
                data.logisticsTotalPrice = (data.logisticsPrice * data.count).toFixed(1);
            }
            console.log(data);

            // ajax 请求保存数据
            jp.post('${ctx}/box/scBox/save', data, function (result) {
                if (result && result.success) {
                    // ajax 查询订单数据，更新订单表格
                    // jp.success('保存成功');
                } else {
                    jp.error('保存失败！');
                }
                // 重新加载此行订单
                jp.post('${ctx}/order/scOrder/detail', {id: _row.order_id}, function (result) {
                    result.will_pay_price = result.willPayPrice;
                    console.log(result);
                    $orderTable.bootstrapTable('updateRow', {
                        index: index,
                        row: result,
                        // replace: true
                    });
                    $orderTable.bootstrapTable('expandRow', index);
                });
            });
        }

        $boxTable.bootstrapTable({
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
            detailFormatter: "detailFormatter2",
            //最低显示2行
            minimumCountColumns: 2,
            //是否显示行间隔色
            striped: true,
            //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
            cache: false,
            //是否显示分页（*）
            pagination: false,
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
            url: "${ctx}/report/scReport/findCaiWuItemReportList",
            //默认值为 'limit',传给服务端的参数为：limit, offset, search, sort, order Else
            //queryParamsType:'',
            ////查询参数,每次调用是会带上这个参数，可自定义
            queryParams: function (params) {
                var searchParam = {};//$("#searchForm").serializeJSON();
                searchParam['date'] = row.deliver_date;
                searchParam['agentName'] = row.agent_name;
                searchParam.pageNo = params.limit === undefined ? "1" : params.offset / params.limit + 1;
                searchParam.pageSize = params.limit === undefined ? -1 : params.limit;
                searchParam.orderBy = params.sort === undefined ? "" : params.sort + " " + params.order;
                return searchParam;
            },
            <c:if test="${settingTable !=null}">
            onLoadSuccess: function () {
                <c:if test="${settingTable.boxItemExpanded == '1'}">
                $('#tab-' + index + '-box').find('.detail-icon').click();
                </c:if>
            },
            </c:if>
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
            uniqueId: 'id',
            onEditableInit: function () {
                // console.log('init', arguments);
                return true;
            },
            onEditableShown: onEditableShownForBox,
            onEditableHidden: onEditableHiddenForBox,
            onEditableSave: onEditableSaveForBox,
            columns: [
                // {
                //     checkbox: true
                // },
                {
                    field: 'id',
                    title: 'ID编号',
                    hide: true,
                    formatter: function (value, row, index) {
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
                    field: 'phone',
                    title: '电话',
                    sortable: true,
                    sortName: 'phone'
                }
                , {
                    field: 'username',
                    title: '姓名',
                    sortable: true,
                    sortName: 'username'
                }
                ,
                {
                    field: 'address',
                    title: '地址',
                    sortable: true,
                    sortName: 'address'
                }
                , {
                    field: 'name',
                    title: '规格',
                    sortable: true,
                    sortName: 'name'
                },
                {
                    field: 'count',
                    title: '件数',
                    sortable: true,
                    sortName: 'count'
                }
                , {
                    field: 'weight',
                    title: '重量',
                    sortable: true,
                    sortName: 'weight'
                }
                , {
                    field: 'singlePrice',
                    title: '货物单价',
                    sortable: true,
                    sortName: 'singlePrice',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_required,
                        clear: false
                    }
                }
                , {
                    field: 'totalPrice',
                    title: '货物总价',
                    sortable: true,
                    sortName: 'totalPrice'
                }
                , {
                    field: 'logisticsPrice',
                    title: '物流单价',
                    sortable: true,
                    sortName: 'logisticsPrice',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_required
                    }
                }
                , {
                    field: 'logisticsTotalPrice',
                    title: '物流总价',
                    sortable: true,
                    sortName: 'logisticsTotalPrice'
                }
            ]
        });
    };
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

<script type="text/template" id="scBoxChildrenTpl">//<!--
	<div class="tabs-container">
		<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-boxitem-{{idx}}-1" aria-expanded="true">每箱</a></li>
		</ul>
		<div class="tab-content">
				 <div id="tab-boxitem-{{idx}}-1" class="tab-pane fade in active">
						<table class="text-nowrap table table-bordered table-hover table-boxitem">
						<thead>
							<tr>
								<th>生成编号</th>
								<th>第几箱</th>
								<th>进度</th>
								<th>打印者</th>
								<th>打印时间</th>
<%--								<th>生产者</th>--%>
								<th>生产时间</th>
								<th>包装者</th>
								<th>包装时间</th>
								<th>包装照片</th>
								<th>实取物流公司</th>
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
<%--					<td>--%>
<%--						{{row.productionUser.name}}--%>
<%--					</td>--%>
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
						{{#row.photos}}<img   onclick="jp.showPic('/bak{{row.photos}}');"' + ' height="50px" src="/bak{{row.photos}}">{{/row.photos}}
					</td>
					<td>
						{{row.logisticsUser.company.name}}
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
