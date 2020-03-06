package com.xxin.drugstore.product.repository;

import com.xxin.drugstore.common.entity.Product;
import com.xxin.drugstore.common.entity.Shop;
import com.xxin.drugstore.common.pojo.StatisticItem;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/1 14:24
 * @Description
 */
@Repository
public interface ProductRepository extends JpaRepository<Product,String>, JpaSpecificationExecutor<Product> {
    @Query(value = "select concat(DATE_FORMAT(CURDATE(),'%Y%m%d'),right(10001+IFNULL(max(right(product_no,4)),0),4)) from d_product where mid(product_no,1,8)=DATE_FORMAT(CURDATE(),'%Y%m%d')",nativeQuery = true)
    String getNextProductNo();

    Page<Product> getProductByShopAndIsShowEquals(Shop shop, Integer status,Pageable pageable);

    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(b.name,count(a.productId),0) from Categories b left join CategoryProduct a on a.categoryId=b.mainId left join Product  c on c.mainId = a.productId and c.shop=?1 and c.isShow=1 where  b.mainId in(1,2,3,4,5) group by b.mainId")
    List<StatisticItem> getProductComposeByCategory(Shop shop);

    @Query("select new  com.xxin.drugstore.common.pojo.StatisticItem(b.name,count(a.productId),0) from CategoryProduct a left join Categories b on a.categoryId=b.mainId left join Product c on a.productId=c.mainId where b.code=1000 and c.isShow=1 and c.shop=?1 group by a.categoryId")
    List<StatisticItem> getProductComposeByBrand(Shop shop);
}
