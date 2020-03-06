package com.xxin.drugstore.portal.util;

import com.xxin.drugstore.common.response.Message;

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
        if (session.getAttribute("currentUser")!=null){
            return (HashMap) session.getAttribute("currentUser");
        }else if (session.getAttribute("currentAdmin")!=null){
            return (HashMap) session.getAttribute("currentAdmin");
        }
        return null;
    }
    public static  String checkLogin(HttpSession session){
        if (session.getAttribute("currentUser")!=null){
            HashMap user = (HashMap) session.getAttribute("currentUser");
            return user.get("mainId").toString();
        }else if (session.getAttribute("currentAdmin")!=null){
            HashMap user = (HashMap) session.getAttribute("currentAdmin");
            return user.get("mainId").toString();
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
