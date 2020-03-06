<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房-卖家平台</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
    <style>
        .myInform{
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
            <table id="orderTable" lay-filter="orderTable"></table>
        </div>
    </div>
    <script type="text/html" id="operation">
        <a class="layui-btn layui-btn-xs" lay-event="detail">详情</a>
        <a class="layui-btn layui-btn-xs" lay-event="read">已读</a>
    </script>
<#include "common/footer.ftl"/>
</div>
<script src="/admin/static/js/jquery-1.8.3.min.js"></script>
<script src="/admin/static/frame/layui/layui.js"></script>
<script>
    $(document).ready(function () {
        $('#left-nav-1').html("全部通知");
        $('#left-nav-1-child')
                .append("<dd><a style='color:white;background: #009688;'  href='/admin/page/inform-new'>新通知</a>" + "</dd>")
                .append("<dd><a  href='/admin/page/inform-read'>已读通知</a>" + "</dd>")
    })
    layui.use(['table','element'], function(){
        var table = layui.table;
        var element = layui.element;
        //第一个实例
        table.render({
            elem: '#orderTable'
            ,height: 400
            ,url: '/admin/user/inform/new' //数据接口
            ,page: true //开启分页
            ,parseData: function(res){ //res 即为原始返回的数据
                for(var r in res.data.content){
                    if (res.data.content[r].isRead==null){
                        res.data.content[r].isRead="未读";
                    }
                }
                return {
                    "code": 0, //解析接口状态
                    "msg": res.message, //解析提示文本
                    "count": res.data.totalElements,//解析数据长度
                    "data": res.data.content //解析数据列表,
                };
            }
            ,request: {
                pageName: 'index' //页码的参数名称，默认：page
                ,limitName: 'size' //每页数据量的参数名，默认：limit
            }
            ,cols: [[ //表头
                {field:'d.creator.name', title: '创建人', width: 160,templet: '<div>{{d.creator.name}}</div>'}
                ,{field: 'title', title: '标题', width:180}
                ,{field: 'outline', title: '简要', width:285}
                ,{field: 'createTime', title: '创建时间', width:170,sort: true}
                ,{field: 'isRead', title: '状态', width:100}
                ,{title:"操作",toolbar:"#operation",width:130}
            ]],
            toolbar:true
        });
        table.on('tool(orderTable)', function(obj){
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var tr = obj.tr; //获得当前行 tr 的 DOM 对象（如果有的话）
            if(layEvent === 'detail'){ //查看
                var inform = data;
                layer.open({
                    type: 1
                    ,title: inform.title //不显示标题栏
                    ,closeBtn: false
                    ,area: '400px;'
                    ,shade: 0.8
                    ,id: 'LAY_layuipro' //设定一个id，防止重复弹出
                    ,btn: ['朕知道了']
                    ,btnAlign: 'c'
                    ,moveType: 0 //拖拽模式，0或者1
                    ,content: '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">纲要：'+inform.outline+'<br>内容：'+inform.content+'<br>创建时间：'+inform.createTime+'<br>创建人：'+inform.creator.name+'<br><br></div>'
                    ,success: function(layero){
                        data.isRead=1;
                        $.ajax({
                            type:"post",
                            contentType:"application/json",
                            dataType:"json",
                            url:"/admin/user/read/inform",
                            data:JSON.stringify(data),
                            success:function (res) {
                                if(res.success){
                                    obj.del();
                                    header.countInform();
                                }
                            }
                        })
                    }
                });
            } else if(layEvent === 'read'){ //
                data.isRead=1;
                $.ajax({
                    type:"post",
                    contentType:"application/json",
                    dataType:"json",
                    url:"/admin/user/read/inform",
                    data:JSON.stringify(data),
                    success:function (res) {
                        if(res.success){
                            layer.msg("已读");
                            obj.del();
                            header.countInform();
                        }
                    }
                })
            }
        });
    });

</script>