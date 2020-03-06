package com.xxin.drugstore.common.entity;

import lombok.Data;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Objects;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 16:48
 * @Description
 */
@Entity
@Table(name = "d_delivery", schema = "drug_store", catalog = "")
@Data
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
public class Delivery {
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;

    private String orderId;

    @ManyToOne
    @JoinColumn(name ="from_address_id")
    private Address fromAddress;

    @ManyToOne
    @JoinColumn(name ="to_address_id")
    private Address toAddress;

    private Date sendTime;
    private Date receiveTime;
    private String status;
    private String delivery;
    private Double deliveryFee;
}
