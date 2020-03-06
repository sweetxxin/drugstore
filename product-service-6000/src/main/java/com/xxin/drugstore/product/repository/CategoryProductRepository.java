package com.xxin.drugstore.product.repository;

import com.xxin.drugstore.common.entity.Categories;
import com.xxin.drugstore.common.entity.CategoryProduct;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/5 21:11
 * @Description
 */
public interface CategoryProductRepository extends JpaRepository<CategoryProduct,String> {
    CategoryProduct getByProductIdAndCategoryId(String pid,Integer cid);
    void deleteByProductId(String id);


}
