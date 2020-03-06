package com.xxin.drugstore.admin.controller;

import com.xxin.drugstore.admin.service.UserService;
import com.xxin.drugstore.admin.util.LoginUtil;
import com.xxin.drugstore.common.entity.ShopVerify;
import com.xxin.drugstore.common.entity.Shop;
import com.xxin.drugstore.common.entity.ShopDelivery;
import com.xxin.drugstore.common.response.Message;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/30 21:30
 * @Description
 */
@RestController
public class ShopController {
    @Resource
    private UserService shopService;

    @GetMapping("/shop/info")
    public Message getShopInfoById(HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return shopService.getShopInfoById(s);
    }
    @PostMapping("/shop/info/update")
    public Message updateShopInfo(@RequestBody Shop shop,HttpSession session){
        Message message = shopService.updateShopInfo(shop);
        if (message.isSuccess()){
            session.setAttribute("currentShop",message.getData());
        }
        return message;
    }

    @GetMapping("/shop/delivery")
    public Message getShopDelivery(HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return shopService.getShopDelivery(s);
    }
    @PostMapping("/shop/delivery/update")
    public Message updateShopDelivery(@RequestBody ShopDelivery delivery){

        return shopService.updateShopDelivery(delivery);
    }
    @PostMapping("/shop/delivery/add")
    public Message addShopDelivery(@RequestBody ShopDelivery delivery,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        delivery.setShopId(s);
        return shopService.updateShopDelivery(delivery);
    }
    @GetMapping("/shop/delivery/{id}/del")
    public Message delShopDelivery(@PathVariable("id")Integer id){
        return shopService.delShopDelivery(id);
    }

    @GetMapping("/shop/customer")
    public Message getShopCustomer(@RequestParam("index")Integer index,@RequestParam("size")Integer size,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return shopService.getShopCustomer(s,index-1,size);
    }
    @PostMapping("/shop/verify")
    public Message verifyShop(@RequestBody ShopVerify verify,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
       Shop shop = new Shop();
       shop.setMainId(s);
       verify.setShop(shop);
       return shopService.verifyShop(verify);
    }
    @GetMapping("/shop/verify/info")
    public Message verifyInfo(HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return shopService.verifyInfo(s);
    }
}
