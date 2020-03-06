package com.xxin.drugstore.user.repository;

import com.xxin.drugstore.common.entity.WebSetting;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/29 16:48
 * @Description
 */
public interface WebSettingRepository extends JpaRepository<WebSetting,String> {
    List<WebSetting> getByTypeOrderBySort(Integer type);
    void deleteByType(Integer type);
}
