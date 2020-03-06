package com.xxin.drugstore.common.entity;

import lombok.Data;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/30 15:39
 * @Description
 */
@Data
@Entity
@Table(name = "d_shop")
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
public class Shop {
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;

    @OneToOne
    @JoinColumn(name = "user_id")
    private User keeper;

    private String name;
    private String email;
    private String website;
    private String mobile;
    private String address;
    private String slogan;
    private String description;
    private int isDisplay;
    private int isVerify;
    private String poster;
}
