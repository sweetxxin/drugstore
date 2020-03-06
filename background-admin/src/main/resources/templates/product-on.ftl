<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房后台管理</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
    <style>
        .myProduct{
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
    <a class="layui-btn layui-btn-xs" lay-event="detail">详情</a>
    <a class="layui-btn layui-btn-xs" lay-event="save">保存</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="off">下架</a>
</script>
<script src="/admin/static/frame/layui/layui.js"></script>
<script src="/admin/static/js/jquery-1.8.3.min.js"></script>
<script>
    $(document).ready(function () {
        $('#left-nav-1').html("我的商品");
        $('#left-nav-1-child')
                .append("<dd><a style='color:white;background: #009688;' href='/admin/page/product-on'>上架商品</a>" + "</dd>")
                .append("<dd><a href='/admin/page/product-off'>下架商品</a>" + "</dd>")
                .append("<dd><a  href='/admin/page/product-add'>新增商品</a>" + "</dd>")
                .append("<dd><a href='/admin/page/product-expand'>进货</a>" + "</dd>")
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
            ,url: '/admin/product/on/list' //数据接口
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
                {field: 'productNo', title: '商品编号', width:140, sort: true, fixed: 'left'}
                ,{field: 'sales', title: '销量', width:88,sort:true}
                ,{field: 'name',edit:true, title: '商品名称', width:230}
                ,{field: 'keywords', edit:true,title: '关键词', width: 180}
                ,{field: 'description',edit:true, title: '描述', width:230},
                ,{title:"操作",toolbar:"#operation",width:180}
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