<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page isELIgnored="false" %>
<%--想用c:foreach的话 得先引入标签库--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set value="${pageContext.request.contextPath}" var="APP_PATH"/>   <%--获取项目路径 比如http://localhost:8080/SSMcrud_war--%>
<html>
<head>
    <title>员工列表</title>
    <%--引入jquery(先去官网上下载jquery,解压后文件放在webapp下,再手动引入)--%>

    <script src="static/js/jquery-3.4.1.js"></script>
    <%--引入bootstrap的css全局样式(先去官网上下载bootstrap,解压后文件放在webapp下,再手动引入)--%>
    <link href="static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <%--引入bootstrap的js插件--%>
    <script src="static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
<%--搭建显示页面--%>

<div class="container">
    <%--表格的标题--%>
    <div class="row">
        <div class="col-xs-12">
            <h1>
                SSM-CRUD 
            </h1>
        </div>
    </div>
    <%--标题下的按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button type="button" class="btn btn-primary">新增</button>
            <button type="button" class="btn btn-danger">删除</button>
        </div>
    </div>
     <%--表格中的内容--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover">
                <tr>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                <c:forEach items="${pageInfo.list}" var="emp">
                    <tr>
                        <th>${emp.emp_id }</th>
                        <th>${emp.emp_name }</th>
                        <th>${emp.gender }</th>
                        <th>${emp.email }</th>
                        <th>${emp.department.deptName }</th>
                        <th>
                            <button class="btn btn-primary  btn-sm">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>编辑</button>
                            <button class="btn btn-danger  btn-sm">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除</button>
                        </th>
                    </tr>
                </c:forEach>

            </table>
        </div>
    </div>
      <%--显示分页信息--%>
    <div class="row">
        <%--分页文字信息--%>
        <div class="col-md-6">
            当前${pageInfo.pageNum}页,总${pageInfo.pages}页,总${pageInfo.total}条记录
        </div>
         <%--分页条信息--%>
        <div class="col-md-6">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li><a href="${APP_PATH}/emps?pn=1" >首页</a></li>
                    <c:if test="${pageInfo.hasPreviousPage}">
                        <li>
                            <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum-1 }" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>

                    <c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">
                        <c:if test="${page_Num == pageInfo.pageNum}">
                            <li class="active"><a href="#">${page_Num }</a></li>
                        </c:if>
                        <c:if test="${page_Num != pageInfo.pageNum}">
                            <li><a href="${APP_PATH}/emps?pn=${page_Num }">${page_Num }</a></li>
                        </c:if>
                    </c:forEach>
                    <c:if test="${pageInfo.hasNextPage}">
                        <li>
                            <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum+1 }" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>

                    <li><a href="${APP_PATH}/emps?pn=${pageInfo.pages}" >末页</a></li>
                </ul>
            </nav>
        </div>

    </div>

</div>


</body>

</html>