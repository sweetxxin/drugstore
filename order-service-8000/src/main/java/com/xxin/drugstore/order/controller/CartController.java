package com.xxin.drugstore.order.controller;

import com.xxin.drugstore.common.entity.Cart;
import com.xxin.drugstore.common.response.Message;

import com.xxin.drugstore.order.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/7 14:59
 * @Description
 */
@RestController
public class CartController {
    @Autowired
    private CartService cartService;


    @PostMapping("/cart/count")
    public Message getCartCount(@RequestParam("id")String id){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(cartService.countCart(id));
        return message;
    }

    @PostMapping("/cart/list")
    public Message getCartList(@RequestParam("id")String id,@RequestParam("index")Integer index,@RequestParam("size")Integer size){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(cartService.getCartList(id,index-1 ,size));
        return message;
    }

    @PostMapping("/cart/delete/{id}")
    public Message delCart(@PathVariable("id")String id){
        Message message = new Message();
        message.setMessage("删除成功");
        message.setSuccess(cartService.delCart(id));
        return message;
    }
    @PostMapping("/cart/delete/in")
    public Message delCartIn(@RequestBody List<String> ids){
        Message message = new Message();
        message.setMessage("删除成功");
        message.setSuccess(cartService.delCartIn(ids));
        return message;
    }
    @PostMapping("/cart/clear")
    public Message clearCart(@RequestParam("id")String id){
        Message message = new Message();
        message.setSuccess(cartService.clearCart(id));
        message.setMessage("购物车清空成功");
        return message;
    }

    @PostMapping("/cart/off/clear")
    public Message clearOffCart(@RequestParam("id")String id){
        Message message = new Message();
        message.setMessage("失效商品清空成功");
        message.setSuccess(cartService.clearOffCart(id));
        return message;
    }
    @PostMapping("/cart/add")
    public Message addInCart(@RequestBody Cart cart){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(cartService.addInCart(cart));
        return message;
    }
}
