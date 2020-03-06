<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房卖家平台</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
    <style>
        .myOrder{
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
            <table id="orderTable" lay-filter="orderTable"></table>
        </div>
    </div>
    <script type="text/html" id="operation">
        <a class="layui-btn layui-btn-xs" lay-event="detail">详情</a>
    </script>
<#include "common/footer.ftl"/>
</div>
<script src="/admin/static/js/jquery-1.8.3.min.js"></script>
<script src="/admin/static/frame/layui/layui.js"></script>
<script>
    $(document).ready(function () {
        $('#left-nav-1').html("全部订单");
        $('#left-nav-1-child')
                .append("<dd><a href='/admin/page/order-to-deal'>新订单</a>" + "</dd>")
                .append("<dd><a href='/admin/page/order-prepare'>揽件中</a>" + "</dd>")
                .append("<dd><a href='/admin/page/order-transport'>运输中</a>" + "</dd>")
                .append("<dd><a style='color:white;background: #009688;' href='/admin/page/order-receive'>待收货</a>" + "</dd>")
                .append("<dd><a href='/admin/page/order-comment'>待评论</a>" + "</dd>")
                .append("<dd><a href='/admin/page/order-finish'>已完成</a>" + "</dd>")
    })
    layui.use('element', function(){
        var element = layui.element;
    });
    layui.use('table', function(){
        var table = layui.table;
        //第一个实例
        table.render({
            elem: '#orderTable'
            ,height: 400
            ,url: '/admin/order/status/4' //数据接口
            ,page: true //开启分页
            ,parseData: function(res){ //res 即为原始返回的数据
                for(var r in res.data.content){
                    res.data.content[r].totalPrice="￥"+parseFloat(res.data.content[r].totalPrice).toFixed(2);
                    res.data.content[r].toAddressInfo= res.data.content[r].delivery.toAddress.province+res.data.content[r].delivery.toAddress.city+res.data.content[r].delivery.toAddress.town+res.data.content[r].delivery.toAddress.detail;
                }
                return {
                    "code": 0, //解析接口状态
                    "msg": res.message, //解析提示文本
                    "count": res.data.totalElements, //解析数据长度
                    "data": res.data.content //解析数据列表,
                };
            }
            ,request: {
                pageName: 'index' //页码的参数名称，默认：page
                ,limitName: 'size' //每页数据量的参数名，默认：limit
            }
            ,cols: [[ //表头
                {field: 'orderNo', title: '订单编号', width:160, sort: true, fixed: 'left'}
                ,{field:'d.user.name', title: '用户名', width: 147,templet: '<div>{{d.user.name}}</div>'}
                ,{field: 'status', title: '订单状态', width:120}
                ,{field: 'totalPrice', title: '金额', width:100, sort: true}
                ,{field:"toAddressInfo",title:'收货地址',width:200}
                ,{field: 'createTime', title: '创建时间', width:170}
                ,{title:"操作",toolbar:"#operation",width:130}
            ]],
            toolbar:true
        });
        table.on('tool(orderTable)', function(obj){
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var tr = obj.tr; //获得当前行 tr 的 DOM 对象（如果有的话）
            if(layEvent === 'detail'){ //查看
                layer.open({
                    type: 2,
                    content: "/admin/page/order/detail?id="+data.mainId,
                    title:"订单详情",
                    area:['700px','450px']
                });
            } else if(layEvent === 'check'){ //
                var mainId = data.mainId;
                $.get("/admin/order/"+mainId+"/update",{},function (res) {
                    if(res.success){
                        layer.msg("订单已确认")
                        obj.del();
                    }
                })
            }
        });
    });

</script>