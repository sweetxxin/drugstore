<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="author" content="xxin"/>
    <title>益和药房-个人中心</title>
    <link rel="stylesheet" type="text/css" href="/web/static/css/header.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/order.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/self_info.css">
    <link rel="stylesheet" type="text/css" href="/web/static/layui/css/layui.css">
    <script src="/web/static/layui/layui.js"></script>
    <script src="/web/static/js/jquery-1.8.3.min.js"></script>
    <script src="/web/static/js/vue.js"></script>
    <script src="/web/static/js/vue-resource.min.js"></script>
    <style>
        .my-inform{
            color:#ff6700!important;font-weight:bold;
        }
        .cart-scroll .cart-load-all,.order-scroll .order-load-all{
            text-align: center;
            margin-top: 10px;
            margin-bottom: 10px;
            color: #9F9F9F;
        }
        .cart-scroll .cart-loading,.order-scroll .order-loading{
            text-align: center;
        }
        .knowBtn{
            height: 40px;
            width: 100px;
            margin-top: 30px;
            margin-right: 20px;
            background: #ff6700;
            border: 0px;
            color: white;
            font-size: 14px;
            border-radius: 5px;
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
            <div class="ddzxbt">消息通知({{informCount}})</div>
            <div style="height: 420px;overflow-y: scroll;overflow-x: hidden" id="orderScroll" class="order-scroll">
                <div v-for="(inform,index) in informList" class="ddxq">
                    <div class="ddspt fl"><a @click="getDetail(inform,index)">查看详情</a></div>
                    <div style="margin-right: 100px" class="ddbh fl">{{inform.title}}</div>
                    <div  class="ztxx">
                        {{inform.outline}}
                        <button v-if="inform.isRead!=1" style="cursor: pointer" @click="readInform(inform,index)" class="knowBtn fr">我知道啦</button>
                        <button v-else style="cursor: pointer;background: #dddddd" disabled  class="knowBtn fr">已阅</button>
                    </div>

                    <div class="clear"></div>
                </div>
                <div v-show="!isLoadAll" class="order-loading">
                    <i class="layui-icon layui-icon-loading layui-icon layui-anim layui-anim-rotate layui-anim-loop"></i>
                    <div class="doc-icon-name">玩命加载中...</div>
                </div>
                <div  v-show="isLoadAll" class="order-load-all">--已加载全部--</div>
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
            informList:[],
            currentIndex:0,
            isLoadAll:false,
            informCount:0
        },
        mounted:function () {
            this.getInformByUser();
            var _self = this;
            $('#orderScroll').scroll(function () {
                var scrollTop = $('#orderScroll').scrollTop();//被滚动条隐藏的高度，随着滚动条下拉变大
                var height = $('#orderScroll').height();//可见区域高度
                var scrollHeight = $('#orderScroll').get(0).scrollHeight;//元素里面内容的实际高度
                if (!_self.isLoadAll&&scrollTop+height+100>=scrollHeight){
                    _self.currentIndex++;
                    _self.getInformByUser();
                }
            })

        },
        methods:{
            getInformByUser(){
                this.$http.get("/web/user/inform/"+this.currentIndex).then(function (res) {
                    if (res.body.data.content.length==0){
                        this.isLoadAll = true;
                    }else if (res.body.data.content.length<5){
                        this.isLoadAll = true;
                        this.informList.push.apply(this.informList,res.body.data.content);
                    }  else{
                        this.informList.push.apply(this.informList,res.body.data.content);
                    }
                    this.informCount = res.body.data.totalElements;
                })
            },
            readInform(inform,index){
                this.$http.post("/web/user/inform/read",JSON.stringify(inform)).then(function (res) {
                        if (res.body.success){
                            this.informList[index]= res.body.data;
                            this.$forceUpdate();
                            header.countInform();
                        }
                })
            },
            getDetail(inform,index){
                var _self = this;
                layui.use('layer',function () {
                    layer.open({
                        type: 1
                        ,title: inform.title //不显示标题栏
                        ,closeBtn: false
                        ,area: '400px;'
                        ,shade: 0.8
                        ,id: 'LAY_layuipro' //设定一个id，防止重复弹出
                        ,btn: ['朕知道了']
                        ,btnAlign: 'c'
                        ,moveType: 0 //拖拽模式，0或者1
                        ,content: '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">纲要：'+inform.outline+'<br>内容：'+inform.content+'<br>创建时间：'+inform.createTime+'<br>创建人：'+inform.creator.name+'<br><br></div>'
                        ,success: function(layero){
                            if (inform.isRead!=1)
                                _self.readInform(inform,index);
                        }
                    });
                })

            }
        }
    })
</script>
</body>
</html>