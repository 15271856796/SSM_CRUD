package com.hdl.controller;

import com.hdl.bean.Department;
import com.hdl.bean.Msg;
import com.hdl.services.DepartmentService;
import com.sun.org.apache.bcel.internal.generic.RETURN;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 处理和部门相关的请求
 */

@Controller
public class DepartmentController {
    @Autowired
    DepartmentService departmentService;

    @ResponseBody
    @RequestMapping("depts")
    public Msg getAllDept(){

        List<Department>  depts=departmentService.getAllDept();

        return Msg.success().add("depts",depts);


    }
}
