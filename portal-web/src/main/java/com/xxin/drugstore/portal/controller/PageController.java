package com.xxin.drugstore.portal.controller;

import com.xxin.drugstore.common.entity.*;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.common.util.JsonUtil;
import com.xxin.drugstore.common.util.RedisUtil;
import com.xxin.drugstore.portal.service.OrderService;
import com.xxin.drugstore.portal.service.ProductService;
import com.xxin.drugstore.portal.util.LoginUtil;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/25 22:08
 * @Description
 */
@Controller
public class PageController {
    @Resource
    private ProductService productService;
    @Resource
    private OrderService orderService;
    @Resource
    private RedisUtil redisUtil;

    @GetMapping("/page/{p}")
    public String page(@PathVariable(value = "p",required = false)String p, HttpSession session, Model model, HttpServletResponse response){
        HashMap map =  LoginUtil.getUserInfo(session);
        if (map!=null){
            model.addAttribute("status",map);
        }
        if (p.equals("index")){
            return "index";
        }
        return p;
    }

    @GetMapping("/page/product/detail")
    public String productDetail(@RequestParam("id")String id,Model model,HttpSession session){
        HashMap map =  LoginUtil.getUserInfo(session);
        if (map!=null){
            model.addAttribute("status",map);
        }
        Message hotProduct = productService.getHotProduct(0, 5);
        Map  products = (Map) hotProduct.getData();
        model.addAttribute("hotProduct",products.get("content"));
        model.addAttribute("imgList", (List) productService.getProductImg(id).getData());
        List productImg = (List) productService.getProductImg(id).getData();
        System.out.println(productImg);
        return "detail";
    }
    @GetMapping("/page/order/detail")
    public String orderDetail(@RequestParam("id")String id,Model model,HttpSession session){
        HashMap map =  LoginUtil.getUserInfo(session);
        if (map!=null){
            model.addAttribute("status",map);
        }
        Message orderDetail = orderService.getOrderDetail(id);
        Map order = (Map) orderDetail.getData();
        model.addAttribute("delivery",order.get("delivery"));
        model.addAttribute("product", order.get("orderProduct"));
        model.addAttribute("order",order);
        model.addAttribute("orderJson", JsonUtil.objectToJson(order));
        Order o = new Order();
        o.setMainId(id);
        model.addAttribute("assessment",orderService.getAssessmentByOrder(o).getData());
        return "order_detail";
    }
    @RequestMapping(value={"/product/list/{first}/{second}/{third}","/product/list/{first}/{second}","/product/list/{first}","/product/list"})
    public String list(HttpSession session, Model model,@PathVariable(value = "first",required = false)Integer first,@PathVariable(value = "second",required = false)Integer second,@PathVariable(value = "third",required = false)Integer third,@RequestParam(value = "keyword",required = false)String keyword){
        HashMap mp =  LoginUtil.getUserInfo(session);
        if (mp!=null){
            model.addAttribute("status",mp);
        }
        HashMap<String, List<LinkedHashMap<String,Object>>> map = getFirstCategory();
        List<HashMap<String,String>> title = new ArrayList<>();
        HashMap m = new HashMap();
        m.put("name","全部商品");
        m.put("url","/web/product/list");
        title.add(m);
        HashMap param = new HashMap();
        if (first!=null){
            ArrayList list = new ArrayList();
            model.addAttribute("firstSelected", first);
            List<LinkedHashMap<String, Object>> category = map.get("category");
            for (LinkedHashMap<String, Object> c : category) {
                System.out.println(c);
                if (c.get("mainId").equals(first)){
                    HashMap hm = new HashMap();
                    hm.put("name", c.get("name").toString());
                    hm.put("url","/web/product/list/"+first);
                    title.add(hm);
                    break;
                }
            }
            list.add(first);
            if (second!=null){
                model.addAttribute("secondSelected", second);
                list.add(second);
                if (third!=null){
                    model.addAttribute("thirdSelected", third);
                    list.add(third);
                }
            }
            param.put("category", list);
        }
        if (keyword!=null){
            param.put("keyword",keyword);
        }
        Message message = productService.searchProduct(param, 0, 15);
        model.addAttribute("products",message.getData());
        model.addAttribute("productsJson",JsonUtil.objectToJson(message.getData()));
        model.addAttribute("keyword",keyword);
        model.addAttribute("titles",title);
        model.addAttribute("firstCategory",map.get("category"));
        model.addAttribute("forms",(List)map.get("form"));
        return "list";
    }

    private HashMap<String, List<LinkedHashMap<String,Object>>> getFirstCategory(){
        if (redisUtil.hasKey("updateCategory")){
            Message firstCategory = productService.getFirstCategory();
            HashMap<String, List<LinkedHashMap<String,Object>>> map = (HashMap<String, List<LinkedHashMap<String, Object>>>) firstCategory.getData();
            redisUtil.set("firstCategory", map);
            redisUtil.del("updateCategory");
            System.out.println("后台更新了分类信息");
            return map;
        }
        if (redisUtil.hasKey("firstCategory")) {
            System.out.println("已有缓存");
            return (HashMap<String, List<LinkedHashMap<String, Object>>>) redisUtil.get("firstCategory");
        }else {
            Message firstCategory = productService.getFirstCategory();
            HashMap<String, List<LinkedHashMap<String,Object>>> map = (HashMap<String, List<LinkedHashMap<String, Object>>>) firstCategory.getData();
            redisUtil.set("firstCategory", map);
            return map;
        }
    }
}
