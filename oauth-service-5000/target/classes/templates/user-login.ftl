<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
        <meta name="author" content="order by dede58.com"/>
		<title>会员登录</title>
		<link rel="stylesheet" type="text/css" href="/oauth/static/css/login.css">
	</head>
	<body>
			<#include "common/header.ftl"/>
		<!-- login -->
		<div  class="form center">
			<div class="login">
			<div class="login_center">
				<div class="login_top">
					<div class="left fl">会员登录</div>
					<div class="right fr">您还不是我们的会员？<a href="/oauth/user/register" target="_self">立即注册</a></div>
					<div class="clear"></div>
					<div class="xian center"></div>
				</div>
				<form id="loginForm">
				<div class="login_main center">
					<div class="username">用户名:&nbsp;<input class="shurukuang" type="text" name="username" placeholder="请输入你的用户名"/></div>
					<div class="username">密&nbsp;&nbsp;&nbsp;&nbsp;码:&nbsp;<input class="shurukuang" type="password" name="password" placeholder="请输入你的密码"/></div>
					<div class="username">
						<div class="left fl">验证码:&nbsp;<input class="yanzhengma" type="text" name="code" placeholder="请输入验证码"/></div>
						<div onclick="changeVerifyCode()" class="right fl">
							<img id="verifyCode" src="">
						</div>
						<div class="clear"></div>
					</div>
				</div>
				<div class="login_submit">
					<input class="submit" onclick="login()" type="button" name="submit" value="立即登录" >
				</div>
                </form>
			</div>
		</div>
		</div>
		<#include "common/footer.ftl"/>
	</body>
<script src="/oauth/static/js/jquery-1.8.3.min.js"></script>
<script>
	window.onload = function (ev) {
	    changeVerifyCode();
	}
	function changeVerifyCode() {
		document.getElementById("verifyCode").src = "/oauth/verifyCode?"+new Date().getTime();
    }
    document.onkeydown=function(ev) {
        var event = ev || event
        if (event.keyCode == 13) {
            login();
        }
    }
	function login() {
	    $.post("/oauth/user/login",
			{
				"code": $("input[name='code']").val(),
				"username":$("input[name='username']").val(),
				"password":$("input[name='password']").val()
			},
			function (res) {
				if (res.success){
				    localStorage.setItem("token",res.token);
                    // $.ajax({
                    //     url: res.data,
                    //     data: {},
                    //     type: "GET",
                    //     async : false,
                    //     beforeSend: function(xhr){xhr.setRequestHeader('token', res.token);},//这里设置header
                    // });
                    // console.log(res.data)
				    window.location = res.data;
				} else{
				    alert(res.message);
				}
        	}
		)
    }
</script>
</html>