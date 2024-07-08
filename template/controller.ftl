package ${packageName}.controller;

import com.saicmotor.maxus.basic.component.web.BaseResult;
import com.saicmotor.maxus.basic.component.web.PageResult;
import ${packageName}.service.${entityName}Service;
import ${packageName}.vo.${entityName}Vo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.bind.annotation.*;


/**
* @Author : ${author}
* @Contact : ${contact}
* @ClassName : ${entityName}Controller
* @Date : Create in ${date}
* @Description :
*/

@Api(value = "${tableComment}管理", tags = {"${tableComment}管理接口"})
@RestController
@RequestMapping(path = "${lowEntityName}", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
public class ${entityName}Controller {

    @Autowired
    private ${entityName}Service ${lowEntityName}Service;

    @ApiOperation(value = "分页条件查询", nickname = "list")
    @RequestMapping(name = "分页条件查询", value = "list", method = {RequestMethod.GET})
    public ResponseEntity<PageResult<${entityName}Vo>> list(@RequestParam(value = "oid", required = false) String oid, @RequestParam(name = "page", required = false, defaultValue = "1") int page, @RequestParam(name = "rows", required = false, defaultValue = "50") int rows) {
        PageResult<${entityName}Vo> result = ${lowEntityName}Service.list(oid, page - 1, rows);
        return ResponseEntity.ok(result);
    }

    @ApiOperation(value = "查询明细", nickname = "listInfo")
    @RequestMapping(name = "查询明细", value = "listInfo/{oid}", method = {RequestMethod.GET})
    public ResponseEntity<BaseResult<${entityName}Vo>> listInfo(@PathVariable("oid") String oid) {
        ${entityName}Vo vo = ${lowEntityName}Service.listById(oid);
        return ResponseEntity.ok(new BaseResult(vo));
    }

    @ApiOperation(value = "新增", nickname = "add")
    @RequestMapping(name = "新增", value = "add", method = {RequestMethod.POST})
    public ResponseEntity<BaseResult> add(@RequestBody ${entityName}Vo vo) {
        ${lowEntityName}Service.add(vo);
        return ResponseEntity.ok(new BaseResult<>());
    }

    @ApiOperation(value = "删除", nickname = "delete")
    @RequestMapping(name = "删除", value = "delete/{oid}", method = {RequestMethod.POST})
    public ResponseEntity<BaseResult> delete(@PathVariable("oid") String oid) {
        ${lowEntityName}Service.deleteById(oid);
        return ResponseEntity.ok(new BaseResult());
    }

    @ApiOperation(value = "修改", nickname = "update")
    @RequestMapping(name = "修改", value = "update", method = {RequestMethod.POST})
    public ResponseEntity<BaseResult> update(@RequestBody ${entityName}Vo vo) {
        ${lowEntityName}Service.update(vo);
        return ResponseEntity.ok(new BaseResult());
    }
}
