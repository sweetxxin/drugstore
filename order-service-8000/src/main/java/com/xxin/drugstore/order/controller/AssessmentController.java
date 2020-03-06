package com.xxin.drugstore.order.controller;

import com.xxin.drugstore.common.entity.Order;
import com.xxin.drugstore.common.entity.User;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.order.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/20 21:41
 * @Description
 */
@RestController
public class AssessmentController {
    @Autowired
    private CommentService commentService;

    @PostMapping("/assessment/product/{productId}")
    public Message getAssessmentByProduct(@PathVariable("productId")String productId, @RequestParam("index")Integer index,@RequestParam("size")Integer size,@RequestParam("id")String id){
        Message message = new Message();
        User user= new User();
        user.setMainId(id);
        message.setData(commentService.getAssessmentByProductId(productId,index ,size,user));
        message.setSuccess(true);
        return message;
    }
    @PostMapping("/assessment/user")
    public Message getAssessmentByUser(@RequestBody User user,@RequestParam("index")Integer index,@RequestParam("size")Integer size){
        Message message = new Message();
        message.setSuccess(true);
        System.out.println("这里可以");
        System.out.println(user);
        message.setData(commentService.getAssessmentByUser(user,index ,size));
        return message;
    }
    @PostMapping("/assessment/order")
    public Message getAssessmentByOrder(@RequestBody Order order){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(commentService.getAssessmentByOrder(order));
        return message;
    }
}
