package com.xxin.drugstore.order.repository;

import com.xxin.drugstore.common.entity.Product;
import com.xxin.drugstore.common.entity.Shop;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/1 14:24
 * @Description
 */
@Repository
public interface ProductRepository extends JpaRepository<Product,String> {
    @Query(value = "select concat(DATE_FORMAT(CURDATE(),'%Y%m%d'),right(10001+IFNULL(max(right(product_no,4)),0),4)) from d_product where mid(product_no,1,8)=DATE_FORMAT(CURDATE(),'%Y%m%d')",nativeQuery = true)
    String getNextProductNo();

    Page<Product> getProductByShopAndIsShowEquals(Shop shop, Integer status, Pageable pageable);

}
