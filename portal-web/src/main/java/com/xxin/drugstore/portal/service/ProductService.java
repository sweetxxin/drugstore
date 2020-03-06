package com.xxin.drugstore.portal.service;


import com.xxin.drugstore.common.entity.Product;
import com.xxin.drugstore.common.entity.Shop;
import com.xxin.drugstore.common.response.Message;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/13 14:22
 * @Description
 */
@FeignClient(value = "product-service")
public interface ProductService {
    //分类
    @GetMapping("/product/category/first")
    Message getFirstCategory();
    @GetMapping("/product/category/{id}/child")
    Message getCategoryByFirstId(@PathVariable("id") Integer id);
    //搜索产品
    @PostMapping("/product/search")
    Message searchProduct(@RequestBody(required = false) HashMap<String,Object> param,@RequestParam(value = "index",required = true) Integer index,@RequestParam(value = "size",required = true) Integer size);
    //广告产品
    @GetMapping("/product/hot")
    Message getHotProduct(@RequestParam("index") Integer index,@RequestParam("size") Integer size);
    @GetMapping("/product/new")
    Message getNewProduct(@RequestParam("index") Integer index,@RequestParam("size") Integer size);
    @GetMapping("/product/recommend")
    Message getRecommendProduct(@RequestParam("index") Integer index,@RequestParam("size") Integer size);

//
    @GetMapping("/product/list/{index}")
    Message getProduct(@PathVariable("index") Integer index);


    @GetMapping("/product/{id}/sku")
    Message getProductSku(@PathVariable("id") String id);
    @GetMapping("/product/{id}/img")
    Message getProductImg(@PathVariable("id")String id);

    @GetMapping("/factory/info/{id}")
    Message getFactoryInfoById(@PathVariable("id") String id);

}
