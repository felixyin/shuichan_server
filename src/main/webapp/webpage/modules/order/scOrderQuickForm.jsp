<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<html>
<head>
    <title>订单管理</title>
    <meta name="decorator" content="ani"/>
    <link href="${ctxs}/static/plugin/jquery-autocomplete/easy-autocomplete.min.css" rel="stylesheet">
    <style>
        .width-label {
            width: 10%;
        }

        .width-value {
            width: 15%;
        }

        .easy-autocomplete-container {
            z-index: 200;
        }
    </style>
    <script src="${ctxs}/static/plugin/jquery-autocomplete/jquery.easy-autocomplete.min.js"></script>
    <script type="text/javascript">

        var Log = {
            colors: {
                primary: 'primary',
                info: 'info',
                danger: 'danger',
                success: 'success',
                warning: 'warning'
            },
            data: {},
            log: function (params) {
                setTimeout(function () {
                    this.data = $.extend({}, this.data, params);
                    var $lu = $('#logUl').empty(), logHtml = '';
                    for (var key in this.data) {
                        if (this.data.hasOwnProperty(key) && this.data[key] && this.data[key][1]) {
                            logHtml += '<li class="text-' + this.data[key][0] + '">' + this.data[key][1] + '</li>';
                        }
                    }
                    $lu.append(logHtml);
                });
            }
        };

        /**
         * 保存处理
         */
        function save(isOpenNextDialog) {
            var agentNameVal = $('#agentName').val();
            if ($.trim(agentNameVal) == '') {
                jp.warning('代理人不能为空！');
                return;
            }
            var usernameVal = $('#username').val();
            // if ($.trim(agentNameVal) == '' && $.trim(usernameVal) == '') {
            //     jp.warning('姓名、代理人不能同时为空！');
            //     return;
            // }
            var phoneVal = $('#phone').val();
            var addressVal = $('#address').val();
            if ($.trim(usernameVal) == '' && $.trim(addressVal) == '' && $.trim(phoneVal) == '') {
                jp.warning('电话、姓名、地址至少一项不能为空！');
                return;
            }

            // 移除没有填写的包装箱
            $('#scBoxList').find('tr').each(function (i, n) {
                var $tr = $(this);
                var willDel = true;
                $tr.find('input').each(function () {
                    var value = $(this).val();
                    if (value && value !== "0") {
                        console.log(value);
                        willDel = false;
                    }
                });
                if (willDel) {
                    if ($('#scBoxList').find('tr').size() > 1) {
                        $tr.remove();
                    }
                }
            });

            var isValidate = jp.validateForm('#inputForm');//校验表单
            if (!isValidate) {
                jp.warning('表单验证失败，请检查表单输入项！');
                return false;
            } else {
                localStorage.setItem('__deliver_date', $('#deliverDate').val());
                jp.loading();
                jp.post("${ctx}/order/scOrder/saveAll", $('#inputForm').serialize(), function (data) {
                    if (data.success) {
                        jp.getParent().refresh();
                        var dialogIndex = parent.layer.getFrameIndex(window.name); // 获取窗口索引
                        parent.layer.close(dialogIndex);
                        jp.success(data.msg);
                        if (isOpenNextDialog) {
                            jp.getParent().add();
                        }
                    } else {
                        jp.error(data.msg);
                    }
                })
            }

        }

        var _custom_id, _custom_phone, _custom_username, _custom_address = null;

        $(document).ready(function () {

            Log.log({
                kuaijiejian: [Log.colors.danger, '操作提示：导航：鼠标移动到空间上方或按下Tab键盘可快速导航。自动完成选项：鼠标在控件上双击展开可选项，右击可清除内容，物流公司、规格、调拨工厂控件可输入拼音或拼音首字母快速匹配选项']
            });

            // 页面加载完毕，自动添加3行包装箱
            for (var i = 0; i < 2; i++) {
                addRow('#scBoxList', scBoxRowIdx, scBoxTpl);
                scBoxRowIdx = scBoxRowIdx + 1;
            }

            // 记住上次保存的发货日期
            var deliverDate = Date.now();
            var ddStr = localStorage.getItem('__deliver_date');
            if (ddStr) {
                if(parseInt(ddStr) > deliverDate){ // 记住的日期如果小于当前时间，则弃用，否则使用。
                    deliverDate = Date.parse(ddStr);
                }
            }
            $('#deliverDate').datetimepicker({
                format: "YYYY-MM-DD",
                defaultDate: deliverDate
            });

            /*
            // 鼠标hover，input自动获取焦点 客户不喜欢这个功能
            $('#inputForm').find('input,textarea,select').hover(function () {
                $(this).focus();
            }).contextmenu(function () {
                $(this).val('');
            });
             */

            function createAutocompleteOption($input, inputName) {

                function parseData(data, inputName) {
                    if ('phone' === inputName) {
                        data.phone = data.value;
                        var arr = data.descr.split(' | ');
                        data.username = arr[0];
                        data.address = arr[1];
                    } else if ('username' === inputName) {
                        data.username = data.value;
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

                    data = parseData(data, inputName);

                    $phone.val(data.phone);
                    $username.val(data.username);
                    $address.val(data.address);

                    _custom_id = data.id;
                    _custom_phone = data.phone;
                    _custom_username = data.username;
                    _custom_address = data.address;

                    $customId.val(data.id);
                    Log.log({
                        custom: [Log.colors.primary,
                            '选择客户：您选择了客户管理中的客户数据:' + [$phone.val(), $username.val(), $address.val()].join('-')]
                    });
                    // 获取此客户所有的代理人
                    jp.post('${ctx}/order/scOrder/autoCompleteAgentName', {customId: data.id}, function (result) {
                        if (result && result.success) {
                            if (result.msg) {
                                $('#agentName').val(result.msg);
                                Log.log({
                                    dlr: [Log.colors.primary,
                                        '自动填写代理人：从此客户的相关历史订单记录中找到最新保存的代理人:' + result.msg]
                                });
                            } else {
                                Log.log({
                                    dlr: [Log.colors.danger,
                                        '自动填写代理人：从此客户的相关历史订单记录中没有找到最新保存的代理人']
                                });
                            }
                        }
                    });
                };
                return {
                    url: function (query) {
                        return '${ctx}/oimport/scOrderImport/autoCompleteCustom?' + inputName + '=' + $.trim(query);
                    },
                    getValue: function (result) {
                        // _custom_id = result.id;
                        return result.value;
                    },
                    minCharNumber: 0,
                    template: {
                        type: "description",
                        fields: {
                            description: "descr"
                        }
                    },
                    list: {
                        /* onSelectItemEvent: function () {
                                 // var data = $input.getSelectedItemData();
                                 // if ('phone' === inputName) {
                                 //     data.phone = data.value;
                                 //     var arr = data.descr.split(' | ');
                                 //     data.username = arr[0];
                                 //     data.address = arr[1];
                                 // } else if ('username' === inputName) {
                                 //     data.username = data.value;
                                 //     var arr = data.descr.split(' | ');
                                 //     data.phone = arr[0];
                                 //     data.address = arr[1];
                                 // } else if ('address' === inputName) {
                                 //     data.address = data.value;
                                 //     var arr = data.descr.split(' | ');
                                 //     data.phone = arr[0];
                                 //     data.username = arr[1];
                                 // }
                                 // var phoneValue = $.trim($phone.val());
                                 // if (!phoneValue) {
                                 //     $phone.attr('placeholder', data.phone)
                                 // }
                                 // var usernameValue = $.trim($username.val());
                                 // if (!usernameValue) {
                                 //     $username.attr('placeholder', data.username)
                                 // }
                                 // var addressValue = $.trim($address.val());
                                 // if (!addressValue) {
                                 //     $address.attr('placeholder', data.address)
                                 // }
                            return false;
                        },*/
                        onChooseEvent: onChooseEvent,
                        onLoadEvent: function () {
                            var data = $input.getItemData(0);
                            var currentInputValue = $input.val();
                            if (inputName === 'phone') { // 手机号唯一，采用手机号确认客户id
                                if (currentInputValue === data.value) { // 您选择了
                                    // $customId.val(data.id);
                                    onChooseEvent(data);
                                } else { // 将会创建
                                    $customId.val('');
                                    _custom_id = '';
                                    Log.log({
                                        custom: [Log.colors.success,
                                            '创建客户：将会自动创建此客户:' + [$phone.val(), $username.val(), $address.val()].join('-') + '，并关联此订单']
                                    });
                                }
                            } else {
                                if (_custom_username === $username.val() && _custom_address === $address.val()) { // 您选择了
                                    Log.log({
                                        custom: [Log.colors.primary,
                                            '选择客户：您选择了客户管理中的客户数据:' + [$phone.val(), $username.val(), $address.val()].join('-')]
                                    });
                                } else { // 将会修改
                                    Log.log({
                                        custom: [Log.colors.warning,
                                            '修改客户：您选择了客户管理中的客户数据，并且提交表单后客户会修改为:' + [$phone.val(), $username.val(), $address.val()].join('-')]
                                    });
                                }
                            }
                        }
                    }
                };
            }

            // 客户电话 自动完成
            var $customId = $('#customId');
            var $phone = $('#phone');
            var $username = $('#username');
            var $address = $('#address');
            $phone.focus().easyAutocomplete(createAutocompleteOption($phone, 'phone'));
            $username.focus().easyAutocomplete(createAutocompleteOption($username, 'username'));
            $address.easyAutocomplete(createAutocompleteOption($address, 'address'));
            $($phone, $username, $address).keyup(function () {
                if (!$(this).val()) {
                    Log.log({custom: [Log.colors.success, '']});
                    Log.log({dlr: [Log.colors.success, '']});
                }
            });

            // 代理人自动完成
            var $agentName = $('#agentName');
            $agentName.easyAutocomplete({
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

            // 物流公司自动完成
            var $logisticsName = $('#logisticsName');
            var $logisticsId = $('#logisticsId');
            var onChooseEvent = function (firstData) {
                //  获取客户 的 其他信息填写
                var data = $logisticsName.getSelectedItemData();
                if (firstData) data = firstData;
                $logisticsId.val(data.id);
                Log.log({
                    wuliu: [Log.colors.primary,
                        '选择物流公司：您选择了机构管理中的机构数据:' + data.value]
                });
            };
            $logisticsName.easyAutocomplete({
                url: function (query) {
                    var url = '${ctx}/order/scOrder/autoCompleteOffice?type=2&officeName=' + $.trim(query);
                    // fixme  临时不添加，查询全部数据
                    // if (_custom_id) {
                    //     url += '&customId=' + _custom_id;
                    // }
                    return url;
                },
                getValue: function (result) {
                    return result.value;
                },
                list: {
                    onChooseEvent: onChooseEvent,
                    onLoadEvent: function () {
                        var firstData = $logisticsName.getItemData(0);
                        if (firstData !== -1 && $logisticsName.val() === firstData.value) { // 匹配到
                            onChooseEvent(firstData);
                        } else { // 不匹配
                            $logisticsId.val('');
                            Log.log({
                                wuliu: [Log.colors.success,
                                    '创建物流公司：将会自动创建此机构:' + $logisticsName.val() + '，并关联此订单']
                            });
                        }
                    }
                }
            }).keyup(function () {
                if (!$(this).val()) {
                    Log.log({wuliu: [Log.colors.success, '']});
                }
            });

        });


        function addRow(list, idx, tpl, row) {
            var remarks = $('#remarks').val();
            if (remarks && !row) {
                row = {};
                row.remarks = remarks;
            }
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
            /*
             // 客户不喜欢这个功能
             $(list + idx).find('input,textarea,select').hover(function () {
                 $(this).focus();
             }).contextmenu(function () {
                 $(this).val('');
             });
             */

            var $productionId = $('#scBoxList' + idx + '_productionId');
            var $productionName = $('#scBoxList' + idx + '_productionName');
            var $singlePrice = $('#scBoxList' + idx + '_singlePrice');
            var $allotFactoryId = $('#scBoxList' + idx + '_allotFactoryId');
            var $allotFactoryName = $('#scBoxList' + idx + '_allotFactoryName');
            var $weight = $('#scBoxList' + idx + '_weight');
            var $logisticsPrice = $('#scBoxList' + idx + '_logisticsPrice');

            var _production_name, _single_price = null;

            // 规格自动完成

            var onChooseEvent = function (firstData) {
                var data = $productionName.getSelectedItemData();
                if (firstData) data = firstData;
                _production_name = data.value;
                _single_price = data.descr;
                $productionId.val(data.id);
                $singlePrice.val(data.descr);
                Log.log({
                    guige: [Log.colors.primary,
                        '选择规格：您选择了产品管理中的产品数据:' + data.value]
                });
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
                    return result.value;
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
                        } else { // 不匹配
                            $productionId.val('');
                            _production_name = '';
                            Log.log({
                                price: [Log.colors.primary, ''],
                            });
                            Log.log({
                                guige: [Log.colors.success,
                                    '创建规格：将会自动创建产品:' + $productionName.val() + '，并关联此包装箱']
                            });
                            // $singlePrice.attr('required','true');
                        }
                    }
                }
            }).keyup(function () {
                if (!$(this).val()) {
                    Log.log({guige: [Log.colors.success, '']});
                }
            });

            /**
             * 设置每斤价格提示
             */
            $singlePrice.keyup(function () {
                if (!_production_name) return;
                var v = $(this).val();
                // if (!v) {
                //     v = _single_price;
                //     $(this).val(v);
                // }
                if (_single_price === v) {
                    Log.log({price: [Log.colors.primary, '']});
                } else {
                    Log.log({
                        price: [Log.colors.warning,
                            '修改规格价格：将会修改产品管理中规格名（' + _production_name + '）的最新每斤价格为：' + v]
                    });
                }
            });


            /**
             * 设置单箱快递费用
             */
            $weight.keyup(function () {
                if (!_custom_id) {
                    Log.log({
                        kdf: [Log.colors.primary,
                            '自动填写单箱快递费：检测到您还没有录入客户信息，客户信息和重量都需要录入，才可帮您查询和录入单箱快递费']
                    });
                    return;
                }
                var weight = $(this).val();
                if (!weight) {
                    Log.log({kdf: [Log.colors.primary, '']});
                    return;
                }

                jp.post('${ctx}/order/scOrder/findLogisticsPrice',
                    // {customId: customId, productionId: productionId, weight: weight}
                    {customId: _custom_id, weight: weight}
                    , function (result) {
                        if (result && result.success) {
                            if (result.msg) {
                                $logisticsPrice.val(result.msg);
                                Log.log({
                                    kdf: [Log.colors.primary,
                                        '自动填写单箱快递费：从此客户(' + _custom_username + ')的相关历史订单记录中找到最新保存的此重量(' + weight + ')对应的快递费:' + result.msg]
                                });
                            } else {
                                Log.log({
                                    kdf: [Log.colors.danger,
                                        '自动填写单箱快递费：从此客户(' + _custom_username + ')的相关历史订单记录中没有找到此重量(' + weight + ')对应的快递费信息']
                                });
                            }
                        }
                    });
            });

            // 调拨工厂
            var onChooseEvent1 = function (firstData) {
                //  获取客户 的 其他信息填写
                var data = $allotFactoryName.getSelectedItemData();
                if (firstData) data = firstData;
                $allotFactoryId.val(data.id);
                Log.log({
                    wuliu: [Log.colors.primary,
                        '选择调拨工厂：您选择了机构管理中的机构数据:' + data.value]
                });
            };
            $allotFactoryName.easyAutocomplete({
                url: function (query) {
                    var url = '${ctx}/order/scOrder/autoCompleteOffice?type=1&officeName=' + $.trim(query);
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
                            $allotFactoryId.val('');
                            Log.log({
                                wuliu: [Log.colors.success,
                                    '创建调拨工厂：将会自动创建此机构:' + $allotFactoryName.val() + '，并关联此订单']
                            });
                        }
                    }
                }
            }).keyup(function () {
                if (!$(this).val()) {
                    Log.log({diaobo: [Log.colors.success, '']});
                }
            });

        }

        function delRow(obj, prefix) {
            if ($('#scBoxList').find('tr').size() == 1) {
                jp.warning('不能删除！');
                return;
            }
            var id = $(prefix + "_id");
            var delFlag = $(prefix + "_delFlag");
            if (id.val() === "") {
                var $tr = $(obj).parent().parent();
                // 判断用户是否已经填写此行的表单数据，如果填写则给与友好提示
                let find = $tr.find('input');
                var alreadInputCount = find.filter(function () {
                    return $(this).val().length > 0
                }).size();
                if (alreadInputCount <= 1) {
                    $tr.remove();
                } else {
                    jp.confirm('您已填写了表单，是否确认要删除此规格(' + find.eq(2).val() + ')的包装箱？', function () {
                        $tr.remove();
                    });
                }
            } else if (delFlag.val() === "0") {
                delFlag.val("1");
                $(obj).html("&divide;").attr("title", "撤销删除");
                $(obj).parent().parent().addClass("error");
            } else if (delFlag.val() === "1") {
                delFlag.val("0");
                $(obj).html("&times;").attr("title", "删除");
                $(obj).parent().parent().removeClass("error");
            }
        }
    </script>
</head>
<body class="bg-white">
<form:form id="inputForm" modelAttribute="scOrder" action="${ctx}/order/scOrder/save" method="post"
           class="form-horizontal">
    <%--    <fieldset>--%>
    <%--    <legend>订单信息表单</legend>--%>
    <form:hidden path="id"/>
    <span style="display: none;">
                    <form:hidden path="factory.id" value="${scOrder.factory.id}"/>
                        ${scOrder.factory.name}
                    <form:hidden path="realLogistics.id" value="${scOrder.realLogistics.id}"/>
                        ${scOrder.realLogistics.name}
            </span>
    <table class="table table-bordered">
        <tbody>
        <tr>
            <td class="width-label active"><label class="pull-right"><%--<font color="red">*</font>--%>电话：</label></td>
            <td class="width-value">
                <form:input path="custom.phone" id="phone" htmlEscape="false" class="form-control "/>
                <form:hidden path="custom.id" id="customId" htmlEscape="false" class="form-control "/>
            </td>
            <td class="width-label active"><label class="pull-right"><%--<font color="red">*</font>--%>姓名：</label></td>
            <td class="width-value">
                <form:input path="custom.username" id="username" htmlEscape="false" class="form-control "/>
            </td>
            <td class="width-label active"><label class="pull-right"><%--<font color="red">*</font>--%>地址：</label></td>
            <td class="width-value" colspan="3">
                <form:input path="custom.address" id="address" htmlEscape="false" class="form-control "/>
            </td>
        </tr>
        <tr>
            <td class="width-label active"><label class="pull-right">代理人：</label></td>
            <td class="width-value">
                <form:input path="agentName" id="agentName" htmlEscape="false" class="form-control required"/>
            </td>
            <td class="width-label active"><label class="pull-right">指定物流公司：</label></td>
            <td class="width-value">
                <form:input path="shouldLogistics.name" id="logisticsName" htmlEscape="false" class="form-control "/>
                <form:hidden path="shouldLogistics.id" id="logisticsId" htmlEscape="false" class="form-control "/>
            </td>
            <td class="width-label active"><label class="pull-right">物流班次：</label></td>
            <td class="width-value">
                <form:select path="shift" class="form-control ">
                    <form:option value="" label=""/>
                    <form:options items="${fns:getDictList('logistics_shift')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </td>
            <td class="width-label active"><label class="pull-right">要求发货日期：</label></td>
            <td class="width-value">
                <div class='input-group date'>
                    <input type='text' name="deliverDate" id="deliverDate"
                           class="form-control" value="${deliverDate}"/>
                    <span class="input-group-addon">
                       <span class="glyphicon glyphicon-calendar"></span>
                    </span>
                </div>
            </td>
        </tr>
        <tr>
            <td class="width-label active"><label class="pull-right">订单备注：</label></td>
            <td class="width-value" colspan="4">
                <form:textarea path="remarks" id="remarks" htmlEscape="false" cssStyle="resize: none;" rows="1"
                               class="form-control "
                               placeholder="可不填，如包装箱没有备注信息则保存时自动作为所有包装箱的备注"
                               title="订单下的包装箱默认采用此备注"/>
            </td>
            <td class="width-label active"><label class="pull-right">物流备注：</label></td>
            <td class="width-value" colspan="2">
                <form:textarea path="logisticsRemarks" id="logisticsRemarks" htmlEscape="false" cssStyle="resize: none;" rows="1"
                               class="form-control "
                               placeholder="可不填，用于工厂间调货"
                               title="可不填，用于工厂间调货"/>
            </td>
        </tr>
        </tbody>
    </table>


    <div class="tabs-container">
        <ul class="nav nav-tabs">
            <li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">包装箱：</a>
            </li>
        </ul>
        <div class="tab-content">
            <div id="tab-1" class="tab-pane fade in  active">
                <a class="btn btn-white btn-sm" style="font-size: 14px;"
                   onclick="addRow('#scBoxList', scBoxRowIdx, scBoxTpl);scBoxRowIdx = scBoxRowIdx + 1;" title="新增">
                    <i class="fa fa-plus"></i> 新增
                </a>
                <table class="table table-striped table-bordered table-condensed">
                    <thead>
                    <tr>
                        <th class="hide" style="width:14%"></th>
                        <th style="width:15%"><font color="red">*</font>规格</th>
                        <th style="width:11%"><font color="red">*</font>重量（斤）</th>
                        <th style="width:11%"><font color="red">*</font>数量（箱）</th>
                        <th style="width:11%"><%--<font color="red">*</font>--%>每斤价格</th>
                        <th style="width:11%">单箱快递费</th>
<%--                        <th style="width:14%">调拨工厂</th>--%>
                        <th style="width:32%">规格备注</th>
                        <th style="width: 8%">删除</th>
                    </tr>
                    </thead>
                    <tbody id="scBoxList">
                    </tbody>
                </table>
                <script type="text/template" id="scBoxTpl">//<!--
				<tr id="scBoxList{{idx}}">
					<td class="hide">
						<input id="scBoxList{{idx}}_id" name="scBoxList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
						<input id="scBoxList{{idx}}_delFlag" name="scBoxList[{{idx}}].delFlag" type="hidden" value="0"/>
					</td>
					<td>
						<input id="scBoxList{{idx}}_productionName" name="scBoxList[{{idx}}].production.name" type="text" value="{{row.production.name}}"
						class="form-control"/>
						<input id="scBoxList{{idx}}_productionId" name="scBoxList[{{idx}}].production.id" type="hidden" value="{{row.production.id}}"/>
					</td>
					<td>
						<input id="scBoxList{{idx}}_weight" name="scBoxList[{{idx}}].weight" type="text" value="{{row.weight}}"    class="form-control required isFloatGtZero"/>
					</td>
					<td>
						<input id="scBoxList{{idx}}_count" name="scBoxList[{{idx}}].count" type="text" value="{{row.count}}"    class="form-control required isIntGtZero"/>
					</td>
					<td>
						<input id="scBoxList{{idx}}_singlePrice" name="scBoxList[{{idx}}].singlePrice" type="text" value="{{row.singlePrice}}"
						class="form-control  isFloatGteZero"/>
					</td>
					<td>
						<input id="scBoxList{{idx}}_logisticsPrice" name="scBoxList[{{idx}}].logisticsPrice" type="text" value="{{row.logisticsPrice}}"    class="form-control  isFloatGteZero"/>
					</td>
<%--					<td  class="max-width-250">--%>
<%--						<input id="scBoxList{{idx}}_allotFactoryName" name="scBoxList[{{idx}}].allotFactory.name" type="text" value="{{row.allotFactory.name}}" class="form-control"/>--%>
<%--						<input id="scBoxList{{idx}}_allotFactoryId" name="scBoxList[{{idx}}].allotFactory.id" type="hidden" value="{{row.allotFactory.id}}"/>--%>
<%--					</td>--%>
					<td>
						<input id="scBoxList{{idx}}_remarks" name="scBoxList[{{idx}}].remarks" type="text" value="{{row.remarks}}"    class="form-control
						my-remarks"/>
					</td>
					<td class="text-center" width="10">
						{{#delBtn}}<span class="close" onclick="delRow(this, '#scBoxList{{idx}}')" style="font-size:28px;float:none;" title="删除">&times;</span
						>{{/delBtn}}
					</td>
				</tr>//-->
                </script>
                <script type="text/javascript">
                    var scBoxRowIdx = 0, scBoxTpl = $("#scBoxTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                    $(document).ready(function () {
                        var data = ${fns:toJson(scOrder.scBoxList)};
                        for (var i = 0; i < data.length; i++) {
                            addRow('#scBoxList', scBoxRowIdx, scBoxTpl, data[i]);
                            scBoxRowIdx = scBoxRowIdx + 1;
                        }
                    });
                </script>
            </div>
        </div>
    </div>
</form:form>
<div>
    <div>
        <hr>
        <span style="margin:0  20px;font-weight: bold">提示:</span> <a href="javascript:$('#logUl').empty();">清除</a>
    </div>
    <div class="well-small"
         style="height:80px;max-height: 80px;overflow: scroll;margin: 0 55px; border: 1px solid #0b2e13;">
        <ul style="list-style-type: decimal;font-size: 13px;" id="logUl">
        </ul>
    </div>
</div>
</body>
</html>