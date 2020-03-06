package com.xxin.drugstore.portal.controller;

import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.portal.service.UserService;
import com.xxin.drugstore.portal.util.LoginUtil;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/21 13:39
 * @Description
 */
@RestController
public class UserEventController {
    @Resource
    private UserService userService;

    @PostMapping("/user/thumbUp")
    public Message thumbUp(@RequestParam("itemId") String itemId, HttpSession session){
        String u = LoginUtil.checkLogin(session);
        if (u==null){
            return LoginUtil.noLoginMsg();
        }
        return userService.thumbUp(u, itemId);
    }

    @PostMapping("/user/thumbUp/cancel")
    public Message cancelThumbUp(@RequestParam("itemId") String itemId,HttpSession session){
        String u = LoginUtil.checkLogin(session);
        if (u==null){
            return LoginUtil.noLoginMsg();
        }
        return userService.cancelThumbUp(u, itemId);
    }

    @PostMapping("/assessment/against")
    public Message againstAssessment(String id,String content,HttpSession session){
        String u = LoginUtil.checkLogin(session);
        if (u==null){
          return LoginUtil.noLoginMsg();
        }
        return userService.against(u,id ,content);
    }
    @PostMapping("/assessment/reply")
    public Message replyAssessment(String id,String content,HttpSession session){
        System.out.println(id+" "+content);
        String u = LoginUtil.checkLogin(session);
        if (u==null){
            return LoginUtil.noLoginMsg();
        }
        return userService.reply(u,id ,content);
    }
    @PostMapping("/assessment/{id}/reply")
    public Message getReply(@PathVariable("id")String id){
        return userService.getReply(id);
    }
}
