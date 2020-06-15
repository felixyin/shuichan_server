if (!top.toastr) {
    top.toastr = {};
    top.toastr.options = {
        "closeButton": true,
        "debug": false,
        "progressBar": true,
        "positionClass": "toast-top-right",
        "onclick": null,
        "showDuration": "400",
        "hideDuration": "3000",
        "timeOut": "10000",
        "extendedTimeOut": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
    };
}

function scanPost(url, data, callback, async) {
    $.ajax({
        url: url,
        method: "post",
        async: async,
        data: data,
        error: function (xhr, textStatus) {
            if (xhr.status == 0) {
                jp.info("连接失败，请检查网络!")
            } else if (xhr.status == 404) {
                var errDetail = "<font color='red'>404,请求地址不存在！</font>";
                top.layer.alert(errDetail, {
                    icon: 2,
                    area: ['auto', 'auto'],
                    title: "请求出错"
                })
            } else if (xhr.status && xhr.responseText) {
                var errDetail = "<font color='red'>" + xhr.responseText.replace(/[\r\n]/g, "<br>").replace(/[\r]/g, "<br>").replace(/[\n]/g, "<br>") + "</font>";
                top.layer.alert(errDetail, {
                    icon: 2,
                    area: ['80%', '70%'],
                    title: xhr.status + "错误"
                })
            } else {
                var errDetail = "<font color='red'>未知错误!</font>";
                top.layer.alert(errDetail, {
                    icon: 2,
                    area: ['auto', 'auto'],
                    title: "真悲剧，后台抛出异常了"
                })
            }
        },
        success: function (data, textStatus, jqXHR) {
            if (data.indexOf == "_login_page_") {//登录超时
                location.reload(true);
            } else {
                callback(data);
            }
        }
    });
};

function scanningGunListener(scanCode) {
    // if (scanCode && scanCode.indexOf('http://') !== -1) {
    // jp.info('已经过滤掉不合法数据，接收的扫描内容是(将会自动发起此请求，判断是扫码枪还是手机(又判断微信或佰安客工厂APP)后，来处理箱子数据以及订单数据，开发中...)：' + scanCode);
    // debugger;
    scanPost(scanCode + '&device=pc', {}, function (result) {
        console.log(result);
        if (result && result.body) {
            var order = result.body.order;
            var box = result.body.box;
            var boxItem = result.body.boxItem;
            var msg = result.body.msg;
            var success = result.body.success;
            if (success === 1) { // 成功
                top.toastr.success('客户' + order.custom.username + '(' + order.custom.phone + ')的订单，规格为' + box.production.name + '的产品' + msg + '，箱号是：' + boxItem.serialNum);
                // fixme，这个地方，需要在列表配置中增加配置项，可以配置扫码成功后是否自动刷新
                try {
                    var $table = top.getActiveTab()[0].contentWindow.$orderTable;
                    $table.bootstrapTable('refresh');
                } catch (e) {
                }
            } else if (success === 2) { // 已生产，无需再次扫码
                top.toastr.warning('客户' + order.custom.username + '(' + order.custom.phone + ')的订单，规格为' + box.production.name + '的产品' + msg + '，箱号是：' + boxItem.serialNum);
            } else if (success === 3) { // 未打印，扫码无效
                top.toastr.error('客户' + order.custom.username + '(' + order.custom.phone + ')的订单，规格为' + box.production.name + '的产品' + msg + '，箱号是：' + boxItem.serialNum);
            }
        }
    });
    // }
}

window.onload = function (e) {
    var code = "";
    var lastTime, nextTime;
    var lastCode, nextCode;

    document.onkeypress = function (e) {
        nextCode = e.which;
        nextTime = new Date().getTime();

        if (lastCode != null && lastTime != null && nextTime - lastTime <= 30) {
            code += String.fromCharCode(lastCode);
        } else if (lastCode != null && lastTime != null && nextTime - lastTime > 200) {
            code = "";
        }
        lastCode = nextCode;
        lastTime = nextTime;
    }
    this.onkeypress = function (e) {
        if (e.which === 13 && code.startsWith('http://')) {
            console.log(code);
            scanningGunListener(code);
            code = "";
        }
    }
}