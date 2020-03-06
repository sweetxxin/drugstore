package com.xxin.drugstore.order.controller;

import com.xxin.drugstore.common.entity.*;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.order.service.CommentService;
import com.xxin.drugstore.order.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 16:33
 * @Description
 */
@RestController
public class OrderController {
    @Autowired
    private OrderService orderService;
    @Autowired
    private CommentService commentService;

    @PostMapping("/order/create")
    public Message createNewOrder(@RequestParam("uid") String uid, @RequestParam("toAddressId") String toAddressId,@RequestParam("delivery")String deliveryTitle,@RequestParam("deliveryFee")double deliveryFee, @RequestParam("totalPrice") double totalPrice, @RequestBody List<OrderProduct> products){
        Delivery delivery = new Delivery();
        delivery.setDeliveryFee(deliveryFee);
        delivery.setDelivery(deliveryTitle);
        Address address = new Address();
        address.setMainId(toAddressId);
        delivery.setToAddress(address);
        Shop shop = new Shop();
        shop.setMainId("402809816ebc8b51016ebc8b94e70000");

        User user = new User();
        user.setMainId(uid);
        return orderService.createNewOrder(user,shop, delivery,totalPrice ,products);
    }

    @PostMapping("/order/pay")
    public Message payOrder(@RequestBody Order order){
        return orderService.payOrder(order);
    }

    @PostMapping("/order/list")
    public Message getOrderList(@RequestParam("index")Integer index,@RequestParam("size")Integer size,@RequestParam("id")String uid){
        Message message = new Message();
        User user = new User();
        user.setMainId(uid);
        message.setData(orderService.getOrderList(index-1,size ,user));
        message.setSuccess(true);
        return message;
    }
    @GetMapping("/order/{id}/detail")
    public Message getOrderDetail(@PathVariable("id")String id){
        Message message = new Message();
        Order orderDetail = orderService.getOrderDetail(id);
        message.setSuccess(orderDetail!=null);
        message.setData(orderDetail);
        return message;
    }

    @PostMapping("/order/status/{status}")
    public Message getOrderByStatus(@PathVariable("status")Integer status, @RequestParam("shopId")String shopId,@RequestParam("index")Integer index,@RequestParam("size")Integer size){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(orderService.getOrderByStatus(shopId, status, index-1, size));
        return message;
    }
    @PostMapping("/order/cancel")
    public Message cancelOrder(@RequestParam("id") String id){
        Message message = new Message();
        message.setData(orderService.cancelOrder(id));
        message.setSuccess(true);
        return message;
    }
    @PostMapping("/order/{id}/update")
    public Message updateOrderStatus(@PathVariable("id")String id){
        Message message = new Message();
        Order order = orderService.updateOrderStatus(id);
        message.setSuccess(order!=null);
        message.setData(order);
        return message;
    }

    @PostMapping("/order/comment")
    public Message commentOrder(@RequestBody Assessment assessment){
        System.out.println(assessment);
        Message message = new Message();
        message.setData(commentService.commentOrder(assessment));
        message.setSuccess(true);
        return message;
    }
}
