package com.xxin.drugstore.user.service;

import com.xxin.drugstore.common.entity.Address;
import com.xxin.drugstore.user.repository.AddressRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 14:24
 * @Description
 */
@Service
public class AddressService {
    @Autowired
    private AddressRepository addressRepository;


    public List<Address> getAddressByUserId(String uid){
        return addressRepository.getAddressByUserId(uid);
    }

    @Transactional
    public Address saveAddress(Address address){
        if (address.getIsDefault()!=null&&address.getIsDefault()==1){
            addressRepository.resetDefaultAddress(address.getUserId());
        }
        addressRepository.save(address);
        return address;
    }
    @Transactional
    public void deleteAddress(String id){
        addressRepository.deleteById(id);
    }
}
