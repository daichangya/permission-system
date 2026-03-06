package com.hiclaw.permission;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 权限管理系统启动类
 */
@SpringBootApplication
@MapperScan("com.hiclaw.permission.mapper")
public class PermissionSystemApplication {

    public static void main(String[] args) {
        SpringApplication.run(PermissionSystemApplication.class, args);
    }
}
