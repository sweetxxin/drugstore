package com.xxin.drugstore.portal.controller;



import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.portal.service.ProductService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
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

    @GetMapping("/product/hot")
    public Message getHotProduct(@RequestParam("index") Integer index,@RequestParam("size") Integer size){
        return productService.getHotProduct(index,size);
    }
    @GetMapping("/product/new")
    public Message getNewProduct(@RequestParam("index") Integer index, @RequestParam("size") Integer size){
        return productService.getNewProduct(index,size);
    }
    @GetMapping("/product/recommend")
    public Message getRecommendProduct(@RequestParam("index") Integer index,@RequestParam("size") Integer size){
        return productService.getRecommendProduct(index,size);
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
}
