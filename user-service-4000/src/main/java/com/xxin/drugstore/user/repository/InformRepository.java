package com.xxin.drugstore.user.repository;

import com.xxin.drugstore.common.entity.Inform;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.HashMap;
import java.util.Map;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/18 21:11
 * @Description
 */
public interface InformRepository extends JpaRepository<Inform,String> {
    Page<Inform> getByUserId(String userId, Pageable pageable);

    @Query(value = "select new Inform( i.mainId,i.title,i.content,i.outline,i.createTime,i.userId,i.creator,r.isRead,r.readTime) from Inform i left join ReadInform r on i = r.inform where i.userId = ?1")
    Page<Inform> getInform(String uid, Pageable pageable);

    @Query(value = "select new Inform( i.mainId,i.title,i.content,i.outline,i.createTime,i.userId,i.creator,r.isRead,r.readTime) from Inform i left join ReadInform r on i = r.inform where i.userId = ?1 and  r.isRead is null")
    Page<Inform> getNewInform(String uid, Pageable pageable);

    @Query("select new Inform( i.mainId,i.title,i.content,i.outline,i.createTime,i.userId,i.creator,r.isRead,r.readTime) from Inform i left join ReadInform r on i = r.inform where i.userId = ?1 and  r.isRead is not null")
    Page<Inform> getReadInform(String uid, Pageable pageable);

    @Query(value = "select count(*) from d_inform a left join d_read_inform b on a.main_id = b.inform_id where a.user_id = ?1 and b.is_read is null",nativeQuery = true)
    Integer countNewInform(String uid);
}
