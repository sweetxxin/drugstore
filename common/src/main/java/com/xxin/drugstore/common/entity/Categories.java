package com.xxin.drugstore.common.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.persistence.*;
import java.util.Objects;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/27 14:05
 * @Description
 */
@Entity
@Table(name = "d_categories", schema = "drug_store")
@Data
@JsonIgnoreProperties(value = { "hibernateLazyInitializer", "handler" })
public class Categories {
    @Id
    private int mainId;
    private String name;
    private String description;
    private Integer isDisplay;
    private Integer parentId;
    private Integer sort;
    private Byte isHot;
    private Integer code;
    private String type;
    @Transient
    private Categories parent;
}
