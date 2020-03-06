<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="author" content="order by xxin"/>
    <title>益和药房-个人中心</title>
    <link rel="stylesheet" type="text/css" href="/web/static/css/header.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/self_info.css">
    <style>
        .my-center{
            color:#ff6700!important;font-weight:bold;
        }
    </style>
</head>
<body>
<!-- start header -->
 <#include "common/header.ftl"/>
<!--end header -->
<#--<#include  "common/search.ftl"/>-->
<!-- self_info -->
<div id="app" class="grzxbj">
    <div class="selfinfo center">
        <#include "common/left-nav.ftl"/>
        <div class="rtcont fr">
            <div class="grzlbt ml40">
                我的资料
                <button @click="updateUserInfo()" class="update-btn">更新</button>
            </div>

            <div class="subgrzl ml40">
                <span>姓名</span>
                <span><input type="text" ref="name" :readonly="!editStatus.name.editable" v-model="userInfo.name"></span>
                <span><a @click="changeStatus('name')" :style="editStatus.name.style">{{editStatus.name.text}}</a></span>
            </div>
            <div class="subgrzl ml40">
                <span>昵称</span>
                <span><input :readonly="!editStatus.nickName.editable" ref="nickName"  type="text" v-model="userInfo.nickName"></span>
                <span><a @click="changeStatus('nickName')" :style="editStatus.nickName.style">{{editStatus.nickName.text}}</a></span>
            </div>
            <div class="subgrzl ml40">
                <span>性别</span>
                <span><input :readonly="!editStatus.gender.editable" ref="gender"  type="text" v-model="userInfo.gender"></span>
                <span><a  @click="changeStatus('gender')" :style="editStatus.gender.style">{{editStatus.gender.text}}</a></span>
            </div>
            <div class="subgrzl ml40">
                <span>手机号</span>
                <span><input :readonly="!editStatus.mobile.editable" ref="mobile"  type="text" v-model="userInfo.mobile"></span>
                <span><a  @click="changeStatus('mobile')" :style="editStatus.mobile.style">{{editStatus.mobile.text}}</a></span>
            </div>
            <div class="subgrzl ml40">
                <span>邮箱</span>
                <span><input :readonly="!editStatus.email.editable" ref="email"  type="text" v-model="userInfo.email"></span>
                <span><a  @click="changeStatus('email')" :style="editStatus.email.style">{{editStatus.email.text}}</a></span>
            </div>
            <div class="subgrzl ml40">
                <span>个性签名</span>
                <span><input :readonly="!editStatus.slogan.editable" ref="slogan"  type="text" v-model="userInfo.slogan"></span>
                <span><a  @click="changeStatus('slogan')" :style="editStatus.slogan.style">{{editStatus.slogan.text}}</a></span>
            </div>
            <div class="subgrzl ml40">
                <span>我的爱好</span>
                <span><input :readonly="!editStatus.hobby.editable" ref="hobby"  type="text" v-model="userInfo.hobby"></span>
                <span><a  @click="changeStatus('hobby')" :style="editStatus.hobby.style">{{editStatus.hobby.text}}</a></span>
            </div>
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
            userInfo:{},
            editStatus:{
                name:{
                    editable:false,
                    text:"编辑",
                    style:"",
                    focus:false
                },
                nickName:{
                    editable:false,
                    text:"编辑",
                    style:"",
                    focus:false
                },
                gender:{
                    editable:false,
                    text:"编辑",
                    style:"",
                    focus:false
                },
                mobile:{
                    editable:false,
                    text:"编辑",
                    style:"",
                    focus:false
                },
                slogan:{
                    editable:false,
                    text:"编辑",
                    style:"",
                    focus:false
                },
                hobby:{
                    editable:false,
                    text:"编辑",
                    style:"",
                    focus:false
                },
                email:{
                    editable:false,
                    text:"编辑",
                    style:"",
                    focus:false
                }
            }
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
            updateUserInfo(){
                this.$http.post("/web/user/info/update",
                        JSON.stringify(this.userInfo),
                {emulateJSON: true}).then(function (res) {
                    alert("更新成功")
                    location. reload();
                })
            },
            changeStatus(key){
                if (!this.editStatus[key].editable) {
                    this.editStatus[key].style = "color:red";
                    this.editStatus[key].text = "确定";
                    this.$refs[key].focus();
                }else{
                    this.editStatus[key].style = "";
                    this.editStatus[key].text = "编辑";
                }
                this.editStatus[key].editable=!this.editStatus[key].editable;
            }
        }
    })
</script>
</body>
</html>