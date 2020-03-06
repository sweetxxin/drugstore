package com.xxin.drugstore.oauth.controller;

import com.xxin.drugstore.common.entity.User;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.common.util.EncryptUtil;
import com.xxin.drugstore.common.util.JwtHelper;
import com.xxin.drugstore.common.util.RedisUtil;
import com.xxin.drugstore.common.util.VerifyCodeUtil;
import com.xxin.drugstore.oauth.service.UserService;
import io.jsonwebtoken.Claims;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/25 21:39
 * @Description
 */
@RestController
@Slf4j
public class OauthController {
    @Value("${server.port}")
    public int port;
    @Resource
    private UserService userService;


    @RequestMapping(method = RequestMethod.GET,value = "/verifyCode",produces = MediaType.IMAGE_JPEG_VALUE)
    public byte[] verifyCode(HttpSession session){
        HashMap verifyImg = VerifyCodeUtil.getVerifyImg();
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        try {
            boolean write = ImageIO.write((BufferedImage) verifyImg.get("img"), "JPEG", out);
            session.setAttribute("verifyCode",verifyImg.get("code"));
        } catch (IOException e) {
            e.printStackTrace();
        }
        return out.toByteArray();
    }

    @PostMapping("/user/login")
    public Message userLogin(HttpSession session,@RequestParam("username")String username,@RequestParam("password")String password,@RequestParam("code")String code,HttpServletRequest request,HttpServletResponse response){
        System.out.println("用户登陆");
        return dealLogin(code, username, password,session , request,response ,"user" );
    }
    @PostMapping("/admin/login")
    public Message adminLogin(HttpSession session,@RequestParam("username")String username,@RequestParam("password")String password,HttpServletRequest request,HttpServletResponse response){
        System.out.println("管理员登陆");
        if (session.getAttribute("currentShop")!=null){
            Map m = (Map) session.getAttribute("currentUser");
            if (m!=null&&m.get("username").equals(username)&&m.get("password").equals(password)){
                System.out.println("已登录");
                Message message = new Message();
                message.setMessage("已登录");
                message.setData("/admin/page/index");
                return afterLoginSuccess(message,m , request,response ,session);
            }
        }
        return dealLogin(null,username,password,session,request,response,"admin");
    }
    @PostMapping("/register")
    public Message register(@RequestParam("username")String username,
                            @RequestParam("password")String password,
                            @RequestParam("verifyCode")String code,
                            @RequestParam("mobile")String mobile,
                            HttpSession session){
        Message message = new Message();
        if (null== session.getAttribute("verifyCode")){
            message.setMessage("验证码失效");
        }else if (!code.equals(session.getAttribute("verifyCode"))){
            message.setMessage("验证码错误");
        }else {
            User user = new User();
            user.setUsername(username);
            String salt = EncryptUtil.getRandomSalt();
            user.setSalt(salt);
            user.setType(0);
            user.setPassword(EncryptUtil.getSaltMd5AndSha(salt, password));
            user.setMobile(mobile);
            message = userService.saveUser(user);
        }
        return message;
    }
    @GetMapping("/user/logout")
    public ModelAndView logout(HttpSession session,@RequestParam("from")String from){
        session.removeAttribute("toPage");
        session.removeAttribute("token");

        if (session.getAttribute("currentAdmin")!=null&&from.equals("admin")){
            //1.后台登入并且退出
            session.removeAttribute("currentShop");
            session.removeAttribute("currentAdmin");
            return new ModelAndView("admin-login");
        }else if (session.getAttribute("currentAdmin")!=null&&from.equals("user")){
            //2.后台登入，从前台退出
        }else if (session.getAttribute("currentUser")!=null&&from.equals("admin")){
            //3.从前台登入，后台退出
        }else if(session.getAttribute("currentUser")!=null&&from.equals("user")){//4.从前台登入，从前台登出
            HashMap m = (HashMap) session.getAttribute("currentUser");
            if (Integer.valueOf(m.get("type").toString())==1){
                //是管理员
                session.removeAttribute("currentShop");
            }
            session.removeAttribute("currentUser");
        }
        if (from.equals("admin")){
            return new ModelAndView("admin-login");
        }
        return new ModelAndView("user-login");
    }


    @PostMapping("/oauth/token/fresh")
    public Message freshToken(HttpServletRequest request){
        String token = request.getHeader("token");
        Claims claims = JwtHelper.parseJWT(token);
        System.out.println(claims);
        return null;
    }

    private Message afterLoginSuccess(Message message, Map<String, Object> map, HttpServletRequest request, HttpServletResponse response, HttpSession session){
        message.setMessage("登陆成功");
        String token = JwtHelper.generateJWT(map.get("mainId").toString(), map.get("username").toString(),request.getHeader("User-Agent"));
        response.setHeader("token",token);
        session.setAttribute("token", token);
        message.setToken(token);
        return message;
    }
    private Message dealLogin(String code,String username,String password,HttpSession session,HttpServletRequest request,HttpServletResponse response,String type){
        Message message = new Message();
        String res = "";
        System.out.println("要去的地方是"+session.getAttribute("toPage"));
        if (type.equals("user")){
            message = checkVerifyCode(session,code);//1/检查验证码
            res = session.getAttribute("toPage")==null?"/web/page/index":session.getAttribute("toPage").toString();
            session.removeAttribute("toPage");
        }else {
            message.setSuccess(true);
            res= session.getAttribute("toPage")==null?"/admin/page/index":session.getAttribute("toPage").toString();
            session.removeAttribute("toPage");
        }
        if (message.isSuccess()){
            message = checkUserName(username);//2.检查用户名是否存在
            if (message.isSuccess()){
                Map<String,Object> map = (Map<String, Object>) message.getData();
                message = checkPassword(password,message);//3.检查密码是否正确
                if (message.isSuccess()){
                    if (type.equals("admin")&&Integer.valueOf(map.get("type").toString())==0){
                        message.setMessage("不是商家用户");
                        message.setSuccess(false);
                        return message;
                    }else if (type.equals("admin")&&Integer.valueOf(map.get("type").toString())==1){//药店管理员登陆后台
                        Message m = userService.getShopByUser(map.get("mainId").toString());
                        session.setAttribute("currentShop",m.getData());
                        session.setAttribute("currentAdmin",map);
                    }else if (type.equals("admin")&&Integer.valueOf(map.get("type").toString())==2){//系统管理员登陆后台
                        session.setAttribute("currentAdmin",map);
                    }else if (type.equals("user")&&Integer.valueOf(map.get("type").toString())==1){//药店管理登陆前台
                        Message m = userService.getShopByUser(map.get("mainId").toString());
                        session.setAttribute("currentUser",map);
                        session.setAttribute("currentShop",m.getData());
                    } else {
                        session.setAttribute("currentUser",map);
                    }
                    message = afterLoginSuccess(message,map,request,response,session);
                    message.setData(res);
                }
            }
        }
        return message;
    }
    private Message checkVerifyCode(HttpSession session,String code){
        Message message = new Message();
        if (session.getAttribute("verifyCode")==null){
            message.setMessage("验证码失效");
        }else if (code==null||code.equals("")||!code.equals(session.getAttribute("verifyCode"))){
            message.setMessage("验证码错误");
        }else {
            message.setSuccess(true);
        }
        return message;
    }
    private Message checkUserName(String username){
        Message message = userService.getUserInfoByUsername(username);
        if (message.getData()==null){
            message.setSuccess(false);
            message.setMessage("用户名不存在");
        }
        return message;
    }
    private Message checkPassword(String password,Message message){
        Map<String,String> map = (Map) message.getData();
        if (!EncryptUtil.getSaltVerifyMd5AndSha(password, map.get("password"),map.get("salt"))){
            message.setSuccess(false);
            message.setMessage("密码错误");
            message.setData(null);
        }
        return message;
    }
}
