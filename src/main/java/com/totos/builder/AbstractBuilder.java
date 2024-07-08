package com.totos.builder;

import com.totos.config.BuilderConfig;
import com.totos.config.TableConfig;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

/**
 * @author : caiyh
 * @Contact : 18019692161@163.com
 * @Date: Create in 11:22 2024/7/5
 */
public abstract class AbstractBuilder {

    @Autowired
    protected BuilderConfig builderConfig;

    protected static final String JAVA_DIR = "dest/java/";
    protected static final String HTML_DIR = "dest/pages/";

    protected String date;

    public AbstractBuilder() {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        this.date = simpleDateFormat.format(Calendar.getInstance().getTime());
    }

    @Autowired
    private FreemarkerService freemarkerService;

    public abstract void build(TableConfig tableConfig, List<Map<String, Object>> propertyList) throws Exception;

    protected File buildJavaFile(String packageName, String fileName) throws Exception {
        fileName = indexToUp(fileName);
        File file = new File(JAVA_DIR + packageName.replace(".", "/"), fileName);
        if (!file.getParentFile().isDirectory()) {
            file.getParentFile().mkdirs();
        }
        file.createNewFile();
        return file;
    }

    protected File buildPageFile(String dir, String fileName) throws Exception {
        File file = new File(HTML_DIR + dir, fileName);
        if (!file.getParentFile().isDirectory()) {
            file.getParentFile().mkdirs();
        }
        file.createNewFile();
        return file;
    }

    protected void writeFile(String templateName, Map<String, Object> params, File file, TableConfig tableConfig) throws Exception {
        params.put("author", builderConfig.getAuthor());
        params.put("contact", builderConfig.getContact());
        params.put("date", date);
        params.put("packageName", builderConfig.getPackageName());
        params.put("contextPath", builderConfig.getContextPath());
        params.put("entityName", indexToUp(tableConfig.getEntity()));
        params.put("lowEntityName", indexToLow(tableConfig.getEntity()));
        freemarkerService.templateWrite(templateName, params, file);
    }

    protected String indexToUp(String value) {
        return Character.toUpperCase(value.charAt(0)) + value.substring(1);
    }

    protected String indexToLow(String value) {
        return Character.toLowerCase(value.charAt(0)) + value.substring(1);
    }


}
