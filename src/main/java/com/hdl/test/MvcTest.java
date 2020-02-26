
package com.hdl.test;

import com.github.pagehelper.PageInfo;
import com.hdl.bean.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MockMvcBuilder;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;


/**
 * 使用spring测试模提供的测试请求模块,测试curd的正确性
 */


import com.github.pagehelper.PageInfo;
import com.hdl.bean.Employee;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:contextConfigLocation.xml","file:E:\\IdeaWorkspace\\ssm_crud\\src\\main\\resources\\springMVC.xml"})
public class MvcTest {
    //传入springmvc的ioc
    @Autowired
    WebApplicationContext context;
    MockMvc mockMvc;

    @Before
    public  void initMockMvc(){
        //虚拟mvc请求,并获取到处理结果
        mockMvc= MockMvcBuilders.webAppContextSetup(context).build();
    }
    @Test
    //模拟发送请求并拿到返回值
    public void testPage() throws Exception {
        MvcResult result =mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn","1")).andReturn();
        //请求成功以后,在请求域中会有 pageInfo,我们可以取出pageInfo进行验证
        MockHttpServletRequest request=result.getRequest();
        PageInfo pi=(PageInfo) request.getAttribute("pageInfo");
        System.out.println("当前页码:"+pi.getPageNum());
        System.out.println("总页码:"+pi.getPages());
        System.out.println("总记录数:"+pi.getTotal());
        System.out.println("在页面需要连续显示的页码:");
        int []nums=pi.getNavigatepageNums();
        for(int i :nums){
            System.out.println(" "+i);
        }
        //获取员工数据,也就是我们查询的第一页员工的数据
        List<Employee> list=pi.getList();
        for(Employee emp:list){
            System.out.println(emp.toString());
        }

    }
}

