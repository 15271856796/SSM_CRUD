package com.hdl.mapper;

import com.hdl.bean.Employee;
import com.hdl.bean.EmployeeExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface EmployeeMapper {
    long countByExample(EmployeeExample example);

    int deleteByExample(EmployeeExample example);

    int deleteByPrimaryKey(Integer emp_id);

    int insert(Employee record);

    int insertSelective(Employee record);

    List<Employee> selectByExample(EmployeeExample example);

    Employee selectByPrimaryKey(Integer emp_id);

    List<Employee> selectByExampleWithDeptname(EmployeeExample example);

    Employee selectByPrimaryKeyWithDeptname(Integer emp_id);

    List<Employee> selectByEmpName(String emp_name);


    int updateByExampleSelective(@Param("record") Employee record, @Param("example") EmployeeExample example);

    int updateByExample(@Param("record") Employee record, @Param("example") EmployeeExample example);

    int updateByPrimaryKeySelective(Employee record);

    int updateByPrimaryKey(Employee record);
}