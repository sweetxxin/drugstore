package com.xxin.drugstore.order.service;


import com.xxin.drugstore.common.entity.Cart;
import com.xxin.drugstore.common.entity.Sku;
import com.xxin.drugstore.order.repository.CartRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/7 15:09
 * @Description
 */
@Service
public class CartService {
    @Autowired
    private CartRepository cartRepository;

    public long countCart(String id){
        return cartRepository.countByUserId(id);
    }

    public Page<Cart> getCartList(String uid,int index,int size){
        Cart cart = new Cart();
        cart.setUserId(uid);
        Example<Cart> example = Example.of(cart);
        return cartRepository.findAll(example, PageRequest.of(index, size, Sort.by("createTime").descending()));
    }
    @Transactional
    public boolean delCart(String id){
        cartRepository.deleteById(id);
        return true;
    }
    @Transactional
    public boolean delCartIn(List<String> ids){
        cartRepository.deleteByMainIdIn(ids);
        return true;
    }
    @Transactional
    public boolean clearCart(String uid){
        cartRepository.deleteByUserId(uid);
        return true;
    }
    @Transactional
    public boolean clearOffCart(String uid){
        cartRepository.deleteOffCart(uid);
        return true;
    }

    @Transactional
    public Cart addInCart(Cart cart){
        Cart c = cartRepository.getByUserIdAndSku(cart.getUserId(),cart.getSku());
        if (c!=null){
            c.setAmount(cart.getAmount());
            return cartRepository.save(c);
        }
        return cartRepository.save(cart);
    }
}
