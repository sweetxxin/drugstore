<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房-卖家平台</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
    <style>
        .myShop{
            color: white !important;
            background: #5FB878;
        }
    </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
<#include "common/top-nav.ftl"/>
<#include "common/left-nav.ftl"/>
    <div id="app" class="layui-body">
        <!-- 内容主体区域 -->
        <div style="padding: 15px;">
            <table id="customerTable" lay-filter="customerTable"></table>
        </div>
    </div>
<#include "common/footer.ftl"/>
</div>
<script src="/admin/static/js/jquery-1.8.3.min.js"></script>
<script src="/admin/static/js/vue.js"></script>
<script src="/admin/static/js/vue-resource.min.js"></script>
<script src="/admin/static/frame/layui/layui.js"></script>
<script>
    var vue = new Vue({
        el: "#app",
        data: {
            shopInfo: {},
            isDisplay: false
        },
        mounted:function () {
            $('#left-nav-1').html("我的商店");
    $('#left-nav-1-child')
            .append("<dd><a  href='/admin/page/shop'>基本信息</a>" + "</dd>")
            .append("<dd><a style='color:white;background: #009688;' href='/admin/page/customer'>商店用户</a>" + "</dd>")
            .append("<dd><a href='/admin/page/shop-activity'>商店活动</a>" + "</dd>")
            .append("<dd><a href='/admin/page/shop-delivery'>物流信息</a>" + "</dd>");
        }
    })
    layui.use(['table','element'], function(){
        var table = layui.table;
        var element = layui.element;
        //第一个实例
        table.render({
            elem: '#customerTable'
            ,height: 400
            ,url: '/admin/shop/customer' //数据接口
            ,page: true //开启分页
            ,parseData: function(res){ //res 即为原始返回的数据
               for (var i in res.data.content){
                   if (res.data.content[i]!=null){
                       if (res.data.content[i].gender==1){
                           res.data.content[i].gender="男"
                       }else{
                           res.data.content[i].gender="女";
                       }
                   }
               }
                return {
                    "code":  0, //解析接口状态
                    "msg": "加载中", //解析提示文本
                    "data": res.data.content, //解析数据列表,
                    "count": res.data.totalElements,//解析数据长度
                };
            }
            ,request: {
                pageName: 'index'
                ,limitName: 'size'
            }
            ,cols: [[ //表头
                {field: 'username', title: '用户名', width:140, sort: true, fixed: 'left'}
                ,{field: 'name', title: '姓名', width:140}
                ,{field: 'nickName', title: '昵称', width:140, }
                ,{field: 'mobile', title: '手机号', width:120}
                ,{field: 'gender', title: '性别', width: 80}
                ,{field: 'email', title: '邮箱', width: 150, sort: true}
                ,{field: 'hobby', title: '爱好', width: 200, sort: true}
            ]]
        });
    });
</script>