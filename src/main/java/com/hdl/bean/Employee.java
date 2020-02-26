package com.hdl.bean;

import javax.validation.constraints.Pattern;

public class Employee {
    private Integer emp_id;

    @Pattern(regexp = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]+$)",message="用户名可以使用2-5个中文格式或者6-16个英文和中文的组合")
    private String emp_name;

    private String gender;


    @Pattern(regexp = "(^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$)|(^[a-z\\d]+(\\.[a-z\\d]+)*@([\\da-z](-[\\da-z])?)+(\\.{1,2}[a-z]+)+$)"
            ,message="邮箱格式不正确")
    private String email;

    private Integer d_id;
    private Department department;


    public Integer getEmp_id() {
        return emp_id;
    }

    public Employee() {
    }

    public Employee(Integer emp_id, String emp_name, String gender, String email, Integer d_id) {
        this.emp_id = emp_id;
        this.emp_name = emp_name;
        this.gender = gender;
        this.email = email;
        this.d_id = d_id;
    }

    public void setEmp_id(Integer emp_id) {
        this.emp_id = emp_id;
    }

    public String getEmp_name() {
        return emp_name;
    }

    public void setEmp_name(String emp_name) {
        this.emp_name = emp_name == null ? null : emp_name.trim();
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender == null ? null : gender.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim();
    }

    public Integer getD_id() {
        return d_id;
    }

    public void setD_id(Integer d_id) {
        this.d_id = d_id;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    @Override
    public String toString() {
        return "Employee{" +
                "emp_id=" + emp_id +
                ", emp_name='" + emp_name + '\'' +
                ", gender='" + gender + '\'' +
                ", email='" + email + '\'' +
                ", d_id=" + d_id +
                ", department=" + department +
                '}';
    }
}