package com.xxin.drugstore.admin.controller;


import com.xxin.drugstore.admin.service.UserService;
import com.xxin.drugstore.admin.util.LoginUtil;
import com.xxin.drugstore.common.entity.Inform;
import com.xxin.drugstore.common.entity.User;
import com.xxin.drugstore.common.response.Message;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/20 21:34
 * @Description
 */
@RestController
public class UserController {
    @Resource
    private UserService userService;

    @GetMapping("/keeper/info")
    public Message getUserInfo(HttpSession session){
        String s = LoginUtil.checkLogin(session);
        if (s==null){
            return new Message();
        }
        return userService.getUserInfoByUserId(s);
    }

    @PostMapping("/keeper/info/update")
    public Message updateUserInfo(@RequestBody User user,HttpSession session){
        Message message =userService.updateUserInfo(user);
        if (message.isSuccess()){
           session.setAttribute("currentUser",message.getData());
        }
        return message;
    }

    @GetMapping("/user/inform")
    public Message getUserInform(@RequestParam("index")Integer index,@RequestParam("size")Integer size,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return userService.getUserInform(index-1, size,s);
    }
    @GetMapping("/user/inform/new")
    public Message getNewInform(@RequestParam("index")Integer index,@RequestParam("size")Integer size,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return userService.getNewInform(index-1, size,s);
    }
    @GetMapping("/user/inform/read")
    public Message getReadInform(@RequestParam("index")Integer index,@RequestParam("size")Integer size,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return userService.getReadInform(index-1, size,s);
    }
    @PostMapping("/user/read/inform")
    public Message readInform(@RequestBody Inform inform){
        return userService.readInform(inform);
    }

    @GetMapping("/user/inform/count")
    public Message countNewInform(HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return userService.countNewInform(s);
    }
}
