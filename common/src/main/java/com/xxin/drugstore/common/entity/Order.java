package com.xxin.drugstore.common.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.hibernate.annotations.GenericGenerator;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 16:50
 * @Description
 */
@Entity
@Table(name = "d_order", schema = "drug_store", catalog = "")
@Data
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
@EntityListeners(AuditingEntityListener.class)
public class Order {
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;
    private String orderNo;
    private String status;
    private Double totalPrice;
    private Integer code;
    @CreatedDate
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date payDeadline;

    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date finishTime;
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date dealTime;
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date deleteTime;
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date payTime;
    @ManyToOne
    @JoinColumn(name ="user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "delivery_id")
    private Delivery delivery;

    @ManyToOne
    @JoinColumn(name = "shop_id")
    private Shop shop;
    @Transient
    List<OrderProduct> orderProduct;
    private Integer type;
    private String shortIn;
}
