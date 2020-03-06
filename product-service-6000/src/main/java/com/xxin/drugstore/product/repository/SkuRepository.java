package com.xxin.drugstore.product.repository;

import com.xxin.drugstore.common.entity.Product;
import com.xxin.drugstore.common.entity.Sku;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;


import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/1 15:25
 * @Description
 */
@Repository
public interface SkuRepository extends JpaRepository<Sku,String> {
    @Query(value = "select concat(DATE_FORMAT(CURDATE(),'%Y%m%d'),right(10001+IFNULL(max(right(sku_no,4)),0),4)) from d_sku where mid(sku_no,1,8)=DATE_FORMAT(CURDATE(),'%Y%m%d')",nativeQuery = true)
    String getNextSkuNo();

    List<Sku> getSkuByProduct(Product product);

    Sku getSkuByProductAndIsDefault(Product product,Integer flag);

    @Query("select s from Sku s join Product p on s.product = p where s.skuName like %?1% or p.name like %?1% or p.description like %?1% or p.keywords like %?1% or p.productNo like %?1%")
    List<Sku> searchProductSku(String keyword);
}
