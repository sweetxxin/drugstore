package com.xxin.drugstore.product.controller;

import com.xxin.drugstore.common.entity.*;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.common.util.JsonUtil;
import com.xxin.drugstore.product.service.ImgService;
import com.xxin.drugstore.product.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/1 16:58
 * @Description
 */
@RestController
public class ProductController {
    @Autowired
    private ProductService productService;
    @Autowired
    private ImgService imgService;


    @PostMapping("/product/add")
    public Message addNewProduct(@RequestBody HashMap map){

        List<Sku> productSku =JsonUtil.jsonToList(map.get("productSku").toString(),Sku.class);
        Map productCategory = (Map) map.get("productCategory");
        Product product = JsonUtil.jsonToPojo(map.get("newProduct").toString(), Product.class);
        Factory factory = JsonUtil.jsonToPojo(map.get("factory").toString(),Factory.class);
        Map productImg = JsonUtil.jsonToPojo(map.get("productImg").toString(), Map.class);
        Collection<Map<String,Object>> imgs = productImg.values();
        List<String> symptom = (List<String>) map.get("symptom");

        System.out.println(symptom);
        System.out.println(factory);
        System.out.println(map.get("newProduct"));
        System.out.println(product);
        System.out.println(productCategory);
        System.out.println(productSku);
        System.out.println(imgs);

        productService.createProduct(product,factory , productSku, productCategory,symptom,imgs,map.get("shopId").toString(),map.get("creatorId").toString() );

        Message message = new Message();
        message.setSuccess(true);
        message.setMessage("保存成功");
        return message;
    }

    @GetMapping("/product/{status}/shop/{id}")
    public Message getProductByShop(@PathVariable("status")String status, @PathVariable("id")String id, @RequestParam("index")Integer index,@RequestParam("size")Integer size){
        Message message = new Message();
        Shop shop = new Shop();
        shop.setMainId(id);
        Page<Product> on = productService.getProductByShop(shop, status.equals("on") ? 1 : 0,  index, size,null);
        message.setData(on);
        message.setSuccess(true);
        return message;
    }

    @PostMapping("/product/info/update")
    public Message updateProductInfo(@RequestBody Product product){
        Message message = new Message();
        message.setData(productService.updateProductInfo(product));
        message.setSuccess(true);
        return message;
    }

    @GetMapping("/product/hot")
    public Message getHotProduct(@RequestParam("index") Integer index,@RequestParam("size") Integer size){
        Product product = new Product();
        product.setIsShow(1);
        product.setIsHot(1);
        Message message = new Message();
        message.setSuccess(true);
        message.setData(productService.getProduct(product, index, size));
        return message;
    }
    @GetMapping("/product/new")
    public Message getNewProduct(@RequestParam("index") Integer index,@RequestParam("size") Integer size){
        Product product = new Product();
        product.setIsShow(1);
        product.setIsNew(1);
        Message message = new Message();
        message.setSuccess(true);
        message.setData(productService.getProduct(product, index, size));
        return message;
    }
    @PostMapping("/product/search")
    public Message searchProduct(@RequestBody(required = false) HashMap<String,Object> param, @RequestParam(value = "index",required = true) Integer index, @RequestParam(value = "size",required = true) Integer size, HttpSession session){
        Message message = new Message();
        message.setData(productService.searchProduct(param,index ,size));
        message.setSuccess(true);
        System.out.println("sessionID"+session.getId());
        return message;
    }
    @GetMapping("/product/recommend")
    public Message getRecommendProduct(@RequestParam("index") Integer index,@RequestParam("size") Integer size){
        Product product = new Product();
        product.setIsShow(1);
        product.setIsCommend(1);
        Message message = new Message();
        message.setSuccess(true);
        message.setData(productService.getProduct(product, index, size));
        return message;
    }

    @GetMapping("/product/{id}/sku")
    public Message getProductSku(@PathVariable("id")String id){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(productService.getSkuByProductId(id));
        return message;
    }
    @GetMapping("/product/{id}/img")
    public Message getProductImg(@PathVariable("id")String id){
        Message message = new Message();
        message.setData(imgService.getProductImg(id));
        message.setSuccess(true);
        return message;
    }

    @PostMapping("/product/sku/search")
    public Message searchProductSku(@RequestBody HashMap<String,Object> param){
        System.out.println(param);
        Message message = new Message();
        message.setSuccess(true);
        message.setData(productService.searchProductSku(param));
       return message;
    }
    @PostMapping("/product/sku/add")
    public Message addSku(@RequestParam("skuId")String skuId,@RequestParam("num")Integer num,@RequestParam("uid")String uid,@RequestParam("shopId")String shopId){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(productService.addSku(skuId, uid, shopId, num));
        return message;
    }
}
