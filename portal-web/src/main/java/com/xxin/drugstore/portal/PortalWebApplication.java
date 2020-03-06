package com.xxin.drugstore.portal;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.session.data.redis.config.annotation.web.http.EnableRedisHttpSession;


@SpringBootApplication(scanBasePackages = {"com.xxin.drugstore.portal","com.xxin.drugstore.common.util"})
@EnableFeignClients(basePackages = "com.xxin.drugstore.portal.service")
@EnableEurekaClient
@EnableJpaAuditing
@EnableRedisHttpSession
public class PortalWebApplication {

    public static void main(String[] args) {
        SpringApplication.run(PortalWebApplication.class, args);
    }

}
