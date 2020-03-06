package com.xxin.drugstore.admin.controller;

import com.xxin.drugstore.admin.service.OrderService;
import com.xxin.drugstore.admin.util.LoginUtil;
import com.xxin.drugstore.common.response.Message;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/14 19:49
 * @Description
 */
@RestController
public class OrderController {
    @Resource
    private OrderService orderService;

    @GetMapping("/order/status/{status}")
    public Message getOrderByStatus(@PathVariable("status")Integer status, @RequestParam("index")Integer index,@RequestParam("size")Integer size,HttpSession session){
        String s = LoginUtil.getShopId(session);
        System.out.println("当前商家"+s);
        if (s==null){
            return new Message();
        }
        return orderService.getOrderByStatus(status,s,index,size);
    }

    @GetMapping("/order/{id}/update")
    public Message updateOrderStatus(@PathVariable("id")String id){
        return orderService.updateOrderStatus(id);
    }


}
