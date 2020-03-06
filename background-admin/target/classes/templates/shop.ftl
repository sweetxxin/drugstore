<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房后台管理</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
    <style>
        .myShop {
            color: white !important;
            background: #5FB878;
        }
    </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
<#include "common/top-nav.ftl"/>
<#include "common/left-nav.ftl"/>
    <div id="app" class="layui-body">
        <!-- 内容主体区域 -->
        <div style="padding: 15px;margin-top: 30px;">
            <form class="layui-form" action="">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">商店名称</label>
                        <div class="layui-input-inline">
                            <input type="text" v-model="shopInfo.name" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">邮箱</label>
                        <div class="layui-input-inline">
                            <input type="text" v-model="shopInfo.email" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">联系电话</label>
                        <div class="layui-input-inline">
                            <input type="tel" v-model="shopInfo.mobile" class="layui-input">
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">网址</label>
                        <div class="layui-input-inline">
                            <input type="text" v-model="shopInfo.website" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">标语</label>
                        <div class="layui-input-inline">
                            <input type="text" v-model="shopInfo.slogan" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">发布商店</label>
                        <div class="layui-input-block">
                            <input type="checkbox" :checked="isDisplay" lay-filter="switchTest" name="switch"
                                   lay-skin="switch">
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">地址</label>
                    <div class="layui-input-block">
                        <input type="text" v-model="shopInfo.address" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item layui-form-text">
                    <label class="layui-form-label">业务描述</label>
                    <div class="layui-input-block">
                        <textarea v-model="shopInfo.description" placeholder="请输入内容" class="layui-textarea"></textarea>
                    </div>
                </div>
                <div style="margin-left: 110px;display: inline-block">
                    <button type="button" class="layui-btn" id="poster">上传宣传海报</button>
                    <div class="upload-list" style="margin-top: 20px;text-align: center;">
                        <img class="layui-upload-img" style="max-height: 250px;max-width: 150px;" id="poster-img">
                        <p id="poster-text"></p>
                    </div>
                </div>
            </form>
        </div>
        <div style="width: 216px; margin: 0 auto">
            <button type="button" @click="updateShopInfo()" class="layui-btn layui-btn-fluid">更新</button>
        </div>

    </div>
<#--<#include "common/footer.ftl"/>-->
</div>
<script src="/admin/static/frame/layui/layui.js"></script>
<script src="/admin/static/js/jquery-1.8.3.min.js"></script>
<script src="/admin/static/js/vue.js"></script>
<script src="/admin/static/js/vue-resource.min.js"></script>
<script>
    var vue = new Vue({
        el: "#app",
        data: {
            shopInfo: {
                poster:null
            },
            isDisplay: false
        },
        mounted: function () {
            $('#left-nav-1').html("我的商店");
            $('#left-nav-1-child')
                    .append("<dd><a style='color:white;background: #009688;' href='/admin/page/shop'>基本信息</a>" + "</dd>")
                    .append("<dd><a href='/admin/page/customer'>商店用户</a>" + "</dd>")
                    .append("<dd><a href='/admin/page/shop-activity'>商店活动</a>" + "</dd>")
                    .append("<dd><a href='/admin/page/shop-delivery'>物流信息</a>" + "</dd>")
                    .append("<dd><a href='/admin/page/verify'>商家认证</a>" + "</dd>")
            ;
            var _self = this;
            layui.use(['element', 'form','upload'], function () {
                var element = layui.element;
                var form = layui.form;
                var upload = layui.upload;
                form.on('switch(switchTest)', function (data) {
                    if (this.checked) {
                        _self.shopInfo.isDisplay = 1
                    } else {
                        _self.shopInfo.isDisplay = 0;
                    }
                });
                var uploadPoster = upload.render({
                    elem: '#poster'
                    , url: '/resource/upload/'
                    , multiple: true
                    , auto:false
                    , number:1
                    ,accept: 'images' //只允许上传图片
                    ,acceptMime: 'image/*' //只筛选图片
                    ,choose:function (obj) {
                        obj.preview(function (index, file, result) {
                            $('#poster-img').attr('src', result);
                            $('.upload-list').append('<button  type="button" class="layui-btn layui-btn-xs upload-poster">点击上传</button>'
                            )
                            $('.upload-list').find('.upload-poster').on('click', function () {
                                obj.upload(index, file);
                            });
                        })
                    }
                    ,done: function (res, index, upload){
                        if(res.success){
                            $('#poster-text').text("上传成功");
                            $('.upload-list').find('.upload-poster').remove();
                            _self.shopInfo.poster=res.data[0];
                        }
                    }
                })
            });
            this.getShopInfo();
        },
        methods: {
            getShopInfo() {
                this.$http.get("/admin/shop/info").then(function (res) {
                    this.shopInfo = res.body.data;
                    if (this.shopInfo.isDisplay == 1) {
                        this.isDisplay = true;
                    }
                    if (this.shopInfo.poster){
                        $('#poster-img').attr('src', "/resource/static"+this.shopInfo.poster);
                    }
                })
            },
            updateShopInfo() {
                this.$http.post("/admin/shop/info/update", JSON.stringify(this.shopInfo)).then(function (res) {
                    if (res.body.success) {
                        layer.msg("更新成功")
                    }
                })
            }
        }
    })
</script>