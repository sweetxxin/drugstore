<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>订单评价</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" type="text/css" href="/web/static/layui/css/layui.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/header.css">
    <style>
       .success-div{
           text-align: center;
           margin-top: 50px;
           font-size: 20px;
       }
        .to-comment{
            text-align: center;
            margin-top: 30px;
            font-size: 18px;
        }
        .to-comment img{
            height: 30px;
            width: 30px;
        }
        .to-comment a:hover{
            color: red;
        }
    </style>
</head>
<body>
 <#include "common/header.ftl"/>
    <div class="success-div">
        <img src="/resource/static/img/finish.png">
        <p>订单已完成</p>
    </div>
    <div class="to-comment">
        <#--<img src="/resource/static/img/comment.png">-->
        <i onclick="toComment()" style="margin-right: 10px;cursor: pointer" class="layui-icon  layui-icon-dialogue">去评价</i>
        <i onclick="back()" style="cursor: pointer"  class="layui-icon layui-icon-return">返回</i>
    </div>
<script src="/web/static/js/jquery-1.8.3.min.js"></script>
<script>
    var orderId = "";
    window.onload = function (ev) {
        orderId = getQueryValue("id");
        if (orderId==null){
            window.location = "/web/page/order";
        }
    }
    function back() {
        // window.history.back(-1);
        window.location = "/web/page/order"
    }
    function toComment() {
        window.location = "/web/page/assessment?id="+orderId;
    }
    function getQueryValue(queryName) {
        var query = decodeURI(window.location.search.substring(1));
        var vars = query.split("&");
        for (var i = 0; i < vars.length; i++) {
            var pair = vars[i].split("=");
            if (pair[0] == queryName) { return pair[1]; }
        }
        return null;
    }
</script>
</body>
</html>