package com.xxin.drugstore.user;

import com.xxin.drugstore.common.entity.Address;
import com.xxin.drugstore.common.entity.Shop;
import com.xxin.drugstore.user.service.AddressService;
import com.xxin.drugstore.user.service.ShopService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class UserServiceApplicationTests {
    @Autowired
    private ShopService shopService;
    @Autowired
    private AddressService addressService;

    @Test
    public void test(){
        Address address = new Address();
        address.setCity("");
        address.setCreateTime(null);
        addressService.saveAddress(address);
    }
}
