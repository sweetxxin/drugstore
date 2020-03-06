<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房-后台管理</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
    <style>
        .myWeb{
            color: white !important;
            background: #5FB878;
        }
        .rotationContain{
            margin-left: 120px;
        }
        .rotationImg{
            display: inline-block;
            margin-right: 20px;
            margin-top: 20px;
            position: relative;
            vertical-align: text-top;
        }
        .rotationImg img{
            height: 200px;
            width: 400px;
        }
        .save-btn{
            margin: 0px auto;
            display: block;
            width: 150px;
            margin-top: 20px;
        }

        #upload{
            height: 140px;
            width: 340px;
            line-height: 50px;
        }
        .badge{
            position: absolute;right: -10px;top: -10px;cursor: pointer
        }
    </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
<#include "common/top-nav.ftl"/>
   <#include "common/left-nav.ftl"/>
    <div id="rotation" class="layui-body">
        <!-- 内容主体区域 -->
        <div style="padding: 15px;">
           <div class="rotationContain">
               <div v-for="(img,index) in rotationImg" id="rotationImg"  class="rotationImg">
                   <li><span @click="delImg(index)" class="layui-badge badge">X</span></li>
                   <img :src="img.url"/>
               </div>
               <div  style="" class="rotationImg">
                   <div class="layui-upload-drag" id="upload">
                       <i class="layui-icon"></i>
                       <p>点击上传，或将文件拖拽到此处</p>
               </div>
           </div>
            <button type="button" @click="save()" class="layui-btn save-btn">保存</button>
        </div>
    </div>
</div>
</body>
<script src="/admin/static/frame/layui/layui.js"></script>
<script>
    $(document).ready(function () {
        $('#left-nav-1').html("我的网站");
        $('#left-nav-1-child')
                .append("<dd><a style='color:white;background: #009688;' href='/admin/page/rotation-setting'>首页轮播图</a>" + "</dd>")
                .append("<dd><a href='/admin/page/article-setting'>文章设置</a>" + "</dd>")
                .append("<dd><a href='/admin/page/article-setting'>热销药品</a>" + "</dd>")
                .append("<dd><a href='/admin/page/article-setting'>推荐药品</a>" + "</dd>")
                .append("<dd><a href='/admin/page/article-setting'>精选药品</a>" + "</dd>");
    })
    var rotation = new Vue({
        el: '#rotation',
        data:{
            rotationImg:[]
        },
        mounted:function () {
            this.getRotationImg();
            var self = this;
            layui.use(['upload','layer','element'], function(){
                var upload = layui.upload;
                var layer = layui.layer;
                var element = layui.element;
                upload.render({
                    elem: '#upload'
                    ,url: '/resource/upload' //改成您自己的上传接口,
                    ,choose(obj){
                        obj.preview(function(index, file, result){
                        })
                    }
                    ,done: function(res){
                        self.rotationImg.push({"url":'/resource/static'+res.data[0],"type":1})
                    }
                });
            });
        },
        methods:{
            getRotationImg(){
                this.$http.get("/user/ad/rotation").then(function (res) {
                    this.rotationImg = res.body.data;
                })
            },
            delImg(img){
                this.rotationImg.splice(img,1)
            },
            save(){
                this.$http.post('/user/ad/rotation/save',JSON.stringify(this.rotationImg)).then(function (res) {
                    layer.msg(res.body.message)
                })
                console.log(this.rotationImg)
            }
        }
    })
</script>
</html>