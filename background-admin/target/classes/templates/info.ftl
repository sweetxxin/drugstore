<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房-后台管理</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <#include "common/top-nav.ftl"/>
    <#include "common/left-nav.ftl"/>
    <div id="app" class="layui-body">
        <!-- 内容主体区域 -->
        <div style="padding: 15px;">
            <form class="layui-form" action="">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">头像</label>
                        <img  id="test1" style="height: 80px;width: 80px" :src="avatar">
                        <p style="text-align: right;color: #cc5b5b;">点击头像更换</p>
                        <#--<button type="button" class="layui-btn" >-->
                            <#--<i class="layui-icon">&#xe67c;</i>更换头像-->
                        <#--</button>-->
                    </div>
                </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">姓名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="phone" v-model="info.name" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">昵称</label>
                    <div class="layui-input-inline">
                        <input type="text" v-model="info.nickName" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">手机号</label>
                    <div class="layui-input-inline">
                        <input type="tel" v-model="info.mobile" name="phone" lay-verify="required|phone" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">邮箱</label>
                    <div class="layui-input-inline">
                        <input type="text" v-model="info.email" name="email" lay-verify="email" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">爱好</label>
                    <div class="layui-input-inline">
                        <input type="text" v-model="info.hobby" name="phone"  autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">性别</label>
                    <div class="layui-input-block">
                        <input lay-filter="switchTest" :checked="isMan" type="checkbox" name="close" lay-skin="switch" lay-text="男|女">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">座右铭</label>
                <div class="layui-input-block">
                    <input type="text" v-model="info.slogan" name="title" lay-verify="title" autocomplete="off" class="layui-input">
                </div>
            </div>
            </form>
            <button style="margin: 0px auto;display: block;width: 150px;" @click="updateInfo()" class="layui-btn layui-btn-lg layui-btn-normal">更新</button>
        </div>
    </div>
    <#include "common/footer.ftl"/>
</div>
<script src="/admin/static/frame/layui/layui.js"></script>
<script src="/admin/static/js/vue.js"></script>
<script src="/admin/static/js/vue-resource.min.js"></script>
<script>
    var vue = new Vue({
        el:"#app",
        data:{
            info:{},
            isMan:false,
            avatar:"http://t.cn/RCzsdCq"
        },
        mounted:function () {
            var _self = this;
            layui.use(['element','form','upload'], function(){
                var element = layui.element;
                var form = layui.form;
                form.on('switch(switchTest)', function(data){
                    if (this.checked) {
                        _self.info.gender=1
                    }else{
                        _self.info.gender=0;
                    }
                });
                var upload = layui.upload;
                var uploadInst = upload.render({
                    elem: '#test1' //绑定元素
                    ,url: '/resource/upload/' //上传接口
                    ,choose:function (obj){
                        obj.preview(function (index, file, result) {
                            _self.avatar=result;
                            _self.$forceUpdate();
                        })
                    }
                    ,done: function(res){
                       _self.avatar='/resource/static'+ res.data[0];
                    }
                    ,error: function(){
                        //请求异常回调
                    }
                });
            });
            this.getUserInfo();
        },
        methods:{
            getUserInfo(){
                this.$http.get("/admin/keeper/info").then(function (res){
                    this.info = res.body.data;
                    if (this.info.gender==1){
                        this.isMan=true;
                    }
                    if (this.info.avatar){
                        this.avatar=this.info.avatar;
                    }
                })
            },
            updateInfo(){
                this.info.avatar=this.avatar;
                this.$http.post("/admin/keeper/info/update",JSON.stringify(this.info)).then(function (res){
                    if (res.body.success){
                        layer.msg("更新成功")
                        window.location.reload();
                    }
                })
            }
        }
    })
</script>
</body>
</html>