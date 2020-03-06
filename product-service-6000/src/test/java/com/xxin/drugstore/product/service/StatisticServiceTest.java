package com.xxin.drugstore.product.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import static org.junit.Assert.*;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/26 14:55
 * @Description
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class StatisticServiceTest {
    @Autowired
    private StatisticService statisticService;

    @Test
    public void getProductCompose() {
        System.out.println(statisticService.getProductComposeByBrand("402809816ebc8b51016ebc8b94e70000"));
    }
}