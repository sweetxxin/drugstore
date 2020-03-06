package com.xxin.drugstore.user.repository;

import com.xxin.drugstore.common.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/27 17:21
 * @Description
 */
@Repository
public interface UserRepository extends JpaRepository<User,String> {
     User getUserByUsername(String username);
}
