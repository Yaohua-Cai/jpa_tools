package ${packageName}.entity;

import com.saicmotor.maxus.basic.component.jpa.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * @Author : ${author}
 * @Contact : ${contact}
 * @ClassName : ${entityName}Entity
 * @Date : Create in ${date}
 * @Description : ${tableComment}
 */

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
@Entity
@DynamicInsert
@DynamicUpdate
@Table(name = "${tableName}")
public class ${entityName}Entity extends BaseEntity {

    <#list propertyList as property>
    <#if property.columnKey != "PRI"
      && property.columnName != "create_by"
      && property.columnName != "create_time"
      && property.columnName != "update_by"
      && property.columnName != "update_time">
    /**
    * ${property.columnComment}
    */
    @Column(name = "${property.columnName}", nullable = ${property.nullable}<#if property.maxLength?length gt 0>, length = ${property.maxLength}</#if>, columnDefinition = "${property.columnType}<#if property.columnDefault?length gt 0> default ${property.columnDefault} ${property.extra}</#if> comment '${property.columnComment}'"<#if property.columnName == "create_time" || property.columnName == "update_time">, insertable = false, updatable = false</#if>)
    private ${property.propertyType} ${property.propertyName};
    </#if>
    </#list>
}
