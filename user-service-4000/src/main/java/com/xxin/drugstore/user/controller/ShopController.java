package com.xxin.drugstore.user.controller;

import com.xxin.drugstore.common.entity.ShopVerify;
import com.xxin.drugstore.common.entity.Shop;
import com.xxin.drugstore.common.entity.ShopDelivery;
import com.xxin.drugstore.common.entity.User;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.user.service.ShopService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/30 21:26
 * @Description
 */
@RestController
public class ShopController {
    @Autowired
    private ShopService shopService;
    @GetMapping("/shop/info/id/{id}")
    public Message  getShopInfoById(@PathVariable("id") String id){
        Message message = new Message();
        System.out.println("获取商店信息");
        message.setData(shopService.getShopInfo(id));
        message.setSuccess(true);
        return message;
    }
    @PostMapping("/shop/info/update")
    public Message updateShopInfo(@RequestBody Shop shop){
        Message message = new Message();
        message.setData(shopService.updateShopInfo(shop));
        message.setSuccess(true);
        return message;
    }

    @GetMapping("/shop/{id}/delivery")
    public Message getShopDelivery(@PathVariable("id")String id){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(shopService.getShopDelivery(id));
        return message;
    }

    @PostMapping("/shop/delivery/update")
    public Message updateShopInfo(@RequestBody ShopDelivery delivery){
        Message message = new Message();
        message.setData(shopService.updateShopDelivery(delivery));
        message.setSuccess(true);
        return message;
    }

    @GetMapping("/shop/delivery/{id}/del")
    public Message delShopDelivery(@PathVariable("id")Integer id){
        Message message = new Message();
        shopService.delShopDelivery(id);
        message.setSuccess(true);
        return message;
    }
    @PostMapping("/shop/customer")
    public Message getShopCustomer(@RequestParam("id") String id, @RequestParam("index") Integer index, @RequestParam("size") Integer size){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(shopService.getShopCustomer(index,size ,id));
        return message;
    }
    @PostMapping("/shop/info/keeper")
    public Message getShopByUser(@RequestParam("id") String id){
        Message message = new Message();
        User user = new User();
        user.setMainId(id);
        Shop u = shopService.getShopByUser(user);
        message.setSuccess(u!=null);
        message.setData(u);
        return message;
    }

    @PostMapping("/shop/verify")
    public Message verifyShop(@RequestBody ShopVerify verify){
        Message message = new Message();
        ShopVerify shopVerify = shopService.verifyShop(verify);
        message.setMessage("提交成功，等待认证");
        message.setSuccess(true);
        message.setData(shopVerify);
        return message;
    }
    @GetMapping("/shop/verify/info")
    public Message verifyInfo(@RequestParam("id")String id){
        Message message = new Message();
        message.setSuccess(true);
        Shop shop = new Shop();
        shop.setMainId(id);
        message.setData(shopService.verifyInfo(shop));
        return message;
    }
    @GetMapping("/shop/verify/{status}/info")
    public Message getVerifyingShop(@RequestParam("index")int index,@RequestParam("size")int size,@PathVariable("status")Integer status){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(shopService.getVerifyInfo(status,index-1,size));
        return message;
    }

    @PostMapping("/shop/verify/fail")
    public Message failVerify(@RequestBody ShopVerify shopVerify){
        Message message = new Message();
        message.setData(shopService.failVerify(shopVerify));
        message.setSuccess(true);
        return message;
    }
}
