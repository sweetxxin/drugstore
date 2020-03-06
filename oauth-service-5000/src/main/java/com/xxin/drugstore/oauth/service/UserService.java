package com.xxin.drugstore.oauth.service;

import com.xxin.drugstore.common.entity.User;
import com.xxin.drugstore.common.response.Message;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/27 17:35
 * @Description
 */
@FeignClient("user-service")
public interface UserService {

    @PostMapping("/user/save")
    public Message saveUser(@RequestBody User user);

    @GetMapping("/user/id/{id}")
    Message getUserInfoById(@PathVariable("id")String id);
    @GetMapping("/user/username/{name}")
    Message getUserInfoByUsername(@PathVariable("name")String name);

    @PostMapping("/shop/info/keeper")
    Message getShopByUser(@RequestParam("id") String id);
}
