package com.totos.builder;

import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.Charset;

/**
 * @author : caiyh
 * @Contact : 18019692161@163.com
 * @Date: Create in 11:22 2024/7/5
 */
@Slf4j
@Service
public class FreemarkerService {
    private Configuration configuration;

    public FreemarkerService() {
        try {
            configuration = new Configuration(Configuration.DEFAULT_INCOMPATIBLE_IMPROVEMENTS);
            configuration.setDirectoryForTemplateLoading(new File("template"));
            configuration.setObjectWrapper(new DefaultObjectWrapper(Configuration.DEFAULT_INCOMPATIBLE_IMPROVEMENTS));
            configuration.setDefaultEncoding("UTF-8");
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public void templateWrite(String templateName, Object params, File file) throws Exception {
        OutputStreamWriter writer = null;
        try {
            writer = new OutputStreamWriter(new FileOutputStream(file), Charset.forName("UTF-8"));
            Template template = configuration.getTemplate(templateName);
            template.process(params, writer);
        } finally {
            if (writer != null) {
                try {
                    writer.close();
                } catch (IOException e) {
                    // nothing
                }
            }
        }
    }
}
