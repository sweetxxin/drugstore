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
 * @Date 2020/1/14 16:17
 * @Description
 */
@Entity
@Table(name = "d_inform", schema = "drug_store", catalog = "")
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
@Data
@EntityListeners(AuditingEntityListener.class)
public class Inform {
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;

    private String title;
    private String content;
    private String outline;

    @CreatedDate
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    private String userId;
    @ManyToOne
    @JoinColumn(name = "creator_id")
    private User creator;

    @Transient
    private Integer isRead;
    @Transient
    private Date readTime;

    public Inform(){}
    public Inform(String mainId,String title, String content, String outline, Date createTime, String userId, User creator,Integer isRead,Date readTime) {
        this.mainId = mainId;
        this.title = title;
        this.content = content;
        this.outline = outline;
        this.createTime = createTime;
        this.userId = userId;
        this.creator = creator;
        this.readTime = readTime;
        this.isRead = isRead;
    }
}
