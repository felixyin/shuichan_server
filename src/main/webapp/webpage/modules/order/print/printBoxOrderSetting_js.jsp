<%@ page contentType="text/html;charset=UTF-8" %>
<script>
    $(function () {
        $('#printType_yes').click(function () {
            $('#newline-id').hide();
        });
        $('#printType_no').click(function () {
            $('#newline-id').show();
        });
    });

    /**
     * @param type 打印类型。1，订单编号；2，包装箱编号；3，每箱编号
     */
    function printBoxOrder(type) {
        var ids = getIdSelections();
        if (!ids || ids.length <= 0) {
            jp.warning('请选择订单，再点击批量打印！！！');
            return;
        }
        var s = getPrintBoxOrderSetting();
        jp.openPrintDialog('装箱单打印预览', "${ctx}/order/scOrder/printBoxOrder?ids=" + ids + '&type=' + type, (s.printType === '1')?'470px':'80%', '90%');
    }

    function setPrintBoxOrder() {
        jp.openSettingPrintBoxDialog('装箱单打印设置', "${ctx}/order/scOrder/settingBoxOrder", '700px', '60%', function (iframeWin) {
            var ok = iframeWin.saveSettingData();
            if (ok) {
                jp.success('保存成功！');
            }
        }, function (iframeWin) {
            var ok = iframeWin.resetSettingData();
            if (ok) {
                jp.success('重置成功！');
            }
        });
    }

    var defaultData = {
        printType: "1",
        border: "1",
        tableHead: "1",
        jin: "1",
        count: "1",
        logistics: "1",
        shift: "1",
        receiverBold: "on",
        receiverNewline: "on",
        receiverFontsize: "45",
        remarksFontsize: "40",
        pageWidth: "0",
        pageHeight: "0",
        remarksOffset: "6",
        printAdjusting: "on"
    };

    function setFormValue(d) {
        if (d.hasOwnProperty('printType')) {
            if (d.printType === '1') {
                $('#printType_yes').prop('checked', true);
            } else {
                $('#printType_no').prop('checked', true);
            }
        }
        if (d.hasOwnProperty('border')) {
            if (d.border === '1') {
                $('#border_yes').prop('checked', true);
            } else {
                $('#border_no').prop('checked', true);
            }
        }
        if (d.hasOwnProperty('tableHead')) {
            if (d.tableHead === '1') {
                $('#table_head_yes').prop('checked', true);
            } else {
                $('#table_head_no').prop('checked', true);
            }
        }
        if (d.hasOwnProperty('jin')) {
            if (d.jin === '1') {
                $('#jin_yes').prop('checked', true);
            } else {
                $('#jin_no').prop('checked', true);
            }
        }
        if (d.hasOwnProperty('count')) {
            if (d.count === '1') {
                $('#count_yes').prop('checked', true);
            } else {
                $('#count_no').prop('checked', true);
            }
        }
        if (d.hasOwnProperty('logistics')) {
            if (d.logistics === '1') {
                $('#logistics_yes').prop('checked', true);
            } else {
                $('#logistics_no').prop('checked', true);
            }
        }
        if (d.hasOwnProperty('shift')) {
            if (d.shift === '1') {
                $('#shift_yes').prop('checked', true);
            } else {
                $('#shift_no').prop('checked', true);
            }
        }
        if (d.hasOwnProperty('receiverBold')) {
            if (d.receiverBold === 'on') {
                $('#receiver_bold').prop('checked', true).next().text('是');
            } else {
                $('#receiver_bold').prop('checked', false).next().text('否');
            }
        }
        if (d.hasOwnProperty('receiverNewline')) {
            if (d.receiverNewline === 'on') {
                $('#receiver_newline').prop('checked', true).next().text('是');
            } else {
                $('#receiver_newline').prop('checked', false).next().text('否');
                ;
            }
        }
        if (d.hasOwnProperty('receiverFontsize')) {
            $('#receiver_fontsize').val(d.receiverFontsize);
        }
        if (d.hasOwnProperty('remarksFontsize')) {
            $('#remarks_fontsize').val(d.remarksFontsize);
        }
        if (d.hasOwnProperty('pageWidth')) {
            $('#page_width').val(d.pageWidth);
        }
        if (d.hasOwnProperty('pageHeight')) {
            $('#page_height').val(d.pageHeight);
        }
        if (d.hasOwnProperty('remarksOffset')) {
            $('#remarks_offset').val(d.remarksOffset);
        }
        if (d.hasOwnProperty('printAdjusting')) {
            if (d.printAdjusting === 'on') {
                $('#print_adjusting').prop('checked', true).next().text('打印');
            } else {
                $('#print_adjusting').prop('checked', false).next().text('不打印');
            }
        }
    }

    function getFormValue() {
        var array = $('#setting_form').serializeArray();
        var data = {};
        for (var a of array) {
            data[a.name] = a.value;
        }
        for (var p in defaultData) {
            if (!data.hasOwnProperty(p)) {
                data[p] = 'off';
            }
        }
        return data;
    }

    /**
     * 保存装箱单设置
     * @returns {boolean}
     */
    function saveSettingData() {
        var data = getFormValue();
        var dd = JSON.stringify(data);
        // console.log(dd);
        localStorage.setItem('setting_print_box_order', dd);

        // 保存redis缓存服务器
        $.ajax({
            type: 'post',
            url: ctx + '/order/scOrder/saveSettingBoxOrderPrint',
            data: data,
            async: false
        }).done(function (result) {
            // alert(result.success);
            return result.success;
        });
        return true;
    }

    /**
     * 重置装箱单设置
     * @returns {boolean}
     */
    function resetSettingData() {
        localStorage.setItem('setting_print_box_order', JSON.stringify(defaultData));
        setFormValue(defaultData);
        saveSettingData();
        return true;
    }

    /**
     *
     */
    function loadSettingData() {
        // 保存redis缓存服务器
        $.ajax({
            type: 'get',
            url: ctx + '/order/scOrder/loadSettingBoxOrderPrint',
            async: false
        }).done(function (result) {
            console.log(result.body.setting);
            var data = result.body.setting;
            setFormValue(data);
            if(data.printType === "1"){
                $('#newline-id').hide();
            }
            return result.success;
        });
/*
        var dd = localStorage.getItem('setting_print_box_order');
        // console.log(dd);
        var data = JSON.parse(dd);
        setFormValue(data);
        if(data.printType === "1"){
            $('#newline-id').hide();
        }
 */
    }

    // ------------------ 下面是动效处理 ------------------

    $('#receiver_bold,#receiver_newline').change(function () {
        var v = $(this).prop('checked');
        if (v) {
            $(this).next().text('是');
        } else {
            $(this).next().text('否');
        }
    });

    $('#print_adjusting').change(function () {
        var v = $(this).prop('checked');
        if (v) {
            $(this).next().text('打印');
        } else {
            $(this).next().text('不打印');
        }
    });

    $('#page_width').change(function () {
        var v = parseInt($(this).val());
        if (v === 0) {
            $(this).parent().next().text('默认1075')
        } else {
            $(this).parent().next().text((1075 + v) + ',默认1075')
        }
    });

    $('#page_height').change(function () {
        var v = parseInt($(this).val());
        if (v === 0) {
            $(this).parent().next().text('默认1567')
        } else {
            $(this).parent().next().text((1567 + v) + ',默认1567')
        }
    });

    $('#remarks_offset').change(function () {
        var v = parseInt($(this).val()) * 10;
        if (v === 0) {
            $(this).parent().next().text('默认600')
        } else {
            $(this).parent().next().text((600 + v) + ',默认600')
        }
    });

    function func_remarks_offset() {
        try {
            var vv = $(this).val();
            if (!jQuery.isNumeric(vv)) {
                $(this).val(40);
                return;
            }
            var v = parseInt(vv);
            if (v < 25) {
                $(this).val(25);
            } else if (v > 55) {
                $(this).val(55);
            }
        } catch (e) {
            $(this).val(40);
        }
    }

    $('#remarks_fontsize').change(func_remarks_offset).blur(func_remarks_offset);

    function func_receiver_fontsize() {
        try {
            var vv = $(this).val();
            if (!jQuery.isNumeric(vv)) {
                $(this).val(45);
                return;
            }
            var v = parseInt(vv);
            // console.log(v)
            if (v < 28) {
                $(this).val(28);
            } else if (v > 80) {
                $(this).val(80);
            }
        } catch (e) {
            $(this).val(45);
        }
    }

    $('#receiver_fontsize').change(func_receiver_fontsize).blur(func_receiver_fontsize);

    // 如没有设置过，则初始化默认设置
    if (!localStorage.getItem('setting_print_box_order')) {
        localStorage.setItem('setting_print_box_order', JSON.stringify(defaultData));
    }

    // 恢复上次保存的值
    loadSettingData();

    /**
     * 获取装箱单设置
     * @returns {any}
     */
    function getPrintBoxOrderSetting() {
        var dd = localStorage.getItem('setting_print_box_order');
        var data = JSON.parse(dd);
        return data;
    }

</script>
