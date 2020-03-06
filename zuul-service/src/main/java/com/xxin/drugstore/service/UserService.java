package com.xxin.drugstore.service;

import com.xxin.drugstore.common.response.Message;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/27 17:35
 * @Description
 */
@FeignClient("user-service")
public interface UserService {

    @GetMapping("/user/id/{id}")
    Message getUserInfoById(@PathVariable("id") String id);
    @GetMapping("/user/username/{name}")
    Message getUserInfoByUsername(@PathVariable("name") String name);
}
