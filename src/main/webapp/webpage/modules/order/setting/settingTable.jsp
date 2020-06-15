<%--
  Created by IntelliJ IDEA.
  User: fy
  Date: 2019-08-10
  Time: 11:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <%--    <meta name="decorator" content="blank"/>--%>
    <title>表格设置</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${ctxStatic}/plugin/bootstrap-4.3.1/css/bootstrap.min.css"/>
    <style>
    </style>
    <script src="${ctxStatic}/common/js/scangun.js"></script>
</head>
<body>
<div class="container">
    <br>
    <form id="setting_form">
        <fieldset class="form-group">
            <div class="row">
                <legend class="col-form-label col-sm-4 pt-0">自动展开包装箱：</legend>
                <div class="col-sm-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="boxExpanded" id="boxExpanded_yes" value="1">
                        <label class="form-check-label" for="boxExpanded_yes">
                            展开
                        </label>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="boxExpanded" id="boxExpanded_no" value="0" checked>
                        <label class="form-check-label" for="boxExpanded_no">
                            不展开
                        </label>
                    </div>
                </div>
                <div class="col-sm-3 alert-success text-center">
                    默认不展开
                </div>
            </div>
        </fieldset>
        <hr>
        <fieldset class="form-group">
            <div class="row">
                <legend class="col-form-label col-sm-4 pt-0">自动展开箱子明细：</legend>
                <div class="col-sm-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="boxItemExpanded" id="boxItemExpanded_yes" value="1">
                        <label class="form-check-label" for="boxItemExpanded_yes">
                            展开
                        </label>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="boxItemExpanded" id="boxItemExpanded_no" value="0" checked>
                        <label class="form-check-label" for="boxItemExpanded_no">
                            不展开
                        </label>
                    </div>
                </div>
                <div class="col-sm-3 alert-success text-center">
                    默认不展开
                </div>
            </div>
        </fieldset>
        <hr>
    </form>

</div>
<script src="${ctxStatic}/plugin/jquery/jquery-3.3.1.min.js"></script>
<script src="${ctxStatic}/plugin/bootstrap-4.3.1/js/bootstrap.min.js"></script>
<script type="text/javascript">var ctx = '${ctx}', ctxStatic = '${ctxStatic}';</script>
<script>

    /**
     * @param type 打印类型。1，订单编号；2，包装箱编号；3，每箱编号
     */
    function printBoxOrder(type) {
        var ids = getIdSelections();
        if (!ids || ids.length <= 0) {
            jp.warning('请选择订单，再点击批量打印！！！');
            return;
        }
        jp.openPrintDialog('装箱单打印预览', "${ctx}/order/scOrder/printBoxOrder?ids=" + ids + '&type=' + type, '80%', '80%');
    }

    function setPrintBoxOrder() {
        jp.openSettingPrintBoxDialog('装箱单打印设置', "${ctx}/order/scOrder/settingBoxOrder", '700px', '60%');
    }

    var defaultData = {
        boxExpanded: "0",
        boxItemExpanded: "0",
    };

    function setFormValue(d) {
        if (d.hasOwnProperty('boxExpanded')) {
            if (d.boxExpanded === '1') {
                $('#boxExpanded_yes').prop('checked', true);
            } else {
                $('#boxExpanded_no').prop('checked', true);
            }
        }
        if (d.hasOwnProperty('boxItemExpanded')) {
            if (d.boxItemExpanded === '1') {
                $('#boxItemExpanded_yes').prop('checked', true);
            } else {
                $('#boxItemExpanded_no').prop('checked', true);
            }
        }
    }

    function getFormValue() {
        var array = $('#setting_form').serializeArray();
        var data = {};
        for (var a of array) {
            data[a.name] = a.value;
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
        localStorage.setItem('setting_table', dd);

        // 保存redis缓存服务器
        $.ajax({
            type: 'post',
            url: ctx + '/order/scOrder/saveSettingTable',
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
        localStorage.setItem('setting_table', JSON.stringify(defaultData));
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
            url: ctx + '/order/scOrder/loadSettingTable',
            async: false
        }).done(function (result) {
            // console.log(result);
            // console.log(result.body.setting);
            // var dd = localStorage.getItem('setting_table');
            // console.log(dd);
            // var data = JSON.parse(dd);
            setFormValue(result.body.setting);
        });
    }


    // 如没有设置过，则初始化默认设置
    if (!localStorage.getItem('setting_table')) {
        localStorage.setItem('setting_table', JSON.stringify(defaultData));
    }

    // 恢复上次保存的值
    loadSettingData();

    /**
     * 获取装箱单设置
     * @returns {any}
     */
    function getSettingTable() {
        var dd = localStorage.getItem('setting_table');
        var data = JSON.parse(dd);
        return data;
    }

    function saveTableSettingData() {
        saveSettingData();
        return true;
    }

    function resetTableSettingData() {
        resetSettingData();
        return true;
    }
</script>

</body>
</html>
