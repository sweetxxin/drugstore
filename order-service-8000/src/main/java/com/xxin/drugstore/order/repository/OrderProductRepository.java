package com.xxin.drugstore.order.repository;

import com.xxin.drugstore.common.entity.OrderProduct;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/14 1:04
 * @Description
 */
public interface OrderProductRepository extends JpaRepository<OrderProduct,String> {
    @Query(value = "select IFNULL(sum(amount),0) as stock from d_order_product  where shop_id = ?1 and sku_id = ?2",nativeQuery = true)
    int sumStockBySkuId(String shopId,String skuId);

    List<OrderProduct> getByOrderId(String id);
}
