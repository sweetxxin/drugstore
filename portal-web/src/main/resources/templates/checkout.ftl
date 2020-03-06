<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="author" content="order by dede58.com"/>
    <title>确认订单车-益和药房</title>
    <#--<link rel="stylesheet" type="text/css" href="/static/css/style.css">-->
    <link rel="stylesheet" type="text/css" href="/web/static/css/header.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/cart.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/checkout.css">
</head>
<body>
<!-- start header -->
 <#include "common/header.ftl"/>
<!--end header -->
<!-- start banner_x -->
<div class="banner_x center">
    <div class="wdgwc fl ml40">订单确认</div>
    <div class="wxts fl ml20">温馨提示：产品是否购买成功，以最终下单为准哦，请尽快结算</div>
    <div class="clear"></div>
</div>
<div class="xiantiao"></div>
<div id="app" class="gwcxqbj">
    <div class="gwcxd center">
        <div class="top2 center">
            <div class="delivery">
                <div class="delivery-logo"></div>
                <div class="delivery-title">配送至:</div>
                <div v-show="isHasAddress" class="delivery-content">

                    <div  @click="changeAddress()">
                        <template v-if="selectedAddress">
                        <div class="receiver">{{selectedAddress.receiver}}</div>
                        <div>{{selectedAddress.mobile}}</div>
                        <div class="address">{{selectedAddress.province}}&nbsp;&nbsp;{{selectedAddress.city}}&nbsp;&nbsp;{{selectedAddress.town}}&nbsp;&nbsp;{{selectedAddress.detail}}</div>
                        </template>
                    </div>

                    <div v-show="isShowPop" class="popAddress">
                        <div v-for="addr in addressList" class="pop-delivery-content">
                            <div @click="selectThisAddress(addr)"  style="width: 90%">
                                <div class="receiver">{{addr.receiver}}</div>
                                <div>{{addr.mobile}}</div>
                                <div class="address">{{addr.province}}&nbsp;&nbsp;{{addr.city}}&nbsp;&nbsp;{{addr.town}}&nbsp;&nbsp;{{addr.detail}}</div>
                            </div>
                            <div v-if="addr.isDefault!=1"  @click="setDefaultAddr(addr)" class="isDefault">设为默认</div>
                            <div v-else class="default">默认地址</div>
                        </div>
                        <div @click="showPopAddress()" class="pop-add-address">新增地址</div>
                    </div>
                </div>
                <div v-if="!isHasAddress" @click="showPopAddress()" class="add-new-address">
                    添加物流配送信息
                    <img src="/resource/static/img/add.png">
                </div>
                <div v-show="isHasAddress" @click="changeAddress()" class="delivery-more"></div>
            </div>
        </div>
        <div @click="hidePop()" style="padding-bottom: 50px;">
            <div v-for="cart in buyCart" class="content2 center">
                <div class="sub_content fl "></div>
                <div class="sub_content fl"><img :src="'/resource/static'+cart.sku.product.defaultImg"></div>
                <div class="sub_content fl ft20"><a :href="'/web/page/product/detail?id='+cart.sku.product.mainId"class="getDetail">{{cart.sku.product.name}}-{{cart.sku.skuName}}</a></div>
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
                <li><a href="/web/page/cart" target="_self">我的购物车</a></li>
                <li><a href="/web/page/index" target="_self">继续购物</a></li>
                <li>|</li>
                <li><a @click="back()" >返回</a></li>
                <li>|</li>
                <li>共<span>{{buyCart.length}}</span>件商品</li>
                <div class="clear"></div>
            </ul>
        </div>
        <div class="jiesuan fr">
            <div v-if="delivery.fee!=0" class="jiesuanjiage fl">合计（不含运费,运费{{delivery.fee}}元）：<span>{{parseFloat(totalPrice).toFixed(2)}}元</span>
            </div>
            <div v-else class="jiesuanjiage fl">合计（免运费）：<span>{{parseFloat(totalPrice).toFixed(2)}}元</span>
            </div>
            <div class="jsanniu fr"><input class="jsan" type="submit" name="jiesuan" @click="toPay()" value="去支付"/></div>
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
            selectedAddress:[],
            addressList:[],
            isShowPop:false,
            isHasAddress:false,
            layer:null,
            delivery:{"fee":0}
        },
        mounted:function () {
            if (localStorage.getItem("buyCart")==null) {
                window.location = "/web/page/index";
            }else{
                localStorage.removeItem("seletedAddr");
                var data = JSON.parse(localStorage.getItem("buyCart"));
                this.buyCart = data.product;
                this.totalPrice = data.totalPrice;
                this.delivery=data.delivery;
                this.getAddress();
                var self = this;
                layui.use("layer",function () {
                    self.layer = layui.layer;
                })
            }
        },
        methods:{
            toPay(){
                if (this.selectedAddress==null){
                    alert("请选择物流信息")
                    return;
                }
                var products={};
                for(var i in this.buyCart){
                    products[this.buyCart[i].sku.mainId] = {"price":this.buyCart[i].sku.skuPrice,"amount":this.buyCart[i].amount};
                }
                localStorage.setItem("selectedAddress",JSON.stringify(this.selectedAddress));

                this.$http.post("/web/order/create",{"products":JSON.stringify(products),"totalPrice":parseFloat(this.totalPrice).toFixed(2),"toAddressId":this.selectedAddress.mainId,"deliveryFee":this.delivery.fee,"delivery":this.delivery.title},{emulateJSON: true}).then(function (res) {
                    if (res.body.success){
                        localStorage.setItem("newOrder",JSON.stringify(res.body.data));
                        window.location="/web/page/pay";
                    }else{
                        this.layer.msg(res.body.message);
                        if (res.body.code==-1){
                            setTimeout(function () {
                                window.location="/web/page/verify";
                            },1500)
                        }
                    }
                })
            },
            getAddress(){
                this.$http.get("/web/user/address").then(function (res) {
                    this.addressList = res.body.data;
                    if (this.addressList.length==0){
                        this.isHasAddress =false;
                    }else{
                        this.isHasAddress = true;
                    }
                    this.selectedAddress = this.addressList[0];
                })
            },
            showPopAddress(){
                layui.use('layer', function(){
                    this.layer = layui.layer;
                    var idx = layer.open({
                        type : 2,
                        title : '新增收货地址',
                        area : [ '650px', '450px' ],
                        fix : false,
                        content : '/web/page/popAddress',
                        // btn: ['确定', '取消'],
                        end : function() {
                        }
                    });
                });
            },
            selectThisAddress(addr){
                this.selectedAddress = addr;
                this.changeAddress();
            },
            changeAddress(){
                this.isShowPop = !this.isShowPop;
            },
            hidePop(){
                this.isShowPop = false;
            },
            setDefaultAddr(addr){
                this.isShowPop=true;
                addr.isDefault=1;
                this.$http.post("/web/user/address/save",JSON.stringify(addr)).then(function (res) {
                    alert(res.body.message)
                    if (res.body.success){
                        this.getAddress();
                    }
                })
            },
            back(){
                window.history.back(-1);
            }
        }
    })
</script>
</body>
</html>
