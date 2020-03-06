package com.xxin.drugstore.user.repository;

import com.xxin.drugstore.common.entity.Address;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 14:23
 * @Description
 */
public interface AddressRepository extends JpaRepository<Address,String> {

    @Query(value = "select * from d_address where user_id = :uid order by update_time and is_default desc",nativeQuery = true)
    List<Address> getAddressByUserId(@Param("uid") String uid);

    @Query(value = "update d_address set is_default = 0 where user_id = :uid",nativeQuery = true)
    @Modifying
    void resetDefaultAddress(@Param("uid") String uid);

}
