<%@ page contentType="text/html;charset=UTF-8" %>
<script>
    $(document).ready(function () {
        $('#scBoxItemTable').bootstrapTable({

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
            url: "${ctx}/boxitem/scBoxItem/data",
            //默认值为 'limit',传给服务端的参数为：limit, offset, search, sort, order Else
            //queryParamsType:'',
            ////查询参数,每次调用是会带上这个参数，可自定义
            queryParams: function (params) {
                var searchParam = $("#searchForm").serializeJSON();
                var id = '${scBox.id}';
                searchParam['box.id'] = id ? id : '000'
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
                    jp.confirm('确认要删除该每箱记录吗？', function () {
                        jp.loading();
                        jp.get("${ctx}/boxitem/scBoxItem/delete?id=" + row.id, function (data) {
                            if (data.success) {
                                $('#scBoxItemTable').bootstrapTable('refresh');
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
                    field: 'serialNum',
                    title: '生成编号',
                    sortable: true,
                    sortName: 'serialNum'
                    , formatter: function (value, row, index) {
                        value = jp.unescapeHTML(value);
                        <c:choose>
                        <c:when test="${fns:hasPermission('boxitem:scBoxItem:edit')}">
                        return "<a href='javascript:edit(\"" + row.id + "\")'>" + value + "</a>";
                        </c:when>
                        <c:when test="${fns:hasPermission('boxitem:scBoxItem:view')}">
                        return "<a href='javascript:view(\"" + row.id + "\")'>" + value + "</a>";
                        </c:when>
                        <c:otherwise>
                        return value;
                        </c:otherwise>
                        </c:choose>
                    }

                }
                , {
                    field: 'few',
                    title: '第几箱',
                    sortable: true,
                    sortName: 'few'

                }
                , {
                    field: 'process',
                    title: '进度',
                    sortable: true,
                    sortName: 'process',
                    formatter: function (value, row, index) {
                        return jp.getDictLabel(${fns:toJson(fns:getDictList('process_box_item'))}, value, "-");
                    }

                }
                , {
                    field: 'printUser.name',
                    title: '打印者',
                    sortable: true,
                    sortName: 'printUser.name'

                }
                , {
                    field: 'printDate',
                    title: '打印时间',
                    sortable: true,
                    sortName: 'printDate'

                }
                , {
                    field: 'productionUser.name',
                    title: '生产者',
                    sortable: true,
                    sortName: 'productionUser.name'

                }
                , {
                    field: 'productionDate',
                    title: '生产时间',
                    sortable: true,
                    sortName: 'productionDate'

                }
                , {
                    field: 'packageUser.name',
                    title: '包装者',
                    sortable: true,
                    sortName: 'packageUser.name'

                }
                , {
                    field: 'packageDate',
                    title: '包装时间',
                    sortable: true,
                    sortName: 'packageDate'

                }
                , {
                    field: 'photos',
                    title: '包装照片',
                    sortable: true,
                    sortName: 'photos',
                    formatter: function (value, row, index) {
                        try {
                            var valueArray = value.split("|");
                            var labelArray = [];
                            for (var i = 0; i < valueArray.length; i++) {
                                if (!/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(valueArray[i])) {
                                    labelArray[i] = "<a href=\"" + valueArray[i] + "\" url=\"" + valueArray[i] + "\" target=\"_blank\">" + decodeURIComponent(valueArray[i].substring(valueArray[i].lastIndexOf("/") + 1)) + "</a>"
                                } else {
                                    labelArray[i] = '<img   onclick="jp.showPic(\'' + valueArray[i] + '\')"' + ' height="50px" src="' + valueArray[i] + '">';
                                }
                            }
                            return labelArray.join(" ");
                        } catch (e) {
                        }
                    }

                }
                , {
                    field: 'logisticsUser.name',
                    title: '快递员',
                    sortable: true,
                    sortName: 'logisticsUser.name'

                }
                , {
                    field: 'logisticsDate',
                    title: '取件时间',
                    sortable: true,
                    sortName: 'logisticsDate'

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


            $('#scBoxItemTable').bootstrapTable("toggleView");
        }

        $('#scBoxItemTable').on('check.bs.table uncheck.bs.table load-success.bs.table ' +
            'check-all.bs.table uncheck-all.bs.table', function () {
            $('#remove').prop('disabled', !$('#scBoxItemTable').bootstrapTable('getSelections').length);
            $('#view,#edit').prop('disabled', $('#scBoxItemTable').bootstrapTable('getSelections').length != 1);
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
                    jp.downloadFile('${ctx}/boxitem/scBoxItem/import/template');
                },
                btn2: function (index, layero) {
                    var iframeWin = layero.find('iframe')[0]; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
                    iframeWin.contentWindow.importExcel('${ctx}/boxitem/scBoxItem/import', function (data) {
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
            var sortName = $('#scBoxItemTable').bootstrapTable("getOptions", "none").sortName;
            var sortOrder = $('#scBoxItemTable').bootstrapTable("getOptions", "none").sortOrder;
            var values = "";
            for (var key in searchParam) {
                values = values + key + "=" + searchParam[key] + "&";
            }
            if (sortName != undefined && sortOrder != undefined) {
                values = values + "orderBy=" + sortName + " " + sortOrder;
            }

            jp.downloadFile('${ctx}/boxitem/scBoxItem/export?' + values);
        })


        $("#search").click("click", function () {// 绑定查询按扭
            $('#scBoxItemTable').bootstrapTable('refresh');
        });

        $("#reset").click("click", function () {// 绑定查询按扭
            $("#searchForm  input").val("");
            $("#searchForm  select").val("");
            $("#searchForm  .select-item").html("");
            $('#scBoxItemTable').bootstrapTable('refresh');
        });

        $('#beginPrintDate').datetimepicker({
            format: "YYYY-MM-DD HH:mm:ss"
        });
        $('#endPrintDate').datetimepicker({
            format: "YYYY-MM-DD HH:mm:ss"
        });
        $('#beginProductionDate').datetimepicker({
            format: "YYYY-MM-DD HH:mm:ss"
        });
        $('#endProductionDate').datetimepicker({
            format: "YYYY-MM-DD HH:mm:ss"
        });
        $('#beginPackageDate').datetimepicker({
            format: "YYYY-MM-DD HH:mm:ss"
        });
        $('#endPackageDate').datetimepicker({
            format: "YYYY-MM-DD HH:mm:ss"
        });
        $('#beginLogisticsDate').datetimepicker({
            format: "YYYY-MM-DD HH:mm:ss"
        });
        $('#endLogisticsDate').datetimepicker({
            format: "YYYY-MM-DD HH:mm:ss"
        });

    });

    function getIdSelections() {
        return $.map($("#scBoxItemTable").bootstrapTable('getSelections'), function (row) {
            return row.id
        });
    }

    function deleteAll() {

        jp.confirm('确认要删除该每箱记录吗？', function () {
            jp.loading();
            jp.get("${ctx}/boxitem/scBoxItem/deleteAll?ids=" + getIdSelections(), function (data) {
                if (data.success) {
                    $('#scBoxItemTable').bootstrapTable('refresh');
                    jp.success(data.msg);
                } else {
                    jp.error(data.msg);
                }
            })

        })
    }

    //刷新列表
    function refresh() {
        $('#scBoxItemTable').bootstrapTable('refresh');
    }

    function add() {
        jp.openSaveDialog('新增每箱', "${ctx}/boxitem/scBoxItem/form", '800px', '500px');
    }


    function edit(id) {//没有权限时，不显示确定按钮
        if (id == undefined) {
            id = getIdSelections();
        }
        jp.openSaveDialog('编辑每箱', "${ctx}/boxitem/scBoxItem/form?id=" + id, '800px', '500px');
    }

    function view(id) {//没有权限时，不显示确定按钮
        if (id == undefined) {
            id = getIdSelections();
        }
        jp.openViewDialog('查看每箱', "${ctx}/boxitem/scBoxItem/form?id=" + id, '800px', '500px');
    }


</script>