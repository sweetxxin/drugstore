package com.xxin.drugstore.common.pojo;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/25 17:40
 * @Description
 */
@Data
@NoArgsConstructor
public class StatisticItem {
    private String name;
    private Long countVal;
    private Double sumVal;

    public StatisticItem(Object name,Object countVal,Object sumVal){
        this.name = name.toString();
        this.countVal=Long.valueOf(countVal.toString());
        this.sumVal = Double.valueOf(sumVal.toString());
    }
}
