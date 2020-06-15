<%@ page contentType="text/html;charset=UTF-8" %>
<script>
    /**
     * 合并单元格
     * @param data  原始数据（在服务端完成排序）
     * @param fieldNames 合并属性名称
     * @param colspan   合并列
     * @param target    目标表格对象
     */
    function mergeCells(data, fieldNames, colspan, target) {
        //声明一个map计算相同属性值在data对象出现的次数和
        var sortMap = {};
        var splitFields = fieldNames.split(',');

        for (var i = 0; i < data.length; i++) {
            var key = '';
            for (var k = 0; k < splitFields.length; k++) {
                var fn = splitFields[k];
                key += data[i][fn];
            }
            if (sortMap.hasOwnProperty(key)) {
                sortMap[key] = sortMap[key] * 1 + 1;
            } else {
                sortMap[key] = 1;
            }
        }

        for (var prop in sortMap) {
            console.log(prop, sortMap[prop])
        }
        var index = 0;
        for (var prop in sortMap) {
            var count = sortMap[prop] * 1;
            for (var k = 0; k < splitFields.length; k++) {
                var fieldName = splitFields[k];
                $(target).bootstrapTable('mergeCells', {
                    index: index,
                    field: fieldName,
                    colspan: colspan,
                    rowspan: count
                });
            }
            index += count;
        }
    }


    $(document).ready(function () {
        var $table = $('#scOrderImportTable');
        $table.bootstrapTable({
            onLoadSuccess: function (data) {
                var data = $table.bootstrapTable('getData', true);
                // 合并单元格
                mergeCells(data, "phone,username,address,agentName,logisticsName,shiftName", 0, $table);
            },
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
            pageSize: 1000,
            //可供选择的每页的行数（*）
            pageList: [10, 25, 50, 100],
            //这个接口需要处理bootstrap table传递的固定参数,并返回特定格式的json数据
            url: "${ctx}/oimport/scOrderImport/data",
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
                    jp.confirm('确认要删除该导入订单记录吗？', function () {
                        jp.loading();
                        jp.get("${ctx}/oimport/scOrderImport/delete?id=" + row.id, function (data) {
                            if (data.success) {
                                $('#scOrderImportTable').bootstrapTable('refresh');
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
                    field: 'phone',
                    title: '序号',
                    formatter: function (value, row, index) {
                        return index +1;
                    }
                },
                 {
                    field: 'phone',
                    title: '电话',
                    sortable: true,
                    sortName: 'phone'
                    , formatter: function (value, row, index) {
                        if(!value) value = '—';
                        value = jp.unescapeHTML(value);
                        <c:choose>
                        <c:when test="${fns:hasPermission('oimport:scOrderImport:edit')}">
                        return "<a href='javascript:edit(\"" + row.id + "\")'>" + value + "</a>";
                        </c:when>
                        <c:when test="${fns:hasPermission('oimport:scOrderImport:view')}">
                        return "<a href='javascript:view(\"" + row.id + "\")'>" + value + "</a>";
                        </c:when>
                        <c:otherwise>
                        return value;
                        </c:otherwise>
                        </c:choose>
                    }

                }
                , {
                    field: 'username',
                    title: '姓名',
                    sortable: true,
                    sortName: 'username'

                }
                , {
                    field: 'address',
                    title: '地址',
                    sortable: true,
                    sortName: 'address'

                }
                , {
                    field: 'agentName',
                    title: '代理人',
                    sortable: true,
                    sortName: 'agentName'

                }
                , {
                    field: 'logisticsName',
                    title: '物流公司',
                    sortable: true,
                    sortName: 'logisticsName'

                }
                , {
                    field: 'shiftName',
                    title: '物流班次',
                    sortable: true,
                    sortName: 'shiftName'

                },
                /*   {
                       field: 'factoryName',
                       title: '所属加工厂',
                       sortable: true,
                       sortName: 'factoryName'

                   },
                {
                    field: 'allotFactoryName',
                    title: '调拨加工厂',
                    sortable: true,
                    sortName: 'allotFactoryName'
                },*/
                 {
                    field: 'productionName',
                    title: '品名（规格）',
                    sortable: true,
                    sortName: 'productionName'

                }
                , {
                    field: 'lastUnitPrice',
                    title: '每斤价格',
                    sortable: true,
                    sortName: 'lastUnitPrice'

                }
                , {
                    field: 'weight',
                    title: '单箱重量（斤）',
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
                    field: 'logisticsPrice',
                    title: '单箱快递费',
                    sortable: true,
                    sortName: 'logisticsPrice'

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
            $('#scOrderImportTable').bootstrapTable("toggleView");
        }

        $('#scOrderImportTable').on('check.bs.table uncheck.bs.table load-success.bs.table ' +
            'check-all.bs.table uncheck-all.bs.table', function () {
            $('#remove').prop('disabled', !$('#scOrderImportTable').bootstrapTable('getSelections').length);
            $('#view,#edit').prop('disabled', $('#scOrderImportTable').bootstrapTable('getSelections').length != 1);
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
                    jp.downloadFile('${ctx}/oimport/scOrderImport/import/template');
                },
                btn2: function (index, layero) {
                    var iframeWin = layero.find('iframe')[0]; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
                    iframeWin.contentWindow.importExcel('${ctx}/oimport/scOrderImport/import', function (data) {
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
            var sortName = $('#scOrderImportTable').bootstrapTable("getOptions", "none").sortName;
            var sortOrder = $('#scOrderImportTable').bootstrapTable("getOptions", "none").sortOrder;
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
            $('#scOrderImportTable').bootstrapTable('refresh');
        });

        $("#reset").click("click", function () {// 绑定查询按扭
            $("#searchForm  input").val("");
            $("#searchForm  select").val("");
            $("#searchForm  .select-item").html("");
            $('#scOrderImportTable').bootstrapTable('refresh');
        });


    });

    function getIdSelections() {
        return $.map($("#scOrderImportTable").bootstrapTable('getSelections'), function (row) {
            return row.id
        });
    }

    function deleteAll() {

        jp.confirm('确认要删除该导入订单记录吗？', function () {
            jp.loading();
            jp.get("${ctx}/oimport/scOrderImport/deleteAll?ids=" + getIdSelections(), function (data) {
                if (data.success) {
                    $('#scOrderImportTable').bootstrapTable('refresh');
                    jp.success(data.msg);
                } else {
                    jp.error(data.msg);
                }
            })

        })
    }

    //刷新列表
    function refresh() {
        $('#scOrderImportTable').bootstrapTable('refresh');
    }

    function add() {
        jp.openSaveDialog('新增导入订单', "${ctx}/oimport/scOrderImport/form", '60%', '70%');
    }


    function edit(id) {//没有权限时，不显示确定按钮
        if (id == undefined) {
            id = getIdSelections();
        }
        jp.openSaveDialog('编辑导入订单', "${ctx}/oimport/scOrderImport/form?id=" + id, '60%', '70%');
    }

    function view(id) {//没有权限时，不显示确定按钮
        if (id == undefined) {
            id = getIdSelections();
        }
        jp.openViewDialog('查看导入订单', "${ctx}/oimport/scOrderImport/form?id=" + id, '60%', '70%');
    }

    function save() {
        jp.loading();
        jp.post("${ctx}/oimport/scOrderImport/saveToOrder", null, function (data) {
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
</script>