<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="author" content="order by xxin"/>
    <title>益和药房-个人中心</title>
    <link rel="stylesheet" type="text/css" href="/web/static/css/header.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/self_info.css">
    <link rel="stylesheet" type="text/css" href="/web/static/layui/css/layui.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/address.css">
    <script type="text/javascript" src="/web/static/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="/web/static/layui/layui.js"></script>
    <script src="/web/static/js/select.js" type="text/javascript"></script>
    <style>
        ::-webkit-scrollbar {
            display: none; /* Chrome Safari */
        }
        .my-assessment{
            color:#ff6700!important;font-weight:bold;
        }
        .comment{
            max-height: 1280pxpx;
            overflow: scroll;
            padding-bottom: 20px;
        }
        .comment-item{
            border: 0.1px solid #ddd;
            padding: 10px;
            margin-top: 20px;
            position: relative;
        }
        .user-avatar{
            height: 60px;
            width: 60px;
            border-radius: 100%;
        }
        .user-name{
            font-size: 18px;
            margin-left: 10px;
        }
        .item-text{
            font-size: 16px;
            padding-left: 60px;
            width: 500px;
        }
        .item-pic{
            margin-top: 20px;
            width: 500px;
            text-align: center;
        }
        .item-pic img{
            height: 150px;
            width: 150px;
            margin-right: 10px;
        }
        .item-oper{
            text-align: right;
        }
        .item-oper .oper{
            display: inline-block;
            margin-right: 5px;
            color: #bfbfbf;
        }
        .item-oper .oper:hover{
            color:red;
            cursor: pointer;
        }
        .oper-pic{
            height: 20px;
            vertical-align: text-bottom;
        }
        .item-info{
            width: 500px;
            text-align: center;
            color: #bfbfbf;
        }
        .item-time{
            position: absolute;
        }
        .pic-show{
            margin-top: 100px;
        }
        .pic-show img{
            height: 100%;

        }
        .reply-div{
            padding: 10px;
            max-height: 200px;
            overflow: scroll;
        }
        .reply{
            border: 0.5px solid #ddd;
            padding: 10px;
            border-radius: 10px;
            margin-bottom: 10px;
        }
        .reply-name{
            margin-left: 10px;
            font-size: 16px;
        }
        .reply-contnet{
            padding-left: 50px;
        }
        .reply-time{
            text-align: right;
        }
    </style>

</head>
<body>
<!-- start header -->
 <#include "common/header.ftl"/>
<!--end header -->
<!-- self_info -->
<div id="app" class="grzxbj">
    <div class="selfinfo center">
       <#include "common/left-nav.ftl"/>
        <div class="rtcont fr">
            <div class="ddzxbt">
                我的评价（{{commentCount}}）
            </div>
            <div class="address-scroll">
                <div v-for="(comment,index) in commentList" class="comment-item">
                    <div class="item-top">
                        <template  v-if="comment.isPublic==1">
                            <img v-if="comment.creator.avatar!=null" class="user-avatar" :src="'/resource/static'+comment.creator.avatar">
                            <img v-else class="user-avatar" src="/resource/static/img/avatar.png">
                            <span  class="user-name">{{comment.creator.nickname}}</span>
                        </template>
                        <template v-else>
                            <img class="user-avatar" src="/resource/static/img/avatar.png">
                            <span  class="user-name">匿名用户</span>
                        </template>
                    </div>
                    <div class="item-text">
                        {{comment.msg}}
                    </div>
                    <div class="item-pic">
                        <img v-for="img in comment.img" :src="'/resource/static'+img.url">
                    </div>
                    <div class="item-info">
                        {{comment.order.shortIn}}
                    </div>
                    <div class="item-oper">
                        <div class="item-time">{{comment.createTime}}</div>
                        <div class="oper">
                            <img class="oper-pic" src="/resource/static/img/good.png">
                            赞({{comment.good}})
                        </div>
                        <div @click="reply(comment.mainId,index)" class="oper">
                            <img class="oper-pic" src="/resource/static/img/reply.png">
                            回复({{comment.reply}})
                        </div>
                        <div class="oper">
                            <img class="oper-pic" src="/resource/static/img/jubao.png">
                            举报({{comment.against}})
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- self_info -->
 <#include "common/footer.ftl"/>
<script>
    var vue = new Vue({
        el: "#app",
        data:{
            commentList:[],
            commentCount:0,
            currentIndex:0,
            size:5,
            layer:null
        },
        mounted:function () {
            this.getAssessment();
            var self = this;
            layui.use('layer', function () {
                self.layer = layui.layer;
            })
        },
        methods:{
            getAssessment(){
                this.$http.post("/web/assessment/user?index="+this.currentIndex+"&size="+this.size).then(function (res) {
                    console.log(res)
                        if (res.body.success){
                            this.commentList = res.body.data.content;
                            this.commentCount = res.body.data.totalElements;
                        }
                });
            },
            showOpen(event,id,index){
                var div='<div>' +
                        '<textarea style="height: 100px;resize: none;" id="reply-text" lay-verify="required" id="reply" placeholder="说点什么吧" class="layui-textarea">' +
                        '</textarea>'+
                        '<div class="reply-div">';
                for (var i in event){
                    div+=('<div class="reply">' +
                            '<img class="user-avatar" src="/resource/static/img/avatar.png">' +
                            '<span class="reply-name">'+event[i].user.nickName+'</span>' +
                            '<div class="reply-contnet">'+event[i].detail+'</div>' +
                            '<div class="reply-time">'+event[i].createTime+'</div>' +
                            '</div>');
                }
                div+=('</div>' + '</div>');
                var self = this;
                self.layer.open({
                    type: 1,
                    title:'所有回复',
                    area: ['650px', '430px'],
                    content: div,
                    shadeClose:true,
                    maxmin:true,
                    btn:["回复","取消"],
                    scrollbar:false,
                    yes: function(idx, layero){
                        if ($("#reply-text").val()!=""){
                            // $.post("/web/assessment/reply",{"id":id,"content":$("#reply-text").val()},function (res) {
                            //     self.commentList[index].reply+=1;
                            //     layer.msg("回复成功");
                            //     layer.close(idx);
                            // })
                        }else{
                            layer.msg("回复内容不能为空")
                        }

                    }
                    ,btn2: function(index, layero){
                    }
                });
            },
            reply(id,index){
                this.$http.post("/web/assessment/"+id+"/reply").then(function (res) {
                    if(res.body.success){
                        this.showOpen(res.body.data,id,index);
                    }
                })


            }
        }
    })
</script>
</body>
</html>