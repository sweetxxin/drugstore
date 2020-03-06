package com.xxin.drugstore.user.repository;

import com.xxin.drugstore.common.entity.Shop;
import com.xxin.drugstore.common.entity.ShopVerify;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/29 15:02
 * @Description
 */
public interface ShopVerifyRepository extends JpaRepository<ShopVerify,String> {
    ShopVerify getByShop(Shop shop);
    Page<ShopVerify> getByCode(int code, Pageable pageable);
}
