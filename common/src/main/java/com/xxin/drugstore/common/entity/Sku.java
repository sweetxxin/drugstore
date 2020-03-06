package com.xxin.drugstore.common.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import org.hibernate.annotations.GenericGenerator;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;

import javax.persistence.*;
import java.util.Date;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/1 14:01
 * @Description
 */
@Table(name = "d_sku")
@Data
@Entity
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
public class Sku {
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;

    private String skuNo;

    private Float marketPrice;
    private Float skuPrice;
    private Float discountPrice;

    @ManyToOne
    @JoinColumn(name = "delivery_id")
    private ShopDelivery delivery;

    @Transient
    private Integer deliveryId;

    private Integer stock;
    private Integer upperLimit;
    private Integer lowerLimit;

    private String createId;
    @CreatedDate
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    @LastModifiedDate
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date updateTime;


    private String updateId;

    private String saleWay;
    private String skuName;
    private String skuImg;
    private String packing;
    private Double size;

    private String status;

    private Integer isDisplay;
    private Integer isDefault;
}
