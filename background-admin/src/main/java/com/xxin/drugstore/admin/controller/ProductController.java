package com.xxin.drugstore.admin.controller;


import com.xxin.drugstore.admin.service.ProductService;
import com.xxin.drugstore.admin.util.LoginUtil;
import com.xxin.drugstore.common.entity.Product;
import com.xxin.drugstore.common.response.Message;
import org.hibernate.type.descriptor.sql.BasicBinder;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/20 15:38
 * @Description
 */
@RestController
public class ProductController {
    @Resource
    private ProductService productService;

    @GetMapping("/product/{status}/list")
    public Message getProductList(@PathVariable("status")String status,@RequestParam("index") int index, @RequestParam("size")int size, HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        return productService.getProductByShopId(status,s, index-1,size);
    }
    @PostMapping("/product/info/update")
    public Message updateProductInfo(@RequestBody Product product){
        System.out.println(product);
        return productService.updateProductInfo(product);
    }
    @GetMapping("/product/{id}/sku")
    public Message getProductSku(@PathVariable("id")String id){
        return productService.getProductSku(id);
    }

    @PostMapping("/product/search")
    public Message searchProduct(@RequestBody HashMap<String,Object> param, @RequestParam("index") Integer index, @RequestParam("size") Integer size){
        System.out.println(param);
        System.out.println(index+"===="+size);
//        return null;
        return productService.searchProduct(param,index-1 ,size);
    }
    @PostMapping("/product/sku/search")
    public Message searchProductSku(@RequestBody HashMap<String,Object> param,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        param.put("shopId",s);
        System.out.println(param);
        return productService.searchProductSku(param);
    }

    @GetMapping("/product/{id}/add/{num}")
    public Message addProductStock(@PathVariable("id")String id,@PathVariable("num")Integer num){
        return productService.addProductStock(id,num);
    }

    @PostMapping("/product/add")
    public Message addNewProduct(@RequestBody HashMap map,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        map.put("shopId",s);
        map.put("creatorId", LoginUtil.checkLogin(session));
        System.out.println(map);
        return productService.addNewProduct(map);
    }

    @PostMapping("/product/sku/add")
    public Message addSku(@RequestParam("skuId")String skuId,@RequestParam("num")Integer num,HttpSession session){
        String s = LoginUtil.getShopId(session);
        if (s==null){
            return new Message();
        }
        System.out.println(skuId+" "+num);
        return productService.addSku(skuId,num ,LoginUtil.checkLogin(session) ,s);
    }
}
