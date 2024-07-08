package ${packageName}.${entityName?lower_case};

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
* @Author : ${author}
* @Contact : ${contact}
* @ClassName : ${entityName}Vo
* @Date : Create in ${date}
* @Description :
*/

@Data
public class ${entityName}Vo {
    <#list propertyList as property>

    <#if property.columnComment?? && property.columnComment?trim?length gt 1 >
    @ApiModelProperty(value = "${property.columnComment}")
    </#if>
    private ${property.propertyType} ${property.propertyName};
    </#list>
}
