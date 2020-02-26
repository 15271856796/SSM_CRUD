<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="UTF-8"%>
<%@page isELIgnored="false" %>
<jsp:forward page="/emps"></jsp:forward>  <%--页面重定位,去找/emps的Controller,不再显示index.jsp--%>
<html>
<head>
<title>index.jsp</title>

<%--引入jquery(先去官网上下载jquery,解压后文件放在webapp下,再手动引入)--%>
<script type="text/javascript" src="static/js/jquery-3.4.1.js"></script>

   <%--引入bootstrap的css全局样式(先去官网上下载bootstrap,解压后文件放在webapp下,再手动引入)--%>
<link href="static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
      <%--引入bootstrap的js插件--%>
<script src="static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>

</head>

<body>
<button type="button" class="btn btn-danger">（成功）Success</button>
</body>
</html>
