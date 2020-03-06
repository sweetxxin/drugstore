package com.xxin.drugstore.product.controller;

import com.xxin.drugstore.common.entity.Categories;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.product.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/27 16:05
 * @Description
 */
@RestController
public class CategoryController {
    @Autowired
    private CategoryService categoryService;

    @GetMapping("/product/category/first")
    public Message getFirstCategory(){
        Message message = new Message();
        message.setSuccess(true);
        message.setData( categoryService.getFirstCategory());
        return message;
    }

    @GetMapping("/product/category/{id}/child")
    public Message getCategoryByFirstId(@PathVariable("id")Integer id){
        Message message = new Message();
        message.setSuccess(true);
        message.setData( categoryService.getAllCategoryByFirstId(id));
        return message;
    }

    @PostMapping("/product/category")
    public Message getCategoryByProduct(@RequestParam("id") String id){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(categoryService.getCategoryByProduct(id));
        return message;
    }
    @GetMapping("/category/{type}/list")
    public Message getCategoryList(@RequestParam("index")int index,@RequestParam("size")int size,@PathVariable("type")int type){
        Message message = new Message();
        message.setData(categoryService.getCategoryList(index-1, size,type));
        message.setSuccess(true);
        return message;
    }
    @PostMapping("/category/add")
    public Message addCategory(@RequestBody Categories categories){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(categoryService.addCategory(categories));
        System.out.println(categories);
        return message;
    }
    @PostMapping("/category/del")
    public Message delCategory(@RequestBody Categories categories){
        Message message = new Message();
        message.setSuccess(true);
        categoryService.delCategory(categories);
        return message;
    }
}
