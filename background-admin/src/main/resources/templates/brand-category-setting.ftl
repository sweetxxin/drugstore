<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房-后台管理</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
    <style>
        .categorySetting{
            color: white !important;
            background: #5FB878;
        }
    </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
<#include "common/top-nav.ftl"/>
   <#include "common/left-nav.ftl"/>
    <div class="layui-body">
        <!-- 内容主体区域 -->
        <div style="padding: 15px;">
            <div class="demoTable">
                <div class="layui-inline">
                    <input class="layui-input" name="id" id="demoReload" autocomplete="off">
                </div>
                <button class="layui-btn" data-type="reload">搜索</button>
            </div>
            <table id="productTable" lay-filter="productTable"></table>
        </div>
    </div>
</div>
</body>
<script type="text/html" id="operation">
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="save">保存</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
<script src="/admin/static/frame/layui/layui.js"></script>
<script src="/admin/static/js/jquery-1.8.3.min.js"></script>
<script>
    $(document).ready(function () {
        $('#left-nav-1').html("全部分类");
        $('#left-nav-1-child')
                .append("<dd><a href='/admin/page/first-category-setting'>第一级分类</a>" + "</dd>")
                .append("<dd><a href='/admin/page/second-category-setting'>第二级分类</a>" + "</dd>")
                .append("<dd><a href='/admin/page/third-category-setting'>第三级分类</a>" + "</dd>")
                .append("<dd><a href='/admin/page/form-category-setting'>药品剂型</a>" + "</dd>")
                .append("<dd><a href='/admin/page/material-category-setting'>药品原料</a>" + "</dd>")
                .append("<dd><a href='/admin/page/use-category-setting'>症状/用途</a>" + "</dd>")
                .append("<dd><a style='color:white;background: #009688;'  href='/admin/page/brand-category-setting'>药品品牌</a>" + "</dd>")
    })
    //JavaScript代码区域
    layui.use('element', function(){
        var element = layui.element;
    });
    layui.use('table', function(){
        var table = layui.table;
        //第一个实例
        table.render({
            elem: '#productTable'
            ,height: 420
            ,url: '/product/category/1000/list' //数据接口
            ,page: true //开启分页
            ,parseData: function(res){ //res 即为原始返回的数据

                return {
                    "code": 0, //解析接口状态
                    "msg": res.message, //解析提示文本
                    "count": res.data.totalElements, //解析数据长度
                    "data": res.data.content //解析数据列表
                };
            }
            ,request: {
                pageName: 'index' //页码的参数名称，默认：page
                ,limitName: 'size' //每页数据量的参数名，默认：limit
            },
            toolbar: 'default'
            ,cols: [[ //表头
                {field:'type', title: '类型', width: 147}
                ,{field: 'name', edit:true,title: '名称', width:300}
                ,{field: 'description',edit:true, title: '描述', width:160}
                ,{field: 'd.parent.name',templet: '<div>{{d.parent.name}}</div>',title: '父类', width:300}
                ,{title:"操作",toolbar:"#operation",width:120}
            ]]
            ,id: 'productTableRender'
        });
        //监听事件
        table.on('toolbar(productTable)', function(obj){
            var data = obj.data; //获得当前行数据
            var checkStatus = table.checkStatus(obj.config.id);
            switch(obj.event){
                case 'add':
                    layer.open({
                        title:"新增品牌分类",
                        type:2,
                        area:['676px','400px'],
                        content:"/admin/page/popCategory?type=1000"
                    });
                    break;
            };
        });
        table.on('tool(productTable)', function(obj){
            var data = obj.data; //获得当前行数据
            switch(obj.event){
                case 'save':
                    updateInfo('/product/category/add',obj.data,function () {
                        layer.msg('修改成功');
                    });
                    break;
                case 'del':
                    layer.confirm('确定删除?', {icon: 3, title:'提示'}, function(index){
                        updateInfo("/product/category/del",obj.data,function () {
                            layer.msg('删除成功');
                            obj.del();
                            layer.close(index);
                        });
                    });
                    break;
            };
        })
    });
    function updateInfo(url,data,callback) {
        $.ajax({
            type: "POST",
            url: url,
            contentType: "application/json",
            dataType: "json",
            data: JSON.stringify(data),
            success:function (res) {
                if (res.success&&callback!=null){
                    callback();
                }
            }
        })
    }
</script>
</html>