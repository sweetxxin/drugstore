package com.xxin.drugstore.product.controller;

import com.xxin.drugstore.common.pojo.StatisticItem;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.product.service.StatisticService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/26 15:00
 * @Description
 */
@RestController
public class StatisticController {
    @Autowired
    private StatisticService statisticService;

    @GetMapping("/product/compose/{type}")
    public Message getProductCompose(@RequestParam("id") String shopId, @PathVariable("type")String type){
        Message message = new Message();
        message.setSuccess(true);
        if (type.equals("brand")){
            message.setData(statisticService.getProductComposeByBrand(shopId));
        }else{
            message.setData(statisticService.getProductComposeByCategory(shopId));
        }
        return message;
    }
}
