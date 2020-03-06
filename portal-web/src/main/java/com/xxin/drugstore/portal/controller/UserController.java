package com.xxin.drugstore.portal.controller;

import com.xxin.drugstore.common.entity.Address;
import com.xxin.drugstore.common.entity.Inform;
import com.xxin.drugstore.common.entity.User;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.portal.service.UserService;
import com.xxin.drugstore.portal.util.LoginUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 14:17
 * @Description
 */
@RestController
public class UserController {
    @Resource
    private UserService userService;

    @GetMapping("/user/address")
    public Message getAddressByUserId(HttpSession session){
        String u = LoginUtil.checkLogin(session);
        if (u==null){
            return new Message();
        }
        return userService.getAddressByUserId(u);
    }

    @PostMapping("/user/address/save")
    public Message saveAddress(@RequestBody Address address,HttpSession session){
        String u = LoginUtil.checkLogin(session);
        if (u==null){
            return new Message();
        }
        address.setUserId(u);
        System.out.println(address);
        return userService.saveAddress(address);
    }
    @GetMapping("/user/address/{id}/delete")
    public Message deleteAddress(@PathVariable("id") String id){
        return userService.deleteAddress(id);
    }


    @GetMapping("/user/info")
    public Message getUserInfo(HttpSession session){
        String u = LoginUtil.checkLogin(session);
        if (u==null){
            return new Message();
        }
        return userService.getUserInfoById(u);
    }

    @PostMapping("/user/info/update")
    public Message updateUserInfo(@RequestBody User user){
        return userService.updateUserInfo(user);
    }

    @GetMapping("/user/inform/{index}")
    public Message getUserInform(@PathVariable("index")Integer index,HttpSession session){
        String u = LoginUtil.checkLogin(session);
        if (u==null){
            return new Message();
        }
        return userService.getUserInform(index, 5,u);
    }
    @PostMapping("/user/inform/read")
    public Message readInform(@RequestBody Inform inform){
        return userService.readInform(inform);
    }

    @GetMapping("/user/inform/count")
    public Message countNewInform(HttpSession session){
        String u = LoginUtil.checkLogin(session);
        if (u==null){
            return new Message();
        }
        return userService.countNewInform(u);
    }
    @PostMapping("/user/info/verify")
    public Message verifyInfo(String name,String idNum,HttpSession session){
        String u = LoginUtil.checkLogin(session);
        if (u==null){
            return new Message();
        }
        return userService.verifyInfo(u,name,idNum);
    }

}
