<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="author" content="order by xxin"/>
    <title>京鲜生市场-个人中心</title>
    <link rel="stylesheet" type="text/css" href="/web/static/css/header.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/order.css">
    <link rel="stylesheet" type="text/css" href="/web/static/layui/css/layui.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/self_info.css">
    <script src="/web/static/js/jquery-1.8.3.min.js"></script>
    <script src="/web/static/js/vue.js"></script>
    <script src="/web/static/js/vue-resource.min.js"></script>
    <style>
        .my-order{
            color:#ff6700!important;font-weight:bold;
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
            <div class="ddzxbt">交易订单({{orderCount}})</div>
            <div style="height: 420px;overflow-y: scroll;overflow-x: hidden" id="orderScroll" class="order-scroll">
                <div v-for="order in orderList" class="ddxq">
                    <div  class="ddspt fl"> {{order.shortIn}}</div>
                    <div v-if="order.code==5" class="ddspt fl"><a style="color: darkred" :href="'/web/page/assessment?id='+order.mainId">去评价</a></div>
                    <#--<div class="ddbh fl">订单号:{{order.orderNo}}</div>-->
                    <div class="ztxx fr">
                        <ul>
                            <li>{{order.status}}</li>
                            <li>￥{{parseFloat(order.totalPrice).toFixed(2)}}</li>
                            <li style="line-height: 30px;">{{order.createTime}}</li>
                            <li><a @click="getDetail(order)">订单详情></a></li>
                            <div class="clear"></div>
                        </ul>
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
            orderList:[],
            currentIndex:1,
            isLoadAll:false,
            orderStatus:["待处理","揽件中","运输中","已送达","已完成"],
            orderCount:0
        },
        mounted:function () {
            this.getOrderByUser();
            var _self = this;
            $('#orderScroll').scroll(function () {
                var scrollTop = $('#orderScroll').scrollTop();//被滚动条隐藏的高度，随着滚动条下拉变大
                var height = $('#orderScroll').height();//可见区域高度
                var scrollHeight = $('#orderScroll').get(0).scrollHeight;//元素里面内容的实际高度
                if (!_self.isLoadAll&&scrollTop+height+100>=scrollHeight){
                    _self.currentIndex++;
                    _self.getOrderByUser();
                }
            })
        },
        methods:{
            getOrderByUser(){
                this.$http.get("/web/order/list/"+this.currentIndex).then(function (res) {
                    if (res.body.success){
                        if (res.body.data.last){
                            this.isLoadAll = true;
                        }
                        if (res.body.data.content.length!=0){
                            this.orderList.push.apply(this.orderList,res.body.data.content);
                        }
                        this.orderCount = res.body.data.totalElements;
                    }


                })
            },
            getDetail(order){
                window.location =  "/web/page/order/detail?id="+order.mainId;
            }
        }
    })
</script>
</body>
</html>