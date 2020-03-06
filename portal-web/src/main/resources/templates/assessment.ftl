<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>订单评价</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" type="text/css" href="/web/static/layui/css/layui.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/header.css">
    <script type="text/javascript" src="/web/static/layui/layui.js"></script>
    <script src="/web/static/js/jquery-1.8.3.min.js"></script>
    <script src="/web/static/js/vue.js"></script>
    <script src="/web/static/js/vue-resource.min.js"></script>
    <style>
        .ml20{
            margin-left: 20px;
        }
        .publish-btn{
            float: right;
            margin-right: 20px;
            margin-bottom: 20px;
            width: 100px;
        }
        #imgList img{
            height: 150px;
            width: 150px;
            margin-bottom: 10px;
            margin-right: 15px;
        }
        .layui-badge{
            position: absolute;
            margin-left: 145px;
            margin-top: -5px;
            cursor: pointer;
        }
    </style>
</head>
<body>
 <#include "common/header.ftl"/>
<form class="layui-form">
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
    <legend>留言评价</legend>
</fieldset>
<div class="ml20"><span>描述相符：</span><div id="test13"></div></div>
<div class="layui-form-item layui-form-text ml20">
    <textarea placeholder="说点什么吧..." id="msg" class="layui-textarea"></textarea>
</div>

    <div class="layui-upload-drag ml20" id="upload-file">
        <i class="layui-icon"></i>
        <p>添加图片/视频</p>
    </div>
    <button style="margin-bottom: 60px;margin-left: 20px;" id="upload" type="button" class="layui-btn layui-btn-danger layui-btn-radius btn layui-hide">全部上传
    </button>
    <div class="ml20" id="imgList">
        <hr>
    </div>
    <hr>
<div class="layui-form-item ml20">
    <input type="checkbox" checked="" name="open" lay-skin="switch" lay-filter="switchTest" lay-text="公开|匿名">
</div>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
    <legend>店铺评价</legend>
</fieldset>
<ul class="ml20">
    <li><span>描述相符：</span><div id="test10"></div></li>
    <li><span>物流服务：</span><div id="test11"></div></li>
    <li><span>服务态度：</span><div id="test12"></div></li>
</ul>
    <button type="button" onclick="publish()" class="layui-btn layui-btn-normal publish-btn">发布</button>
</form>
<script src="/web/static/js/jquery-1.8.3.min.js"></script>
<script>
    var fileList=[];
    var goodsStar = 3;
    var shopStar = 3;
    var deliveryStar = 3;
    var serviceStar = 3;
    var msg = "";
    var isPublic = 1;
    var orderId = "";
    window.onload = function (ev) {
        orderId = getQueryValue("id");
        if (orderId==null){
            window.location = "/web/page/order";
        }
    }
    layui.use(['rate','form','upload'], function(){
        var form = layui.form;
        var rate = layui.rate;
        var upload = layui.upload;
        form.on('switch(switchTest)', function(data){
            isPublic = data.elem.checked==true?1:0;
        });
        //主题色
        rate.render({
            elem: '#test10'
            ,value: 5
            ,text:true
            ,theme: '#FF8000' //自定义主题色
            ,setText: function(value){ //自定义文本的回调
                var arrs = {
                    '1': '极差'
                    ,'2': '差'
                    ,'3': '中等'
                    ,'4': '好'
                    ,'5': '极好'
                };
                this.span.text(arrs[value] || ( value + "星"));
            }
            ,choose: function(value){
                shopStar = value;
            }
        });
        rate.render({
            elem: '#test11'
            ,value: 5
            ,text:true
            ,theme: '#009688'
            ,setText: function(value){ //自定义文本的回调
                var arrs = {
                    '1': '极差'
                    ,'2': '差'
                    ,'3': '中等'
                    ,'4': '好'
                    ,'5': '极好'
                };
                this.span.text(arrs[value] || ( value + "星"));
            }
            ,choose: function(value){
                deliveryStar = value;
            }
        });
        rate.render({
            elem: '#test12'
            ,value: 5
            ,text:true
            ,theme: '#1E9FFF'
            ,setText: function(value){ //自定义文本的回调
                var arrs = {
                    '1': '极差'
                    ,'2': '差'
                    ,'3': '中等'
                    ,'4': '好'
                    ,'5': '极好'
                };
                this.span.text(arrs[value] || ( value + "星"));
            }
            ,choose: function(value){
                serviceStar = value;
            }
        })
        rate.render({
            elem: '#test13'
            ,value: 5
            ,text:true
            ,theme: '#1E9FFF'
            ,setText: function(value){ //自定义文本的回调
                var arrs = {
                    '1': '极差'
                    ,'2': '差'
                    ,'3': '中等'
                    ,'4': '好'
                    ,'5': '极好'
                };
                this.span.text(arrs[value] || ( value + "星"));
            }
            ,choose: function(value){
                goodsStar = value;
            }
        })

        //拖拽上传
        var uploadListIns = upload.render({
            elem: '#upload-file'
            ,url: '/resource/upload/'
            , multiple: true
            , auto:false
            , drag:true
            ,bindAction: "#upload"
            ,choose:function (obj) {
                obj.preview(function (index, file, result) {
                    var files = this.files = obj.pushFile();
                    var imgList = $('#imgList')
                    var div = $(['<div  id="upload-' + index + '" style="display: inline-block;text-align: center;"> ' +
                    '<span class="layui-badge img-delete">x</span> ' +
                    '<img  src="' + result + '" class="layui-upload-img"> ' +
                    '<div  style="text-align: center">待上传</div>' +
                    '<a class="wait-to-upload layui-btn layui-btn-xs img-reload">上传</a>' +
                    '</div>'].join(''));
                    div.find('.img-reload').on('click', function () {
                        obj.upload(index, file);
                    });
                    div.find('.img-delete').on('click', function () {
                        delete files[index]; //删除对应的文件
                        div.remove();
                        if (Object.keys(files).length==0){
                            $('#upload').addClass('layui-hide');
                        }
                        fileList.splice(index,1);
                        uploadListIns.config.elem.next()[0].value = '';
                    });
                    $('#upload').removeClass('layui-hide');
                    imgList.append(div);
                })
            }
            , done: function (res, index, upload) {
                layer.closeAll('loading'); //关闭loading
                if(res.success){ //上传成功
                    var div = $('#imgList').find('div#upload-'+ index);
                    var child = div.children();
                    child.eq(0).remove();
                    child.eq(2).html('<span style="color: #5FB878;">上传成功</span>');
                    child.eq(3).remove();
                    fileList[index]={"url":res.data[0]};
                    return delete files[index];
                }
                this.error(index, upload);
            }
            ,allDone: function(obj){ //当文件全部被提交后，才触发
                console.log(obj.total); //得到总文件数
                console.log(obj.successful); //请求成功的文件数
                console.log(obj.aborted); //请求失败的文件数
            }
            ,error: function(index, upload){
                layer.closeAll('loading'); //关闭loading
                var div = $('#imgList').find('div#upload-'+ index);
                var child = div.children();
                child.eq(2).html('<span style="color: #FF5722;">上传失败</span>');
                child.eq(3).html('<span style="color: #FF5722;">重试</span>');
            }
        });
    });
    function publish() {
        msg = $('#msg').val();
        console.log(fileList);
        var files = [];
        for(var i in fileList){
            files.push(fileList[i])
        }
        var data = {
            "files":files,
            "shopStar":shopStar,
            "deliveryStar":deliveryStar,
            "goodsStar":goodsStar,
            "serviceStar":serviceStar,
            "isPublic":isPublic,
            "msg":msg,
            "order":{"mainId":orderId}
        }
        $.ajax({
            url: "/web/order/comment",
            data: JSON.stringify(data),
            type: "POST",
            dataType: "json",
            contentType:"application/json",
            success: function(data) {
                if (data.success){
                    alert("评论成功！！！")
                    window.location = "/web/page/order";
                }
            }
        });
    }
    function getQueryValue(queryName) {
        var query = decodeURI(window.location.search.substring(1));
        var vars = query.split("&");
        for (var i = 0; i < vars.length; i++) {
            var pair = vars[i].split("=");
            if (pair[0] == queryName) { return pair[1]; }
        }
        return null;
    }
</script>

</body>
</html>