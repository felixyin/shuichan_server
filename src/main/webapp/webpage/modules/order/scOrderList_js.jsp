<%@ page contentType="text/html;charset=UTF-8" %>
<link href="${ctxs}/static/plugin/jquery-autocomplete/easy-autocomplete.min.css" rel="stylesheet">
<style>
    .easy-autocomplete-container {
        z-index: 200;
    }

    .editable-error-block {
        color: darkred !important;
    }
    .editable-popup{
     margin-top: 13px!important;
    }
    .popover-content{
        padding: 0px!important;
    }
</style>
<script src="${ctxs}/static/plugin/jquery-autocomplete/jquery.easy-autocomplete.min.js"></script>
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
    // 订单表格
    var $orderTable;
    $(document).ready(function () {

        // 查询默认鼠标hover时自动激活焦点，回车自动查询
        $('#searchForm').find('input').hover(function () {
            $(this).focus();
        }).keydown(function (event) {
            if (event.keyCode === 13) { //只有当用户按下回车键时
                refresh();
            }
        });
        $('#status').change(refresh);

        // 双击行，自动展开明细
        $(document).on('dblclick', 'table>tbody>tr:not(".detail-view")', function () {
            $(this).find('.detail-icon').click();
        });

        $orderTable = $('#scOrderTable');

        function onEditableShownForOrder(_field, _row, _rowIndex, _$el) {
            // console.log('shown', _field, _row, _$el);

            // 宽度处理
            var $a = $(_$el[0]);

            var tdWidth = $a.parent().data('width');//.width() - 2;
            var $cssDiv = $a.siblings();
            var $input = $cssDiv.find('input,select');

            function createAutocompleteOption($input, inputName) {

                function parseData(data, inputName) {
                    if ('phone' === inputName) {
                        data.phone = data.value;
                        var arr = data.descr.split(' | ');
                        data.username = arr[0];
                        data.address = arr[1];
                    } else if ('username' === inputName) {
                        data.username = data.value;
                        // debugger;
                        var arr = data.descr.split(' | ');
                        data.phone = arr[0];
                        data.address = arr[1];
                    } else if ('address' === inputName) {
                        data.address = data.value;
                        var arr = data.descr.split(' | ');
                        data.phone = arr[0];
                        data.username = arr[1];
                    }
                    return data;
                }

                var onChooseEvent = function (firstData) {
                    //  获取客户 的 其他信息填写
                    var data = $input.getSelectedItemData();
                    if (firstData) data = firstData;

                    if (!data) return;

                    data = parseData(data, inputName);

                    _row.custom2 = {
                        id: data.id,
                        username: data.username,
                        phone: data.phone,
                        address: data.address
                    };

                    // 获取此客户所有的代理人，自动更新表格的代理人
                    jp.post('${ctx}/order/scOrder/autoCompleteAgentName', {customId: data.id}, function (result) {
                        if (result && result.success) {
                            if (result.msg) {
                                jp.success('自动填写代理人：' + result.msg);
                                _row.agentName = result.msg;
                            }
                            //  else {
                            //     jp.toastr.info('没有匹配到代理人，请自己修改');
                            // }
                        }
                    });
                };
                return {
                    url: function (query) {
                        return '${ctx}/oimport/scOrderImport/autoCompleteCustom?' + inputName + '=' + $.trim(query);
                    },
                    getValue: function (result) {
                        // _custom_id = result.id;
                        if (result && result.value) {
                            return result.value;
                        }
                    },
                    minCharNumber: 0,
                    template: {
                        type: "description",
                        fields: {
                            description: "descr"
                        }
                    },
                    list: {
                        onChooseEvent: onChooseEvent,
                        onLoadEvent: function () {
                            var data = $input.getItemData(0);
                            var currentInputValue = $input.val();
                            if (inputName === 'phone') { // 手机号唯一，采用手机号确认客户id
                                if (currentInputValue === data.value) {
                                    // $customId.val(data.id);
                                    onChooseEvent(data);
                                } else { // 将会创建
                                    _row.custom2 = {
                                        id: '',
                                        username: _row.custom.username,
                                        phone: _row.custom.phone,
                                        address: _row.custom.address
                                    };
                                }
                            }
                        }
                    }
                };
            }

            // 客户电话 自动完成
            if (_field === 'custom.username' || _field === 'custom.phone' || _field === 'custom.address') {
                tdWidth = 200;
            }
            if (_field === 'custom.phone') {
                _row.custom3 = _row.custom;
                $input.focus().easyAutocomplete(createAutocompleteOption($input, _field.split('.')[1]));
                // $input.keyup(function () {
                //     if (!$(this).val()) {
                //         _row.custom2 = {
                //             id: '',
                //             username: _row.custom.username,
                //             phone: _row.custom.phone,
                //             address: _row.custom.address
                //         };
                //     }
                // });
            }

            // 代理人自动完成
            if (_field == 'agentName') {
                $input.easyAutocomplete({
                    url: function (query) {
                        var url = '${ctx}/order/scOrder/autoCompleteAgentName2?agentName=' + $.trim(query);
                        // fixme  临时不添加，查询全部数据
                        // if (_custom_id) {
                        //     url += '&customId=' + _custom_id;
                        // }
                        return url;
                    },
                    getValue: function (result) {
                        return result.value;
                    },
                });
            }

            if ('shouldLogistics.name' == _field) {// 应取物流公司
                _row.shouldLogistics3 = _row.shouldLogistics;
                var $allotFactoryName = $input;
                var onChooseEvent1 = function (firstData) {
                    //  获取客户 的 其他信息填写
                    var data = $allotFactoryName.getSelectedItemData();
                    if (firstData) data = firstData;
                    // _row.allotFactory.id = data.id;
                    _row.shouldLogistics2 = {
                        id: data.id,
                        name: data.value
                    }
                };
                $allotFactoryName.easyAutocomplete({
                    url: function (query) {
                        var url = '${ctx}/order/scOrder/autoCompleteOffice?type=2&officeName=' + $.trim(query);
                        return url;
                    },
                    getValue: function (result) {
                        return result.value;
                    },
                    list: {
                        onChooseEvent: onChooseEvent1,
                        onLoadEvent: function () {
                            var firstData = $allotFactoryName.getItemData(0);
                            if (firstData !== -1 && $allotFactoryName.val() === firstData.value) { // 找到数据
                                onChooseEvent1(firstData);
                            } else {
                                _row.shouldLogistics2 = {
                                    id: '',
                                    name: _row.shouldLogistics.name
                                };
                            }
                        }
                    }
                });
            }

            if ('realLogistics.name' == _field) {// 实取物流公司
                _row.realLogistics3 = _row.realLogistics;
                var $allotFactoryName = $input;
                var onChooseEvent1 = function (firstData) {
                    //  获取客户 的 其他信息填写
                    var data = $allotFactoryName.getSelectedItemData();
                    if (firstData) data = firstData;
                    // _row.allotFactory.id = data.id;
                    _row.realLogistics2 = {
                        id: data.id,
                        name: data.value
                    }
                };
                $allotFactoryName.easyAutocomplete({
                    url: function (query) {
                        var url = '${ctx}/order/scOrder/autoCompleteOffice?type=2&officeName=' + $.trim(query);
                        return url;
                    },
                    getValue: function (result) {
                        return result.value;
                    },
                    list: {
                        onChooseEvent: onChooseEvent1,
                        onLoadEvent: function () {
                            var firstData = $allotFactoryName.getItemData(0);
                            if (firstData !== -1 && $allotFactoryName.val() === firstData.value) { // 找到数据
                                onChooseEvent1(firstData);
                            } else {
                                _row.realLogistics2 = {
                                    id: '',
                                    name: _row.realLogistics.name
                                };
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

        function onEditableHiddenForOrder(_field, _row, _$el, _reason) {
            console.log('hidden', _reason);
            if ('custom.username' == _field || 'custom.phone' == _field || 'custom.address' == _field) { // 规格
                if (_row.custom3) {
                    _row.custom = _row.custom3;
                }
                delete _row.custom2;
                delete _row.custom3;
            } else if ('shouldLogistics.name' == _field) {
                if (_row.shouldLogistics3) {
                    _row.shouldLogistics = _row.shouldLogistics3;
                }
                delete _row.shouldLogistics2;
                delete _row.shouldLogistics3;
            } else if ('realLogistics.name' == _field) {
                if (_row.realLogistics3) {
                    _row.realLogistics = _row.realLogistics3;
                }
                delete _row.realLogistics2;
                delete _row.realLogistics3;
            }
            return true;
        }

        function onEditableSaveForOrder(_field, _row, _rowIndex, _oldValue, _$el) {
            // console.log('save', _field, _row, _rowIndex, _oldValue);
            // console.log('save', _$el);

            if ('custom.username' == _field || 'custom.phone' == _field || 'custom.address' == _field) { // 规格，回车更新价格
                if (_row.custom2) {
                    _row.custom = _row.custom2;
                }
                delete _row.custom2;
                delete _row.custom3;

            } else if ('shouldLogistics.name' == _field) {// 调拨工厂
                if (_row.shouldLogistics2) {
                    _row.shouldLogistics = _row.shouldLogistics2;
                }
                delete _row.shouldLogistics2;
                delete _row.shouldLogistics3;
            } else if ('realLogistics.name' == _field) {// 调拨工厂
                if (_row.realLogistics2) {
                    _row.realLogistics = _row.realLogistics2;
                }
                delete _row.realLogistics2;
                delete _row.realLogistics3;
            }

            // 保存订单行时，不需要一起保存包装箱
            delete _row.scBoxList;
            // 删除，后台会自动填入最新时间，不删除则不会更新日期
            delete _row.updateDate;

            var data = jp.jsonToFormData(_row);

            // 提示手机号验证消息
            // if (!data['custom.phone']) { // 如果用户先填写的客户或者是地址，则手机号可能为空的情况处理
            //     jp.toastr.warning('手机号必须填写，否则不保存!');
            // }
            // 提示物流公司自动创建消息
            if (!data['shouldLogistics.id']) {
                var name = data['shouldLogistics.name'];
                if (name) {
                    jp.toastr.info('自动在机构管理中为您创建物流公司:' + name);
                }
            }

            // 提示物流公司自动创建消息
            if (!data['realLogistics.id']) {
                var name = data['realLogistics.name'];
                if (name) {
                    jp.toastr.info('自动在机构管理中为您创建物流公司:' + name);
                }
            }

            // 自动计算总价
            if ('goodsOrderPrice' === _field || 'logisticsOrderPrice' === _field) {
                data.willPayPrice = parseInt(data.goodsOrderPrice) + parseInt(data.logisticsOrderPrice);
            }

            // ajax 请求保存数据
            // console.log(data);
            jp.post('${ctx}/order/scOrder/saveOrder', data, function (result) {
                if (result && result.success) {
                    // ajax 查询订单数据，更新订单表格
                    // jp.success('保存成功');
                } else {
                    jp.error('保存失败！');
                }
                // 重新加载此行订单
                jp.post('${ctx}/order/scOrder/detail', {id: _row.id}, function (result) {
                    $orderTable.bootstrapTable('updateRow', {
                        index: _rowIndex,
                        row: result,
                        // replace: true
                    });
                    $orderTable.bootstrapTable('expandRow', _rowIndex);
                });
            });
        }

        $orderTable.bootstrapTable({
            // height: document.body.clientHeight - $('#search-collapse').height() - 96,
            //请求方法
            method: 'post',
            //类型json
            dataType: "json",
            contentType: "application/x-www-form-urlencoded",
            //显示检索按钮
            showSearch: false,
            //显示刷新按钮
            showRefresh: true,
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
            // detailFormatter: "detailFormatter",
            //最低显示2行
            minimumCountColumns: 2,
            //是否显示行间隔色
            striped: true,
            //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
            cache: false,
            // 固定列
            // fixedColumns: true,
            // fixedNumber: 2,
            //是否显示分页（*）
            pagination: false,
            //排序方式
            sortOrder: "asc",
            //初始化加载第一页，默认第一页
            pageNumber: 1,
            //每页的记录行数（*）
            pageSize: 10000000,
            //可供选择的每页的行数（*）
            pageList: [100, 250, 500, 1000, 2000, 10000],
            //这个接口需要处理bootstrap table传递的固定参数,并返回特定格式的json数据
            url: "${ctx}/order/scOrder/data",
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
                        jp.get("${ctx}/order/scOrder/delete?id=" + row.id, function (data) {
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
            <c:if test="${settingTable !=null}">
            onLoadSuccess: function () {
                <c:if test="${settingTable.boxExpanded == '1'}">
                $('#scOrderTable>tbody>tr:not(".detail-view")').dblclick(); // 自动展开
                </c:if>
            },
            </c:if>
            onExpandRow: onExpandRow,
            // uniqueId: 'id',
            onEditableInit: function () {
                // console.log('init', arguments);
                return true;
            },
            onEditableShown: onEditableShownForOrder,
            onEditableHidden: onEditableHiddenForOrder,
            onEditableSave: onEditableSaveForOrder,
            columns: [
                {
                    checkbox: true
                }, {
                    field: 'no',
                    title: '订单号',
                    sortable: false,
                    sortName: 'no',
                    formatter: function (value, row, index) {
                      <%--  value = jp.unescapeHTML(value);--%>
                      <%--/*  <c:choose>--%>
                      <%--  <c:when test="${fns:hasPermission('order:scOrder:edit')}">--%>
                      <%--  return "<a href='javascript:edit(\"" + row.id + "\")'>" + value + "</a>";--%>
                      <%--  </c:when>--%>
                      <%--  <c:when test="${fns:hasPermission('order:scOrder:view')}">--%>
                      <%--  return "<a href='javascript:view(\"" + row.id + "\")'>" + value + "</a>";--%>
                      <%--  </c:when>--%>
                      <%--  <c:otherwise>--%>
                      <%--  return value;--%>
                      <%--  </c:otherwise>--%>
                      <%--  </c:choose>*/--%>
                        return value;
                    },
                }, {
                    field: 'status',
                    title: '状态',
                    sortable: true,
                    sortName: 'status',
                    <%--editable: {--%>
                    <%--    mode: 'inline',--%>
                    <%--    type: 'select',--%>
                    <%--    source: jp.getDictForSelect(${fns:toJson(fns:getDictList('status_order'))}),--%>
                    <%--    showbuttons: false,--%>
                    <%--    validate: validate_required,--%>
                    <%--    clear: false--%>
                    <%--},--%>
                    formatter: function (value, row, index) {
                        return jp.getDictLabel(${fns:toJson(fns:getDictList('status_order'))}, value, "-");
                    }
                }, {
                    field: 'custom.phone',
                    title: '电话',
                    sortable: false,
                    sortName: 'custom.phone',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        validate: validate_phone,
                        showbuttons: false,
                        clear: false
                    }
                }, {
                    field: 'custom.username',
                    title: '客户',
                    sortable: true,
                    sortName: 'custom.username',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_required,
                        clear: false
                    }

                }, {
                    field: 'custom.address',
                    title: '地址',
                    sortable: false,
                    sortName: 'custom.address',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        validate: validate_required,
                        showbuttons: false,
                        clear: false
                    }
                }, {
                    field: 'agentName',
                    title: '代理人',
                    sortable: true,
                    sortName: 'agentName',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_required,
                        clear: false
                    }
                }, {
                    field: 'shouldLogistics.name',
                    title: '指定物流公司',
                    sortable: true,
                    sortName: 'shouldLogistics.name',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_required,
                        clear: false
                    }

                }
                , {
                    field: 'shift',
                    title: '物流班次',
                    sortable: true,
                    sortName: 'shift',
                    <%--formatter: function (value, row, index) {--%>
                    <%--    return jp.getDictLabel(${fns:toJson(fns:getDictList('logistics_shift'))}, value, "-");--%>
                    <%--},--%>
                    editable: {
                        mode: 'inline',
                        type: 'select',
                        source: jp.getDictForSelect(${fns:toJson(fns:getDictList('logistics_shift'))}),
                        showbuttons: false,
                        validate: validate_required,
                        clear: false
                    }

                }
                // , {
                //     field: 'factory.name',
                //     title: '所属加工厂',
                //     sortable: true,
                //     sortName: 'factory.name',
                //     editable: {
                //         mode: 'inline',
                //         type: 'text',
                //         showbuttons: false,
                //         clear: false
                //     }
                // }
                /*, {
                    field: 'realLogistics.name',
                    title: '实取物流公司',
                    sortable: true,
                    sortName: 'realLogistics.name',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_required,
                        clear: false
                    }

                }*/,
                <shiro:hasPermission name="order:scOrder:showPrice">
                {
                    field: 'goodsOrderPrice',
                    title: '货物总价',
                    sortable: true,
                    sortName: 'goodsOrderPrice',
                    // editable: {
                    //     mode: 'inline',
                    //     type: 'text',
                    //     showbuttons: false,
                    //     validate: validate_number,
                    //     clear: false
                    // }
                    // , formatter: function (value, row, index) {
                    //     if (!value) {
                    //         return 0;
                    //     }
                    // }
                },
                /* {
                    field: 'deliverOrderPrice',
                    title: '已发货总价',
                    sortable: true,
                    sortName: 'deliverOrderPrice',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_number,
                        clear: false
                    }
                    // , formatter: function (value, row, index) {
                    //     if (!value) {
                    //         return 0;
                    //     }
                    // }
                }*/


             /*    {
                    field: 'realPayPrice',
                    title: '客户实付',
                    sortable: true,
                    sortName: 'realPayPrice',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_number,
                        clear: false
                    }
                    // , formatter: function (value, row, index) {
                    //     if (!value) {
                    //         return 0;
                    //     }
                    // }
                },*/
                </shiro:hasPermission>
                {
                    field: 'logisticsOrderPrice',
                    title: '物流总价',
                    sortable: true,
                    sortName: 'logisticsOrderPrice',
                    // editable: {
                    //     mode: 'inline',
                    //     type: 'text',
                    //     showbuttons: false,
                    //     validate: validate_number,
                    //     clear: false
                    // }
                    // , formatter: function (value, row, index) {
                    //     if (!value) {
                    //         return 0;
                    //     }
                    // }
                },
                {
                    field: 'willPayPrice',
                    title: '客户应付',
                    sortable: true,
                    sortName: 'willPayPrice',
                    // editable: {
                    //     mode: 'inline',
                    //     type: 'text',
                    //     showbuttons: false,
                    //     validate: validate_number,
                    //     clear: false
                    // }
                    // , formatter: function (value, row, index) {
                    //     if (!value) {
                    //         return 0;
                    //     }
                    // }
                },
                {
                    field: 'deliverDate',
                    title: '要求发货时间',
                    sortable: true,
                    sortName: 'deliverDate',
                    editable: {
                        mode: 'popup',
                        type: 'date',
                        showbuttons: false,
                        validate: validate_required,
                        clear: false
                    },
                    formatter: function (value, row, index) {
                        // if (row.status < 4) { // 未发货之前的状态
                        //     var deliverDate = moment(value).subtract(1, 'hours');
                        //     var nowDate = moment();
                        //     var diff = deliverDate.diff(nowDate, 'hours');
                        //
                        //     if (diff > 6) { // 当前时间里要求发货时间还有5小时以上
                        //         value = "<span class=\"alert-success\" title=\"距离发货时间还有" + diff + "小时\">" + value + "</span>";
                        //     } else if (diff > 3) {
                        //         value = "<span class=\"alert-info\" title=\"距离发货时间还有" + diff + "小时\">" + value + "</span>";
                        //     } else if (diff > 1) {
                        //         value = "<span class=\"alert-warning\" title=\"距离发货时间还有" + diff + "小时\">" + value + "</span>";
                        //     } else if (diff < 0) {
                        //         value = "<span class=\"alert-danger\" title=\"已超过发货时间" + (-diff) + "小时\">" + value + "</span>";
                        //     }
                        // }
                        // value = jp.escapeHTML(value);
                        return value;
                    }
                }
                <%--, {--%>
                <%--    field: 'tomorrowCancellation',--%>
                <%--    title: '明天未发作废',--%>
                <%--    sortable: true,--%>
                <%--    sortName: 'tomorrowCancellation',--%>
                <%--    editable: {--%>
                <%--        mode: 'inline',--%>
                <%--        type: 'select',--%>
                <%--        source: jp.getDictForSelect(${fns:toJson(fns:getDictList('tomorrow_cancellation'))}),--%>
                <%--        showbuttons: false,--%>
                <%--        validate: validate_required,--%>
                <%--        clear: false--%>
                <%--    },--%>
                <%--    &lt;%&ndash;formatter: function (value, row, index) {&ndash;%&gt;--%>
                <%--    &lt;%&ndash;    return jp.getDictLabel(${fns:toJson(fns:getDictList('tomorrow_cancellation'))}, value, "-");&ndash;%&gt;--%>
                <%--    &lt;%&ndash;}&ndash;%&gt;--%>
                <%--}--%>

                , {
                    field: 'createBy.name',
                    title: '创建者',
                    sortable: true,
                    sortName: 'createBy.name'
                }
                , {
                    field: 'createDate',
                    title: '下单日期',
                    sortable: true,
                    sortName: 'createDate'
                }
                , {
                    field: 'remarks',
                    title: '订单备注',
                    sortable: true,
                    sortName: 'remarks',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_required,
                        clear: false
                    }
                },
                {
                    field: 'logisticsRemarks',
                    title: '物流备注',
                    sortable: true,
                    sortName: 'logisticsRemarks',
                    editable: {
                        mode: 'inline',
                        type: 'text',
                        showbuttons: false,
                        validate: validate_required,
                        clear: false
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

        /*
         * 订单的批量导入功能
         */
        $("#btnImport").click(function () {
            jp.open({
                type: 2,
                area: [500, 200],
                auto: true,
                title: "导入数据",
                content: "${ctx}/tag/importExcel",
                btn: ['下载模板', '确定', '关闭'],
                btn1: function (index, layero) {
                    jp.downloadFile('${ctx}/oimport/scOrderImport/import/template');
                },
                btn2: function (index, layero) {
                    var iframeWin = layero.find('iframe')[0]; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
                    iframeWin.contentWindow.importExcel('${ctx}/oimport/scOrderImport/import', function (data) {
                        if (data.success) {
                            // refresh();
                            jp.openSaveDialog('导入订单预处理', '${ctx}/oimport/scOrderImport', '80%', '80%');
                            jp.success('');
                            alert(data.msg);
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

            jp.downloadFile('${ctx}/oimport/scOrderImport/export?' + values);
        })
        $("#search").click("click", function () {// 绑定查询按扭
            $('#scOrderTable').bootstrapTable('refresh');
        });

        $("#reset").click("click", function () {// 绑定查询按扭
            $("#searchForm  input").val("");
            $("#searchForm  select").val("");
            $("#searchForm  .select-item").html("");
            var dateStr = jp.dateFormat(new Date(), 'YYYY-M-d');
            if (dateStr) {
                $('#beginCreateDate_laji,#endCreateDate_laji').val(dateStr);
            }
            $('#scOrderTable').bootstrapTable('refresh');
        });

        fixDateTimepicker('beginCreateDate', '${beginCreateDate}');
        fixDateTimepicker('endCreateDate', '${endCreateDate}');
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
            jp.get("${ctx}/order/scOrder/deleteAll?ids=" + getIdSelections(), function (data) {
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
        jp.openSaveAndNextDialog('快速新建订单', "${ctx}/order/scOrder/form/add", '80%', '70%');
    }

    function edit(id) {//没有权限时，不显示确定按钮
        if (id == undefined) {
            id = getIdSelections();
        }
        jp.openSaveAndCloseDialog('编辑订单', "${ctx}/order/scOrder/form/edit?id=" + id, '90%', '90%');
    }


    function view(id) {//没有权限时，不显示确定按钮
        if (id == undefined) {
            id = getIdSelections();
        }
        jp.openViewDialog('查看订单', "${ctx}/order/scOrder/form/view?id=" + id, '90%', '90%');
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
        var htmltpl = $("#scOrderChildrenTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
        var html = Mustache.render(htmltpl, {
            idx: row.id
        });
        $.get("${ctx}/order/scOrder/detail?id=" + row.id, function (scOrder) {
            var scOrderChild1RowIdx = 0,
                scOrderChild1Tpl = $("#scOrderChild1Tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
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


    function getPicHtml(value, row, index) {
        var valueArray = value.split("|");
        var labelArray = [];
        for (var i = 0; i < valueArray.length; i++) {
            if (!/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(valueArray[i])) {
                if (valueArray[i]) {
                    labelArray[i] = "<a href=\"" + valueArray[i] + "\" url=\"" + valueArray[i] + "\" target=\"_blank\">" + decodeURIComponent(valueArray[i].substring(valueArray[i].lastIndexOf("/") + 1)) + "</a>"
                }
            } else {
                // $('.fixed-table-body').css('overflowX','hidden')
                labelArray[i] = '<img   onclick="jp.showPic(\'' + valueArray[i] + '\');"' + ' height="150px" src="' + valueArray[i] + '">';
            }
        }
        return labelArray.join(" ");
    }

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


    function addRow(list, idx, tpl, row) {
        var nodes = Mustache.render(tpl, {
            idx: idx, delBtn: true, row: row
        });
        $(list).append(nodes);
    }


    function printDeliveryOrder() {
        alert('打印出货单');
    }

    function setPrintDeliveryOrder() {
        alert('设置打印出货单');
    }

    /**
     * 列表设置
     */
    function settingTable() {
        jp.openSettingPrintBoxDialog('表格设置', '${ctx}/order/scOrder/settingTable', '680px', '300px', function (iframeWin) {
            var ok = iframeWin.saveTableSettingData();
            if (ok) {
                jp.success('保存成功！');
                window.location.reload();
                jp.close(0);
            }
        }, function (iframeWin) {
            var ok = iframeWin.resetTableSettingData();
            if (ok) {
                jp.success('重置成功！');
                window.location.reload();
                jp.close(0);
            }
        });
    }

</script>
