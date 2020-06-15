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
        var $table = $('#outOrderTable');
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
            minimumCountColumns: 2,
            width: 800,
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
            url: "${ctx}/order/scOrder/outOrderData?ids=${ids}",
            // data:'',
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
            onClickRow: function (row, $el) {
            },
            onShowSearch: function () {
                $("#search-collapse").slideToggle();
            },
            columns: [
                <c:if test="${setting.num == '1'}">
                {
                    title: '序号',
                    field: 'num',
                    align: 'center',
                    width: 35,
                    formatter: function (value, row, index) {
                        return index + 1;
                    }
                },
                </c:if>
                <c:if test="${setting.phone == '1'}">
                {
                    field: 'phone',
                    title: '电话',
                    align: 'center',
                    width: 70
                },
                </c:if>
                <c:if test="${setting.name == '1'}">
                {
                    field: 'username',
                    title: '姓名',
                    align: 'center',
                    width: 60,
                },
                </c:if>
                <c:if test="${setting.address == '1'}">
                {
                    field: 'address',
                    title: '地址',
                    align: 'center',
                    width: 180,
                },
                </c:if>
                <c:if test="${setting.spec == '1'}">
                {
                    field: 'spec',
                    title: '品名（规格）',
                    align: 'center',
                    width: 70,
                },
                </c:if>
                <c:if test="${setting.count == '1'}">
                {
                    field: 'count',
                    title: '数量（箱）',
                    align: 'center',
                    width: 50,
                }
                </c:if>
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