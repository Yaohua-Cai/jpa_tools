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
public class PageBuilder extends AbstractBuilder {

    @Override
    public void build(TableConfig tableConfig, List<Map<String, Object>> propertyList) throws Exception {
        Map<String, Object> params = new HashMap<>(10);
        params.put("propertyList", propertyList);
        params.put("tableComment", tableConfig.getComment());
        params.put("pageName", tableConfig.getPage());
        params.put("pageSearch", tableConfig.isPageSearch());
        params.put("pageAdd", tableConfig.isPageAdd());
        params.put("pageUpdate", tableConfig.isPageUpdate());
        params.put("pageDelete", tableConfig.isPageDelete());
        File file = buildPageFile(tableConfig.getPage(), tableConfig.getPage() + ".html");
        writeFile("page.ftl", params, file, tableConfig);
    }
}
