package com.xxin.drugstore.portal;


import com.xxin.drugstore.common.util.RedisUtil;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import javax.annotation.Resource;
import java.util.HashMap;

@SpringBootTest
@RunWith(SpringRunner.class)
public class PortalWebApplicationTests {


    @Test
    public void contextLoads() {
        RedisUtil redisUtil = new RedisUtil();

        String key = "spring:session:sessions:3fa29250-3034-48fe-bc00-322222";
        HashMap map = new HashMap();
        map.put("createTime","123456");
        map.put("lastAccessedTime","2345");
        redisUtil.hmset(key, map);
    }

}
