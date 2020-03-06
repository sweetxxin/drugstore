package com.xxin.drugstore.common.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import org.hibernate.annotations.GenericGenerator;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.util.Date;

/**
 * <p>
 * 
 * </p>
 *
 * @author xxin
 * @since 2019-11-07
 */

@Data
@Entity
@Table(name = "d_user")
@EntityListeners(AuditingEntityListener.class)
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
public class User{
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;

    private String username;
    private String password;
    private String salt;
    private Integer type;

    private String name;
    private String nickName;
    private Integer gender;
    private String mobile;
    private String email;
    private String slogan;
    private String hobby;
    private String idNum;
    private String avatar;
    private Integer isVerify;
    @CreatedDate
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    @LastModifiedDate
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date updateTime;
}
