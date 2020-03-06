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
 * @Date 2020/1/14 16:17
 * @Description
 */
@Entity
@Table(name = "d_read_inform", schema = "drug_store", catalog = "")
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
@Data
@EntityListeners(AuditingEntityListener.class)
public class ReadInform {
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;

    @ManyToOne
    @JoinColumn(name = "inform_id")
    private Inform inform;

    private String userId;

    @CreatedDate
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date readTime;

    private Integer isRead;
}
