
package com.hdl.test;


/*测试mapper是否走的通*/


import com.hdl.bean.Department;
import com.hdl.bean.Employee;
import com.hdl.mapper.DepartmentMapper;

import com.hdl.mapper.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;


/**
// * 推荐spring的项目就使用Spring的单元测试,可以自动注入我们需要的组件,就不用创建SpringIOC容器,再从容器中获取mapper
// * 1 先导入Spring-test的坐标
// * 2  @ContextConfiguration注解指定sprinf配置文件位置
// * 3  @RunWith指定单元测试模块
// * 4 用@Autowired注解自动注入组件
// */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:contextConfigLocation.xml"})
public class MapperTest {


/**
//     * 测试DepartmentMapper
//     */

    @Autowired
    DepartmentMapper departmentMapper;
    @Autowired
    EmployeeMapper employeeMapper;
    @Autowired
    SqlSession sqlSession;
    @Test
    public void testCRUD(){
        //1.创建SpringIOC容器
        //ApplicationContext ac = new ClassPathXmlApplicationContext("classpath:contextConfigLocation.xml");
        //2.从容器中获取mapper
        //DepartmentMapper departmentMapper = ac.getBean(DepartmentMapper.class);
        //先测试一下IOC容器是否有问题,是否可以创建对象成功
        System.out.println(departmentMapper);

        //1 插入几个部门
        departmentMapper.insertSelective(new Department(null,"体育部"));
        departmentMapper.insertSelective(new Department(null,"测试部"));
        //2 插入几个员工
        employeeMapper.insertSelective(new Employee(null,"何睿","男","15732632513@163.com",3));
        //3 批量插入多个员工(可以直接使用批量操作的sqlSession)
        EmployeeMapper mapper=sqlSession.getMapper(EmployeeMapper.class);
        for(int i=1;i<=1000;i++){
            String uid=UUID.randomUUID().toString().substring(0,5)+i;
            mapper.insertSelective(new Employee(null,uid,"男","@"+uid+"163.com",3));
        }
        System.out.println("批量成功");



    }

}

