package com.xxin.drugstore.order.service;

import com.xxin.drugstore.common.entity.*;
import com.xxin.drugstore.common.enums.OrderStatus;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.order.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 16:46
 * @Description
 */
@Service
public class OrderService {
    @Autowired
    private OrderRepository orderRepository;
    @Autowired
    private DeliveryRepository deliveryRepository;
    @Autowired
    private SkuRepository skuRepository;
    @Autowired
    private OrderProductRepository orderProductRepository;
    @Autowired
    private CartRepository cartRepository;
    @Autowired
    private InformRepository informRepository;
    @Autowired
    private UserRepository userRepository;

    @Transactional
    public Message createNewOrder(User user,Shop shop, Delivery delivery, double totalPrice, List<OrderProduct> products){
        Message message = new Message();
        User u = userRepository.getOne(user.getMainId());
        if (u.getIsVerify()==null||u.getIsVerify()!=1){
            message.setCode(-1);
            message.setMessage("请到个人中心进行实名认证再进行购买！！！");
            return message;
        }
        StringBuffer shortIn = new StringBuffer();
        for (OrderProduct product : products) {//1.检查库存情况
            int stock = orderProductRepository.sumStockBySkuId(shop.getMainId(),product.getSku().getMainId());
            System.out.println(product.getSku().getMainId()+"-剩余库存"+stock);
            if (stock<=0||stock<product.getAmount()){
                message.setMessage(product.getSku().getMainId()+":库存不足");
                return message;
            }
            Sku one = skuRepository.getOne(product.getSku().getMainId());
            product.setProductId(one.getProduct().getMainId());
            shortIn.append(one.getSkuName()+" X"+product.getAmount()+" ");
        }
        delivery.setStatus("待支付");//2.新建物流记录
        delivery = deliveryRepository.save(delivery);

        Order order = new Order();//3.新建订单记录
        order.setStatus("待支付");
        order.setCode(0);
        order.setType(1);
        order.setDelivery(delivery);
        order.setUser(user);
        order.setTotalPrice(totalPrice+delivery.getDeliveryFee());
        order.setOrderNo(orderRepository.getNextOrdertNo());
        order.setShop(shop);
        order.setShortIn(shortIn.toString());
        long currentTime = System.currentTimeMillis() ;
        currentTime +=60*2000;
        order.setPayDeadline(new Date(currentTime));

        order = orderRepository.save(order);
        delivery.setOrderId(order.getMainId());
        deliveryRepository.save(delivery);

        for (OrderProduct product : products) {//4.新建订单商品记录
            product.setOrderId(order.getMainId());
            product.setAmount(-product.getAmount());
            product.setShopId(shop.getMainId());
            orderProductRepository.save(product);
        }
            order.setOrderProduct(products);
            message.setMessage("订单待支付");
            message.setData(order);
            message.setSuccess(true);
            return message;
    }
    @Transactional
    public Message payOrder(Order order){
        System.out.println("支付订单");
        //1.更改物流信息状态
        Delivery delivery = order.getDelivery();
        delivery.setStatus("等待商家处理");
        delivery = deliveryRepository.save(delivery);
        //2.删除购物车相关记录
       List<OrderProduct>products = order.getOrderProduct();
        for (OrderProduct product : products) {
            cartRepository.deleteByUserIdAndSku(order.getUser().getMainId(),product.getSku());
        }
        //3.更改订单状态
        order.setStatus("等待商家处理");
        order.setDelivery(delivery);
        order.setCode(1);
        order.setPayTime(new Date());
        order = orderRepository.save(order);
        //4.通知商家有新订单
        Inform inform = new Inform();
        inform.setUserId(order.getShop().getMainId());
        inform.setTitle("您有新订单");
        inform.setOutline("新订单啦");
        inform.setCreator(order.getUser());
        informRepository.save(inform);
        inform = new Inform();
        inform.setUserId(order.getUser().getMainId());
        inform.setTitle("新订单创建成功");
        inform.setOutline("新订单啦");
        User user = new User();
        user.setMainId("0");
        inform.setCreator(user);
        informRepository.save(inform);

        Message message = new Message();
        message.setSuccess(true);
        message.setData(order);
        message.setMessage("支付成功");
        return message;
    }
    @Transactional
    public Order cancelOrder(String id){
        Order order = orderRepository.getOne(id);
        List<OrderProduct>products = orderProductRepository.getByOrderId(id);
        Delivery de = deliveryRepository.getByOrderId(order.getMainId());
        orderProductRepository.deleteAll(products);
        orderRepository.delete(order);
        deliveryRepository.delete(de);
//        order.setCode(-1);
//        order.setStatus("订单已取消");
//        order.setDeleteTime(new Date());
        return null;
    }
    public Page<Order> getOrderList(Integer index,Integer size,User user){
        //过滤无效订单
        return orderRepository.getOrderList(user.getMainId(),PageRequest.of(index, size, Sort.by("create_time").descending()));
    }
    public Order getOrderDetail(String id){
        Optional<Order> orderOpt = orderRepository.findById(id);
        if (orderOpt.isPresent()){
            Order order = orderOpt.get();
            List<OrderProduct> products =  orderProductRepository.getByOrderId(id);
            order.setOrderProduct(products);
            return order;
        }
        return null;
    }
    public Page<Order>getOrderByStatus(String shopId,Integer status,Integer index,Integer size){
        Order order = new Order();
        Shop shop = new Shop();
        shop.setMainId(shopId);
        shop.setIsDisplay(1);
        shop.setIsVerify(1);
        order.setShop(shop);
        order.setCode(status);
        order.setType(1);
        Example<Order> example = Example.of(order);
        return orderRepository.findAll(example, PageRequest.of(index, size,Sort.by("createTime").descending()));
    }

    @Transactional
    public Order updateOrderStatus(String id){
        Optional<Order> orderOpt = orderRepository.findById(id);
        if (orderOpt.isPresent()){
            Order order = orderOpt.get();
            int status = order.getCode()+1;
            order.setStatus(OrderStatus.getOrderStatus(status).getMessage());
            order.setCode(status);
            Inform inform = new Inform();
            inform.setTitle("订单状态更新");
            inform.setUserId(order.getUser().getMainId());
            inform.setCreator(order.getShop().getKeeper());
            informRepository.save(inform);
            return orderRepository.save(order);
        }
        return null;
    }


}
