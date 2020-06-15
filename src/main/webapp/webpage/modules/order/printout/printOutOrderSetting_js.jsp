<%@ page contentType="text/html;charset=UTF-8" %>
<script>

    /**
     * @param type 打印类型。1，订单编号；2，包装箱编号；3，每箱编号
     */
    function printOutOrder(type) {
        // 临时先刷新查询
        // $('#scOrderTable').bootstrapTable('refresh');
        var shouldLogistics = $('#shouldLogistics').val();
        if (!shouldLogistics) {
            jp.warning('请填写指定物流搜索后，再点击批量打印！！！');
            return;
        }
        var shift = $('#shift').val();

        var ids = getIdSelections();
        if (!ids || ids.length <= 0) {
            jp.warning('请选择订单，再点击批量打印！！！');
            return;
        }
        jp.openPrintDialog('出货单打印预览', "${ctx}/order/scOrder/printOutOrder?ids=" + ids + '&type=' + type + '&shouldLogistics=' + shouldLogistics + '&shift=' + shift, '90%', '80%');
    }

    function setPrintOutOrder() {
        jp.openSettingPrintBoxDialog('出货单打印设置', "${ctx}/order/scOrder/settingOutOrder", '800px', '60%', function (iframeWin) {
            var ok = iframeWin.saveOutSettingData();
            if (ok) {
                jp.success('保存成功！');
            }
        }, function (iframeWin) {
            var ok = iframeWin.resetOutSettingData();
            if (ok) {
                jp.success('重置成功！');
            }
        });
    }

    var defaultOutData = {
        logistics: "1",
        shift: "1",
        num: "1",
        name: "1",
        address: "1",
        phone: "1",
        spec: "1",
        count: "1",
    };

    function setOutFormValue(d) {
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
        if (d.hasOwnProperty('num')) {
            if (d.num === '1') {
                $('#num_yes').prop('checked', true);
            } else {
                $('#num_no').prop('checked', true);
            }
        }
        if (d.hasOwnProperty('name')) {
            if (d.name === '1') {
                $('#name_yes').prop('checked', true);
            } else {
                $('#name_no').prop('checked', true);
            }
        }
        if (d.hasOwnProperty('address')) {
            if (d.address === '1') {
                $('#address_yes').prop('checked', true);
            } else {
                $('#address_no').prop('checked', true);
            }
        }
        if (d.hasOwnProperty('phone')) {
            if (d.phone === '1') {
                $('#phone_yes').prop('checked', true);
            } else {
                $('#phone_no').prop('checked', true);
            }
        }
        if (d.hasOwnProperty('spec')) {
            if (d.spec === '1') {
                $('#spec_yes').prop('checked', true);
            } else {
                $('#spec_no').prop('checked', true);
            }
        }
        if (d.hasOwnProperty('count')) {
            if (d.count === '1') {
                $('#count_yes').prop('checked', true);
            } else {
                $('#count_no').prop('checked', true);
            }
        }
    }

    function getOutFormValue() {
        var array = $('#setting_form').serializeArray();
        var data = {};
        for (var a of array) {
            data[a.name] = a.value;
        }
        for (var p in defaultOutData) {
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
    function saveOutSettingData() {
        var data = getOutFormValue();
        var dd = JSON.stringify(data);
        // console.log(dd);
        localStorage.setItem('setting_print_out_order', dd);

        // 保存redis缓存服务器
        $.ajax({
            type: 'post',
            url: ctx + '/order/scOrder/saveSettingOutOrderPrint',
            data: data,
            async: false
        }).done(function (result) {
            return result.success;
        });
        return true;
    }

    /**
     * 重置装箱单设置
     * @returns {boolean}
     */
    function resetOutSettingData() {
        localStorage.setItem('setting_print_out_order', JSON.stringify(defaultOutData));
        setOutFormValue(defaultOutData);
        saveOutSettingData();
        return true;
    }

    /**
     *
     */
    function loadOutSettingData() {
        // 保存redis缓存服务器
        $.ajax({
            type: 'get',
            url: ctx + '/order/scOrder/loadSettingOutOrderPrint',
            async: false
        }).done(function (result) {
            console.log(result.body.setting);
            setOutFormValue(result.body.setting);
            return result.success;
        });
        /*
         var dd = localStorage.getItem('setting_print_out_order');
         // console.log(dd);
         var data = JSON.parse(dd);
         setOutFormValue(data);
         */
    }


    // 如没有设置过，则初始化默认设置
    if (!localStorage.getItem('setting_print_out_order')) {
        localStorage.setItem('setting_print_out_order', JSON.stringify(defaultOutData));
    }

    // 恢复上次保存的值
    loadOutSettingData();

    /**
     * 获取装箱单设置
     * @returns {any}
     */
    function getPrintOutOrderSetting() {
        var dd = localStorage.getItem('setting_print_out_order');
        var data = JSON.parse(dd);
        return data;
    }

</script>
