package com.xxin.drugstore.order.repository;

import com.xxin.drugstore.common.entity.Cart;
import com.xxin.drugstore.common.entity.Sku;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/7 15:08
 * @Description
 */
public interface CartRepository  extends JpaRepository<Cart,String> {
    long countByUserId(String uid);
    void deleteByUserId(String uid);
    void deleteByMainIdIn(List<String>ids);
    void deleteByUserIdAndSku(String uid,Sku sku);
    @Query(value = "delete a from d_cart a LEFT JOIN d_sku b on a.sku_id = b.main_id LEFT JOIN d_product c on b.product_id = c.main_id where c.is_show = 0 and a.user_id = :uid",nativeQuery = true)
    @Modifying
    void deleteOffCart(@Param("uid") String uid);
    Cart getByUserIdAndSku(String uid,Sku sku);
}
