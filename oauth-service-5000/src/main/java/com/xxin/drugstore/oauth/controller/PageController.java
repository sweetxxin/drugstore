package com.xxin.drugstore.oauth.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/27 1:17
 * @Description
 */
@Controller
public class PageController {

    @GetMapping("/user/login")
    public String userLogin(HttpSession httpSession){
        System.out.println("Oauth模块-sessionID"+httpSession.getId());
        return "user-login";
    }
    @GetMapping("/user/register")
    public String userRegister(){
        return "user-register";
    }

    @GetMapping("/admin/login")
    public String adminLogin(HttpSession httpSession){
        System.out.println("Oauth模块-sessionID"+httpSession.getId());
        return "admin-login";
    }
    @GetMapping("/admin/register")
    public String adminRegister(HttpSession httpSession){
        System.out.println("Oauth模块-sessionID"+httpSession.getId());
        return "admin-register";
    }
}
