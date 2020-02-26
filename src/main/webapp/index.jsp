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
    <script type="text/javascript">
        //1 页面加载完成以后,直接发送ajax请求,得到分页数据
        $(function(){
            ajax_to_page(1);
            //点击新增按钮弹出模态框
            $("#emp_add_model_btn").click(function () {
                //为了防止连续插入两次一样的数据,所以在弹出模态框的时候都要清空表单(完整重置,表单的数据和样式)
                $("#add_form")[0].reset();
                $("#add_form").find("*").removeClass("has-error has-success");
                $("#add_form").find(".help-block").text("");//提示语的清空

                //发送ajax请求,查出所有的部门信息,并显示在下拉列表中
                getDepts("#dept_add_select");

                //显示新增按钮的模态框
                $("#empAddModel").modal({
                    backdrop:"static"
                });
            });

            //点击新增中的保存按钮,向数据库中插入数据
            $("#save_emp").click(function () {
                save_emp();
            });

            //判断用户名是否重复,用户名输入款的内容改变事件
            $("#empName_input").change(function (){
                //发送ajax请求校验用户名是否有重复
                $.ajax({
                    url:"${APP_PATH}/emps/getbyname",
                    type:"GET",
                    data:"emp_name="+$("#empName_input").val(),
                    success:function(result){
                        if(result.code==100){
                            show_validate_msg("#empName_input","success",result.extend.msg);
                            $("#emp_add_model_btn").attr("ajax","success");//给标签添加一个名为ajax的属性,值为success

                        }else{
                            show_validate_msg("#empName_input","error",result.extend.msg);
                            $("#emp_add_model_btn").attr("ajax","fail");
                        }
                    }
                });
            });

            //这样的绑定方式不行,因为页面加载完后,还没有.update_btn 这个是通过页面加载完后,通过ajax请求才产生的,所以用$({document})
            /*$(".update_btn").click(function (){
                alert("编辑");
            });*/

            //点击编辑按钮绑定的事件
            $(document).on("click",".update_btn",function (){
                //查出员工信息,并放在模态框中
                getEmp($(this).attr("emp_id"));
                //查出部门列表,并放在模态框的下拉列表中
                getDepts("#dept_update_select");
                //把员工的id传递给模态框中的更新按钮
                $("#update_emp").attr("emp_id",$(this).attr("emp_id"));
                //弹出编辑按钮的模态框
                $("#empUpdateModel").modal({
                    backdrop:"static"
                });

            });

            //点击编辑按钮中的更新按钮,向数据库中更新数据
            $("#update_emp").click(function () {
                update_emp();
            });


            //点击单个删除按钮
            $(document).on("click",".delete_btn",function(){
                //1 弹出是否确认删除对话框
                var emp_name=$(this).parents("tr").find("td:eq(2)").text();//获得被点击的删除按钮那行记录的用户名
                if(confirm("确认删除"+emp_name+"员工吗?")){
                    $.ajax({
                        url:"${APP_PATH}/emps/"+$(this).attr("emp_id"),
                        type:"DELETE",
                        success:function () {
                            ajax_to_page(currentPageNum);
                            alert("删除成功");

                        }
                    });
                }
            });


            //全选或者全不选功能
            $("#check_all").click(function () {
                //用attr获取checked属性值是undefined,因为我们创建复选框的时候确实没有加checked属性,
                //所以dom原生的属性用prop来获取和修改,用attr创建,获取,修改自定义的属性的值
                $(".check_item").prop("checked",$(this).prop("checked"));
            });

            //单个复选框的点击事件
            $(document).on("click",".check_item",function () {
                //判断当前单个的复选框是否都选中了
               var flag=$(".check_item:checked").length==$(".check_item").length;
               $("#check_all").prop("checked",flag);

            })

            //大的删除按钮的点击事件(选中多个,然后一次性删除)
            $("#emp_delete_model_btn").click(function () {
                var empName="";
                var empId="";
                $.each($(".check_item:checked"),function () {
                    empName += $(this).parents("tr").find("td:eq(2)").text()+",";
                    empId+=$(this).parents("tr").find("td:eq(1)").text()+"-";

                })
                //最后一个名字没有下一个,但是也会有逗号,所以我们要去掉最后一个逗号
                empName=empName.substring(0,empName.length-1);
                empId=empId.substring(0,empId.length-1);
                if(confirm("确认删除"+empName+"吗?")){
                    //发送ajax请求
                    $.ajax({
                        url:"${APP_PATH}/emps/"+empId,
                        type:"DELETE",
                        success:function () {
                            alert("删除成功");
                            ajax_to_page(currentPageNum);

                        }

                    })

                }

            });


        });



        var totalPageNum;  //全局变量,用来存储总记录数
        var currentPageNum;


        function  ajax_to_page(pn) {
            $("#check_all").prop("checked",false);
            $.ajax({
                url:"${APP_PATH}/emps",
                data:"pn="+pn,
                type:"GET",
                //请求成功时的回调函数,也就是请求成功的时候做什么,里面的参数result可以任意的起名,实参就是请求给返回的数据
                success:function (result) {
                    console.log(result);//控制台输出请求到的数据
                    //2 解析json串,显示员工信息
                    build_emps_table(result);
                    //3 解析json串,显示分页信息
                    build_page_info(result);
                    //4 解析json串,显示分页条数据
                    build_page_nav(result);

                }
            });
            
        }
        function build_emps_table(result){
            //先清空表单,不然换页的时候总在原有基础上进行了添加
            $("#emps_table tbody").empty();

            var emps=result.extend.pageInfo.list;
            $.each(emps,function (index,item) {
                var checkBoxId=$("<td><input type='checkbox' class='check_item'/></td>");

                //alert(item.emp_name);
                var emp_id_td=$("<td></td>").append(item.emp_id);
                var emp_name_td=$("<td></td>").append(item.emp_name);
                var gender_td=$("<td></td>").append(item.gender);
                var email_td=$("<td></td>").append(item.email);
                var department_td=$("<td></td>").append(item.department.deptName);
                /**
                 * <button class="btn btn-primary  btn-sm">
                 <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>编辑</button>
                 */
                var editBtn=$("<button></button>").addClass("btn btn-primary  btn-sm update_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-pencil").append("编辑"));

                //在编辑按钮标签上新加一个emp_id的属性,值为item.emp_id
                editBtn.attr("emp_id",item.emp_id);

                /**
                 * <button class="btn btn-danger  btn-sm">
                 <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除</button>
                 */
                var delteBtn=$("<button></button>").addClass("btn btn-danger  btn-sm delete_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-trash").append("删除"));

                delteBtn.attr("emp_id",item.emp_id);


                var btntd=$("<td></td>").append(editBtn).append(delteBtn);



                //append方法执行完成以后还是返回原来的标签元素
                $("<tr></tr>").append(checkBoxId)
                    .append(emp_id_td)
                    .append(emp_name_td)
                    .append(gender_td)
                    .append(email_td)
                    .append(department_td)
                    .append(btntd)
                    .appendTo("#emps_table tbody");

            });

        }


        //解析显示分页信息
        function build_page_info(result){
            //先清空
            $("#page_info_area").empty();
           $("#page_info_area").append("当前"+ result.extend.pageInfo.pageNum+"页,总"+ result.extend.pageInfo.pages +"页,总"+result.extend.pageInfo.total+"条记录");
            totalPageNum=result.extend.pageInfo.total;
            currentPageNum=result.extend.pageInfo.pageNum;
        }
        //解析显示分页条
        function build_page_nav(result){
            //先清空
            $("#page_nav_area").empty();
            var nav = $("<nav></nav>").attr("aria-label","Page navigation");
            // 每个导航数字 1 2 3都在li标签里面，所有li在一个ul里面，ul在nav里面
            var ul = $("<ul></ul>").addClass("pagination");
            // 首页li
            var firstLi = $("<li></li>").append($("<a></a>").attr("href","#").append("首页"));

            // 上一页li
            var prevLi = $("<li></li>").append($("<a></a>").attr("href","#").append("&laquo;"));
            if(result.extend.pageInfo.hasPreviousPage==false){
                firstLi.addClass("disabled");
                prevLi.addClass("disabled");
            }else{
                firstLi.click(function () {
                    ajax_to_page(1);
                });
                prevLi.click(function () {
                    ajax_to_page(result.extend.pageInfo.pageNum-1);
                });

            }

            ul.append(firstLi).append(prevLi);
            // 遍历此次pageInfo中的导航页，并构建li标签，添加到ul
            $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
                var navLi = $("<li></li>").append($("<a></a>").attr("href","#").append(item));
                // 遍历到当前显示的页，就高亮，且不能点击
                if(result.extend.pageInfo.pageNum == item){
                    navLi.addClass("active");
                }else {
                    // 绑定单击事件
                    navLi.click(function () {
                        // 传入页号，获取数据
                        ajax_to_page(item);
                    });
                }
                ul.append(navLi);
            })
            // 下一页li
            var nextLi = $("<li></li>").append($("<a></a>").attr("href","#").append("&raquo;"));
            // 尾页li
            var lastLi = $("<li></li>").append($("<a></a>").attr("href","#").append("尾页"));
            if(result.extend.pageInfo.hasNextPage==false){
                nextLi.addClass("disabled");
                lastLi.addClass("disabled");

            }else{
                lastLi.click(function () {
                    ajax_to_page(result.extend.pageInfo.pages);
                });
                nextLi.click(function () {
                    ajax_to_page(result.extend.pageInfo.pageNum+1);
                });

            }

            ul.append(nextLi).append(lastLi);
            // 将ul添加到nav
            nav.append(ul);
            nav.appendTo($("#page_nav_area"));

        }

        //发送ajax请求,查出所有的部门并显示在模态框的下拉列表中
        function getDepts(ele) {
            $(ele).empty();
            $.ajax({
                url:"${APP_PATH}/depts",
                type:"GET",
                //请求成功时的回调函数,也就是请求成功的时候做什么,里面的参数result可以任意的起名,实参就是请求给返回的数据
                success:function (result) {
                    $.each(result.extend.depts,function (index,item){
                        var optionEle=$("<option></option>").append(item.deptName).attr("value",item.deptId);
                        $(ele).append(optionEle);

                    });
                }
            });
        }

        //校验新增中表单中的数据
        function validate_add_form() {
            //1 先拿到我们要校验的数据,再使用jquery中的正则表达式进行校验
            var empName=$("#empName_input").val();  //取出输入的值
            var regName=/(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]+$)/;   //直接百度上搜jqueryAPI上面就已经有写好的正则表达式
            if(!regName.test(empName)){
                //为了美观,如果输入不满足要求,不是弹框提示,而是直接在输入框旁边报错
                //alert("用户名可以使2-5个中文格式或者6-16个英文和中文的组合");
                show_validate_msg("#empName_input","error","用户名可以使用2-5个中文格式或者6-16个英文和中文的组合");

                return false;
            }else{
                show_validate_msg("#empName_input","success","");


            }
            //2 校验邮箱
            var email=$("#email_input").val();
            var reg=/(^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$)|(^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$)/;
            if(!reg.test(email)){
                //alert("邮箱格式不正确");
                show_validate_msg("#email_input","error","邮箱格式不正确");

                return false;
            }else{
                show_validate_msg("#email_input","success","");

            }
            return true;
        }

        //提示信息显示
        function show_validate_msg(ele,status,msg) {
            //清除当前元素的校验状态
            $(ele).parent().removeClass("has-success has-error");
            $(ele).next("span").text("");
            if("success"==status){
                $(ele).parent().addClass("has-success");
                $(ele).next("span").text(msg);

            }else{
                $(ele).parent().addClass("has-error");
                $(ele).next("span").text(msg);


            }


            
        }


        //保存按钮点击绑定的事件
         function save_emp() {
            //1点击保存时,对用户输入的信息先进行校验
             if(!validate_add_form()){
                 return false; //不再发请求
             }
             //2 根据事先已发送的ajax请求,根据保存按钮的ajax属性值去判断用户名是否重复
             if($("#emp_add_model_btn").attr("ajax")=="fail"){
                 show_validate_msg("#empName_input","error","用户名不可用");
                 return false;
             }

            // 2发送ajax请求进行保存
            $.ajax({
               url:"${APP_PATH}/emps",
               type:"POST",
               data:$("#empAddModel form").serialize(),   //emp_name=&email=&gender=%E7%94%B7&d_id=3
               success:function (result) {
                   if(result.code==100){
                       //1点击保存后,关闭模态框
                       $("#empAddModel").modal('hide');
                       //2 并跳转到最后一页去查看我们插入的数据(发送ajax请求来显示最后一页数据即可,只要超过总页码,就显示最后一页)
                       ajax_to_page(totalPageNum);

                   }else{
                       //显示失败信息
                       if(undefined!=result.extend.errorFileds.email){
                           show_validate_msg("#email_input","error",result.extend.errorFileds.email);

                       }
                       if(undefined!=result.extend.errorFileds.emp_name){
                           show_validate_msg("#empName_input","error",result.extend.errorFileds.emp_name);



                       }
                   }

               } 
            });
         }

         //通过用户id查用户的信息,并放在编辑的模态框中
         function getEmp(emp_id) {
            $.ajax({
                url:"${APP_PATH}/emps/"+emp_id,
                type:"GET",
                success:function (result) {
                    var empData=result.extend.emp;
                    $("#empName_update").text(empData.emp_name);
                    $("#email_update").val(empData.email);
                    //对性别的单选框进行设置
                    $("#empUpdateModel input[name=gender]").val([empData.gender]);
                    //对部门下拉列表进行选择
                    $("#empUpdateModel select").val([empData.d_id]);
                }
            });

         }


        //更新按钮点击绑定的事件
        function update_emp() {
            //1点击更新时,前端对用户输入的邮箱进行校验
            var email=$("#email_update").val();
            var reg=/(^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$)|(^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$)/;
            if(!reg.test(email)){
                //alert("邮箱格式不正确");
                show_validate_msg("#email_update","error","邮箱格式不正确");

                return false;
            }else{
                show_validate_msg("#email_update","success","");
            }
            // 2发送ajax请求进行保存
            $.ajax({
                url:"${APP_PATH}/emps/"+$("#update_emp").attr("emp_id"),
                //只能发POST或者GET请求,但是后端要求这个请求必须是PUT请求,
                // 那么需要首先配置文件中配置过将POST请求自动转换成PUT或者DELETE请求
                //然后在Data里添加&_method=PUT
                type:"PUT",
                data:$("#empUpdateModel form").serialize(),   //emp_name=&email=&gender=%E7%94%B7&d_id=3
                success:function (result) {
                    if(result.code==100){
                        //1点击保存后,关闭模态框
                        $("#empUpdateModel").modal('hide');
                        //2 并跳转到最后一页去查看我们插入的数据(发送ajax请求来显示最后一页数据即可,只要超过总页码,就显示最后一页)
                        ajax_to_page(currentPageNum);

                    }else{
                        //显示失败信息
                        if(undefined!=result.extend.errorFileds.email){
                            show_validate_msg("#email_update","error",result.extend.errorFileds.email);

                        }

                    }

                }
            });
        }
            



    </script>
</head>
<body>
<!-- 新增员工时候弹出的模态框 -->
<div class="modal fade" id="empAddModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="add_form">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">员工名称</label>
                        <div class="col-sm-10">
                            <input type="text" name="emp_name" class="form-control" id="empName_input" placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">邮箱地址</label>
                        <div class="col-sm-10">
                            <input type="text"  name="email" class="form-control" id="email_input" placeholder="email@163.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_input" value="男" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_input" value="女"> 女
                            </label>

                        </div>
                    </div>
                    <div class="form-group">
                        <%--部门是我们通过查询数据库得到的(发ajax请求)--%>
                        <label class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-4">
                           <%--提交部门id即可--%>
                            <select class="form-control" name="d_id" id="dept_add_select">
                                //下拉列表中的内容通过ajax请求得到后,再通过函数封装上

                            </select>

                        </div>
                    </div>


                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="save_emp">保存</button>
            </div>
        </div>
    </div>
</div>


<!-- 修改员工的时候弹出的模态框 -->
<div class="modal fade" id="empUpdateModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="update_form">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">员工名称</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update"></p>

                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">邮箱地址</label>
                        <div class="col-sm-10">
                            <input type="text"  name="email" class="form-control" id="email_update" placeholder="email@163.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update" value="男" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update" value="女"> 女
                            </label>

                        </div>
                    </div>
                    <div class="form-group">
                        <%--部门是我们通过查询数据库得到的(发ajax请求)--%>
                        <label class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-4">
                            <%--提交部门id即可--%>
                            <select class="form-control" name="d_id" id="dept_update_select">
                                //下拉列表中的内容通过ajax请求得到后,再通过函数封装上

                            </select>

                        </div>
                    </div>


                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="update_emp">更新</button>
            </div>
        </div>
    </div>
</div>

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
            <button type="button" class="btn btn-primary" id="emp_add_model_btn">新增</button>
            <button type="button" class="btn btn-danger" id="emp_delete_model_btn">删除</button>
        </div>
    </div>
    <%--表格中的内容--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id ="emps_table">
                <thead>
                    <tr>
                        <th>
                            <%--复选框--%>
                            <input type="checkbox" id="check_all"/>
                        </th>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody id="emps_table tbody">

                </tbody>

            </table>
        </div>
    </div>
    <%--显示分页信息--%>
    <div class="row">
        <%--分页文字信息--%>
        <div class="col-md-6" id="page_info_area">
        </div>
        <%--分页条信息--%>
         <div class="col-md-6" id="page_nav_area">
         </div>

    </div>

</div>


</body>

</html>