package com.xxin.drugstore.user.service;

import com.xxin.drugstore.common.entity.*;
import com.xxin.drugstore.user.repository.InformRepository;
import com.xxin.drugstore.user.repository.ShopDeliveryRepository;
import com.xxin.drugstore.user.repository.ShopRepository;
import com.xxin.drugstore.user.repository.ShopVerifyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/30 21:24
 * @Description
 */
@Service
public class ShopService {
    @Autowired
    private ShopRepository shopRepository;
    @Autowired
    private ShopDeliveryRepository deliveryRepository;
    @Autowired
    private ShopVerifyRepository shopVerifyRepository;
    @Autowired
    private InformRepository informRepository;

    public Shop getShopInfo(String id){
        return shopRepository.getByMainId(id);
    }
    public Shop updateShopInfo(Shop shop){
        return shopRepository.saveAndFlush(shop);
    }
    public Shop getShopByUser(User user){
        return shopRepository.getByKeeper(user);

    }
    public List<ShopDelivery> getShopDelivery(String id){
        return deliveryRepository.getByShopId(id);
    }
    @Transactional
    public ShopDelivery updateShopDelivery(ShopDelivery delivery){
        deliveryRepository.saveAndFlush(delivery);
        return delivery;
    }
    public void delShopDelivery(Integer id){
        deliveryRepository.deleteById(id);
    }
    public Page<User> getShopCustomer(Integer index,Integer size,String shopId){
        Shop shop = new Shop();
        shop.setMainId(shopId);
        return shopRepository.getShopCustomer(shop, PageRequest.of(index, size));
    }
    public ShopVerify verifyShop(ShopVerify verify){
        ShopVerify byShop = shopVerifyRepository.getByShop(verify.getShop());
        if (byShop!=null){
            return shopVerifyRepository.save(verify);
        }
        verify.setCode(0);
        verify.setStatus("待审核");
        return shopVerifyRepository.save(verify);
    }
    public ShopVerify verifyInfo(Shop shop){
        return shopVerifyRepository.getByShop(shop);
    }
    public Page<ShopVerify> getVerifyInfo(int code,int index,int size){
        return shopVerifyRepository.getByCode(code,PageRequest.of(index, size));
    }
    @Transactional
    public ShopVerify passVerify(ShopVerify shopVerify){
        shopVerify.setStatus("审核通过");
        shopVerify.setCode(1);
        shopVerify.setVerifyTime(new Date());
        Shop shop = shopVerify.getShop();
        shop.setIsVerify(1);
        Inform inform = new Inform();
        inform.setTitle("审核状态改变");
        inform.setOutline("审核通过");
        inform.setContent(shopVerify.getResult());
        inform.setUserId(shopVerify.getShop().getMainId());
        informRepository.save(inform);
        shopRepository.save(shop);
        return shopVerifyRepository.save(shopVerify);
    }
    @Transactional
    public ShopVerify failVerify(ShopVerify verify){
        verify.setCode(-1);
        verify.setStatus("不通过");
        Inform inform = new Inform();
        inform.setTitle("审核状态改变");
        inform.setOutline("审核不通过");
        inform.setContent(verify.getResult());
        inform.setUserId(verify.getShop().getMainId());
        informRepository.save(inform);
        return shopVerifyRepository.save(verify);
    }
}
