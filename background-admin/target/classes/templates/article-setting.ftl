<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房-后台管理</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
    <style>
        .myWeb{
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
    <a class="layui-btn layui-btn-xs" lay-event="del">删除</a>
</script>
<script src="/admin/static/frame/layui/layui.js"></script>
<script>
    $(document).ready(function () {
        $('#left-nav-1').html("我的网站");
        $('#left-nav-1-child')
                .append("<dd><a href='/admin/page/rotation-setting'>首页轮播图</a>" + "</dd>")
                .append("<dd><a style='color:white;background: #009688;'  href='/admin/page/article-setting'>文章设置</a>" + "</dd>")
                .append("<dd><a href='/admin/page/article-setting'>热销药品</a>" + "</dd>")
                .append("<dd><a href='/admin/page/article-setting'>推荐药品</a>" + "</dd>")
                .append("<dd><a href='/admin/page/article-setting'>精选药品</a>" + "</dd>");
    })
    layui.use('element', function(){
        var element = layui.element;
    });
    layui.use('table', function(){
        var table = layui.table;
        //第一个实例
        table.render({
            elem: '#productTable'
            ,height: 420
            ,url: '/user/ad/article' //数据接口
            ,page: false //开启分页
            ,toolbar: 'default'
            ,cols: [[ //表头
                {field: 'title',edit:true, title: '文章分类', width:160, sort: true, fixed: 'left'}
                ,{field: 'content',edit:true, title: '标题', width:320,sort:true}
                ,{field: 'url',edit:true, title: '链接', width:350}
                ,{title:"操作",toolbar:"#operation",width:200}
            ]]
        });
        //监听事件
        table.on('toolbar(productTable)', function(obj){
            var data = obj.data; //获得当前行数据
            var checkStatus = table.checkStatus(obj.config.id);
            switch(obj.event){
                case 'add':
                    layer.open({
                        type:2,
                        content:"",
                        title: '添加文章'
                    })
                    // layer.msg('添加成功')
                    break;
            }
        });
        table.on('tool(productTable)', function(obj){
            var data = obj.data; //获得当前行数据
            switch(obj.event){
                case 'save':
                    updateInfo("/user/ad/article/update",obj.data,function () {
                        layer.msg('修改成功');
                    });
                    break;
                case 'del':
                    layer.confirm('确定删除吗？', {icon: 3, title:'警告'}, function(index){
                        updateInfo("/user/ad/article/del",obj.data,function () {
                            layer.msg('删除成功');
                            obj.del();
                        });
                        layer.close(index);
                    });
                    break;
                case 'detail':
                    layer.open({
                        type: 2,
                        content: obj.data.url
                        ,area: ['700px', '500px']
                    })
                    break;
            }
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
                if (callback!=null){
                    callback();
                }
            }
        })
    }
</script>
</html>