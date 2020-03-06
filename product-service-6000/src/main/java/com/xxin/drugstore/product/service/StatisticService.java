package com.xxin.drugstore.product.service;

import com.xxin.drugstore.common.entity.Shop;
import com.xxin.drugstore.common.pojo.StatisticItem;
import com.xxin.drugstore.product.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/26 14:32
 * @Description
 */
@Service
public class StatisticService {
    @Autowired
    private ProductRepository productRepository;

    public List<StatisticItem> getProductComposeByCategory(String shopId){
        Shop shop = new Shop();
        shop.setMainId(shopId);
        return productRepository.getProductComposeByCategory(shop);
    }
    public List<StatisticItem> getProductComposeByBrand(String shopId){
        Shop shop = new Shop();
        shop.setMainId(shopId);
        return productRepository.getProductComposeByBrand(shop);
    }
}
