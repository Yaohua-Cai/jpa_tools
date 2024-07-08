package com.totos.builder;

import com.totos.config.TableConfig;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author : caiyh
 * @Contact : 18019692161@163.com
 * @Date: Create in 11:22 2024/7/5
 */
@Service
public class EntityBuilder extends AbstractBuilder {

    @Override
    public void build(TableConfig tableConfig, List<Map<String, Object>> propertyList) throws Exception {
        Map<String, Object> params = new HashMap<>(10);
        params.put("tableName", tableConfig.getName());
        params.put("tableComment", tableConfig.getComment());
        params.put("propertyList", propertyList);
        File file = buildJavaFile(builderConfig.getPackageName() + ".entity", tableConfig.getEntity() + "Entity.java");
        writeFile("entity.ftl", params, file, tableConfig);
    }
}
