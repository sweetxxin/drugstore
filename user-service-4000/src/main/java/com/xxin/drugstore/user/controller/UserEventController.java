package com.xxin.drugstore.user.controller;

import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.user.service.UserEventService;
import com.xxin.drugstore.user.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/21 13:36
 * @Description
 */
@RestController
public class UserEventController {
    @Autowired
    private UserEventService eventService;

    @PostMapping("/user/thumbUp")
    public Message thumbUp(@RequestParam("userId")String uid,@RequestParam("itemId")String itemId){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(eventService.thumbUp(uid, itemId));
        return message;
    }

    @PostMapping("/user/thumbUp/cancel")
    public Message cancelThumbUp(@RequestParam("userId")String uid,@RequestParam("itemId")String itemId){
        Message message = new Message();
        message.setSuccess(true);
        eventService.cancelThumbUp(uid, itemId);
        return message;
    }
    @PostMapping("/user/assessment/against")
    public Message against(@RequestParam("uid")String uid,@RequestParam("itemId")String itemId,@RequestParam("content")String content){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(eventService.against(uid, itemId, content));
        return message;
    }
    @PostMapping("/user/assessment/reply")
    public Message reply(@RequestParam("uid")String uid,@RequestParam("itemId")String itemId,@RequestParam("content")String content){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(eventService.reply(uid, itemId, content));
        return message;
    }
    @PostMapping("/user/assessment/{id}/reply")
    public Message getReply(@PathVariable("id")String id){
        Message message = new Message();
        message.setData(eventService.getReply(id));
        message.setSuccess(true);
        return message;
    }
}
