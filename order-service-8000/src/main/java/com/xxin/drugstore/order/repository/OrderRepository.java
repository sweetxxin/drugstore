package com.xxin.drugstore.order.repository;

import com.xxin.drugstore.common.entity.Order;
import com.xxin.drugstore.common.entity.Shop;

import com.xxin.drugstore.common.pojo.StatisticItem;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Date;
import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 16:55
 * @Description
 */
public interface OrderRepository extends JpaRepository<Order,String> {
    @Query(value = "select concat(DATE_FORMAT(CURDATE(),'%Y%m%d'),right(10001+IFNULL(max(right(order_no,4)),0),4)) from d_order where mid(order_no,1,8)=DATE_FORMAT(CURDATE(),'%Y%m%d')",nativeQuery = true)
    String getNextOrdertNo();

    @Query(value = "select * from d_order where user_id = ?1 and code != -1 and type=1",nativeQuery = true)
    Page<Order> getOrderList(String id, Pageable page);

    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(YEAR(o.createTime) ,count(o.orderNo), sum(o.totalPrice)) from Order o where o.type=1 and o.shop=?1 and o.code >4 group by YEAR(o.createTime)")
    List<StatisticItem> countSaleEachYear(Shop shop);

    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(MONTH(o.createTime) ,count(o.orderNo), sum(o.totalPrice)) from Order o where o.type=1 and year(o.createTime)=?1 and o.shop=?2 and o.code >4 group by MONTH(o.createTime)")
    List<StatisticItem> countSaleByYear(Integer year,Shop shop);

    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(DAY(o.createTime) ,count(o.orderNo), sum(o.totalPrice)) from Order o where o.type=1 and YEAR(o.createTime)=?1 AND  Month(o.createTime)=?2 and o.shop=?3 and o.code >4 group by MONTH(o.createTime)")
    List<StatisticItem> countSaleByMonth(Integer year,Integer month,Shop shop);
    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(DAY(o.createTime) ,count(o.orderNo), sum(o.totalPrice)) from Order o where o.type=1 and YEAR(o.createTime)=?1 AND  Month(o.createTime)=?2 and Day(o.createTime)=?3 and o.shop=?4 and o.code >4 group by MONTH(o.createTime)")
    List<StatisticItem> countSaleByDate(Integer year,Integer month,Integer day,Shop shop);

    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(p.name,count(p.mainId),sum(o.amount) as sumVal) from Product p join  OrderProduct  o on o.productId=p.mainId where o.type=1 and o.shopId=?1 group by o.productId")
    List<StatisticItem> getTopProduct(String id,Pageable pageable);

    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(p.name,count(p.mainId),sum(o.amount) as sumVal) from Product p join  OrderProduct  o on o.productId=p.mainId join Order ord on o.orderId=ord.mainId where o.type=1 and o.shopId=?1 and year(ord.createTime)=?2 group by o.productId")
    List<StatisticItem> getTopProductAtYear(String id,Integer year,Pageable pageable);
    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(p.name,count(p.mainId),sum(o.amount) as sumVal) from Product p join  OrderProduct  o on o.productId=p.mainId join Order ord on o.orderId=ord.mainId where o.type=1 and o.shopId=?1 and year(ord.createTime)=?2 and month(ord.createTime)=?3 group by o.productId")
    List<StatisticItem> getTopProductAtMonth(String id,Integer year,Integer month,Pageable pageable);
    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(p.name,count(p.mainId),sum(o.amount) as sumVal) from Product p join  OrderProduct  o on o.productId=p.mainId join Order ord on o.orderId=ord.mainId where o.type=1 and o.shopId=?1 and year(ord.createTime)=?2 and month(ord.createTime)=?3 and day(ord.createTime)=?4 group by o.productId")
    List<StatisticItem> getTopProductAtDate(String id,Integer year,Integer month,Integer day,Pageable pageable);

    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(Date(o.createTime),count(o.orderNo),sum(o.totalPrice)) from Order o where o.type=1 and o.shop=?1 and o.code>4 and ?2 <= o.createTime group by Date(o.createTime)")
    List<StatisticItem> recentOrderStatistic(Shop shop, Date date);

    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(o.status,count(o.mainId),0) from Order o where o.type=1 and o.shop=?1 group by o.status")
    List<StatisticItem> orderStatusStatistic(Shop shop);

    @Query("select new com.xxin.drugstore.common.pojo.StatisticItem(b.province,count(a.mainId),0)from Delivery a left join Address b on a.toAddress=b left  join Order c on c.mainId=a.orderId where c.shop = ?1 GROUP BY b.province")
    List<StatisticItem> orderAreaStatistic(Shop shop);


    @Query("select DISTINCT year(o.createTime) as y from Order o where o.type=1 and o.code>4 and o.shop = ?1 order by y desc ")
    List<Integer> getYearOfOrder(Shop shop);

    @Query("select DISTINCT month(o.createTime) as m  from Order o where o.type=1 and o.code>4 and o.shop = ?1 order by m desc")
    List<Integer> getMonthOfOrder(Shop shop);

    @Query("select DISTINCT day(o.createTime) as d from Order o where o.type=1 and o.code>4 and o.shop = ?1 order by d desc")
    List<Integer> getDayOfOrder(Shop shop);


}
