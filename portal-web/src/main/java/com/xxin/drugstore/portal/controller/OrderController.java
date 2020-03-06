package com.xxin.drugstore.portal.controller;

import com.xxin.drugstore.common.entity.*;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.common.util.JsonUtil;
import com.xxin.drugstore.portal.service.OrderService;
import com.xxin.drugstore.portal.util.LoginUtil;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 16:32
 * @Description
 */
@RestController
public class OrderController {
    @Resource
    private OrderService orderService;

    @PostMapping("/order/create")
    public Message createNewOrder(double  totalPrice, @RequestParam("toAddressId") String toAddressId,@RequestParam("delivery")String deliveryTitle,@RequestParam("deliveryFee")double deliveryFee, @RequestParam("products")String products, HttpSession session){
        String s = LoginUtil.checkLogin(session);
        if (s==null){
            return new Message();
        }
        HashMap<String, HashMap> map = JsonUtil.jsonToPojo(products, HashMap.class);
        List<OrderProduct> orderProducts = new ArrayList<>();
        for (String key:map.keySet()){
            OrderProduct orderProduct = new OrderProduct();
            Sku sku = new Sku();
            sku.setMainId(key);
            orderProduct.setSku(sku);
            orderProduct.setAmount(Integer.valueOf(map.get(key).get("amount").toString()));
            orderProducts.add(orderProduct);
        }
        return orderService.createNewOrder(s,toAddressId ,deliveryTitle,deliveryFee, totalPrice,orderProducts);
    }
    @PostMapping("/order/pay")
    public Message payOrder(@RequestBody Order order){
        System.out.println(order);
        return orderService.payOrder(order);
    }
    @GetMapping("/order/{id}/update")
    public Message updateOrder(@PathVariable("id")String id){
        return orderService.updateOrderStatus(id);
    }
    @PostMapping("/order/cancel")
    public Message cancelOrder(@RequestParam("id") String id){
        System.out.println("撤销订单ID"+id);
        return orderService.cancelOrder(id);
    }
    @GetMapping("/order/list/{index}")
    public Message getOrderList(@PathVariable("index")Integer index,HttpSession session){
        String s = LoginUtil.checkLogin(session);
        if (s==null){
            return new Message();
        }
        return orderService.getOrderList(index,5,s);
    }

    @PostMapping("/order/comment")
    public Message commentOrder(@RequestBody Assessment assessment,HttpSession session){
        String s = LoginUtil.checkLogin(session);
        if (s==null){
            return new Message();
        }
        System.out.println(assessment);
        User user = new User();
        user.setMainId(s);
        assessment.setCreator(user);
        return orderService.commentOrder(assessment);
    }
}
