package com.xxin.drugstore.common.entity;



import lombok.Data;

import javax.persistence.*;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/5 15:10
 * @Description
 */
@Entity
@Table(name = "d_factory")
@Data
public class Factory {
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private Integer mainId;
    private String name;
    private String address;
    private String contact;
}
