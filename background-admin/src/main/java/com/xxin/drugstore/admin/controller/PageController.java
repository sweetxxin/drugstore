package com.xxin.drugstore.admin.controller;

import com.xxin.drugstore.admin.service.OrderService;
import com.xxin.drugstore.admin.service.ProductService;
import com.xxin.drugstore.admin.util.LoginUtil;
import com.xxin.drugstore.common.entity.Order;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.common.util.JsonUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/9 14:48
 * @Description
 */
@Controller
public class PageController {
    @Resource
    private OrderService orderService;
    @Resource
    private ProductService productService;


    @GetMapping("/page/{p}")
    public String page(@PathVariable(value = "p",required = false)String p,Model model,HttpSession session){
        HashMap map =  LoginUtil.getUserInfo(session);
        if (map!=null){
            model.addAttribute("userInfo",map);
        }
        if (p.equals("index")){
            if (map!=null){
                if (Integer.valueOf(map.get("type").toString())==2){
                    System.out.println("系统管理员登陆");
                    return "rotation-setting";
                }
            }
            return "product-on";
        }
        return p;
    }
    @GetMapping("/page/product/{id}/detail")
    public String productDetail(@PathVariable("id")String id,Model model,HttpSession session){
        HashMap map =  LoginUtil.getUserInfo(session);
        if (map!=null){
            model.addAttribute("userInfo",map);
        }
        Message skuMsg = productService.getProductSku(id);
        Message imgMsg = productService.getProductImg(id);
        Message categoryMsg = productService.getCategoryByProduct(id);
        System.out.println(skuMsg.getData());
        System.out.println(imgMsg.getData());
        System.out.println(categoryMsg.getData());
        if (((List)skuMsg.getData()).size()>0)
        model.addAttribute("skuJson", JsonUtil.objectToJson(skuMsg.getData()));
        model.addAttribute("imgList", (List)imgMsg.getData());
        model.addAttribute("imgListJson",JsonUtil.objectToJson((List)imgMsg.getData()));
        model.addAttribute("categoryJson",JsonUtil.objectToJson((List)categoryMsg.getData()));
        return "product-details";
    }

    @GetMapping("/page/order/detail")
    public String orderDetail(@RequestParam("id")String id,Model model,HttpSession session){
        HashMap map =  LoginUtil.getUserInfo(session);
        if (map!=null){
            model.addAttribute("userInfo",map);
        }
        Message orderDetail = orderService.getOrderDetail(id);
        Map order = (Map) orderDetail.getData();
        model.addAttribute("delivery",order.get("delivery"));
        model.addAttribute("product", order.get("orderProduct"));
        model.addAttribute("order",order);
        Order o = new Order();
        o.setMainId(order.get("mainId").toString());
        Message m = orderService.getAssessmentByOrder(o);
        System.out.println(m);
        model.addAttribute("assessment",m.getData());
        return "orderDetail";
    }
}
