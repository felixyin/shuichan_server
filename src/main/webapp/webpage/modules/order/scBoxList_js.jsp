<%@ page contentType="text/html;charset=UTF-8" %>

<script>
    let onExpandRow = function (index, row, $detail) {
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

            if ('production.name' == _field) { // 规格
                _row.production3 = _row.production;
                var $productionName = $input;

                // 规格自动完成
                var onChooseEvent = function (firstData) {
                    var data = $productionName.getSelectedItemData();
                    if (firstData) data = firstData;
                    // _row.production.id = data.id;
                    _row.production2 = {
                        id: data.id,
                        name: data.value,
                        lastUnitPrice: data.descr
                    };
                    // jp.info('列表中修改规则，无法实现自动修改每斤价格，请自己修改');
                };
                $productionName.easyAutocomplete({
                    url: function (query) {
                        var url = '${ctx}/order/scOrder/autoCompleteProductionName?productionName=' + $.trim(query);
                        // // fixme  临时不添加，查询全部数据
                        // if (_custom_id) {
                        //     url += '&customId=' + _custom_id;
                        // }
                        return url;
                    },
                    getValue: function (result) {
                        return result ? result.value : '';
                    },
                    template: {
                        type: "description",
                        fields: {
                            description: "descr"
                        }
                    },
                    list: {
                        onChooseEvent: onChooseEvent,
                        onLoadEvent: function () {
                            var firstData = $productionName.getItemData(0);
                            if (firstData !== -1 && $productionName.val() === firstData.value) { // 选择了规格
                                onChooseEvent(firstData);
                            } else { // 不匹配,则默认新建
                                _row.production2 = null;
                            }
                        }
                    }
                });
            } else if ('allotFactory.name' == _field) {// 调拨工厂
                _row.allotFactory3 = _row.allotFactory;
                var $allotFactoryName = $input;
                var onChooseEvent1 = function (firstData) {
                    //  获取客户 的 其他信息填写
                    var data = $allotFactoryName.getSelectedItemData();
                    if (firstData) data = firstData;
                    // _row.allotFactory.id = data.id;
                    _row.allotFactory2 = {
                        id: data.id,
                        name: data.value
                    }
                };
                $allotFactoryName.easyAutocomplete({
                    url: function (query) {
                        var url = '${ctx}/order/scOrder/autoCompleteOffice?type=1&officeName=' + $.trim(query);
                        return url;
                    },
                    getValue: function (result) {
                        return result ? result.value : '';
                    },
                    list: {
                        onChooseEvent: onChooseEvent1,
                        onLoadEvent: function () {
                            var firstData = $allotFactoryName.getItemData(0);
                            if (firstData !== -1 && $allotFactoryName.val() === firstData.value) { // 找到数据
                                onChooseEvent1(firstData);
                            } else {
                                _row.allotFactory2 = null;
                            }
                        }
                    }
                });
            }

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
            if ('manual' !== _reason) {
                if ('production.name' == _field) { // 规格
                    if (_row.production3) {
                        _row.production = _row.production3;
                    }
                } else if ('allotFactory.name' == _field) {
                    if (_row.allotFactory3) {
                        _row.allotFactory = _row.allotFactory3;
                    }
                }
            }
            return true;
        }

        function onEditableSaveForBox(_field, _row, _rowIndex, _oldValue, _$el) {
            console.log('save', _field, _row, _rowIndex, _oldValue);
            console.log('save', _$el);
            // var orderRow = $orderTable.bootstrapTable('getRowByUniqueId', index);
            if (row.status > 4) { // 如果已经开始生产了，则不允许修改
                if ('weight' === _field || 'count' === _field || 'production.name' == _field) {
                    _row[_field] = _oldValue;
                    jp.toastr.warning('已经生产了，不可再修改此数据！');
                }
                return false;
            }

            if ('production.name' == _field) { // 规格，回车更新价格
                if (_row.production2) {
                    _row.production = _row.production2;
                    _row.production.lastUnitPrice = _row.singlePrice;
                } else {
                    delete _row.production.id;
                    _row.production.lastUnitPrice = _row.singlePrice
                }
                delete _row.production2;
                delete _row.production3;
            } else if ('allotFactory.name' == _field) {// 调拨工厂
                if (_row.allotFactory2) {
                    _row.allotFactory = _row.allotFactory2;
                } else {
                    delete _row.allotFactory.id;
                }
                delete _row.allotFactory2;
                delete _row.allotFactory3;
            }

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
                jp.post('${ctx}/order/scOrder/detail', {id: _row.order.id}, function (result) {
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
            url: "${ctx}/box/scBox/data",
            //默认值为 'limit',传给服务端的参数为：limit, offset, search, sort, order Else
            //queryParamsType:'',
            ////查询参数,每次调用是会带上这个参数，可自定义
            queryParams: function (params) {
                var searchParam = {};//$("#searchForm").serializeJSON();
                searchParam['order.id'] = row.id;
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
                    field: 'no',
                    title: '装箱单号',
                    sortable: true,
                    sortName: 'no'
                    , formatter: function (value, row, index) {
                        return value;
                       <%--value = jp.unescapeHTML(value);--%>
                       <%-- <c:choose>--%>
                       <%-- <c:when test="${fns:hasPermission('box:scBox:edit')}">--%>
                       <%-- return "<a href='javascript:editBox(\"" + row.id + "\")'>" + value + "</a>";--%>
                       <%-- </c:when>--%>
                       <%-- <c:when test="${fns:hasPermission('box:scBox:view')}">--%>
                       <%-- return "<a href='javascript:viewBox(\"" + row.id + "\")'>" + value + "</a>";--%>
                       <%-- </c:when>--%>
                       <%-- <c:otherwise>--%>
                       <%-- return value;--%>
                       <%-- </c:otherwise>--%>
                       <%-- </c:choose>--%>
                    }
                }
                , {
                    field: 'production.name',
                    title: '规格',
                    width: '150px',
                    sortable: true,
                    sortName: 'production.name',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_required
                    }
                }
                , {
                    field: 'weight',
                    title: '每箱重量（斤）',
                    sortable: true,
                    sortName: 'weight',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_number
                    },
                }
                , {
                    field: 'count',
                    title: '数量（箱）',
                    sortable: true,
                    sortName: 'count',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_number
                    }
                }
                ,
                <shiro:hasPermission name="order:scOrder:showPrice">
                {
                    field: 'singlePrice',
                    title: '每斤价格',
                    sortable: true,
                    sortName: 'singlePrice',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_number
                    }
                }
                , {
                    field: 'totalPrice',
                    title: '总计价格',
                    sortable: true,
                    sortName: 'totalPrice',
                    // editable: {
                    //     mode: 'inline',
                    //     type: 'text',
                    //     showbuttons: false,
                    //     validate: validate_number
                    // }
                },
                /* {
                    field: 'deliverTotalPrice',
                    title: '已发货总价',
                    sortable: true,
                    sortName: 'deliverTotalPrice',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_number
                    }
                    // , formatter: function (value, row, index) {
                    //     if (!value) {
                    //         return 0;
                    //     }
                    // }
                },*/
                </shiro:hasPermission>
                {
                    field: 'logisticsPrice',
                    title: '单箱快递费',
                    sortable: true,
                    sortName: 'logisticsPrice',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_number
                    },
                    // , formatter: function (value, row, index) {
                    //     if (!value) {
                    //         return 0;
                    //     }
                    // }
                }
                , {
                    field: 'logisticsTotalPrice',
                    title: '总计快递费',
                    sortable: true,
                    sortName: 'logisticsTotalPrice',
                    // editable: {
                    //     mode: 'inline',
                    //     type: 'text',
                    //     showbuttons: false,
                    //     validate: validate_number
                    // }
                    // , formatter: function (value, row, index) {
                    //     if (!value) {
                    //         return 0;
                    //     }
                    // }
                }
             /*   , {
                    field: 'allotFactory.name',
                    title: '调拨工厂',
                    sortable: true,
                    sortName: 'allotFactory.name',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_required,
                        clear: false
                    }
                }*/
                /* , {
                     field: 'status',
                     title: '状态',
                     sortable: true,
                     sortName: 'status',
                     editable: {
                         mode: 'inline',
                         type: 'select',
                         showbuttons: false,
                         source: [
                             {value: 1, text: 'Active'},
                             {value: 2, text: 'Blocked'},
                             {value: 3, text: 'Deleted'}
                         ]
                     },
                     formatter: function (value, row, index) {
                         return jp.getDictLabel({fns:toJson(fns:getDictList('status_box'))}, value, "-");
                    }
                }*/
                , {
                    field: 'remarks',
                    title: '备注信息',
                    sortable: true,
                    sortName: 'remarks',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_required
                    }

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
