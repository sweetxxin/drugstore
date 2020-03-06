package com.xxin.drugstore.order.controller;

import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.order.service.StatisticService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/25 21:06
 * @Description
 */
@RestController
public class StatisticController {
    @Autowired
    private StatisticService statisticService;

    @GetMapping("/order/date")
    public Message getOrderDate(@RequestParam("id")String id){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(statisticService.getOrderDate(id));
        return message;
    }

    @GetMapping("/sale/each/year")
    public Message getSaleEachYear(@RequestParam("id")String id){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(statisticService.countSaleEachYear(id));
        return message;
    }
    @GetMapping("/sale/at/{year}")
    public Message getSaleByYear(@PathVariable("year")Integer year,@RequestParam("id")String id){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(statisticService.countSaleByYear(year,id));
        return message;
    }
    @GetMapping("/sale/{year}/{month}")
    public Message getSaleByMonth(@PathVariable("year")Integer year,@PathVariable("month")Integer month,@RequestParam("id")String id){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(statisticService.countSaleByMonth(year,month,id));
        return message;
    }
    @GetMapping("/sale/{year}/{month}/{day}")
    public Message getSaleByDate(@PathVariable("year")Integer year,@PathVariable("month")Integer month,@PathVariable("day")Integer day,@RequestParam("id")String id){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(statisticService.countSaleByDate(year,month,day,id));
        return message;
    }
    @RequestMapping("/product/top/{num}")
    public Message getTopProduct(@RequestParam("id")String id, @PathVariable(value = "num")Integer num, @RequestBody HashMap<String,Integer> map){
        Message message = new Message();
        System.out.println(map);
        if (map.get("year")!=null&&map.get("month")!=null&&map.get("day")!=null){
            message.setData(statisticService.getTopProductAt(id, num,map.get("year"),map.get("month"),map.get("day")));
        }else if (map.get("year")!=null&&map.get("month")!=null&&map.get("day")==null){
            message.setData(statisticService.getTopProductAt(id,map.get("year"),map.get("month"), num));
        }else if (map.get("year")!=null&&map.get("month")==null&&map.get("day")==null){
            message.setData(statisticService.getTopProductAt(id,map.get("year"), num));
        }else{
            message.setData(statisticService.getTopProduct(id,num));
        }
        message.setSuccess(true);
        return message;
    }
    @GetMapping("/assessment/statistic/{type}")
    public Message getAssessmentStatistic(@PathVariable("type")String type,@RequestParam("id")String id){
        Message message= new Message();
        message.setSuccess(true);
        message.setData(statisticService.getAssessmentStatistic(type, id));
        return message;
    }
    @GetMapping("/assessment/statistic")
    public Message getAssessmentStatistic(@RequestParam("id")String id){
        Message message= new Message();
        message.setSuccess(true);
        message.setData(statisticService.getAssessmentStatistic(id));
        return message;
    }
    @GetMapping("/order/recent/{day}/statistic")
    public Message getRecentOrderStatistic(@PathVariable("day")Integer day,@RequestParam("id")String id){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(statisticService.recentOrderStatistic(id,day ));
        return message;
    }
    @GetMapping("/order/{type}/statistic")
    public Message orderStatisticBy(@PathVariable("type")String type,@RequestParam("id")String id){
        Message message = new Message();
        message.setSuccess(true);
        if (type.equals("area")){
            message.setData(statisticService.orderAreaStatistic(id));
        }else{
            message.setData(statisticService.orderStatusStatistic(id));
        }
        return message;
    }
}
