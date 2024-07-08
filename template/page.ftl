<section class='content'>
    <#if pageAdd>
    <div class='box-tools text-right'>
        <button id='${pageName}_button_add' class='btn btn-primary'>
            新增${tableComment}
        </button>
    </div>
    </#if>
    <div class='box-body'>
        <#if pageSearch>
        <form id="${pageName}_form_search" method="post" class="search-body">
            <div class="row">
                <div class="col-sm-3">
                    <div class="form-group">
                        <label>主键</label>
                        <input name='oid' type='text' class='form-control input-sm'/>
                    </div>
                </div>
            </div>
        </form>
        </#if>

        <table id='${pageName}_table_list' class='table table-bordered table-striped'>
        </table>
    </div>

    <#if pageUpdate>
    <div id='${pageName}_modal_update' class='modal fade  bs-example-modal-lg' tabindex='-1' role='dialog'
         aria-hidden='true' data-backdrop='static'>
        <div class='modal-dialog modal-lg' role='document'>
            <div class='modal-content'>
                <div class='modal-header'>
                    <button type='button' class='close' data-dismiss='modal'>
                        <span aria-hidden='true'>×</span>
                    </button>
                    <h4 class='modal-title'>修改${tableComment}</h4>
                </div>
                <div class='modal-body'>
                    <form id='${pageName}_form_update' method='post'>
                    <#list propertyList as property>
                        <#if property.columnKey == 'PRI'>
                         <input name='${property.propertyName}' type='hidden'/>
                        <#else>
                         <div class='row'>
                             <div class='col-sm-12'>
                                 <div class='form-group'>
                                     <label>${property.columnComment}</label>
                                     <input name='${property.propertyName}' type='text' class='form-control input-sm' maxlength="${property.maxLength}"
                                            placeholder='请输入${property.columnComment}' <#if property.nullable == 'false'>required='required' data-error='${property.columnComment}不能为空'</#if>/>
                                     <div class="help-block with-errors text-red"></div>
                                 </div>
                             </div>
                         </div>
                        </#if>
                    </#list>
                    </form>
                </div>
                <!-- 模态窗底部 -->
                <div class='modal-footer'>
                    <button type='button' class='btn btn-default ' data-dismiss='modal'>取消</button>
                    <button id='${pageName}_button_update_submit' type='button' class='btn btn-primary btn-submit'>保存
                    </button>
                </div>
            </div>
        </div>
    </div>
    </#if>

    <#if pageAdd>
    <div id='${pageName}_modal_add' class='modal fade  bs-example-modal-lg' tabindex='-1' role='dialog'
         aria-hidden='true' data-backdrop='static'>
        <div class='modal-dialog modal-lg' role='document'>
            <div class='modal-content'>
                <div class='modal-header'>
                    <button type='button' class='close' data-dismiss='modal'>
                        <span aria-hidden='true'>×</span>
                    </button>
                    <h4 class='modal-title'>新增${tableComment}</h4>
                </div>
                <div class='modal-body'>
                    <form id='${pageName}_form_add' method='post'>
                    <#list propertyList as property>
                        <#if property.columnKey != 'PRI'>
                         <div class='row'>
                             <div class='col-sm-12'>
                                 <div class='form-group'>
                                     <label>${property.columnComment}</label>
                                     <input name='${property.propertyName}' type='text' class='form-control input-sm'
                                            placeholder='请输入${property.columnComment}' <#if property.nullable == 'false'>required='required' data-error='${property.columnComment}不能为空'</#if>/>
                                     <div class="help-block with-errors text-red"></div>
                                 </div>
                             </div>
                         </div>
                        </#if>
                    </#list>
                    </form>
                </div>
                <!-- 模态窗底部 -->
                <div class='modal-footer'>
                    <button type='button' class='btn btn-default ' data-dismiss='modal'>取消</button>
                    <button id='${pageName}_button_add_submit' type='button' class='btn btn-primary btn-submit'>保存
                    </button>
                </div>
            </div>
        </div>
    </div>
    </#if>

    <!--确认提示框-->
    <div id='${pageName}_modal_confirm' class='popover func-delete-popover'>
        <div class='arrow'></div>
        <h3 class='popover-title'>提示</h3>
        <div class='popover-content'>
            <p class='confirmTitle'></p>
            <div class='popover-btn clearfix'>
                <div class='unit'>
                    <button class='btn btn-block btn-primary accept' data-dismiss='modal'>确 定</button>
                </div>
                <div class='unit'>
                    <button class='btn btn-block btn-default cancel' data-dismiss='modal'>取 消</button>
                </div>
            </div>
        </div>
    </div>

</section>