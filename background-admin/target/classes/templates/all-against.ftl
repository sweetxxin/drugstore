<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房-后台管理</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
    <style>
        .allAgainst{
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
            <table id="productTable" lay-filter="productTable"></table>
        </div>
    </div>
</div>
</body>
<script type="text/html" id="operation">
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="off">隐藏</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="off">忽略</a>
</script>
<script src="/admin/static/frame/layui/layui.js"></script>
<script src="/admin/static/js/jquery-1.8.3.min.js"></script>
<script>
    $(document).ready(function () {
        $('#left-nav-1').html("全部药店");
        $('#left-nav-1-child')
                .append("<dd><a style='color:white;background: #009688;' href='/admin/page/product-on'>待处理</a>" + "</dd>")
                .append("<dd><a href='/admin/page/product-off'>已处理</a>" + "</dd>")
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
            ,url: '/user/against/all' //数据接口
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
                {field:'d.user.name', title: '举报人', width: 147,templet: '<div>{{d.user.name}}</div>'}
                ,{field: 'detail', title: '举报原因', width:300}
                ,{field: 'item', title: '举报项目', width:300}
                ,{field: 'createTime', title: '举报时间', width:160,sort:true}
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
                    // layer.msg('添加');
                    window.location="/admin/page/product-add";
                    break;
                case 'delete':
                    layer.msg('删除');
                    break;
            };
        });
        table.on('tool(productTable)', function(obj){
            var data = obj.data; //获得当前行数据
            switch(obj.event){
                case 'save':
                    updateInfo(obj.data,function () {
                        layer.msg('修改成功');
                    });
                    break;
                case 'off':
                    obj.data.isShow=0;
                    updateInfo(obj.data,function () {
                        layer.msg('下架成功');
                        obj.del();
                    });
                    break;
                case 'detail':
                    localStorage.setItem("selectedProduct",JSON.stringify(obj.data));
                    window.location = "/admin/page/product/"+obj.data.mainId+"/detail";
                    break;
            };
        })
    });
    function updateInfo(data,callback) {
        $.ajax({
            type: "POST",
            url: "/admin/product/info/update",
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