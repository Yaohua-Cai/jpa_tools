package ${packageName}.${entityName?lower_case};

import com.saicmotor.maxus.basic.component.web.PageResult;
import ${packageName}.repository.${entityName}Dao;
import ${packageName}.entity.${entityName}Entity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.data.domain.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import javax.persistence.criteria.Predicate;
import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;

/**
* @Author : ${author}
* @Contact : ${contact}
* @ClassName : ${entityName}Service
* @Date : Create in ${date}
* @Description :
*/

@Service
@Transactional(rollbackOn = Exception.class)
@Slf4j
public class ${entityName}Service {

    @Autowired
    private ${entityName}Dao ${lowEntityName}Dao;

    public List<${entityName}Vo> listAll() {
        List<${entityName}Entity> listData =  ${lowEntityName}Dao.findAll();
        ${entityName}Vo vo;
        List<${entityName}Vo> resList = new ArrayList<>();
        for (${entityName}Entity entity : listData) {
            vo = new ${entityName}Vo();
            BeanUtils.copyProperties(entity, vo);
            resList.add(vo);
        }
        return resList;
    }

    public PageResult<${entityName}Vo> list(String oid, int page, int size) {
        Specification<${entityName}Entity> specification = (root, criteriaQuery, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (oid != null && !oid.isEmpty()) {
                predicates.add(criteriaBuilder.equal(root.get("oid"), oid));
            }
            return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
        };
        Page<${entityName}Entity> pageData = ${lowEntityName}Dao.findAll(specification, PageRequest.of(page, size));
        ${entityName}Vo vo;
        List<${entityName}Vo> resList = new ArrayList<>();
        for (${entityName}Entity entity : pageData.getContent()) {
            vo = new ${entityName}Vo();
            BeanUtils.copyProperties(entity, vo);
            resList.add(vo);
        }
        PageResult<${entityName}Vo> result = new PageResult<>(pageData.getTotalElements(), resList);
        return result;
    }

    public ${entityName}Vo listById(String oid) {
        ${entityName}Entity entity = ${lowEntityName}Dao.getOne(oid);
        ${entityName}Vo vo = new ${entityName}Vo();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    public void add(${entityName}Vo vo) {
        ${entityName}Entity entity = new ${entityName}Entity();
        BeanUtils.copyProperties(vo, entity);
        ${lowEntityName}Dao.save(entity);
    }

    public void deleteById(String oid) {
        ${lowEntityName}Dao.deleteById(oid);
    }

    public void update(${entityName}Vo vo) {
        ${entityName}Entity entity = new ${entityName}Entity();
        BeanUtils.copyProperties(vo, entity);
        ${lowEntityName}Dao.saveAndFlush(entity);
    }
}
