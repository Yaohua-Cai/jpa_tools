package com.totos.builder;

import com.totos.config.BuilderConfig;
import com.totos.config.TableConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author : caiyh
 * @Contact : 18019692161@163.com
 * @Date: Create in 11:22 2024/7/5
 */
@Component
@Slf4j
public class BuilderRunner implements CommandLineRunner {
    private static final String MYSQL_SELECT_COLUMN = "select column_name, data_type, column_key,column_type,column_default,extra, column_comment,is_nullable,character_maximum_length from information_schema.columns where table_name = ? and table_schema = ?";
    private static final String ORACLE_SELECT_COLUMN = "select A.column_name column_name,A.data_type data_type,A.data_length character_maximum_length, A.data_scale, A.nullable is_nullable,A.Data_default column_default,B.comments column_comment from user_tab_columns A,user_col_comments B where A.Table_Name = B.Table_Name and A.Column_Name = B.Column_Name and A.Table_Name = ?";

    private static final String DB_TYPE_MYSQL = "mysql";
    private static final String DB_TYPE_ORACLE = "oracle";

    @Autowired
    private BuilderConfig builderConfig;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private EntityBuilder entityBuilder;

    @Autowired
    private DaoBuilder daoBuilder;

    @Autowired
    private ServiceBuilder serviceBuilder;

    @Autowired
    private ControllerBuilder controllerBuilder;

    @Autowired
    private VoBuilder voBuilder;

    @Autowired
    private PageBuilder pageBuilder;

    @Autowired
    private PageJsBuilder pageJsBuilder;

    @Override
    public void run(String... args) throws Exception {
        if(builderConfig.getCleanBuild()){
            //清空历史构建
            File dest = new File("dest");
            deleteFile(dest);
        }
        List<Map<String, Object>> columnList;
        for (TableConfig tableConfig : builderConfig.getTables()) {
            if (DB_TYPE_ORACLE.equalsIgnoreCase(builderConfig.getDatabaseType())) {
                tableConfig.setName(tableConfig.getName().toUpperCase());
                columnList = jdbcTemplate.queryForList(ORACLE_SELECT_COLUMN, tableConfig.getName());
            } else if (DB_TYPE_MYSQL.equalsIgnoreCase(builderConfig.getDatabaseType())){
                columnList = jdbcTemplate.queryForList(MYSQL_SELECT_COLUMN, tableConfig.getName(), builderConfig.getDatabase());
            }else{
                log.error("数据库类型未设置");
                return;
            }

            String temp=tableConfig.getName();
            if(temp.indexOf("t_")==0){
                temp=temp.substring(2);
            }
            tableConfig.setPage(temp);
            String[] tempArry =temp.split("_");
            if(tempArry.length>1){
                temp="";
                for(String str:tempArry){
                    temp+=String.valueOf(str.charAt(0)).toUpperCase()+str.substring(1);
                }
            }
            tableConfig.setEntity(temp);
            columnList = convertProperties(columnList);
            entityBuilder.build(tableConfig, columnList);
            daoBuilder.build(tableConfig, columnList);
            serviceBuilder.build(tableConfig, columnList);
            controllerBuilder.build(tableConfig, columnList);
            voBuilder.build(tableConfig, columnList);
            if (tableConfig.getPage() != null && !tableConfig.getPage().trim().isEmpty()) {
                try {
                    pageBuilder.build(tableConfig, columnList);
                    pageJsBuilder.build(tableConfig, columnList);
                } catch (Exception e) {
                    log.error(tableConfig.getName(), e);
                    return;
                }
            }
        }
    }

    private List<Map<String, Object>> convertProperties(List<Map<String, Object>> columnList) {
        List<Map<String, Object>> proList = new ArrayList<>();
        String columnName, dataType, propertyName, propertyType, columnKey, columnType, columnDefault, extra, columnComment, isNullable, maxLength;
        int data_scale;
        Map<String, Object> property;
        Object obj;
        for (Map<String, Object> column : columnList) {
            obj = column.get("column_name");
            columnName = obj == null ? "" : obj.toString();
            obj = column.get("data_type");
            dataType = obj == null ? "" : obj.toString();
            obj = column.get("column_key");
            columnKey = obj == null ? "" : obj.toString();
            obj = column.get("column_type");
            columnType = obj == null ? "" : obj.toString();
            obj = column.get("column_default");
            columnDefault = obj == null ? "" : obj.toString();
            obj = column.get("extra");
            extra = obj == null ? "" : obj.toString();
            obj = column.get("column_comment");
            columnComment = obj == null ? "" : obj.toString();
            obj = column.get("is_nullable");
            isNullable = obj == null ? "" : obj.toString();
            obj = column.get("character_maximum_length");
            maxLength = obj == null ? "" : "NVARCHAR2".equalsIgnoreCase(dataType) ? String.valueOf(Integer.parseInt(obj.toString())/2) : obj.toString();
            obj = column.get("data_scale");
            data_scale = obj == null ? 0 : Integer.parseInt(obj.toString());
            propertyName = convertName(columnName);
            propertyType = convertType(dataType, data_scale);
            property = new HashMap<>(20);
            property.put("columnName", columnName);
            property.put("dataType", dataType);
            property.put("columnKey", columnKey);
            property.put("columnType", columnType);
            property.put("columnDefault", columnDefault);
            property.put("extra", extra);
            property.put("columnComment", columnComment);
            property.put("nullable", isNullable.equals("NO") ? "false" : "true");
            property.put("maxLength", maxLength);
            property.put("propertyName", propertyName);
            property.put("propertyType", propertyType);
            if (DB_TYPE_ORACLE.equalsIgnoreCase(builderConfig.getDatabaseType())) {
                property.put("columnKey", columnName.equalsIgnoreCase("C_OID") ? "PRI" : "");
                property.put("nullable", isNullable.equals("N") ? "false" : "true");
            }
            proList.add(property);
        }
        return proList;
    }

    private String convertType(String type, int dataScale) {
        if ("varchar".equalsIgnoreCase(type)) {
            return "String";
        }
        if ("varchar2".equalsIgnoreCase(type)) {
            return "String";
        }
        if ("nvarchar2".equalsIgnoreCase(type)) {
            return "String";
        }
        if ("decimal".equalsIgnoreCase(type)) {
            return "BigDecimal";
        }
        if ("number".equalsIgnoreCase(type)) {
            if (dataScale > 0) {
                return "BigDecimal";
            } else {
                return "Integer";
            }
        }
        if ("int".equalsIgnoreCase(type)) {
            return "Integer";
        }
        if ("timestamp".equalsIgnoreCase(type)) {
            return "Date";
        }
        if ("datetime".equalsIgnoreCase(type)) {
            return "Date";
        }
        if ("date".equalsIgnoreCase(type)) {
            return "Date";
        }
        if ("tinyint".equalsIgnoreCase(type) || "bit".equalsIgnoreCase(type)) {
            return "Boolean";
        }
        return type;
    }

    private String convertName(String name) {
        StringBuilder builder = new StringBuilder();
        name = name.toLowerCase();
        int start = 0;
        if (name.startsWith("c_")) {
            name = name.substring(2);
        }
        int end = name.indexOf("_", start);
        String temp;
        while (end != -1) {
            formatPropertyName(name, builder, start, end);
            start = end + 1;
            end = name.indexOf("_", start);
        }
        end = name.length();
        formatPropertyName(name, builder, start, end);
        return builder.toString();
    }

    private void formatPropertyName(String name, StringBuilder builder, int start, int end) {
        String temp;
        if (start > 0) {
            temp = name.substring(start, end);
            builder.append(Character.toUpperCase(temp.charAt(0)));
            builder.append(temp, 1, temp.length());
        } else {
            builder.append(name, start, end);
        }
    }

    /**
     * 先根遍历序递归删除文件夹
     *
     * @param dirFile 要被删除的文件或者目录
     * @return 删除成功返回true, 否则返回false
     */
    public static boolean deleteFile(File dirFile) {
        // 如果dir对应的文件不存在，则退出
        if (!dirFile.exists()) {
            return false;
        }
        if (dirFile.isFile()) {
            return dirFile.delete();
        } else {
            for (File file : dirFile.listFiles()) {
                deleteFile(file);
            }
        }
        return dirFile.delete();
    }
}
