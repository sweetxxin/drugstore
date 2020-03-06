package com.xxin.drugstore.common.entity;

import lombok.Data;

import javax.persistence.*;
import java.util.Objects;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/26 21:55
 * @Description
 */
@Entity
@Table(name = "d_shop_delivery", schema = "drug_store")
@Data
public class ShopDelivery {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int mainId;
    private String fromAddress;
    private String company;
    private String fee;
    private String contact;
    private String title;
    private String isFree;
    private Integer beginPrice;
    private String shopId;
}
