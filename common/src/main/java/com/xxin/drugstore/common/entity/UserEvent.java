package com.xxin.drugstore.common.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.hibernate.annotations.GenericGenerator;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.util.Date;

/**
 * @author xxin
 * @Created
 * @Date 2020/1/8 16:48
 * @Description
 */
@Entity
@Table(name = "d_user_event", schema = "drug_store", catalog = "")
@Data
@EntityListeners(AuditingEntityListener.class)
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
public class UserEvent {
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;
    private String itemId;

    @JoinColumn(name = "user_id")
    @ManyToOne
    private User user;

    @CreatedDate
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date createTime;
    private Integer type;
    private String detail;
    private Integer isShow;
    private String status;
    @Transient
    private Object item;
}
