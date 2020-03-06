package com.xxin.drugstore.user.repository;

import com.xxin.drugstore.common.entity.Assessment;
import com.xxin.drugstore.common.entity.Order;
import com.xxin.drugstore.common.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/11 14:53
 * @Description
 */
public interface AssessmentRepository extends JpaRepository<Assessment,String> {

    @Query(value = "select a.* from d_assessment a JOIN (select order_id from d_order_product where type = 1 and sku_id in (SELECT sku_id from d_sku where product_id = ?1))b on a.order_id = b.order_id where a.is_show=1",nativeQuery = true)
    Page<Assessment> getByProductId(String productId, Pageable pageable);

    @Query("select a from Assessment a where a.creator = ?1")
    Page<Assessment> getByCreator(User creator, Pageable pageable);

    Assessment getByOrder(Order order);
}
