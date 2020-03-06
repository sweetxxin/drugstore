<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="author" content="xxin"/>
    <title>我的购物车-京鲜生</title>
    <link rel="stylesheet" type="text/css" href="/web/static/css/cart.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/header.css">
    <link rel="stylesheet" type="text/css" href="/web/static/layui/css/layui.css">
</head>
<body>
<!-- start header -->
 <#include "common/header.ftl"/>
<!--end header -->
<!-- start banner_x -->
<div id="app">
<div class="banner_x center">
    <a href="/web/page/index" target="_self"><div class="logo fl"></div></a>
    <div class="wdgwc fl ml40">我的购物车</div>
    <div class="wxts fl ml20">温馨提示：产品是否购买成功，以最终下单为准哦，请尽快结算</div>
    <div @click="clearCart()" class="fr clearCart">清空购物车</div>
    <div @click="clearOffCart()" class="fr clearCart">清空失效商品</div>
    <div class="clear"></div>
</div>
<div class="xiantiao"></div>
<div  class="gwcxqbj">
    <div class="gwcxd center">
        <div class="top2 center">
            <div class="sub_top fl">
                <input type="checkbox" @click="selectAll()" :checked="checkedAll" value="quanxuan" class="quanxuan" /><span style="vertical-align: middle;margin-left: 5px;">全选</span>
            </div>
            <div class="sub_top fl">商品名称</div>
            <div class="sub_top fl">单价</div>
            <div class="sub_top fl">数量</div>
            <div class="sub_top fl">小计</div>
            <div class="sub_top fr">操作</div>
            <div class="clear"></div>
        </div>
        <div id="cartScroll" class="cart-scroll">
            <div v-for="(cart,index) in myCart" class="content2 center">
                <div class="sub_content fl ">
                    <input v-show="cart.sku.product.isShow==1" type="checkbox" @click="selectThis(index)" :checked="isSeleted" value="quanxuan" class="quanxuan" />
                </div>
                <div class="sub_content fl"><img :src="'/resource/static'+cart.sku.product.defaultImg"></div>
                <div class="sub_content fl ft20"><a :href="'/web/page/product/detail?id='+cart.sku.product.mainId"class="getDetail">{{cart.sku.product.name}}-{{cart.sku.skuName}}</a></div>
                <div class="sub_content fl ">{{cart.sku.skuPrice}}</div>
                <div class="sub_content fl">
                    <input class="shuliang" type="number" v-model="cart.amount" step="1" min="1" >
                </div>
                <div class="sub_content fl">{{parseFloat(cart.amount*cart.sku.skuPrice).toFixed(2)}}</div>
                <div class="off" v-if="cart.sku.product.isShow!=1">已失效</div>
                <div class="del"><a @click="deleteCart(cart.mainId)" >×</a></div>

                <div class="clear"></div>
            </div>

            <div v-show="!isLoadAll" class="cart-loading">
                <i class="layui-icon layui-icon-loading layui-icon layui-anim layui-anim-rotate layui-anim-loop"></i>
                <div class="doc-icon-name">玩命加载中...</div>
            </div>
            <div  v-show="isLoadAll" class="cart-load-all">--已加载全部--</div>
        </div>

    </div>
    <div class="jiesuandan mt20 center">
        <div class="tishi fl ml20">
            <ul>
                <li><a @click="back()" >返回</a></li>
                <li>|</li>
                <li><a href="/page/web/index" target="_self">继续购物</a></li>
                <li>|</li>
                <li>共<span>{{totalNum}}</span>件商品，已选择<span>{{numCount}}</span>件</li>
                <li v-show="showDelBtn" @click="deleteCartIn()" class="delCart" style="cursor:pointer;color: #ff6700;">删除选中的商品</li>
                <div class="clear"></div>
            </ul>
        </div>
        <div class="jiesuan fr">
            <div class="jiesuanjiage fl">合计（不含运费）：<span>{{computeTotalPrice}}元</span></div>
            <div class="jsanniu fr"><input class="jsan" type="submit" name="jiesuan" @click="toBuy()" value="去结算"/></div>
            <div class="clear"></div>
        </div>
        <div class="clear"></div>
    </div>
</div>
</div>
<script>
    var vue = new Vue({
        el: "#app",
        data: {
            myCart: [],
            currentIndex: 1,
            isSelectAll:false,
            isSeleted:false,
            totalPrice:0,
            numCount:0,
            selected:{},
            totalNum:0,
            isLoadAll:false,
            showDelBtn:false,
            checkedAll:false
        },
        mounted:function () {
            localStorage.removeItem("buyCart");
            this.getMyCart();
            var _self = this;
            $('#cartScroll').scroll(function () {
                var scrollTop = $('#cartScroll').scrollTop();//被滚动条隐藏的高度，随着滚动条下拉变大
                var height = $('#cartScroll').height();//可见区域高度
                var scrollHeight = $('#cartScroll').get(0).scrollHeight;//元素里面内容的实际高度
                if (!_self.isLoadAll&&scrollTop+height+100>=scrollHeight){
                    _self.currentIndex++;
                    _self.getMyCart();
                }
            })
        },
        methods:{
            getMyCart(){
                this.$http.get("/web/cart/list/"+this.currentIndex).then(function (res) {
                    if (res.body.data.last){
                        this.isLoadAll = true;
                    }
                    if (res.body.data.content.length !=0) {
                        this.myCart.push.apply(this.myCart,res.body.data.content);
                    }
                    this.totalNum = res.body.data.totalElements;
                })
            },
            selectAll(){
                this.isSelectAll = !this.isSelectAll;
            },
            toBuy(){
                if (this.numCount==0){
                    alert("请选择想要购买的商品")
                    return;
                }
                var delivery={};
                var buyCart ={
                    "totalPrice":this.totalPrice,
                     "product":[]
                };
                var fee = 0;
                for(var i in this.selected){
                    if (this.selected[i]) {
                        buyCart.product.push(this.myCart[i]);
                        if (this.myCart[i].sku.delivery.fee>fee){
                            fee=this.myCart[i].sku.delivery.fee;
                            buyCart.delivery=this.myCart[i].sku.delivery;
                        }
                    }
                }
                localStorage.setItem("buyCart",JSON.stringify(buyCart));
                window.location = "/web/page/checkout";
            },
            selectThis(index){
                if (this.selected[index]==null||this.selected[index]==false){
                    this.selected[index]=true;
                    this.numCount++;
                } else{
                    this.selected[index]=false;
                    this.numCount--;
                }
                console.log(this.selected)
            },
            deleteCart(id){
                if (confirm("删除操作不可逆，确定吗？")){
                    this.$http.get("/web/cart/delete/"+id).then(function (res) {
                        console.log(res.body.data);
                        alert(res.body.message)
                        location.reload();
                    })
                }
            },
            deleteCartIn(){
                if (confirm("确定删除选中的商品吗？")){
                    var ids = [];
                    for(var i in this.selected){
                        if (this.selected[i]) {
                            ids.push(this.myCart[i].mainId)
                        }
                    }
                    this.$http.post("/web/cart/delete/in",ids).then(function (res) {
                        console.log(res.body.data);
                        alert(res.body.message)
                        if (res.body.success){
                            location.reload();
                        }
                    })
                }
            },
            clearCart(){
                if (confirm("清空购物车不可逆，确定吗？")){
                    this.$http.get("/web/cart/clear").then(function (res) {
                        console.log(res.body.data);
                        alert(res.body.message)
                        if (res.body.success){
                            location.reload();
                        }
                    })
                }
            },
            clearOffCart(){
                if (confirm("一键清除失效商品？")){
                    this.$http.get("/web/cart/off/clear").then(function (res) {
                        alert(res.body.message)
                        if (res.body.success){
                            location.reload();
                        }
                    })
                }
            },
            back(){
                window.history.back(-1);
            }
        },
        watch:{
            isSelectAll:function () {
                if (this.isSelectAll){
                    var count = 0;
                    for (var i in this.myCart){
                        if (this.myCart[i].sku.product.isShow==1){
                            this.selected[i]=true;
                        }else{
                            count++;
                            this.selected[i]=false;
                        }
                    }
                    this.numCount = this.myCart.length-count;
                    this.isSeleted = true;
                }else {
                    for (var i in this.myCart){
                        this.selected[i]=false;
                    }
                    this.numCount=0;
                    this.isSeleted = false;
                }
            },
            numCount:{
                handler (newVal,oldVal) {
                    var tmp = 0;
                    for(var key in this.selected){
                        if(this.selected[key]){
                            tmp+=this.myCart[key].amount*this.myCart[key].sku.skuPrice;
                        }
                    }
                    this.totalPrice = tmp;
                    if (this.numCount>0){
                        this.showDelBtn = true;
                    }else{
                        this.showDelBtn = false;
                    }
                    if (this.numCount!=this.totalNum){
                        this.checkedAll = false;
                    }else{
                        this.checkedAll = true;
                    }
                },
                deep:true
            }
        },
        computed:{
            computeTotalPrice(){
               this.totalPrice = 0;
                for(var key in this.selected){
                    if(this.selected[key]){
                        this.totalPrice+=this.myCart[key].amount*this.myCart[key].sku.skuPrice;
                    }
                }
                this.totalPrice = parseFloat(this.totalPrice).toFixed(2);
                return this.totalPrice;
            }
        }
    })
</script>
</body>
</html>
