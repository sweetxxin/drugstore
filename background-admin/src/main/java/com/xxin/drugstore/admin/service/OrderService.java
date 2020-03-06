package com.xxin.drugstore.admin.service;

import com.xxin.drugstore.common.entity.Order;
import com.xxin.drugstore.common.response.Message;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/14 20:09
 * @Description
 */
@FeignClient(value = "order-service")
public interface OrderService {
    @PostMapping("/order/status/{status}")
    Message getOrderByStatus(@PathVariable("status")Integer status, @RequestParam("shopId")String shopId,@RequestParam("index")Integer index,@RequestParam("size")Integer size);

    @PostMapping("/order/{id}/update")
    Message updateOrderStatus(@PathVariable("id")String id);

    @GetMapping("/order/{id}/detail")
    Message getOrderDetail(@PathVariable("id")String id);

    @PostMapping("/assessment/order")
    Message getAssessmentByOrder(@RequestBody Order order);

/**销售统计**/
    @GetMapping("/order/date")
    Message getOrderDate(@RequestParam("id")String id);
    @GetMapping("/sale/each/year")
    Message getSaleEachYear(@RequestParam("id")String id);
    @GetMapping("/sale/at/{year}")
    Message getSaleByYear(@PathVariable("year")Integer year,@RequestParam("id")String id);
    @GetMapping("/sale/{year}/{month}")
    Message getSaleByMonth(@PathVariable("year")Integer year,@PathVariable("month")Integer month,@RequestParam("id")String id);
    @GetMapping("/sale/{year}/{month}/{day}")
    Message getSaleByDate(@PathVariable("year")Integer year,@PathVariable("month")Integer month,@PathVariable("day")Integer day,@RequestParam("id")String id);

    @RequestMapping("/product/top/{num}")
    Message getTopProduct(@RequestParam("id")String id, @PathVariable(value = "num")Integer num, @RequestBody HashMap<String,Integer> map);

    @GetMapping("/assessment/statistic/{type}")
    Message getAssessmentStatistic(@PathVariable("type")String type,@RequestParam("id")String id);
    @GetMapping("/assessment/statistic")
    Message getAssessmentStatistic(@RequestParam("id")String id);

    @GetMapping("/order/recent/{day}/statistic")
    Message getRecentOrderStatistic(@PathVariable("day")Integer day,@RequestParam("id")String id);
    @GetMapping("/order/{type}/statistic")
    Message orderStatisticBy(@PathVariable("type")String type,@RequestParam("id")String id);
}
