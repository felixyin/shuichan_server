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
    <title>装箱单打印预览</title>
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
                <legend class="col-form-label col-sm-3 pt-0">打印方式：</legend>
                <div class="col-sm-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="printType" id="printType_yes" value="1" checked>
                        <label class="form-check-label" for="printType_yes">
                            标签
                        </label>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="printType" id="printType_no" value="0">
                        <label class="form-check-label" for="printType_no">
                            A4纸
                        </label>
                    </div>
                </div>
                <div class="col-sm-4 alert-success text-center">
                    默认标签打印
                </div>
            </div>
        </fieldset>
        <hr>
        <fieldset class="form-group">
            <div class="row">
                <legend class="col-form-label col-sm-3 pt-0">显示边框：</legend>
                <div class="col-sm-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="border" id="border_yes" value="1" checked>
                        <label class="form-check-label" for="border_yes">
                            显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="border" id="border_no" value="0">
                        <label class="form-check-label" for="border_no">
                            不显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-4 alert-success text-center">
                   默认显示
                </div>
            </div>
        </fieldset>
        <hr>
        <fieldset class="form-group">
            <div class="row">
                <legend class="col-form-label col-sm-3 pt-0">显示表头：</legend>
                <div class="col-sm-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="tableHead" id="table_head_yes" value="1" checked>
                        <label class="form-check-label" for="table_head_yes">
                            显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="tableHead" id="table_head_no" value="0">
                        <label class="form-check-label" for="table_head_no">
                            不显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-4 alert-success text-center">
                    默认显示
                </div>
            </div>
        </fieldset>

        <hr>
        <fieldset class="form-group">
            <div class="row">
                <legend class="col-form-label col-sm-3 pt-0">显示斤数：</legend>
                <div class="col-sm-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="jin" id="jin_yes" value="1" checked>
                        <label class="form-check-label" for="jin_yes">
                            显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="jin" id="jin_no" value="0">
                        <label class="form-check-label" for="jin_no">
                            不显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-4 alert-success text-center">
                    默认显示
                </div>
            </div>
        </fieldset>

        <hr>
        <fieldset class="form-group">
            <div class="row">
                <legend class="col-form-label col-sm-3 pt-0">显示箱数：</legend>
                <div class="col-sm-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="count" id="count_yes" value="1" checked>
                        <label class="form-check-label" for="count_yes">
                            显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="count" id="count_no" value="0">
                        <label class="form-check-label" for="count_no">
                            不显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-4 alert-success text-center">
                    默认显示
                </div>
            </div>
        </fieldset>

        <hr>
        <fieldset class="form-group">
            <div class="row">
                <legend class="col-form-label col-sm-3 pt-0">显示物流：</legend>
                <div class="col-sm-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="logistics" id="logistics_yes" value="1" checked>
                        <label class="form-check-label" for="logistics_yes">
                            显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="logistics" id="logistics_no" value="0">
                        <label class="form-check-label" for="logistics_no">
                            不显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-4 alert-success text-center">
                    默认显示
                </div>
            </div>
        </fieldset>

        <hr>
        <fieldset class="form-group">
            <div class="row">
                <legend class="col-form-label col-sm-3 pt-0">显示班次：</legend>
                <div class="col-sm-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="shift" id="shift_yes" value="1" checked>
                        <label class="form-check-label" for="shift_yes">
                            显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="shift" id="shift_no" value="0">
                        <label class="form-check-label" for="shift_no">
                            不显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-4 alert-success text-center">
                    默认显示
                </div>
            </div>
        </fieldset>
        <hr>

        <fieldset class="form-group">
            <div class="row">
                <legend class="col-form-label col-sm-4 pt-0">收件信息是否粗体：</legend>
                <div class="col-sm-4">
                    <div class="custom-control custom-switch">
                        <input name="receiverBold" type="checkbox" checked class="custom-control-input" id="receiver_bold">
                        <label class="custom-control-label" for="receiver_bold">是</label>
                    </div>
                </div>
                <div class="col-sm-4 alert-success text-center">
                    默认是
                </div>
            </div>
        </fieldset>
        <div id="newline-id">
        <hr>
        <fieldset class="form-group" >
            <div class="row">
                <legend class="col-form-label col-sm-4 pt-0">收件信息是否换行：</legend>
                <div class="col-sm-4">
                    <div class="custom-control custom-switch">
                        <input name="receiverNewline" type="checkbox" checked class="custom-control-input" id="receiver_newline">
                        <label class="custom-control-label" for="receiver_newline">是</label>
                    </div>
                </div>
                <div class="col-sm-4 alert-success text-center">
                    默认是
                </div>
            </div>
        </fieldset>
        </div>
        <hr>
        <div class="form-group row">
            <label for="receiver_fontsize" class="col-sm-4 col-form-label">收件信息字体大小：</label>
            <div class="col-sm-4">
                <input type="number" class="form-control input-mini" name="receiverFontsize" id="receiver_fontsize" placeholder="默认38px" step="1" value="38"
                       max="28"
                       min="48">
            </div>
            <div class="col-sm-4 alert-success text-center">
                默认38px
            </div>
        </div>
        <hr>
        <div class="form-group row">
            <label for="remarks_fontsize" class="col-sm-4 col-form-label">备注字体大小：</label>
            <div class="col-sm-4">
                <input type="number" class="form-control input-mini" name="remarksFontsize" id="remarks_fontsize" placeholder="默认35px"  step="1" value="35" max="45"
                       min="25">
            </div>
            <div class="col-sm-4 alert-success text-center">
                默认35px
            </div>
        </div>
        <hr>
        <div class="form-group row">
            <label for="page_width" class="col-sm-4 col-form-label">页面宽度微调(px)：</label>
            <div class="col-sm-4">
                <input name="pageWidth" type="range" class="custom-range" min="-10" max="10" step="1"  id="page_width">
            </div>
            <div class="col-sm-4 alert-success text-center">
                默认1075
            </div>
        </div>
        <hr>
        <div class="form-group row">
            <label for="page_height" class="col-sm-4 col-form-label">页面高度微调(px)：</label>
            <div class="col-sm-4">
                <input name="pageHeight" type="range" class="custom-range" min="-10" max="10" step="1" id="page_height">
            </div>
            <div class="col-sm-4 alert-success text-center">
                默认1567
            </div>
        </div>
        <hr>
        <div class="form-group row">
            <label for="remarks_offset" class="col-sm-4 col-form-label">备注起始位置(px)：</label>
            <div class="col-sm-4">
                <input name="remarksOffset" type="range" class="custom-range" min="0" value="5" max="13" id="remarks_offset">
            </div>
            <div class="col-sm-4 alert-success text-center">
                默认660
            </div>
        </div>
        <hr>
        <fieldset class="form-group" style="display: none;">
            <div class="row">
                <legend class="col-form-label col-sm-5 pt-0">调货的装箱单是否打印：</legend>
                <div class="col-sm-3">
                    <div class="custom-control custom-switch">
                        <input name="printAdjusting" type="checkbox" checked class="custom-control-input" id="print_adjusting">
                        <label class="custom-control-label" for="print_adjusting">打印</label>
                    </div>
                </div>
                <div class="col-sm-4 alert-success text-center">
                   默认打印
                </div>
            </div>
        </fieldset>
        <hr>
    </form>

</div>
<script src="${ctxStatic}/plugin/jquery/jquery-3.3.1.min.js"></script>
<script src="${ctxStatic}/plugin/bootstrap-4.3.1/js/bootstrap.min.js"></script>
<script type="text/javascript">var ctx = '${ctx}', ctxStatic='${ctxStatic}';</script>
<%@include file="printBoxOrderSetting_js.jsp" %>
</body>
</html>
