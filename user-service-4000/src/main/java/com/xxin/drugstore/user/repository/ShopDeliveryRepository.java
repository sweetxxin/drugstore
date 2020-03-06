package com.xxin.drugstore.user.repository;

import com.xxin.drugstore.common.entity.Shop;
import com.xxin.drugstore.common.entity.ShopDelivery;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/26 22:03
 * @Description
 */
public interface ShopDeliveryRepository extends JpaRepository<ShopDelivery,Integer> {
    List<ShopDelivery> getByShopId(String id);
}
