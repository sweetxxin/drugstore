package com.xxin.drugstore.admin.service;


import com.xxin.drugstore.common.entity.Order;
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
    /*产品信息管理 begin*/
    @PostMapping("/product/add")
    Message addNewProduct(@RequestBody HashMap map);
    @GetMapping("/product/{id}/add/{num}")
    Message addProductStock(@PathVariable("id") String id, @PathVariable("num") Integer num);
    @GetMapping("/product/{status}/shop/{shopId}")
    Message getProductByShopId(@PathVariable("status") String status, @PathVariable("shopId") String shopId, @RequestParam("index") int index, @RequestParam("size") int size);
    @GetMapping("/product/{id}/sku")
    Message getProductSku(@PathVariable("id")String id);
    @PostMapping("/product/search")
    Message searchProduct(@RequestBody(required = false) HashMap<String,Object> param,@RequestParam(value = "index",required = true) Integer index,@RequestParam(value = "size",required = true) Integer size);
    @PostMapping("/product/sku/search")
    Message searchProductSku(@RequestBody(required = false) HashMap<String,Object> param);
    @PostMapping("/product/sku/add")
    Message addSku(@RequestParam("skuId")String skuId,@RequestParam("num")Integer num,@RequestParam("uid")String uid,@RequestParam("shopId")String shopId);
    @GetMapping("/product/{id}/img")
    Message getProductImg(@PathVariable("id")String id);
    /*产品信息管理 end*/

    /*分类信息管理 begin */
    @GetMapping("/product/category/first")
    Message getFirstCategory();
    @GetMapping("/product/category/{id}/child")
    Message getCategoryByFirstId(@PathVariable("id")Integer id);
    @PostMapping("/product/category")
    Message getCategoryByProduct(@RequestParam("id")String id);
    /*分类信息管理 end */

    @GetMapping("/product/compose/{type}")
     Message getProductCompose(@RequestParam("id") String shopId, @PathVariable("type")String type);


    @PostMapping("/product/info/update")
    Message updateProductInfo(@RequestBody Product product);


}
