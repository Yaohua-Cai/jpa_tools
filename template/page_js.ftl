(function () {
    gh.load([
        [
            gh.pluginsPath + 'bootstrap-validator/validator.js',
            gh.pluginsPath + 'jQuery-form/jquery.form.js',
        ],
        gh.pluginsPath + 'iCheck/icheck.js',
        gh.pluginsPath + 'util/util.js',
        gh.libPath + 'utils/utils.js',

    ], function () {
        let confirm = $E('#${pageName}_modal_confirm');

        let listPageOptions = {
            page: 1,
            rows: 10,
            oid: $E('#${pageName}_form_search input[name="oid"]').val(),
        };

        function getQueryParams(val) {
            listPageOptions.rows = val.limit;
            listPageOptions.offset = val.offset;
            listPageOptions.page = parseInt(val.offset / val.limit) + 1;
            listPageOptions.oid = $E('#${pageName}_form_search input[name="oid"]').val();
        }

        let listTableConfig = {
            ajax: function (origin) {
                gh.api.${contextPath}.${lowEntityName}.list({
                    data: listPageOptions
                }, function (rlt) {
                    origin.success(rlt)
                })
            },
            pageNumber: listPageOptions.page,
            pageSize: listPageOptions.rows,
            pagination: true,
            sidePagination: 'server',
            pageList: [
                10, 20, 30, 50, 100
            ],
            queryParams: getQueryParams,
            dataField: 'data',
            totalField: 'totalRows',
            columns: [
                {
                    title: '序号',
                    width: 80,
                    formatter: function (val, row, index) {
                        return index + 1;
                    },
                },
                <#list propertyList as property>
                {
                    title: '${property.columnComment}',
                    field: '${property.propertyName}',
                },
                </#list>
                <#if pageUpdate || pageDelete>
                {
                    title: '操作',
                    align: 'center',
                    width: 80,
                    formatter: function (val, row) {
                        let buttons = [
                            <#if pageUpdate>
                            {
                                'text': '修改',
                                'type': 'button',
                                'class': 'item-update',
                                'isRender': true,
                                'roleRender': true
                            },
                            </#if>
                            <#if pageDelete>
                            {
                                'text': '删除',
                                'type': 'button',
                                'class': 'item-delete',
                                'isRender': true,
                                'roleRender': true
                            },
                            </#if>
                        ];
                        return util.table.formatter.generateButton(buttons, '${pageName}_table_list');
                    },
                    events: {
                        <#if pageUpdate>
                        'click .item-update': function (e, value, row) {
                            gh.api.${contextPath}.${lowEntityName}.listInfo({
                                param: {
                                    oid: row.oid
                                }
                            }, function (rs) {
                                let form = $E('#${pageName}_form_update');
                                form.validator('destroy');
                                util.form.reset(form);
                                $$.formAutoFix(form, rs.data);
                                util.form.validator.init(form);
                                $E('#${pageName}_modal_update').modal('show')
                            });
                        },
                        </#if>
                        <#if pageDelete>
                        'click .item-delete': function (e, value, row) {
                            confirm.find('.confirmTitle').text('确定删除该记录？');
                            $$.confirm({
                                container: confirm,
                                trigger: this,
                                accept: function () {
                                    gh.api.${contextPath}.${lowEntityName}.delete({
                                        param: {
                                            oid: row.oid
                                        }
                                    }, function (re) {
                                        if (re.code === '00000') {
                                            $E('#${pageName}_table_list').bootstrapTable('refresh')
                                        }
                                    })
                                }
                            });
                        },
                        </#if>
                    }
                },
                </#if>
            ]
        };

        $E('#${pageName}_table_list').bootstrapTable(listTableConfig);
        <#if pageSearch>
        $$.searchInit($E('#${pageName}_form_search'), $E('#${pageName}_table_list'));
        </#if>

        <#if pageUpdate>
        $E('#${pageName}_button_update_submit').on('click', function () {
            let form = $E('#${pageName}_form_update');
            gh.utils.trimForm(form);
            if (!form.validator('doSubmitCheck')) return;
            let _param = util.form.serializeJson(form);
            gh.api.${contextPath}.${lowEntityName}.update(
                {
                    data: _param
                },
                function (result) {
                    if (result.code === '00000') {
                        util.form.reset(form);
                        $E('#${pageName}_modal_update').modal('hide');
                        $E('#${pageName}_table_list').bootstrapTable('refresh');
                    }
                }
            );
        });
        </#if>

        <#if pageAdd>
        $E('#${pageName}_button_add').on('click', function () {
            let form = $E('#${pageName}_form_add');
            form.validator('destroy');
            util.form.reset(form);
            util.form.validator.init(form);
            $E('#${pageName}_modal_add').modal('show');
        });

        $E('#${pageName}_button_add_submit').on('click', function () {
            let form = $E('#${pageName}_form_add');
            gh.utils.trimForm(form);
            if (!form.validator('doSubmitCheck')) return;
            let _param = util.form.serializeJson(form);
            gh.api.${contextPath}.${lowEntityName}.add(
                {
                    data: _param
                },
                function (result) {
                    if (result.code == '00000') {
                        util.form.reset(form);
                        $E('#${pageName}_modal_add').modal('hide');
                        $E('#${pageName}_table_list').bootstrapTable('refresh');
                    }
                }
            );
        });
        </#if>

    })
})();
