package com.xxin.drugstore.product.repository;

import com.xxin.drugstore.common.entity.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 16:55
 * @Description
 */
public interface OrderRepository extends JpaRepository<Order,String> {
    @Query(value = "select concat(DATE_FORMAT(CURDATE(),'%Y%m%d'),right(10001+IFNULL(max(right(order_no,4)),0),4)) from d_order where mid(order_no,1,8)=DATE_FORMAT(CURDATE(),'%Y%m%d')",nativeQuery = true)
    String getNextOrdertNo();

    @Query(value = "select * from d_order where user_id = ?1 and code != -1",nativeQuery = true)
    Page<Order> getOrderList(String id, Pageable page);
}
