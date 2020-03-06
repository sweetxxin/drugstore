package com.xxin.drugstore.order.service;

import com.xxin.drugstore.common.entity.Shop;

import com.xxin.drugstore.common.pojo.StatisticItem;
import com.xxin.drugstore.order.repository.AssessmentRepository;
import com.xxin.drugstore.order.repository.OrderRepository;
import org.apache.el.stream.Stream;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/25 17:20
 * @Description
 */
@Service
public class StatisticService {
    @Autowired
    private OrderRepository orderRepository;
    @Autowired
    private AssessmentRepository assessmentRepository;

    public List<StatisticItem> countSaleEachYear(String shopId){
        Shop shop = new Shop();
        shop.setMainId(shopId);
        return orderRepository.countSaleEachYear(shop);
    }
    public List<StatisticItem> countSaleByYear(Integer year,String shopId){
        Shop shop = new Shop();
        shop.setMainId(shopId);
        return orderRepository.countSaleByYear(year, shop);
    }
    public List<StatisticItem> countSaleByMonth(Integer year,Integer month,String shopId){
        Shop shop = new Shop();
        shop.setMainId(shopId);
        return orderRepository.countSaleByMonth(year,month, shop);
    }
    public List<StatisticItem> countSaleByDate(Integer year,Integer month,Integer day,String shopId){
        Shop shop = new Shop();
        shop.setMainId(shopId);
        return orderRepository.countSaleByDate(year,month,day,shop);
    }

    public HashMap<String,List<Integer>> getOrderDate(String shopId){
        Shop shop = new Shop();
        shop.setMainId(shopId);
        HashMap<String,List<Integer>> map = new HashMap<>();
        map.put("year", orderRepository.getYearOfOrder(shop));
        map.put("month", orderRepository.getMonthOfOrder(shop));
        map.put("day", orderRepository.getDayOfOrder(shop));
        return map;
    }
    public List<StatisticItem> getTopProduct(String shopId,Integer num){
        return orderRepository.getTopProduct(shopId, PageRequest.of(0,num , Sort.by("sumVal") ));
    }
    public List<StatisticItem> getTopProductAt(String shopId,Integer year,Integer num){
        return orderRepository.getTopProductAtYear(shopId,year, PageRequest.of(0,num , Sort.by("sumVal") ));
    }

    public List<StatisticItem> getTopProductAt(String shopId,Integer year,Integer month,Integer num){
        return orderRepository.getTopProductAtMonth(shopId,year,month, PageRequest.of(0,num , Sort.by("sumVal") ));
    }
    public List<StatisticItem> getTopProductAt(String shopId,Integer year,Integer month,Integer day,Integer num){
        return orderRepository.getTopProductAtDate(shopId,year,month,day, PageRequest.of(0,num , Sort.by("sumVal") ));
    }
    public List<StatisticItem> getAssessmentStatistic(String type,String shopId){
        Shop shop = new Shop();
        shop.setMainId(shopId);
        switch (type){
            case "service":return assessmentRepository.getServiceStatistic(shop);
            case "shop":return assessmentRepository.getShopStatistic(shop);
            case "delivery":return assessmentRepository.getDeliveryStatistic(shop);
            case "goods":return assessmentRepository.getGoodsStatistic(shop);
            default:return assessmentRepository.getServiceStatistic(shop);
        }
    }
    public List<StatisticItem> recentOrderStatistic(String shopId,Integer past){
        Shop shop = new Shop();
        shop.setMainId(shopId);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar c = Calendar.getInstance();
        c.add(Calendar.DATE, - past);
        Date time = c.getTime();
        return orderRepository.recentOrderStatistic(shop,time);
    }
    public List<StatisticItem> orderStatusStatistic(String shopId){
        Shop shop = new Shop();
        shop.setMainId(shopId);
        return orderRepository.orderStatusStatistic(shop);
    }
    public List<StatisticItem>orderAreaStatistic(String shopId){
        Shop shop = new Shop();
        shop.setMainId(shopId);
        return orderRepository.orderAreaStatistic(shop);
    }
    public List<StatisticItem> getAssessmentStatistic(String shopId){
        Shop shop = new Shop();
        shop.setMainId(shopId);
        List<StatisticItem> serviceStatistic = assessmentRepository.getServiceStatistic(shop);
        System.out.println();
        List<StatisticItem> goodsStatistic = assessmentRepository.getGoodsStatistic(shop);
        List<StatisticItem> deliveryStatistic = assessmentRepository.getDeliveryStatistic(shop);
        List<StatisticItem> shopStatistic = assessmentRepository.getShopStatistic(shop);

        List<StatisticItem> list = new ArrayList<>();
        StatisticItem item5 = new StatisticItem();
        item5.setName("5");
        item5.setCountVal(serviceStatistic.stream().filter(item -> item.getName().equals("5")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum()+deliveryStatistic.stream().filter(item -> item.getName().equals("5")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum()+shopStatistic.stream().filter(item -> item.getName().equals("5")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum()+goodsStatistic.stream().filter(item -> item.getName().equals("5")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum());

        StatisticItem item4= new StatisticItem();
        item4.setName("4");
        item4.setCountVal(serviceStatistic.stream().filter(item -> item.getName().equals("4")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum()+deliveryStatistic.stream().filter(item -> item.getName().equals("4")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum()+shopStatistic.stream().filter(item -> item.getName().equals("4")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum()+goodsStatistic.stream().filter(item -> item.getName().equals("4")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum());

        StatisticItem item3= new StatisticItem();
        item3.setName("3");
        item3.setCountVal(serviceStatistic.stream().filter(item -> item.getName().equals("3")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum()+deliveryStatistic.stream().filter(item -> item.getName().equals("3")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum()+shopStatistic.stream().filter(item -> item.getName().equals("3")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum()+goodsStatistic.stream().filter(item -> item.getName().equals("3")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum());

        StatisticItem item2= new StatisticItem();
        item2.setName("2");
        item2.setCountVal(serviceStatistic.stream().filter(item -> item.getName().equals("2")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum()+deliveryStatistic.stream().filter(item -> item.getName().equals("2")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum()+shopStatistic.stream().filter(item -> item.getName().equals("2")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum()+goodsStatistic.stream().filter(item -> item.getName().equals("2")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum());

        StatisticItem item1= new StatisticItem();
        item1.setName("1");
        item1.setCountVal(serviceStatistic.stream().filter(item -> item.getName().equals("1")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum()+deliveryStatistic.stream().filter(item -> item.getName().equals("1")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum()+shopStatistic.stream().filter(item -> item.getName().equals("1")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum()+goodsStatistic.stream().filter(item -> item.getName().equals("1")).collect(Collectors.toList()).stream().mapToLong((StatisticItem::getCountVal)).sum());

        list.add(item1);
        list.add(item2);
        list.add(item3);
        list.add(item4);
        list.add(item5);
        return list;
    }
}
