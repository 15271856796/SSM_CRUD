package com.hdl.services;

import com.hdl.bean.Employee;

import java.util.List;

public interface EmployeeService {

    public List<Employee> getAll();

    void saveEmp(Employee employee);

    List<Employee> getEmpName(String emp_name);

    Employee getEmp(Integer emp_id);

    void update_emp(Employee employee);

    void delSingle(Integer emp_id);

    public void deleteBatch(List<Integer> emp_id);
}
