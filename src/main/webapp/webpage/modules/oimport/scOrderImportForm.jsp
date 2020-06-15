<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<html>
<head>
    <title>导入订单管理</title>
    <meta name="decorator" content="ani"/>
    <link href="${ctxStatic}/plugin/jquery-autocomplete/easy-autocomplete.min.css" rel="stylesheet">
    <style>
        /*表单label宽度设置*/
        .width-label {
            width: 18%;
        }

        /*表单input的宽度设置 */
        .width-value {
            width: 32%;
        }

    </style>
    <script src="${ctxStatic}/plugin/jquery-autocomplete/jquery.easy-autocomplete.min.js"></script>
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

        var _custom_id, _custom_phone, _custom_username, _custom_address = null;

        $(document).ready(function () {
            Log.log({
                kuaijiejian: [Log.colors.danger, '操作提示：导航：鼠标移动到空间上方或按下Tab键盘可快速导航。自动完成选项：鼠标在控件上双击展开可选项，右击可清除内容，物流公司、规格、调拨工厂控件可输入拼音或拼音首字母快速匹配选项']
            });

            // 页面显示完毕，电话获取焦点
            $('#phone').focus();

            $('#deliverDate').datetimepicker({
                format: "YYYY-MM-DD HH:mm:ss"
            });

            // 鼠标hover，input自动获取焦点
            $('#inputForm').find('input,textarea').hover(function () {
                $(this).focus();
            });

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
            $username.easyAutocomplete(createAutocompleteOption($username, 'username'));
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

            // 物流班次
            $shiftName = $('#shiftName');
            $shiftName.easyAutocomplete({
                data: ["早班", "中班", "晚班"],
            });


            // 调拨加工厂自动完成
            var $allotFactoryName = $('#allotFactoryName');
            var $logisticsId = $('#logisticsId');
            var onChooseEvent = function (firstData) {
                //  获取客户 的 其他信息填写
                var data = $allotFactoryName.getSelectedItemData();
                if (firstData) data = firstData;
                $logisticsId.val(data.id);
                Log.log({
                    wuliu: [Log.colors.primary,
                        '选择物流公司：您选择了机构管理中的机构数据:' + data.value]
                });
            };

            $allotFactoryName.easyAutocomplete({
                url: function (query) {
                    var url = '${ctx}/order/scOrder/autoCompleteOffice?type=1&officeName=' + $.trim(query);
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
                        var firstData = $allotFactoryName.getItemData(0);
                        if (firstData !== -1 && $allotFactoryName.val() === firstData.value) { // 匹配到
                            onChooseEvent(firstData);
                        } else { // 不匹配
                            $logisticsId.val('');
                            Log.log({
                                wuliu: [Log.colors.success,
                                    '创建物流公司：将会自动创建此机构:' + $allotFactoryName.val() + '，并关联此订单']
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

        function save() {
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

            var isValidate = jp.validateForm('#inputForm');//校验表单
            if (!isValidate) {
                jp.warning('表单验证失败，请检查表单输入项！');
                return false;
            } else {
                jp.loading();
                jp.post("${ctx}/oimport/scOrderImport/save", $('#inputForm').serialize(), function (data) {
                    if (data.success) {
                        jp.getParent().refresh();
                        var dialogIndex = parent.layer.getFrameIndex(window.name); // 获取窗口索引
                        parent.layer.close(dialogIndex);
                        jp.success(data.msg)
                    } else {
                        jp.error(data.msg);
                    }
                });
            }
        }
    </script>
</head>
<body class="bg-white">
<form:form id="inputForm" modelAttribute="scOrderImport" class="form-horizontal">
    <form:hidden path="id"/>
    <table class="table table-bordered">
        <tbody>
        <tr>
            <td class="width-label active"><label class="pull-right"><font color="#ffebcd">*</font>电话：</label></td>
            <td class="width-value">
                <form:input path="phone" id="phone" htmlEscape="false" class="form-control "/>
            </td>
            <td class="width-label active"><label class="pull-right"><font color="#ffebcd">*</font>姓名：</label></td>
            <td class="width-value">
                <form:input path="username" id="username" htmlEscape="false" class="form-control"/>
            </td>
        </tr>
        <tr>
            <td class="width-label active"><label class="pull-right"><font color="#ffebcd">*</font>地址：</label></td>
            <td class="width-value">
                <form:input path="address" id="address" htmlEscape="false" class="form-control"/>
            </td>
            <td class="width-label active"><label class="pull-right">代理人：</label></td>
            <td class="width-value">
                <form:input path="agentName" id="agentName" htmlEscape="false" class="form-control  required "/>
            </td>
        </tr>
        <tr>
            <td class="width-label active"><label class="pull-right">物流公司：</label></td>
            <td class="width-value">
                <form:input path="logisticsName" id="logisticsName" htmlEscape="false" class="form-control "/>
            </td>
            <td class="width-label active"><label class="pull-right">物流班次：</label></td>
            <td class="width-value">
                <form:input path="shiftName" id="shiftName" htmlEscape="false" class="form-control "/>
            </td>
        </tr>
        <tr>
            <td class="width-label active"><label class="pull-right">调拨加工厂：</label></td>
            <td class="width-value">
                <form:input path="allotFactoryName" id="allotFactoryName" htmlEscape="false" class="form-control "/>
            </td>
            <td class="width-label active"><label class="pull-right"><font color="red">*</font>品名（规格）：</label></td>
            <td class="width-value">
                <form:input path="productionName" id="productionName" htmlEscape="false" class="form-control required"/>
            </td>
        </tr>
        <tr>
            <td class="width-label active"><label class="pull-right"><font color="red">*</font>每斤价格：</label></td>
            <td class="width-value">
                <form:input path="lastUnitPrice" id="lastUnitPrice" htmlEscape="false"
                            class="form-control required isFloatGtZero"/>
            </td>
            <td class="width-label active"><label class="pull-right"><font color="red">*</font>单箱重量（斤）：</label></td>
            <td class="width-value">
                <form:input path="weight" id="weight" htmlEscape="false" class="form-control required isIntGtZero"/>
            </td>
        </tr>
        <tr>
            <td class="width-label active"><label class="pull-right"><font color="red">*</font>数量（箱）：</label></td>
            <td class="width-value">
                <form:input path="count" id="count" htmlEscape="false" class="form-control required isIntGtZero"/>
            </td>
            <td class="width-label active"><label class="pull-right">单箱快递费：</label></td>
            <td class="width-value">
                <form:input path="logisticsPrice" id="logisticsPrice" htmlEscape="false"
                            class="form-control  isFloatGtZero"/>
            </td>
        </tr>
        <tr>
            <td class="width-label active"><label class="pull-right">备注信息：</label></td>
            <td class="width-value" colspan="5">
                <form:textarea path="remarks" id="remarks" htmlEscape="false" rows="1" class="form-control "
                               cssStyle="resize:none;"/>
            </td>
        </tr>
        </tbody>
    </table>
</form:form>
<div>
    <div>
        <hr>
        <span style="margin:0  20px;font-weight: bold">提示:</span> <a href="javascript:$('#logUl').empty();">清除</a>
    </div>
    <div class="well-small"
         style="height:80px;max-height: 80px;overflow: scroll;margin: 0 50px; border: 1px solid #0b2e13;">
        <ul style="list-style-type: decimal;font-size: 13px;" id="logUl">
            <li class="text-warning">系统中不存在此客户，将会新建客户</li>
            <li class="text-success">系统中不存在此客户，将会新建客户</li>
            <li class="text-info">系统中不存在此客户，将会新建客户</li>
            <li class="text-info">系统中不存在此客户，将会新建客户</li>
            <li class="text-info">系统中不存在此客户，将会新建客户</li>
            <li class="text-info">系统中不存在此客户，将会新建客户</li>
            <li class="text-info">系统中不存在此客户，将会新建客户</li>
            <li class="text-info">系统中不存在此客户，将会新建客户</li>
            <li class="text-info">系统中不存在此客户，将会新建客户</li>
            <li class="text-info">系统中不存在此客户，将会新建客户</li>
        </ul>
    </div>
</div>
</body>
</html>