package ${packageName}.repository;

import ${packageName}.entity.${entityName}Entity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.io.Serializable;

/**
* @Author : ${author}
* @Contact : ${contact}
* @ClassName : ${entityName}Dao
* @Date : Create in ${date}
* @Description :
*/

@Repository
public interface ${entityName}Dao extends JpaRepository<${entityName}Entity, Serializable>, JpaSpecificationExecutor<${entityName}Entity> {

}
