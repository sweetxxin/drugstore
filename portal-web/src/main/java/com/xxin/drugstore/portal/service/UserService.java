package com.xxin.drugstore.portal.service;

import com.xxin.drugstore.common.entity.Address;
import com.xxin.drugstore.common.entity.Inform;
import com.xxin.drugstore.common.entity.User;
import com.xxin.drugstore.common.response.Message;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 14:17
 * @Description
 */
@FeignClient(value="user-service")
public interface UserService {

    @PostMapping("/user/address")
    Message getAddressByUserId(@RequestParam("id")String id);
    @PostMapping("/user/address/save")
    Message saveAddress(@RequestBody Address address);
    @PostMapping("/user/address/delete")
    Message deleteAddress(@RequestParam("id")String id);

    @GetMapping("/user/id/{id}")
    Message getUserInfoById(@PathVariable("id")String id);
    @PostMapping("/user/info/update")
    Message updateUserInfo(@RequestBody User user);
    @PostMapping("/user/info/verify")
    Message verifyInfo(@RequestParam("id")String id,@RequestParam("name")String name,@RequestParam("idNum")String idNum);

    @PostMapping("/user/inform")
    Message getUserInform(@RequestParam("index")Integer index,@RequestParam("size")Integer size,@RequestParam("userId")String userId);
    @PostMapping("/user/read/inform")
    Message readInform(@RequestBody Inform inform);
    @PostMapping("/user/inform/count")
    Message countNewInform(@RequestParam("userId")String userId);

    @PostMapping("/user/thumbUp")
    Message thumbUp(@RequestParam("userId")String uid,@RequestParam("itemId")String itemId);
    @PostMapping("/user/thumbUp/cancel")
    Message cancelThumbUp(@RequestParam("userId")String uid,@RequestParam("itemId")String itemId);

    @PostMapping("/user/assessment/against")
    Message against(@RequestParam("uid")String uid,@RequestParam("itemId")String itemId,@RequestParam("content")String content);

    @PostMapping("/user/assessment/reply")
    Message reply(@RequestParam("uid")String uid,@RequestParam("itemId")String itemId,@RequestParam("content")String content);
    @PostMapping("/user/assessment/{id}/reply")
    Message getReply(@PathVariable("id")String id);
}
