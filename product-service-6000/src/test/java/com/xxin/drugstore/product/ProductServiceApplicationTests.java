package com.xxin.drugstore.product;

import com.xxin.drugstore.product.service.ProductService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class ProductServiceApplicationTests {
    @Autowired
    private ProductService productService;


    @Test
    public void contextLoads() {

    }

}
