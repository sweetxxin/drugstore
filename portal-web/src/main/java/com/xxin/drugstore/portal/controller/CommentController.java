package com.xxin.drugstore.portal.controller;

import com.xxin.drugstore.common.entity.Order;
import com.xxin.drugstore.common.entity.User;
import com.xxin.drugstore.common.enums.OrderStatus;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.portal.service.OrderService;
import com.xxin.drugstore.portal.util.LoginUtil;
import org.aspectj.weaver.ast.Or;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/20 21:45
 * @Description
 */
@RestController
public class CommentController {
    @Resource
    private OrderService orderService;

    @PostMapping("/assessment/{productId}")
    public Message getAssessmentByProduct(@PathVariable("productId")String productId, @RequestParam("index")Integer index, @RequestParam("size")Integer size, HttpSession session){
        String s = LoginUtil.checkLogin(session);
        if (s==null){
            return orderService.getAssessmentByProduct(productId,index ,size,"");
        }
        return orderService.getAssessmentByProduct(productId,index ,size,s);
    }

    @PostMapping("/assessment/user")
    public Message getAssessmentByUser(@RequestParam("index")Integer index, @RequestParam("size")Integer size,HttpSession session){
        String s = LoginUtil.checkLogin(session);
        if (s==null){
            return new Message();
        }
        User user = new User();
        user.setMainId(s);
        return orderService.getAssessmentByUser(user,index ,size);
    }

}
