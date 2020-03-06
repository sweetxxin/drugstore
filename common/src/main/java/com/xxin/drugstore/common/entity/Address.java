package com.xxin.drugstore.common.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.hibernate.annotations.GenericGenerator;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Objects;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 14:19
 * @Description
 */
@Entity
@Table(name = "d_address", schema = "drug_store", catalog = "")
@Data
@EntityListeners(AuditingEntityListener.class)
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
public class Address {
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;

    private String userId;
    private String country;
    private String province;
    private String city;
    private String town;
    private String detail;

    @CreatedDate
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date createTime;
    @LastModifiedDate
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date updateTime;

    private String receiver;
    private String mobile;

    private Integer isDefault;
}
