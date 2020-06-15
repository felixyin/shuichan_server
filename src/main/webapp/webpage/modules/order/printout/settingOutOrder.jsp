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
                <legend class="col-form-label col-sm-3 pt-0">显示标题物流公司：</legend>
                <div class="col-sm-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="logistics" id="logistics_yes" value="1"
                               checked>
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
                <legend class="col-form-label col-sm-3 pt-0">显示附标题班次：</legend>
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
                <legend class="col-form-label col-sm-3 pt-0">显示序号：</legend>
                <div class="col-sm-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="num" id="num_yes" value="1" checked>
                        <label class="form-check-label" for="num_yes">
                            显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="num" id="num_no" value="0">
                        <label class="form-check-label" for="num_no">
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
                <legend class="col-form-label col-sm-3 pt-0">显示姓名：</legend>
                <div class="col-sm-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="name" id="name_yes" value="1" checked>
                        <label class="form-check-label" for="name_yes">
                            显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="name" id="name_no" value="0">
                        <label class="form-check-label" for="name_no">
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
                <legend class="col-form-label col-sm-3 pt-0">显示地址：</legend>
                <div class="col-sm-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="address" id="address_yes" value="1" checked>
                        <label class="form-check-label" for="address_yes">
                            显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="address" id="address_no" value="0">
                        <label class="form-check-label" for="address_no">
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
                <legend class="col-form-label col-sm-3 pt-0">显示电话：</legend>
                <div class="col-sm-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="phone" id="phone_yes" value="1" checked>
                        <label class="form-check-label" for="phone_yes">
                            显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="phone" id="phone_no" value="0">
                        <label class="form-check-label" for="phone_no">
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
                <legend class="col-form-label col-sm-3 pt-0">显示规格：</legend>
                <div class="col-sm-2">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="spec" id="spec_yes" value="1" checked>
                        <label class="form-check-label" for="spec_yes">
                            显示
                        </label>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="spec" id="spec_no" value="0">
                        <label class="form-check-label" for="spec_no">
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
                <legend class="col-form-label col-sm-3 pt-0">显示总箱数：</legend>
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
    </form>

</div>
<script src="${ctxStatic}/plugin/jquery/jquery-3.3.1.min.js"></script>
<script src="${ctxStatic}/plugin/bootstrap-4.3.1/js/bootstrap.min.js"></script>
<script type="text/javascript">var ctx = '${ctx}', ctxStatic = '${ctxStatic}';</script>
<%@include file="printOutOrderSetting_js.jsp" %>
</body>
</html>
