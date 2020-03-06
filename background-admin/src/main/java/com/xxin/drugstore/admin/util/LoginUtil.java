package com.xxin.drugstore.admin.util;

import com.xxin.drugstore.admin.service.UserService;
import com.xxin.drugstore.common.response.Message;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/28 17:15
 * @Description
 */
public class LoginUtil {

    public static HashMap getUserInfo(HttpSession session){
        if (session.getAttribute("currentAdmin")!=null){
            System.out.println("获取的是Admin");
            return (HashMap) session.getAttribute("currentAdmin");
        }else if (session.getAttribute("currentUser")!=null){
            System.out.println("获取的是User");
            System.out.println(session.getAttribute("currentUser"));
           return (HashMap) session.getAttribute("currentUser");
        }
        return null;
    }
    public static  String checkLogin(HttpSession session){
        if (session.getAttribute("currentAdmin")!=null){
            HashMap user = (HashMap) session.getAttribute("currentAdmin");
            return user.get("mainId").toString();
        }else if (session.getAttribute("currentUser")!=null){
            HashMap user = (HashMap) session.getAttribute("currentUser");
            return user.get("mainId").toString();
        }
       return null;
    }
   public static String getShopId(HttpSession session){
        if (session.getAttribute("currentUser")==null&&session.getAttribute("currentAdmin")==null){
            return null;
        }
        if (session.getAttribute("currentShop")!=null){
            HashMap currentShop = (HashMap)session.getAttribute("currentShop") ;
            return currentShop.get("mainId").toString();
        }
        return null;
   }
    public static Message noLoginMsg(){
        Message message = new Message();
        message.setCode(-1);
        message.setMessage("您还没登陆，请先登录");
        return message;
    }
}
