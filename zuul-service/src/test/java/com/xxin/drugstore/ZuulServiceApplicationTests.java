package com.xxin.drugstore;

import com.xxin.drugstore.property.Filter;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class ZuulServiceApplicationTests {
    @Autowired
    private Filter filter;
    @Test
    public void contextLoads() {
        System.out.println(filter.getInclude());
    }

}
