package com.xxin.drugstore.admin.service;

import com.xxin.drugstore.common.entity.ShopVerify;
import com.xxin.drugstore.common.entity.Inform;
import com.xxin.drugstore.common.entity.Shop;
import com.xxin.drugstore.common.entity.ShopDelivery;
import com.xxin.drugstore.common.entity.User;
import com.xxin.drugstore.common.response.Message;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;
/**
 * @author xxin
 * @Created
 * @Date 2019/11/16 15:51
 * @Description
 */
@FeignClient(value = "user-service")
public interface UserService {
    /**用户商店管理 begin*/
    @GetMapping("/shop/info/id/{id}")
    Message getShopInfoById(@PathVariable("id")String id);
    @PostMapping("/shop/info/update")
    Message updateShopInfo(@RequestBody Shop shop);
    @GetMapping("/shop/{id}/delivery")
    Message getShopDelivery(@PathVariable("id")String id);
    @PostMapping("/shop/delivery/update")
    Message updateShopDelivery(@RequestBody ShopDelivery delivery);
    @GetMapping("/shop/delivery/{id}/del")
    Message delShopDelivery(@PathVariable("id")Integer id);
    @PostMapping("/shop/register")
    Message registerShop(@RequestBody Shop shop);
    @GetMapping("/shop/{id}/user")
    Message getShopUser(@PathVariable("id") String id, @RequestParam("index") Integer index, @RequestParam("size") Integer size);
    @PostMapping("/shop/customer")
    Message getShopCustomer(@RequestParam("id") String id, @RequestParam("index") Integer index, @RequestParam("size") Integer size);
    @PostMapping("/shop/verify")
    Message verifyShop(@RequestBody ShopVerify verify);
    @GetMapping("/shop/verify/info")
    Message verifyInfo(@RequestParam("id")String id);
    @PostMapping("/shop/info/keeper")
    Message getShopByUser(@RequestParam("id") String id);
    /**用户商店管理 end*/

    /*用户信息管理 begin*/
    @GetMapping("/user/id/{uid}")
    Message getUserInfoByUserId(@PathVariable("uid") String uid);
    @PostMapping("/user/info/update")
    Message updateUserInfo(@RequestBody User user);
    /*用户信息管理 end*/

    @PostMapping("/user/inform")
    Message getUserInform(@RequestParam("index")Integer index,@RequestParam("size")Integer size,@RequestParam("userId")String userId);
    @PostMapping("/user/inform/new")
    Message getNewInform(@RequestParam("index")Integer index,@RequestParam("size")Integer size,@RequestParam("userId")String userId);
    @PostMapping("/user/inform/read")
    Message getReadInform(@RequestParam("index")Integer index,@RequestParam("size")Integer size,@RequestParam("userId")String userId);
    @PostMapping("/user/read/inform")
    Message readInform(@RequestBody Inform inform);
    @PostMapping("/user/inform/count")
    Message countNewInform(@RequestParam("userId")String userId);

}
