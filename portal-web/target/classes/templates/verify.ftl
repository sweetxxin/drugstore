<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="author" content="order by xxin"/>
    <title>益和药房-个人中心</title>
    <link rel="stylesheet" type="text/css" href="/web/static/css/header.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/self_info.css">
    <link rel="stylesheet" type="text/css" href="/web/static/layui/css/layui.css">
    <style>
        .my-verify{
            color:#ff6700!important;font-weight:bold;
        }
        .verify-btn{
            margin: 0px auto;
            display: block;
            width: 150px;
            margin-top: 100px;
        }
    </style>
</head>
<body>
 <#include "common/header.ftl"/>
<div id="app" class="grzxbj">
    <div class="selfinfo center">
        <#include "common/left-nav.ftl"/>
        <div class="rtcont fr">
            <div class="grzlbt ml40">
                实名认证
            </div>
            <div class="subgrzl ml40">
                <span>姓名</span>
                <span><input type="text" v-model="userInfo.name"></span>
            </div>
            <div class="subgrzl ml40">
                <span>身份证号</span>
                <span><input type="number"  v-model="userInfo.idNum"></span>
            </div>
            <#--<div class="layui-upload-drag" id="test10">-->
                <#--<i class="layui-icon"></i>-->
                <#--<p>点击上传，或将文件拖拽到此处</p>-->
                <#--<div class="layui-hide" id="uploadDemoView">-->
                    <#--<hr>-->
                    <#--<img src="" alt="上传成功后渲染" style="max-width: 196px">-->
                <#--</div>-->
            <#--</div>-->
            <button @click="verifyUserInfo()" class="layui-btn layui-btn-lg layui-btn-normal verify-btn">认证</button>
        </div>
        <div class="clear"></div>
    </div>
</div>
 <#include "common/footer.ftl"/>
<script src="/web/static/js/vue.js"></script>
<script src="/web/static/js/vue-resource.min.js"></script>
<script>
    var vue = new Vue({
        el: "#app",
        data: {
            userInfo:{}
        },
        mounted:function () {
            this.getUserInfo();

        },
        methods:{
            getUserInfo(){
                this.$http.get("/web/user/info").then(function (res) {
                    this.userInfo = res.body.data;
                })
            },
            verifyUserInfo(){
                var idcardReg = /^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$|^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/;
                if(!idcardReg.test(this.userInfo.idNum)) {
                    alert("请输入有效身份证号");
                    return;
                }
                this.$http.post("/web/user/info/verify",
                        {"name":this.userInfo.name,"idNum":this.userInfo.idNum},
                {emulateJSON: true}).then(function (res) {
                    alert("认证成功");
                    window.history.back(-1);
                })
            }
        }
    })
</script>
</body>
</html>