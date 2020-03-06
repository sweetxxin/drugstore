package com.xxin.drugstore.common.entity;

import lombok.Data;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/30 15:39
 * @Description
 */
@Data
@Entity
@Table(name = "d_web_setting")
@GenericGenerator(name = "jpa-uuid", strategy = "org.hibernate.id.UUIDGenerator")
public class WebSetting {
    @Id
    @GeneratedValue(generator = "jpa-uuid")
    private String mainId;
    private String url;
    private Integer type;
    private String description;
    private String title;
    private String content;
    private Integer isShow;
    private int sort;
}
