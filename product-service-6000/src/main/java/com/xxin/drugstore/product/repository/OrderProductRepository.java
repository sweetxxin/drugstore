package com.xxin.drugstore.product.repository;

import com.xxin.drugstore.common.entity.OrderProduct;
import com.xxin.drugstore.common.entity.Shop;
import com.xxin.drugstore.common.entity.Sku;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/15 22:12
 * @Description
 */
public interface OrderProductRepository extends JpaRepository<OrderProduct,String> {
    @Query(value = "select  count(*) from d_order_product where type= 1 and sku_id in(select d_sku.main_id from d_sku where product_id = ?1)",nativeQuery = true)
    long countSaleByProductId(String id);

    @Query(value = "select ifnull(sum(amount),0) from d_order_product  where shop_id = ?1 and sku_id = ?2",nativeQuery = true)
    int sumStock(String shopId, String skuId);
}
