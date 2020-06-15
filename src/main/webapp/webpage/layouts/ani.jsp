<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<!DOCTYPE html>
<html style="overflow-x:auto;overflow-y:auto;">
<head>
    <title><sitemesh:title/></title>
    <%@ include file="/webpage/include/anihead.jsp" %>
    <sitemesh:head/>
</head>
<body id="<sitemesh:getProperty property='body.id'/>" class="<sitemesh:getProperty property='body.class'/>"
      style="<sitemesh:getProperty property='body.style'/>">
<sitemesh:body/>
<script type="text/javascript">
    try {
        jsObj.domReady(); // 界面加载完毕，显示主窗体
    } catch (e) {
    }
</script>
<%--<audio src="${ctxStatic}/mp3/error.mp3" hidden id="__error-audio"></audio>--%>
<%--<audio src="${ctxStatic}/mp3/warn.mp3" hidden id="__warn-audio"></audio>--%>
<%--<audio src="${ctxStatic}/mp3/info.mp3" hidden id="__info-audio"></audio>--%>
<%--<audio src="${ctxStatic}/mp3/success.mp3" hidden id="__success-audio"></audio>--%>
<%--<audio src="${ctxStatic}/mp3/none.mp3" hidden id="__none-audio"></audio>--%>
<%--<button id="allAudio" type="button" class="btn btn-danger hidden" onclick="jp.playErrorAudio();jp.playWarnAudio();jp.playInfoAudio();jp.playSuccessAudio();"></button>--%>
<%--<script>--%>
<%--	var allAudio = document.getElementById('allAudio');--%>
<%--	if (allAudio) allAudio.click();--%>
<%--</script>--%>

</body>
</html>