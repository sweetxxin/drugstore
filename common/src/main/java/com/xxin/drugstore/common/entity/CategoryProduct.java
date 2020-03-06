package com.xxin.drugstore.common.entity;

import lombok.Data;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.util.Objects;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/5 21:07
 * @Description
 */
@Entity
@Table(name = "d_category_product", schema = "drug_store", catalog = "")
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
@Data
public class CategoryProduct {
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;

    private String productId;
    private Integer categoryId;
}
