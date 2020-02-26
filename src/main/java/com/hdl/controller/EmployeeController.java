
package com.hdl.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.hdl.bean.Employee;
import com.hdl.bean.Msg;
import com.hdl.services.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.xml.bind.SchemaOutputResolver;
import javax.xml.ws.ResponseWrapper;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 处理员工的增删改查操作
 *
 * URL
 * /emps/{id} GET   查询员工
 * /emps       POST  保存员工
 * /emps/{id}   PUT   修改员工
 * /emps/{id}   DELETE  删除员工
 */

@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;



    /**
     * 查询员工数据(分页查询)
     *以返回页面的形式,这种方式有其弊端,就是当客户端从浏览器换成安卓,ios的话,就不好解析返回的页面,所以下面会讲到如何通过返回json串的形式
     * @return
     */

    //@RequestMapping(value="/emps",method = RequestMethod.GET)
    public String getemps(@RequestParam(value ="pn",defaultValue = "1") Integer pn, Model model){
        //由于所有员工的数据量大 所有我们需要实现分页查询,如果我们自己根据页数手动算的话,会比较麻烦,所以我们引进PageHelper分页插件
        //1 导入坐标
        //2 在mybatis全局配置文件中使用进行plugins进行配置
        //3 在查询之前只需要调用,传入页码,以及每页的大小
        PageHelper.startPage(pn,5);
        //startPage后面紧跟的这个查询就是一个分页查询
        List<Employee> emps=employeeService.getAll();

        //使用pageInfo包装查询后的结果,PageInfo里包含了这一页的所有信息,比如是否有前一页,是否有后一页等等,还包括我们的查询数据,所以我们只需要将PageInfo交给页面就行了
        //navigatePages是指连续显示的页数
        PageInfo page=new PageInfo(emps,5);
        model.addAttribute("pageInfo",page); /*将数据放在请求域中*/

        return "list";
    }

    /**
     * 查询员工数据(分页查询)
     *结果以返回json串的形式
     * 想返回json的话,必须是在方法上加@ResponseBody,但想用@ResponseBody必须先导入jackson坐标(pom.xml),
     * 不加@ResponseBody的话会报404,也就是页面找不到
     */
    @ResponseBody   /*自动将返回结果变成json串的形式*/
    @RequestMapping(value="/emps",method = RequestMethod.GET)
    public Msg Newgetemps(@RequestParam(value ="pn",defaultValue = "1") Integer pn, Model model){
        //由于所有员工的数据量大 所有我们需要实现分页查询,如果我们自己根据页数手动算的话,会比较麻烦,所以我们引进PageHelper分页插件
        //1 导入坐标
        //2 在mybatis全局配置文件中使用进行plugins进行配置
        //3 在查询之前只需要调用,传入页码,以及每页的大小
        PageHelper.startPage(pn,5);
        //startPage后面紧跟的这个查询就是一个分页查询
        List<Employee> emps=employeeService.getAll();

        //使用pageInfo包装查询后的结果,PageInfo里包含了这一页的所有信息,比如是否有前一页,是否有后一页等等,还包括我们的查询数据,所以我们只需要将PageInfo交给页面就行了
        //navigatePages是指连续显示的页数
        PageInfo page=new PageInfo(emps,5);
        return Msg.success().add("pageInfo",page);
    }

    /**
     * 员工保存
     * @return
     *
     * 仅靠前端(在点击保存按钮的时候)来校验输入的数据是否合法的话,会有用户恶意逃过校验,比如说直接改前端代码
     * 所以后端也需要来校验输入的数据是否合法(使用springmvc提供的JSR303)
     *第一步:导入JSR303包,也就是先导入左坐标 ,导入Hibernate-Validator
     *第二步:在需要校验的字段属性上加入注解,比如在Employee的emp_name以及email字段上加注解,我们需要对这两个字段进行校验
     *第三步:在接参的参数那使用@Valid,以及加一个类型为BinddingResult的参数,来接收校验的结果
     *
     */
    @ResponseBody
    @RequestMapping(value="/emps",method=RequestMethod.POST)
    //@Valid是指要进行校验,BindingResult来封装校验结果
    public Msg saveEmp(@Valid Employee employee, BindingResult result){   //表单中的value名称与Employee属性一致,所以可以自动封装
        if(result.hasErrors()){
            //校验失败,应该返回失败,还是在输入款下面显示提示信息
            Map<String,Object> map=new HashMap<String, Object>();
            List<FieldError> errors= result.getFieldErrors();
            for (FieldError fieldError:errors){
                System.out.println("错误的字段名:"+fieldError.getField());
                System.out.println("发生错误的提示信息:"+fieldError.getDefaultMessage());
                map.put(fieldError.getField(),fieldError.getDefaultMessage());

            }
            return Msg.fail().add("errorFileds",map);

        }else{
            employeeService.saveEmp(employee);
            return Msg.success();

        }

    }

    /**
     * 查找是否有同名的员工
     *
     */
    @ResponseBody
    @RequestMapping(value = "/emps/getbyname", method=RequestMethod.GET)
    public Msg getEmpName(String emp_name){
        //先判断输入的用户名是否合法(前端里是也加过一遍,但是那个是保存按钮点击事件,这个是绑定在输入框改变事件上)
        String regx="(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]+$)";

        if(!emp_name.matches(regx)){
            return Msg.fail().add("msg","用户名必须是2-5个中文格式或者6-16个英文和中文的组合");

        }

        //再判断用户名是否重复校验
        List<Employee> list=employeeService.getEmpName(emp_name);
        if(list.isEmpty()){
            return Msg.success();

        }else{
            return Msg.fail().add("msg","用户名不可用");
        }
    }

    /**
     * 根据员工id,查询员工信息
     * @param emp_id
     * @return
     */

    @ResponseBody   //返回json串到前端
    @RequestMapping(value = "emps/{emp_id}",method =RequestMethod.GET)
    public Msg getMap(@PathVariable("emp_id") Integer emp_id){
        Employee employee=employeeService.getEmp(emp_id);
        return Msg.success().add("emp",employee);

    }

    /**
     * 更新员工信息
     * 实际这个方法没有在使用,更新常用下一个方法来接参,只是演示如何接收请求url里的参数,第一种方法 用@PathVariable(get post put url都适用)
     */
    //@ResponseBody
   // @RequestMapping(value="/emps/{id}",method=RequestMethod.PUT)
    public Msg update_Emp(Employee employee,@PathVariable("id") Integer id){
        System.out.println(employee.toString());
        employee.setEmp_id(id);
        System.out.println(employee.toString());
        employeeService.update_emp(employee);
        return Msg.success();

    }

    /**
     * 更新员工信息
     * 演示如何接收请求url里的参数的第二种方法 用bean对象来接(常用),前提是/emps/{},花括号里必须是bean对象属性名
     */
    @ResponseBody
    @RequestMapping(value="/emps/{emp_id}",method=RequestMethod.PUT)
    public Msg update_Emp(Employee employee){
        employeeService.update_emp(employee);
        return Msg.success();

    }




    /**
     * 删除员工(单个和批量删除都用这个),只是调用了不同的Service层的方法
     *
     * 如果前端传的是数字,后端可以用Integer类型参数来接收,也可以用String类型来接收,
     * 但是如果前端传的不是纯数字,里面含的有字符的话,那么后端只能拿String类型来接收
     *
     *
     */
    @ResponseBody
    @RequestMapping(value="/emps/{emp_id}",method = RequestMethod.DELETE)
    public Msg delSingle(@PathVariable("emp_id") String emp_id){
        //批量删除(前端将批量删除的emp_id组装成一个用'-'隔开的字符串传入后端)
        if(emp_id.contains("-")){
            String ids[]=emp_id.split("-");
            /*for(String str_id:ids){
                Integer id=Integer.parseInt(str_id);
                employeeService.delSingle(id);
            }*/
            //上面的方法不够优化,我们想创建一个批量删除的方法
            //1 将字符串数组组装成Integer List
            List<Integer> empIds=new ArrayList<>();
            for(String str_id:ids){
                Integer id=Integer.parseInt(str_id);
                empIds.add(id);
            }
            employeeService.deleteBatch(empIds);

        }else{//单个删除,传进来的只有一个emp_id
            Integer id=Integer.parseInt(emp_id);
            employeeService.delSingle(id);

        }
        return Msg.success();

    }

}

