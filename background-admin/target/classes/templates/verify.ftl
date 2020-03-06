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
            <form class="layui-form" style="margin-top: 20px;text-align: center">
                <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">姓名</label>
                    <div style="width: 500px;" class="layui-input-inline">
                        <input type="text" v-model="verifyInfo.name" autocomplete="off" class="layui-input">
                    </div>
                </div>
                </div>
                <div class="layui-form-item">
                    <div  class="layui-inline">
                        <label class="layui-form-label">身份证号</label>
                        <div style="width: 500px;" class="layui-input-inline">
                            <input type="number"  v-model="verifyInfo.idNum"   class="layui-input">
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div style="vertical-align: text-top;" class="layui-inline">
                        <label class="layui-form-label">营业执照</label>
                        <button type="button" class="layui-btn" id="license">
                            <i class="layui-icon">&#xe67c;</i>上传
                        </button>
                        <div class="upload-1" style="margin-top: 20px;text-align: center;margin-left: 30px">
                            <img class="layui-upload-img" style="max-height: 250px;max-width: 150px;" id="license-img">
                            <p id="license-text"></p>
                        </div>
                    </div>
                    <div  style="vertical-align: text-top;" class="layui-inline">
                        <label class="layui-form-label">药品授权</label>
                        <button type="button" class="layui-btn" id="authorize">
                            <i class="layui-icon">&#xe67c;</i>上传
                        </button>
                        <div class="upload-2" style="margin-top: 20px;text-align: center;margin-left: 30px">
                            <img class="layui-upload-img" style="max-height: 250px;max-width: 150px;" id="authorize-img">
                            <p id="authorize-text"></p>
                        </div>
                    </div>
                    <div  style="vertical-align: text-top;" class="layui-inline">
                        <label class="layui-form-label">其他</label>
                        <button type="button" class="layui-btn" id="other">
                            <i class="layui-icon">&#xe67c;</i>上传
                        </button>
                        <div class="upload-3" style="margin-top: 20px;text-align: center;margin-left: 30px">
                            <img class="layui-upload-img" style="max-height: 250px;max-width: 150px;" id="other-img">
                            <p id="other-text"></p>
                        </div>
                    </div>
                </div>
            </form>
            <button style="margin: 0px auto;display: block;width: 150px;" @click="verifyShop()" class="layui-btn layui-btn-lg layui-btn-normal">{{text}}</button>
        </div>
    </div>
    <#include "common/footer.ftl"/>
</div>
<script src="/admin/static/frame/layui/layui.js"></script>
<script src="/admin/static/js/vue.js"></script>
<script src="/admin/static/js/vue-resource.min.js"></script>
<script>
    $('#left-nav-1').html("我的商店");
    $('#left-nav-1-child')
            .append("<dd><a  href='/admin/page/shop'>基本信息</a>" + "</dd>")
            .append("<dd><a href='/admin/page/customer'>商店用户</a>" + "</dd>")
            .append("<dd><a href='/admin/page/shop-activity'>商店活动</a>" + "</dd>")
            .append("<dd><a href='/admin/page/shop-delivery'>物流信息</a>" + "</dd>")
            .append("<dd><a style='color:white;background: #009688;' href='/admin/page/verify'>商家认证</a>" + "</dd>")
    ;
    var vue = new Vue({
        el:"#app",
        data:{
            verifyInfo:{

            },
            text:"认证"
        },
        mounted:function () {
            var _self = this;
            layui.use(['element','form','upload'], function(){
                var element = layui.element;
                var form = layui.form;
                var upload = layui.upload;
                var license = upload.render({
                    elem: '#license' //绑定元素
                    ,url: '/resource/upload/' //上传接口
                    ,auto:false
                    ,choose:function (obj){
                        obj.preview(function (index, file, result) {
                            $('#license-img').attr('src',result);
                            $('.upload-1').append('<button  type="button" class="layui-btn layui-btn-xs license-upload">点击上传</button>'
                            );
                            $('.upload-1').find('.license-upload').on('click', function () {
                                obj.upload(index, file);
                            });
                        })
                    }
                    ,done: function(res){ //上传完毕回调
                        if(res.success){
                            $('#license-text').text("上传成功");
                            $('.upload-1').find('.license-upload').remove();
                            _self.verifyInfo.license=res.data[0];
                        }
                    }
                    ,error: function(){
                    }
                });
                var authorize = upload.render({
                    elem: '#authorize' //绑定元素
                    ,url: '/resource/upload/' //上传接口
                    ,auto:false
                    ,choose:function (obj){
                        obj.preview(function (index, file, result) {
                            $('#authorize-img').attr('src',result);
                            $('.upload-2').append('<button  type="button" class="layui-btn layui-btn-xs authorize-upload">点击上传</button>'
                            );
                            $('.upload-2').find('.authorize-upload').on('click', function () {
                                obj.upload(index, file);
                            });
                        })
                    }
                    ,done: function(res){ //上传完毕回调
                        if(res.success){
                            $('#authorize-text').text("上传成功");
                            $('.upload-2').find('.authorize-upload').remove();
                            _self.verifyInfo.authorize=res.data[0];
                        }
                    }
                    ,error: function(){
                    }
                });
                var other = upload.render({
                    elem: '#other' //绑定元素
                    ,url: '/resource/upload/' //上传接口
                    ,auto:false
                    ,choose:function (obj){
                        obj.preview(function (index, file, result) {
                            $('#other-img').attr('src',result);
                            $('.upload-3').append('<button  type="button" class="layui-btn layui-btn-xs other-upload">点击上传</button>'
                            );
                            $('.upload-3').find('.other-upload').on('click', function () {
                                obj.upload(index, file);
                            });
                        })
                    }
                    ,done: function(res){ //上传完毕回调
                        if(res.success){
                            $('#other-text').text("上传成功");
                            $('.upload-3').find('.other-upload').remove();
                            _self.verifyInfo.other=res.data[0];
                        }
                    }
                    ,error: function(){
                    }
                });
            });
            this.getShopVerifyInfo();
        },
        methods:{
            getShopVerifyInfo(){
                this.$http.get("/admin/shop/verify/info").then(function (res){
                    if (res.body.success){
                        this.verifyInfo=res.body.data;
                        if (this.verifyInfo.other){
                            $('#other-img').attr('src','/resource/static'+this.verifyInfo.other)
                        }
                        if (this.verifyInfo.license){
                            $('#license-img').attr('src','/resource/static'+this.verifyInfo.license)
                        }
                        if (this.verifyInfo.authorize){
                            $('#authorize-img').attr('src','/resource/static'+this.verifyInfo.authorize)
                        }
                        if (this.verifyInfo.code==1){
                            this.text='认证成功';
                        }
                    }


                })
            },
            verifyShop(){
                console.log(this.verifyInfo)
                this.$http.post("/admin/shop/verify",JSON.stringify(this.verifyInfo)).then(function (res){
                    layui.use(['layer'], function(){
                        layui.layer.msg(res.body.message);
                    })
                })
            }
        }
    })
</script>
</body>
</html>