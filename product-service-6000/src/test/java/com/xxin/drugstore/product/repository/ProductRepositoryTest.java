package com.xxin.drugstore.product.repository;

import com.xxin.drugstore.common.entity.Product;
import com.xxin.drugstore.common.entity.Shop;
import com.xxin.drugstore.common.entity.Sku;
import com.xxin.drugstore.product.service.ProductService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.PageRequest;
import org.springframework.test.context.junit4.SpringRunner;

import javax.persistence.Table;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static org.junit.Assert.*;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/1 14:29
 * @Description
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class ProductRepositoryTest {
    @Autowired
    private ProductRepository productRepository;
    @Autowired
    private SkuRepository skuRepository;
    @Autowired
    private ProductService productService;

    @Test
    public void insert(){
        Product product = new Product();
        product.setName("云南白药");
        Shop shop = new Shop();
        shop.setMainId("402809816ebc8b51016ebc8b94e70000");
        product.setShop(shop);
        product.setProductNo(productRepository.getNextProductNo());
        product = productRepository.save(product);
        List<Sku> skus = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            Sku sku = new Sku();
            sku.setSkuNo(skuRepository.getNextSkuNo());
            sku.setSkuName("云南白药1"+i+"片装");
            sku.setProduct(product);
            skus.add(sku);
            skuRepository.save(sku);
        }


        productRepository.save(product);
    }

    @Test
    public void get(){
        Shop shop = new Shop();
        shop.setMainId("402809816ebc8b51016ebc8b94e70000");
        System.out.println(productService.getProductByShop(shop, 1, 0, 5, null).getContent());
    }

}