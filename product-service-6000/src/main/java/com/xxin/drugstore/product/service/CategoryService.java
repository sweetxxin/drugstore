package com.xxin.drugstore.product.service;

import com.xxin.drugstore.common.entity.Categories;
import com.xxin.drugstore.common.entity.CategoryProduct;
import com.xxin.drugstore.common.enums.CategoryType;
import com.xxin.drugstore.common.util.JsonUtil;
import com.xxin.drugstore.common.util.RedisUtil;
import com.xxin.drugstore.product.repository.CategoryProductRepository;
import com.xxin.drugstore.product.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/27 14:08
 * @Description
 */
@Service
public class CategoryService {
    @Autowired
    private CategoryRepository categoryRepository;
    @Autowired
    private CategoryProductRepository categoryProductRepository;
    @Resource
    private RedisUtil redisUtil;

    public HashMap<String, List<Categories>> getFirstCategory(){
        HashMap<String,List<Categories>> map =  new HashMap<>();
        List<Categories> forms = categoryRepository.getByCode(CategoryType.DRUG_FORM.getCode());
        List<Categories> material = categoryRepository.getByCode(CategoryType.MAIN_MATERIAL.getCode());
        map.put("form",forms);
        map.put("material", material);
        map.put("category", categoryRepository.getByParentIdAndCode(null,1));
        return map;
    }
    //根据第一级菜单ID,获取全部子菜单
    public HashMap<String, List<Categories>> getAllCategoryByFirstId(Integer id){
        HashMap<String,List<Categories>> map =  new HashMap<>();
        List<Categories> brand = new ArrayList<>();
        List<Categories> categories = categoryRepository.getByParentId(id);
        brand =  categoryRepository.getByParentIdAndCode(id,CategoryType.BRAND_NAME.getCode());
        System.out.println("品牌"+brand);
        for (Categories c : categories) {
            if (c.getName().equals("热门品牌")){
                brand.addAll(categoryRepository.getByParentIdAndCode(c.getMainId(), CategoryType.BRAND_NAME.getCode()));
                System.out.println("品牌"+brand);
            }else{
                List<Categories> categoriesList = categoryRepository.getByParentIdAndCode(c.getMainId(),CategoryType.THIRD_CATEGORY.getCode());
                List<Categories> useCategories = categoryRepository.getByParentIdAndCode(c.getMainId(),CategoryType.USE_WAY.getCode());
                map.put(c.getMainId()+"-use",useCategories);
                map.put(c.getMainId()+"", categoriesList);
            }
        }
        map.put("brand",brand);
        map.put("self", categories);
        return map;
    }
    public List<Categories> getCategoryByProduct(String id){
        System.out.println(id+"->查找分类");
        return categoryRepository.getCategoryByProductId(id);
    }
    public Page<Categories> getCategoryList(int index,int size,int type){
        Page<Categories> categories = categoryRepository.getByCode(type, PageRequest.of(index, size, Sort.by("code")));
        for (Categories category : categories) {
            if (category.getParentId()!=null){
                System.out.println("查找父类"+categoryRepository.getOne(category.getParentId()));
                category.setParent((categoryRepository.getOne(category.getParentId())));
            }
        }
        return categories;
    }
    public Categories addCategory(Categories categories){
        int code = categories.getCode();
        categories.setType(CategoryType.getCategoryType(code).getMessage());
        categories.setIsDisplay(1);
        Categories save = categoryRepository.save(categories);
        redisUtil.set("updateCategory", "1");
        return save;
    }
    public void delCategory(Categories categories){
        redisUtil.set("updateCategory", "1");
        categoryRepository.delete(categories);
    }
}
