package com.xxin.drugstore.order.repository;

import com.xxin.drugstore.common.entity.Assessment;
import com.xxin.drugstore.common.entity.Order;
import com.xxin.drugstore.common.entity.Shop;
import com.xxin.drugstore.common.entity.User;
import com.xxin.drugstore.common.pojo.StatisticItem;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/11 14:53
 * @Description
 */
public interface AssessmentRepository extends JpaRepository<Assessment,String> {

    @Query(value = "select a.* from d_assessment a JOIN (select order_id from d_order_product where type = 1 and sku_id in (SELECT d_sku.main_id from d_sku where product_id = ?1))b on a.order_id = b.order_id where a.is_show=1",nativeQuery = true)
    Page<Assessment> getByProductId(String productId, Pageable pageable);

    @Query("select a from Assessment a where a.creator = ?1")
    Page<Assessment> getByCreator(User creator, Pageable pageable);

    Assessment getByOrder(Order order);

    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(a.deliveryStar,count(a.deliveryStar),0) from Assessment  a left join Order o on a.order=o where o.shop = ?1 group by a.deliveryStar")
    List<StatisticItem> getDeliveryStatistic(Shop shop);

    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(a.shopStar,count(a.shopStar),0) from Assessment  a left join Order o on a.order=o where o.shop = ?1 group by a.shopStar")
    List<StatisticItem> getShopStatistic(Shop shop);

    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(a.goodsStar,count(a.goodsStar),0) from Assessment  a left join Order o on a.order=o where o.shop = ?1 group by a.goodsStar")
    List<StatisticItem> getGoodsStatistic(Shop shop);
    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(a.serviceStar,count(a.serviceStar),0) from Assessment  a left join Order o on a.order=o where o.shop = ?1 group by a.serviceStar")
    List<StatisticItem> getServiceStatistic(Shop shop);
}
