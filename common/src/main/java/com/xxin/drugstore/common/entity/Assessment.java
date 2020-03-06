package com.xxin.drugstore.common.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.hibernate.annotations.GenericGenerator;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/10 17:09
 * @Description
 */
@Table(name = "d_assessment")
@Data
@Entity
@EntityListeners(AuditingEntityListener.class)
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
public class Assessment {
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;

    @ManyToOne
    @JoinColumn(name = "order_id")
    private Order order;

    private String msg;
    private int shopStar;
    private int deliveryStar;
    private int goodsStar;
    private int serviceStar;
    public int isPublic;

    @Transient
    private List<Img>files;

    @ManyToOne
    @JoinColumn(name = "create_id")
    private User creator;

    @CreatedDate
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    @Transient
    private int good;
    @Transient
    private int reply;
    @Transient
    private int against;

    @Transient
    private boolean giveGood;
    @Transient
    private boolean giveAgainst;
    @Transient
    private List<Img> img;

    private Integer isShow;
}
