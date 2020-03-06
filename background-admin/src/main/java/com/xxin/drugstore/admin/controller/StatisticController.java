package com.xxin.drugstore.admin.controller;

import com.xxin.drugstore.admin.service.OrderService;
import com.xxin.drugstore.admin.service.ProductService;
import com.xxin.drugstore.admin.util.LoginUtil;
import com.xxin.drugstore.common.response.Message;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/25 21:35
 * @Description
 */
@RestController
public class StatisticController {
    @Resource
    private OrderService orderService;
    @Resource
    private ProductService productService;
    @GetMapping("/order/date")
    public Message getOrderDate(HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return orderService.getOrderDate(s);
    }
    @GetMapping("/sale/each/year")
    public Message getSaleEachYear(HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return orderService.getSaleEachYear(s);
    }
    @GetMapping("/sale/at/{year}")
    public Message getSaleByYear(@PathVariable("year")Integer year,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return orderService.getSaleByYear(year,s);
    }
    @GetMapping("/sale/{year}/{month}")
    public Message getSaleByMonth(@PathVariable("year")Integer year,@PathVariable("month")Integer month,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return orderService.getSaleByMonth(year,month ,s);
    }
    @GetMapping("/sale/{year}/{month}/{day}")
    public Message getSaleByDate(@PathVariable("year")Integer year,@PathVariable("month")Integer month,@PathVariable("day")Integer day,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return orderService.getSaleByDate(year,month ,day ,s);
    }

    @RequestMapping({"/product/top/{num}","/product/top/{num}/{year}","/product/top/{num}/{year}/{month}","/product/top/{num}/{year}/{month}/{day}"})
    public Message getTopProduct(@PathVariable(value = "num",required = true)Integer num,@PathVariable(value = "year",required = false)Integer year,@PathVariable(value = "month",required = false)Integer month,@PathVariable(value = "day",required = false)Integer day,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        System.out.println(year+"-"+month+"-"+day);
        HashMap map = new HashMap();
        map.put("year",year );
        map.put("month",month );
        map.put("day",day );
        return orderService.getTopProduct(s,num,map);
    }

    @GetMapping("/product/compose/{type}")
    public Message getProductCompose(@PathVariable("type")String type,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return productService.getProductCompose(s,type);
    }
    @GetMapping("/assessment/statistic/{type}")
    public Message getAssessmentStatistic(@PathVariable("type")String type,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return orderService.getAssessmentStatistic(type,s);
    }
    @GetMapping("/assessment/statistic")
    public Message getAllAssessmentStatistic(HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return orderService.getAssessmentStatistic(s);
    }
    @GetMapping("/order/recent/{day}/statistic")
    public Message getRecentOrderStatistic(@PathVariable("day")Integer day,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return orderService.getRecentOrderStatistic(day,s);
    }
    @GetMapping("/order/{type}/statistic")
    public Message orderStatisticBy(@PathVariable("type")String type,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return orderService.orderStatisticBy(type,s);
    }
}
