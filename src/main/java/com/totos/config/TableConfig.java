package com.totos.config;

import lombok.Data;

/**
 * @author : caiyh
 * @Contact : 18019692161@163.com
 * @Date: Create in 11:22 2024/7/5
 */
@Data
public class TableConfig {
    private String name;
    private String entity;
    private String page;
    private String comment;
    private boolean pageSearch = true;
    private boolean pageAdd = true;
    private boolean pageUpdate = true;
    private boolean pageDelete = true;
}
