package com.totos.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.util.List;

/**
 * @author : caiyh
 * @Contact : 18019692161@163.com
 * @Date: Create in 11:22 2024/7/5
 */
@Configuration
@ConfigurationProperties(prefix = "builder")
@Data
public class BuilderConfig {

    private String packageName;
    private String databaseType;
    private String database;
    private String author;
    private String contact;
    private Boolean cleanBuild;
    private String contextPath;
    private List<TableConfig> tables;
}
