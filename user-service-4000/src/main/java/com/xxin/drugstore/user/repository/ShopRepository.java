package com.xxin.drugstore.user.repository;

import com.xxin.drugstore.common.entity.Shop;
import com.xxin.drugstore.common.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;


import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/30 21:23
 * @Description
 */
@Repository
public interface ShopRepository extends JpaRepository<Shop,String> {
    Shop getByMainId(String mainId);

    @Query("select distinct u from User u left join Order o on u = o.user where o.shop = ?1 and o.type=1")
    Page<User> getShopCustomer(Shop shop, Pageable pageable);

    Shop getByKeeper(User user);
}
