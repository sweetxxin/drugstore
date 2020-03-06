package com.xxin.drugstore.common.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.hibernate.annotations.GenericGenerator;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import java.util.Objects;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/7 15:03
 * @Description
 */
@Entity
@Table(name = "d_cart", schema = "drug_store", catalog = "")
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
@EntityListeners(AuditingEntityListener.class)
@Data
public class Cart {
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;

    @ManyToOne
    @JoinColumn(name = "sku_id")
    private Sku sku;

    private Integer amount;
    private String userId;
    @CreatedDate
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date createTime;

//    @Transient
//    private Sku sku;
}
