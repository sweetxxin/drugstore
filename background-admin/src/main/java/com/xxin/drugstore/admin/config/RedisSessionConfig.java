package com.xxin.drugstore.admin.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.session.data.redis.RedisFlushMode;
import org.springframework.session.data.redis.config.annotation.web.http.EnableRedisHttpSession;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/14 11:23
 * @Description
 */
@Configuration
@EnableRedisHttpSession(redisFlushMode = RedisFlushMode.IMMEDIATE,maxInactiveIntervalInSeconds = 60*1000*30)
public class RedisSessionConfig {

}
