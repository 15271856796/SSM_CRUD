package com.hdl.services.Impl;

import com.hdl.bean.Department;
import com.hdl.bean.Msg;
import com.hdl.mapper.DepartmentMapper;
import com.hdl.services.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentServiceImpl implements DepartmentService {
    @Autowired
    private DepartmentMapper departmentMapper;
   public List<Department> getAllDept(){
       return departmentMapper.selectByExample(null);
    }
}
