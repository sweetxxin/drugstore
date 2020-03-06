package com.xxin.drugstore.product.repository;

import com.xxin.drugstore.common.entity.Categories;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/27 14:07
 * @Description
 */
public interface CategoryRepository extends JpaRepository<Categories,Integer> {

    List<Categories> getByParentId(Integer id);
    List<Categories> getByParentIdAndCode(Integer id,Integer code);
    List<Categories> getByCode(Integer code);

    @Query(value = "select category.* from d_category_product p left join d_categories category on p.category_id = category.main_id where p.product_id=?1",nativeQuery = true)
    List<Categories> getCategoryByProductId(String id);

    Page<Categories> getByCode(int code, Pageable pageable);
}
