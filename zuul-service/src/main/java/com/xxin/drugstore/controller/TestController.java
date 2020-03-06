package com.xxin.drugstore.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.util.regex.Pattern;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/26 16:42
 * @Description
 */
@RestController
public class TestController {
    @GetMapping("/test")
    public String test(HttpSession session){
        return "我是zuul，我的ID是："+session.getId();
    }

    public static void main(String[] args) {

        String content = "/page/a/b/c";
        String custom = "/page/a";
        String pattern = getPatternStr(custom);
        boolean isMatch = Pattern.matches(pattern, content);
        System.out.println(isMatch);

    }
    private static String getPatternStr(String url){
        url = url.replace("/**","/.*");
        url = url.replace("/*","/.?" );
        return url;
    }
}
