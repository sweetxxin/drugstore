package com.xxin.drugstore.common.entity;

import lombok.Data;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/1 13:55
 * @Description
 */
@Table(name = "d_img")
@Data
@Entity
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
public class Img {
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;


    private String itemId;

    private String url;
    private Integer isDefault;
    private Integer type;
}
