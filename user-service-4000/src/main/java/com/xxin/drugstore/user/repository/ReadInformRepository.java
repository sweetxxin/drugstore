package com.xxin.drugstore.user.repository;

import com.xxin.drugstore.common.entity.Inform;
import com.xxin.drugstore.common.entity.ReadInform;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/18 23:20
 * @Description
 */
public interface ReadInformRepository extends JpaRepository<ReadInform,String> {

    ReadInform getByUserIdAndInform(String uid,Inform inform);

}
