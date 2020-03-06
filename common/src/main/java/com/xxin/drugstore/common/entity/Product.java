package com.xxin.drugstore.common.entity;


import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;
import org.hibernate.annotations.GenericGenerator;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.Set;

/**
 * @author xxin
 * @since 2019-11-15
 */
@Table(name = "d_product")
@Data
@Entity
@EntityListeners(AuditingEntityListener.class)
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
public class Product{
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;
    private String productNo;

    private String name;

    private Integer isNew;
    private Integer isHot;
    private Integer isCommend;
    private Integer isShow=1;
    private String isDel;
    private Integer isImport;

    @ManyToOne
    @JoinColumn(name = "create_id")
    private User creator;
    @ManyToOne
    @JoinColumn(name = "check_id")
    private User checker;

    @CreatedDate
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    @LastModifiedDate
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date updateTime;

    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date checkTime;

    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date produceTime;

    private String keywords;
    private String description;

    @OneToOne
    @JoinColumn(name = "factory_id")
    private Factory factory;
    @OneToOne
    @JoinColumn(name = "shop_id")
    private Shop shop;

    private String guarantee;
    private String storageCondition;
    private Double netWeight;
    private Double weight;
    private String originPlace;
    private String dosage;
    private Long sales;
    private String deliveryFrom;

    private String type;
    private String useWay;

    private String defaultImg;

    private Float defaultPrice;
    private String instruction;
    private String poster;
}
