
package com.hdl.services.Impl;

import com.hdl.bean.DepartmentExample;
import com.hdl.bean.Employee;
import com.hdl.bean.EmployeeExample;
import com.hdl.mapper.EmployeeMapper;
import com.hdl.services.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeServiceImpl implements EmployeeService {
    @Autowired
    EmployeeMapper employeeMapper;


/**
     * 查询所以的员工
     * @return
     */

    public List<Employee> getAll(){
        List<Employee> emps=employeeMapper.selectByExampleWithDeptname(null);
        return emps;
    }

    /**
     *保存员工
     * @param employee
     */

    @Override
    public void saveEmp(Employee employee) {
        employeeMapper.insertSelective(employee);
    }

    @Override
    public List<Employee> getEmpName(String emp_name) {
        return employeeMapper.selectByEmpName(emp_name);

    }

    /**
     * 根据用户id查员工
     */
    @Override
    public Employee getEmp(Integer emp_id) {
        return employeeMapper.selectByPrimaryKey(emp_id);
    }

    /**
     * 更新员工
     */
    @Override
    public void update_emp(Employee employee) {

        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    /**
     * 删除单个员工
     */
    @Override
    public void delSingle(Integer emp_id) {
        employeeMapper.deleteByPrimaryKey(emp_id);
    }

    /**
     * 批量删除员工
     */
    @Override
    public void deleteBatch(List<Integer> emp_id) {
        EmployeeExample employeeExample=new EmployeeExample();
        EmployeeExample.Criteria criteria=employeeExample.createCriteria();
        //添加条件,指定emp_id in()
        criteria.andEmp_idIn(emp_id);
        employeeMapper.deleteByExample(employeeExample);


    }
}

