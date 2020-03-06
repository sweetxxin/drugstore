package com.xxin.drugstore.user.controller;

import com.xxin.drugstore.common.entity.Inform;
import com.xxin.drugstore.common.entity.User;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.user.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/25 21:30
 * @Description
 */
@RestController
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping("/user/id/{id}")
    public Message getUserInfoById(@PathVariable("id")String id){
        Message message = new Message();
        message.setData(userService.getUserInfoById(id));
        message.setSuccess(true);
        return message;
    }
    @PostMapping("/user/info/update")
    public Message updateUserInfo(@RequestBody User user){
        Message message = new Message();
        message.setData(userService.updateUserInfo(user));
        message.setSuccess(true);
        return message;
    }
    @PostMapping("/user/info/verify")
    public Message verifyInfo(@RequestParam("id")String id,@RequestParam("name")String name,@RequestParam("idNum")String idNum){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(userService.verifyInfo(id,name,idNum));
        return message;
    }
    @GetMapping("/user/username/{name}")
    public Message getUserInfoByUserName(@PathVariable("name")String name){
        Message message = new Message();
        message.setData(userService.getUserInfoByUserName(name));
        message.setSuccess(true);
        return message;
    }
    @PostMapping("/user/save")
    public Message saveUser(@RequestBody User user){
        System.out.println("保存用户"+user);
        Message message = new Message();
        message.setSuccess(true);
        user = userService.createUser(user);
        if (user==null){
            message.setSuccess(false);
            message.setMessage("用户名已经存在");
        }else {
            message.setMessage("注册成功");
        }
        return message;
    }

    @PostMapping("/user/inform")
    public Message getUserInform(@RequestParam("index")Integer index,@RequestParam("size")Integer size,@RequestParam("userId")String userId){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(userService.getInform(index,size
                ,userId ));
        return message;
    }
    @PostMapping("/user/inform/new")
    public Message getNewInform(@RequestParam("index")Integer index,@RequestParam("size")Integer size,@RequestParam("userId")String userId){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(userService.getNewInform(index,size
                ,userId ));
        return message;
    }
    @PostMapping("/user/inform/read")
    public Message getOldInform(@RequestParam("index")Integer index,@RequestParam("size")Integer size,@RequestParam("userId")String userId){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(userService.getReadInform(index,size
                ,userId ));
        return message;
    }
    @PostMapping("/user/inform/count")
    public Message countNewInform(@RequestParam("userId")String userId){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(userService.countNewInform(userId));
        return message;
    }

    @PostMapping("/user/read/inform")
    public Message countInform(@RequestBody Inform inform){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(userService.readInform(inform));
        return message;
    }
}
