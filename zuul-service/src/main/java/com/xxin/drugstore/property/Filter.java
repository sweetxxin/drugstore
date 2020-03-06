package com.xxin.drugstore.property;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/27 20:38
 * @Description
 */
@Component
@ConfigurationProperties(prefix="filter")
@Data
public class Filter {

    private List<String> include;
    private List<String> exclude;
}
