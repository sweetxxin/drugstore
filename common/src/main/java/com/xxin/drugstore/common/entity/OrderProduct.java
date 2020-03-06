package com.xxin.drugstore.common.entity;

import lombok.Data;
import org.hibernate.annotations.GenericGenerator;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.util.Objects;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 16:37
 * @Description
 */
@Entity
@Table(name = "d_order_product", schema = "drug_store", catalog = "")
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
@Data

public class OrderProduct {
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;

    private String orderId;
    private String productId;
    @ManyToOne
    @JoinColumn(name ="sku_id")
    private Sku sku;

    private String shopId;
    private Integer type = 1;
    private Integer amount;
}
