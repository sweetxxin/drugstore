package com.xxin.drugstore.admin.controller;

import com.xxin.drugstore.admin.service.ProductService;
import com.xxin.drugstore.common.response.Message;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/27 16:10
 * @Description
 */
@RestController
public class CategoryController {
    @Resource
    private ProductService productService;

    @GetMapping("/product/category/first")
    public Message getFirstCategory(){
        return productService.getFirstCategory();
    }

    @GetMapping("/product/category/{id}/child")
    public Message getCategoryByFirstId(@PathVariable("id")Integer id){
        return productService.getCategoryByFirstId(id);
    }

}
