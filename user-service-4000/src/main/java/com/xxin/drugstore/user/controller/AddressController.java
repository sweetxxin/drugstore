package com.xxin.drugstore.user.controller;

import com.xxin.drugstore.common.entity.Address;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.user.service.AddressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 14:25
 * @Description
 */
@RestController
public class AddressController {
    @Autowired
    private AddressService addressService;

    @PostMapping("/user/address")
    public Message getAddressByUserId(@RequestParam("id")String id){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(addressService.getAddressByUserId(id));
        return message;
    }

    @PostMapping("/user/address/save")
    public Message saveAddress(@RequestBody Address address){
        Message message = new Message();
        message.setSuccess(true);
        message.setMessage("地址设置成功");
        System.out.println(address);
        message.setData(addressService.saveAddress(address));
        return message;
    }

    @PostMapping("/user/address/delete")
    public Message deleteAddress(@RequestParam("id")String id){
        Message message = new Message();
        message.setSuccess(true);
        message.setMessage("删除成功");
        addressService.deleteAddress(id);
        return message;
    }
}
