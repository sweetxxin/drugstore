package com.xxin.drugstore.user.repository;

import com.xxin.drugstore.common.entity.User;
import com.xxin.drugstore.common.entity.UserEvent;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/21 13:30
 * @Description
 */
public interface UserEventRepository extends JpaRepository<UserEvent,String> {

    UserEvent getByItemIdAndUserAndType(String itemId, User uid, Integer type);
    List<UserEvent> getByItemIdAndTypeOrderByCreateTimeDesc(String itemId,Integer type);
    Page<UserEvent> getByType(Integer type, Pageable pageable);
}
