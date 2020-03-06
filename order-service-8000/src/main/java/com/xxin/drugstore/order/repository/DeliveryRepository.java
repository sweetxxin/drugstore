package com.xxin.drugstore.order.repository;

import com.xxin.drugstore.common.entity.Delivery;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 16:55
 * @Description
 */
public interface DeliveryRepository extends JpaRepository<Delivery,String> {
    Delivery getByOrderId(String id);
}
