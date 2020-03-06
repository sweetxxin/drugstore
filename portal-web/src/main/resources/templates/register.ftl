<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
        <meta name="author" content="order by dede58.com"/>
		<title>用户注册</title>
		<link rel="stylesheet" type="text/css" href="/static/css/login.css">
	</head>
	<body>
		<form  method="post" action="./regist.php">
		<div class="regist">
			<div class="regist_center">
				<div class="regist_top">
					<div class="left fl">会员注册</div>
					<div class="right fr"><a href="/page/index" target="_self">京鲜生</a></div>
					<div class="clear"></div>
					<div class="xian center"></div>
				</div>
				<div class="regist_main center">
					<div class="username">用&nbsp;&nbsp;户&nbsp;&nbsp;名:&nbsp;&nbsp;<input class="shurukuang" type="text" name="username" placeholder="请输入你的用户名"/><span>请不要输入汉字</span></div>
					<div class="username">密&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码:&nbsp;&nbsp;<input class="shurukuang" type="password" name="password" placeholder="请输入你的密码"/><span>请输入6位以上字符</span></div>
					
					<div class="username">确认密码:&nbsp;&nbsp;<input class="shurukuang" type="password" name="repassword" placeholder="请确认你的密码"/><span>两次密码要输入一致哦</span></div>
					<div class="username">手&nbsp;&nbsp;机&nbsp;&nbsp;号:&nbsp;&nbsp;<input class="shurukuang" type="text" name="mobile" placeholder="请填写正确的手机号"/><span>填写下手机号吧，方便我们联系您！</span></div>
					<div class="username">
						<div class="left fl">验&nbsp;&nbsp;证&nbsp;&nbsp;码:&nbsp;&nbsp;<input class="yanzhengma" type="text" name="verifyCode" placeholder="请输入验证码"/></div>
						<div  onclick="changeVerifyCode()" class="right fl"><img id="verifyCode" src=""></div>
						<div class="clear"></div>
					</div>
				</div>
				<div class="regist_submit">
					<input class="submit" type="button" onclick="register()" name="submit" value="立即注册" >
				</div>
				
			</div>
		</div>
		</form>
	</body>
    <script src="/static/js/jquery-1.8.3.min.js"></script>
    <script>
		window.onload=function (ev) {
            changeVerifyCode();
		}
        function changeVerifyCode() {
            document.getElementById("verifyCode").src = "/verifyCode?type=reg&"+new Date().getTime();
        }
        function register() {
            $.post("/register",
                    {
                        "username": $("input[name='username']").val(),
                        "password": $("input[name='password']").val(),
                        "verifyCode": $("input[name='verifyCode']").val(),
						"mobile":$("input[name='mobile']").val()
                    },
                    function (res) {
                		if (res.success){
                            var c = confirm(res.message+" 自动跳转中...");
                            if (c){
                                setTimeout(function () {
                                    window.location = "/page/login";
                                },1000)
							} else {
                                window.reload();
							}
						} else {
                            alert(res.message)
						}
                        console.log(res)
                    }
            )
        }
    </script>
</html>