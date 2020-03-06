<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>登录页</title>
    <link rel="stylesheet" href="/oauth/static/layui/css/layui.css">
    <link rel="stylesheet" href="/oauth/static/css/style.css">
    <link rel="stylesheet" type="text/css" href="/oauth/static/css/login.css">
</head>
<body>
<#include "common/header.ftl"/>
<div class="login-main">
    <header style="color: white;margin-top: 50px" class="layui-elip">后台管理登录</header>
    <form method="post" class="layui-form">
        <div class="layui-input-inline">
            <input type="text" name="username" required lay-verify="required" placeholder="用户名" autocomplete="off"
                   class="layui-input">
        </div>
        <div class="layui-input-inline">
            <input type="password" name="password" required lay-verify="required" placeholder="密码" autocomplete="off"
                   class="layui-input">
        </div>
        <div class="layui-input-inline login-btn">
            <button lay-submit lay-filter="login" class="layui-btn">登录</button>
        </div>
        <hr/>
        <p ><a href="/page/register" style="color: white" class="fl">立即注册</a><a href="/oauth/user/login" style="color: white" class="fr">前端登陆</a></p>
    </form>
</div>
 <#include "common/footer.ftl"/>
<script src="/oauth/static/js/jquery-1.8.3.min.js"></script>
<script src="/oauth/static/layui/layui.js"></script>
<script type="text/javascript">

    layui.use(['form','layer','jquery'], function () {
        var form = layui.form;
        var $ = layui.jquery;
        form.on('submit(login)',function (data) {
            console.log(data.field);
            login(data.field);
            return false;
        })
    });
    document.onkeydown=function(ev) {
        var event = ev || event
        if (event.keyCode == 13) {
            login();
        }
    }
    function login(data) {
        $.ajax({
            url:'/oauth/admin/login',
            data:data,
            dataType:'json',
            type:'post',
            success:function (res) {
                console.log(res);
                if (res.success){
                    window.location = res.data;
                }else{
                    layer.msg(res.message);
                }
            }
        })
    }
    function  tryLogin(token) {
        $.ajax({
            url:'/login/try',
            data:{"token":token},
            dataType:'json',
            type:'post',
            success:function (res) {
                console.log(res)
                if (res.success){
                    location.href = "/page/index";
                }else{
                    localStorage.removeItem("fresh-access-token");
                }
            }
        })
    }
</script>
</body>
</html>