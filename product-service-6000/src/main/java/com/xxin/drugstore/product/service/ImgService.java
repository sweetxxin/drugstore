package com.xxin.drugstore.product.service;

import com.xxin.drugstore.common.entity.Img;
import com.xxin.drugstore.product.repository.ImgRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/13 22:08
 * @Description
 */
@Service
public class ImgService {
    @Autowired
    private ImgRepository imgRepository;

    public List<Img> getProductImg(String id){
        return imgRepository.getByItemIdOrderByIsDefaultDesc(id);
    }
}
