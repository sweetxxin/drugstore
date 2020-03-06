package com.xxin.drugstore.order.repository;

import com.xxin.drugstore.common.entity.Img;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/1 15:54
 * @Description
 */
@Repository
public interface ImgRepository extends JpaRepository<Img,String> {
    List<Img> getByItemIdOrderByIsDefaultDesc(String id);
    List<Img> getByItemId(String id);
}
