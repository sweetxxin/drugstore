package com.xxin.drugstore.order.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import static org.junit.Assert.*;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/25 17:52
 * @Description
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class StatisticServiceTest {

    @Autowired
    private StatisticService statisticService;

    @Test
    public void getDate(){
        System.out.println(statisticService.getTopProductAt("402809816ebc8b51016ebc8b94e70000",2020,10));
        System.out.println(statisticService.getTopProductAt("402809816ebc8b51016ebc8b94e70000",2020,1,10));
        System.out.println(statisticService.getTopProductAt("402809816ebc8b51016ebc8b94e70000",2020,1,1,10));
    }
    @Test
    public void assessment(){
        System.out.println(statisticService.orderAreaStatistic("402809816ebc8b51016ebc8b94e70000"));

    }
}