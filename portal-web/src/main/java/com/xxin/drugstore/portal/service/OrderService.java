package com.xxin.drugstore.portal.service;

import com.xxin.drugstore.common.entity.*;
import com.xxin.drugstore.common.response.Message;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/7 15:28
 * @Description
 */
@FeignClient(value = "order-service")
public interface OrderService {
    @PostMapping("/order/create")
    Message createNewOrder(@RequestParam("uid") String uid, @RequestParam("toAddressId") String toAddressId,@RequestParam("delivery")String deliveryTitle,@RequestParam("deliveryFee")double deliveryFee, @RequestParam("totalPrice") double totalPrice, @RequestBody List<OrderProduct> products);
    @PostMapping("/order/pay")
    Message payOrder(@RequestBody Order order);
    @PostMapping("/order/cancel")
    Message cancelOrder(@RequestParam("id") String id);
    @PostMapping("/order/comment")
    Message commentOrder(@RequestBody Assessment assessment);
    @PostMapping("/order/{id}/update")
    Message updateOrderStatus(@PathVariable("id")String id);
    @PostMapping("/order/list")
    Message getOrderList(@RequestParam("index")Integer index,@RequestParam("size")Integer size,@RequestParam("id")String uid);
    @GetMapping("/order/{id}/detail")
    Message getOrderDetail(@PathVariable("id")String id);

    @PostMapping("/assessment/product/{productId}")
    Message getAssessmentByProduct(@PathVariable("productId")String productId, @RequestParam("index")Integer index,@RequestParam("size")Integer size,@RequestParam("id")String id);
    @PostMapping("/assessment/user")
     Message getAssessmentByUser(@RequestBody User user, @RequestParam("index")Integer index, @RequestParam("size")Integer size);
    @PostMapping("/assessment/order")
     Message getAssessmentByOrder(@RequestBody Order order);


    @PostMapping("/cart/count")
    Message getCartCount(@RequestParam("id")String id);
    @PostMapping("/cart/list")
    Message getCartList(@RequestParam("id")String id,@RequestParam("index")Integer index,@RequestParam("size")Integer size);
    @PostMapping("/cart/delete/{id}")
    Message delCart(@PathVariable("id")String id);
    @PostMapping("/cart/delete/in")
    Message delCartIn(@RequestBody List<String> ids);
    @PostMapping("/cart/clear")
    Message clearCart(@RequestParam("id")String id);
    @PostMapping("/cart/off/clear")
    Message clearOffCart(@RequestParam("id")String id);
    @PostMapping("/cart/add")
    Message addInCart(@RequestBody Cart cart);
}
