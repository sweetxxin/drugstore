package com.xxin.drugstore.common.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.xxin.drugstore.common.entity.Shop;
import com.xxin.drugstore.common.entity.User;
import lombok.Data;
import org.hibernate.annotations.GenericGenerator;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.util.Date;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/30 15:39
 * @Description
 */
@Data
@Entity
@Table(name = "d_shop_verify")
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
@EntityListeners(AuditingEntityListener.class)
public class ShopVerify {
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;
    private String name;
    private String idNum;
    private String license;
    private String other;
    private String authorize;
    private String status;
    private Integer code;
    private String result;
    @OneToOne
    @JoinColumn(name = "shop_id")
    private Shop shop;
    @CreatedDate
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date createTime;
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date verifyTime;
}
