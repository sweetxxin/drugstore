package com.xxin.drugstore.portal.controller;

import com.xxin.drugstore.common.entity.Cart;
import com.xxin.drugstore.common.entity.Sku;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.portal.service.OrderService;
import com.xxin.drugstore.portal.util.LoginUtil;
import org.springframework.web.bind.annotation.*;
import sun.plugin.com.Utils;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/7 14:47
 * @Description
 */
@RestController
public class CartController {
    @Resource
    private OrderService orderService;

    @GetMapping("/cart/count")
    public Message getCartCount(HttpSession session){
        String s =LoginUtil.checkLogin(session);
        if (s==null){
            return new Message();
        }
        return orderService.getCartCount(s);
    }

    @GetMapping("/cart/list/{index}")
    public Message getCartList(@PathVariable("index")Integer index,HttpSession session){
        String s = LoginUtil.checkLogin(session);
        if (s==null){
            return new Message();
        }
        return orderService.getCartList(s, index,5 );
    }

    @GetMapping("/cart/delete/{id}")
    public Message delCart(@PathVariable("id")String id){
        return orderService.delCart(id);
    }

    @PostMapping("/cart/delete/in")
    public Message delCartIn(@RequestBody List<String> ids){
        System.out.println("购物车删除："+ids);
        return orderService.delCartIn(ids);
    }
    @GetMapping("/cart/clear")
    public Message clearCart(HttpSession session){
        String s = LoginUtil.checkLogin(session);
        if (s==null) {
            return new Message();
        }
        return orderService.clearCart(s);
    }
    @GetMapping("/cart/off/clear")
    public Message clearOffCart(HttpSession session){
        String s = LoginUtil.checkLogin(session);
        if (s==null){
            return new Message();
        }
        return orderService.clearOffCart(s);
    }

    @PostMapping("/cart/add/{id}/{num}")
    public Message addInCart(@PathVariable("id")String id,@PathVariable("num")Integer num,HttpSession session){
        String s = LoginUtil.checkLogin(session);
        if (s==null){
            Message message = new Message();
            message.setMessage("未登录");
            message.setCode(-1);
            return message;
        }
        Cart cart = new Cart();
        cart.setUserId(s);
        cart.setAmount(num);
        Sku sku = new Sku();
        sku.setMainId(id);
        cart.setSku(sku);
        return orderService.addInCart(cart);
    }
}
