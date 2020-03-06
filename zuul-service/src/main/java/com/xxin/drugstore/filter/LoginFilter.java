package com.xxin.drugstore.filter;

import com.netflix.zuul.ZuulFilter;
import com.netflix.zuul.context.RequestContext;
import com.netflix.zuul.exception.ZuulException;
import com.xxin.drugstore.common.util.JwtHelper;
import com.xxin.drugstore.property.Filter;
import javafx.scene.shape.PathElement;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Pattern;

import static org.springframework.cloud.netflix.zuul.filters.support.FilterConstants.PRE_TYPE;
/**
 * @author xxin
 * @Created
 * @Date 2019/11/27 19:11
 * @Description
 */
@Component
public class LoginFilter extends ZuulFilter {
    @Autowired
    private Filter filter;
    @Autowired
    HttpServletRequest httpServletRequest;
    @Autowired
    HttpServletResponse httpServletResponse;


    /**
     * 过滤器类型，前置过滤器
     */
    @Override
    public String filterType() {
        return PRE_TYPE;
    }

    /**
     * 过滤器顺序，越小越先执行
     */
    @Override
    public int filterOrder() {
        return 4;
    }

    /**
     * 过滤器是否生效
     * 返回true代表需要权限校验，false代表不需要用户校验即可访问
     */
    @Override
    public boolean shouldFilter() {
        RequestContext requestContext = RequestContext.getCurrentContext();
        HttpServletRequest request = requestContext.getRequest();
        List<String> urls = filter.getInclude();
        List<String> ex = filter.getExclude();
        for (String s : ex) {
            if (Pattern.matches(getPatternStr(s),request.getRequestURI())){
                return false;
            }
        }
        for (String url : urls) {
            if (Pattern.matches(getPatternStr(url), request.getRequestURI())){
                System.out.println("拦截 include"+url);
                return true;
            }
        }
        return false;
    }
    /**
     * 业务逻辑
     * 只有上面返回true的时候，才会进入到该方法
     */
    @Override
    public Object run() throws ZuulException {
        RequestContext requestContext = RequestContext.getCurrentContext();
        HttpServletRequest request = requestContext.getRequest();
//        String token = request.getHeader("token");
//        if (token==null){
//            token = request.getParameter("token");
//        }
//        if (token==null&&request.getSession().getAttribute("token")!=null){
//            token = request.getSession().getAttribute("token").toString();
//        }
//        if (token!=null&&JwtHelper.validateLogin(token)!=null){
        if (request.getSession().getAttribute("currentUser")!=null||request.getSession().getAttribute("currentAdmin")!=null){
            requestContext.setSendZuulResponse(true);// 对该请求进行路由
            System.out.println("已经登陆");
            HashMap currentUser=null;
            if (request.getRequestURI().startsWith("/admin")){//要去后台管理
                if (request.getSession().getAttribute("currentAdmin")!=null){//优先选择admin信息
                    currentUser = (HashMap) request.getSession().getAttribute("currentAdmin");
                }else{
                    currentUser = (HashMap) request.getSession().getAttribute("currentUser");
                }
            }else{//要去前台
                if (request.getSession().getAttribute("currentUser")!=null){
                    currentUser = (HashMap) request.getSession().getAttribute("currentUser");//优先选择顾客信息
                }else{
                    currentUser = (HashMap) request.getSession().getAttribute("currentAdmin");
                }
            }
                System.out.println("当前登录用户信息"+currentUser);
                System.out.println(request.getRequestURI().startsWith("admin"));
                System.out.println(Integer.valueOf(currentUser.get("type").toString())==0);
            if (request.getRequestURI().startsWith("/admin")&&Integer.valueOf(currentUser.get("type").toString())==0){
                System.out.println("普通用户不能去后台");
                request.getSession().setAttribute("token",null);
                requestContext.setSendZuulResponse(false);
                try {
                    requestContext.getResponse().sendRedirect("/oauth/admin/login");
                }catch (Exception e){

                }
                return null;
            }
            requestContext.setResponseStatusCode(200);
            return requestContext;
        }else{
            request.getSession().setAttribute("token",null);
            requestContext.setSendZuulResponse(false);
            if (request.getRequestURI().contains("/page/")){
                System.out.println("设置要去的地方是"+request.getRequestURI());
                request.getSession().setAttribute("toPage",request.getRequestURI());
            }
            try {
                if (request.getRequestURI().startsWith("/admin")){
                    requestContext.getResponse().sendRedirect("/oauth/admin/login");
                }else {
                    requestContext.getResponse().sendRedirect("/oauth/user/login");
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            return null;
        }

    }
    private String getPatternStr(String url){
        url = url.replace("/**","/.*");
        url = url.replace("/*","/.?" );
        return url;
    }
}
