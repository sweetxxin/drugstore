<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房-后台管理</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
    <style>
        .allShop{
            color: white !important;
            background: #5FB878;
        }
        .layui-table-cell {
            height: inherit;
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
<script type="text/html" id="licenseImg">
    <img style="height:100px;width:180px;line-height:100px!important;" src="/resource/static{{ d.license}}" />
</script>
<script type="text/html" id="licenseImg">
    <img style="height:100px;width:180px;line-height:100px!important;" src="/resource/static{{ d.license}}" />
</script>
<script type="text/html" id="authorizeImg">
    <img style="height:100px;width:180px;line-height:100px!important;" src="/resource/static{{ d.authorize}}" />
</script>
<script src="/admin/static/frame/layui/layui.js"></script>
<script src="/admin/static/js/jquery-1.8.3.min.js"></script>
<script>
    $(document).ready(function () {
        $('#left-nav-1').html("全部药店");
        $('#left-nav-1-child')
                .append("<dd><a  href='/admin/page/shop-verifying'>待审核</a>" + "</dd>")
                .append("<dd><a style='color:white;background: #009688;' href='/admin/page/verify-pass'>已通过</a>" + "</dd>")
                .append("<dd><a href='/admin/page/verify-fail'>不通过</a>" + "</dd>")
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
            ,url: '/user/shop/verify/1/info' //数据接口
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
            toolbar: true
            ,cols: [[ //表头
                {field: 'idNum', title: '身份证号', width:140}
                ,{field: 'name',title: '姓名', width:100}
                ,{field: 'license',templet:'#licenseImg', title: '经营证', width:230}
                ,{field: 'license',templet:'#authorizeImg', title: '授权书', width:230}
                ,{field: 'status', title: '审核状态', width: 100}
                ,{field: 'createTime', title: '创建时间', width:100},
            ]]
        });
    });

</script>
</html>