<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="author" content="order by dede58.com"/>
    <title>确认订单-益和药房</title>
    <link rel="stylesheet" type="text/css" href="/web/static/css/header.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/cart.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/checkout.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/pay.css">
</head>
<body>
<!-- start header -->
 <#include "common/header.ftl"/>
<!--end header -->
<!-- start banner_x -->
<div class="banner_x center">
    <div class="wdgwc fl ml40">支付中...</div>
    <div class="wxts fl ml20">温馨提示：产品是否购买成功，以最终下单为准哦，请尽快支付</div>
    <div class="timing"></div>
    <div class="clear"></div>
</div>
<div class="xiantiao"></div>
<div id="app" class="gwcxqbj">
    <div class="gwcxd center">
        <div class="top2 center">
            <div class="delivery">
                <div class="delivery-logo"></div>
                <div class="delivery-title">配送至:</div>
                <div class="delivery-content">
                    <div class="receiver">{{selectedAddress.receiver}}</div>
                    <div>{{selectedAddress.mobile}}</div>
                    <div class="address">{{selectedAddress.province}}&nbsp;&nbsp;{{selectedAddress.city}}&nbsp;&nbsp;{{selectedAddress.town}}&nbsp;&nbsp;{{selectedAddress.detail}}</div>
                </div>
            </div>
        </div>
        <div style="padding-bottom: 50px;">
            <div v-for="cart in buyCart" class="content2 center">
                <div class="sub_content fl "></div>
                <div class="sub_content fl"><img :src="'/resource/static'+cart.sku.product.defaultImg"></div>
                <div class="sub_content fl ft20">{{cart.sku.product.name}}-{{cart.sku.skuName}}</div>
                <div class="sub_content fl ">￥{{cart.sku.skuPrice}}</div>
                <div class="sub_content fl">
                    x{{cart.amount}}
                </div>
                <div class="sub_content fl">￥{{parseFloat(cart.amount*cart.sku.skuPrice).toFixed(2)}}</div>
                <div class="clear"></div>
            </div>
        </div>

    </div>
    <div class="jiesuandan mt20 center">
        <div class="tishi fl ml20">
            <ul>
                <li><a href="/web/page/order" target="_self">全部订单</a></li>
                <li>|</li>
                <li><a @click="cancelOrder()">取消订单</a></li>
                <li>|</li>
                <li>共<span>{{buyCart.length}}</span>件商品</li>
                <div class="clear"></div>
            </ul>
        </div>
        <div class="jiesuan fr">
            <div class="jiesuanjiage fl">合计（含运费{{newOrder.delivery.deliveryFee}}元）：<span>{{parseFloat(totalPrice).toFixed(2)}}元</span></div>
            <div class="jsanniu fr"><input class="jsan" type="submit" name="jiesuan" @click="payNow()" value="立即支付"/></div>
            <div class="clear"></div>
        </div>
        <div class="clear"></div>
    </div>
</div>
<script type="text/javascript" src="/web/static/layui/layui.js"></script>
<script>
    var vue = new Vue({
        el: "#app",
        data: {
            buyCart: [],
            totalPrice:0,
            selectedAddress:{},
            newOrder:{delivery:{"deliveryFee":0}}
        },
        mounted:function () {
            if (localStorage.getItem("buyCart")!=null&&localStorage.getItem("newOrder")!=null) {
                var data = JSON.parse(localStorage.getItem("buyCart"));
                this.buyCart = data.product;

                this.selectedAddress = JSON.parse(localStorage.getItem("selectedAddress"));
                this.newOrder = JSON.parse(localStorage.getItem("newOrder"));
                var _self = this;
                console.log(this.newOrder)
                this.totalPrice = data.totalPrice+parseFloat(this.newOrder.delivery.deliveryFee);
                layui.use('util', function(){
                    var util = layui.util;
                    console.log(_self.newOrder.payDeadline);
                    var endTime =_self.getDate(_self.newOrder.payDeadline).getTime();
                    var serverTime = new Date().getTime();
                        util.countdown(endTime, serverTime, function(date,serverTime,timer){
                            console.log(date)
                            var str = date[2] + ':' + date[3];
                            if (endTime<=serverTime){
                                alert('截止时间到，订单自动取消');
                                _self.cancelOrder();
                            } else{
                                layui.$('.timing').html(str);
                            }
                        });
                });
            }else{
                window.location = "/web/page/index";
            }
        },
        methods:{
            payNow(){
                var products={};
                for(var i in this.buyCart){
                    products[this.buyCart[i].sku.mainId] = {"price":this.buyCart[i].sku.skuPrice,"amount":this.buyCart[i].amount};
                }
                this.$http.post("/web/order/pay",JSON.stringify(this.newOrder)).then(function (res) {
                    if (res.body.success){
                        localStorage.removeItem("buyCart");
                        localStorage.removeItem("newOrder");
                        localStorage.removeItem("cartCount");
                        window.location = "/web/page/order";
                    }
                    alert(res.body.message)
                })
            },
            cancelOrder(){
                console.log('取消订单');
                this.$http.post("/web/order/cancel",({"id":this.newOrder.mainId}),{emulateJSON:true}).then(function (res) {
                    if (res.body.success){
                        alert('已经取消该订单');
                        localStorage.removeItem("buyCart");
                        localStorage.removeItem("newOrder");
                        localStorage.removeItem("cartCount");
                        window.location = "/web/page/order";
                    }
                });
            },
            getDate(strdate) {
                var arr = strdate.split(/[- : \/]/);
                return new Date(arr[0], arr[1]-1, arr[2], arr[3], arr[4], arr[5]);
            }
        }
    })
</script>
</body>
</html>
