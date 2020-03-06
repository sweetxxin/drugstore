<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
        <meta name="author" content="order by dede58.com"/>
		<title>会员登录</title>
		<link rel="stylesheet" type="text/css" href="/static/css/login.css">
	</head>
	<body>
		<!-- login -->
		<div class="top center">
			<div class="logo center">
				<a href="/page/index" target="_self"><img src="/static/image/freshstore_logo.jpg" alt=""></a>
			</div>
		</div>
		<div  class="form center">
			<div class="login">
			<div class="login_center">
				<div class="login_top">
					<div class="left fl">会员登录</div>
					<div class="right fr">您还不是我们的会员？<a href="/page/register" target="_self">立即注册</a></div>
					<div class="clear"></div>
					<div class="xian center"></div>
				</div>
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
				
			</div>
		</div>
		</div>

		<footer>
			<div class="copyright">简体 | 繁体 | English | 常见问题</div>
			<div class="copyright">京鲜生公司版权所有-京ICP备10046444-<img src="/static/image/ghs.png" alt="">京公网安备110108020201号-京ICP证110107号</div>
		</footer>
	</body>
<script src="/static/js/jquery-1.8.3.min.js"></script>
<script>
	window.onload = function (ev) {
	    changeVerifyCode();
	}
	function changeVerifyCode() {
		document.getElementById("verifyCode").src = "/verifyCode?type=login&"+new Date().getTime();
    }
	function login() {
	    $.post("/login",
			{
			    "username": $("input[name='username']").val(),
				"password": $("input[name='password']").val(),
				"code": $("input[name='code']").val(),
                "to":"index"
			},
			function (res) {
	        	if (res.success){
	        	    localStorage.setItem("fresh-access-token",res.data.accessToken);
	        	    window.location = "/page/index";
				}else{
	        	    alert(res.message);
				}
			    console.log(res)
        	}
		)
    }
</script>
</html>