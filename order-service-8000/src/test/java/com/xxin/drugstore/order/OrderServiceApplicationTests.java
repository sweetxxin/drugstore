package com.xxin.drugstore.order;

import com.xxin.drugstore.common.entity.OrderProduct;
import com.xxin.drugstore.order.repository.OrderProductRepository;
import com.xxin.drugstore.order.repository.OrderRepository;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class OrderServiceApplicationTests {

    @Autowired
    private OrderProductRepository orderProductRepository;


    @Test
    public void contextLoads(){
    }

}
