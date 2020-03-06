package com.xxin.drugstore.order.repository;

import com.xxin.drugstore.common.entity.User;
import com.xxin.drugstore.common.entity.UserEvent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/21 13:30
 * @Description
 */
public interface UserEventRepository extends JpaRepository<UserEvent,String> {

    int countByTypeAndItemId(Integer type,String itemId);
    int countByTypeAndItemIdAndUser(Integer type, String itemId, User user);


}
