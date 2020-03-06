<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>商品详情</title>
    <link rel="stylesheet" type="text/css" href="/web/static/css/header.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/list.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/product-detail.css">
    <link rel="stylesheet" type="text/css" href="/web/static/layui/css/layui.css">
    <script type="text/javascript" src="/web/static/layui/layui.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
    <style>
        ::-webkit-scrollbar {
            display: none; /* Chrome Safari */
        }
        .detail{
            width: 800px;
        }
        .comment{
            max-height: 1280px;
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
            color:#d81e06;
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
            object-fit: cover;
            width: 90%;

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
 <#include "common/header.ftl"/>
 <#include "common/search.ftl"/>
<div id="app">
<div  class="content content-nav-base datails-content">
    <div class="main-nav">
        <div class="inner-cont0">
            <div class="inner-cont1 w1200">
            </div>
        </div>
    </div>
    <div class="data-cont-wrap w1200">
        <div class="crumb">
            <a href="/web/page/index">首页</a>
            <span>></span>
            <a href="/web/product/list">所有商品</a>
            <span>></span>
            <a href="javascript:;">产品详情</a>
        </div>
        <div class="product-intro layui-clear">
            <div class="preview-wrap">
                <div class="preview-on"><img :src="preImgUrl"></div href="javascript:;">
                <div class="preview-list">
                    <#if imgList?exists>
                        <#list imgList as img>
                        <#list img?keys as key>
                        <#if key=="url">
                            <div class="preview-list-img">
                                <img @mouseover="previewImg('/resource/static${img[key]}')" src="/resource/static${img[key]}">
                            </div>
                        </#if>
                        </#list>
                        </#list>
                    </#if>
                </div>
            </div>
            <div class="itemInfo-wrap">
                <div class="itemInfo">
                    <div class="title">
                        <h4>{{selectedProduct.name}} </h4>
                        <span><i class="layui-icon layui-icon-rate-solid"></i>收藏</span>
                    </div>
                    <div class="summary">
                        <p class="reference"><span>原价</span> <del>￥{{selectedSku.marketPrice}}</del></p>
                        <p class="activity">
                            <span>现价</span>
                            <strong class="price"><i>￥</i>{{parseFloat(selectedSku.skuPrice*buyAmount).toFixed(2)}}</strong>
                        </p>
                        <p class="address-box"><span>发&nbsp;&nbsp;&nbsp;&nbsp;货</span><strong v-if="selectedSku.delivery" class="address">{{selectedSku.delivery.fromAddress}}</strong></p>
                        <p class="activity">
                            <span>运费</span>
                            <del v-if="selectedSku.delivery">￥{{selectedSku.delivery.fee}}</del>
                        </p>
                    </div>
                    <div class="choose-attrs">
                        <div class="color layui-clear">
                            <span class="title">规&nbsp;&nbsp;&nbsp;&nbsp;格</span>
                            <div v-for="(sku,index) in skuList" class="color-cont">
                                <span  @click="selectThisSku(index)" :class="computedBtnOn[index]" class="btn">{{sku.skuName}}</span>
                            </div>
                        </div>

                        <div class="number layui-clear"><span class="title">数&nbsp;&nbsp;&nbsp;&nbsp;量</span><div class="number-cont"><span  @click="decreaseAmount()" class="cut btn">-</span><input onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}" onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}" maxlength="4" type="" name="" v-model="buyAmount"><span @click="increaseAmount()" class="add btn">+</span></div></div>
                    </div>
                    <div class="choose-btns">
                        <button @click="addInCart()" class="layui-btn layui-btn-primary  cart-btn" style="border: 1px solid #ff5500;color: #ff5500;"><i class="layui-icon layui-icon-cart-simple"></i>加入购物车</button>
                        <button @click="buyNow()" class="layui-btn  layui-btn-danger purchase-btn" style="color:white">立刻购买</button>


                    </div>
                </div>
            </div>
        </div>
        <div class="layui-clear">
            <div class="aside">
                <h4>热销推荐</h4>
                <div  class="item-list">
                    <#if hotProduct??>
                        <#list hotProduct as hot>
                            <div  class="item">
                                <img src="${'/resource/static'+hot.defaultImg}">
                                <p><span>${hot.name}</span><span class="price">￥99.00</span></p>
                                <p></p>
                            </div>
                        </#list>
                    </#if>
                </div>
            </div>
            <div class="detail">
                <h4 @click="setDetailActive()" :class="detailActive">详情</h4>
                <h4 @click="setShopActive()" :class="shopActive">店铺</h4>
                <h4 @click="setCommentActive()" :class="commentActive">评论({{commentCount}})</h4>
                <div v-show="detailActive=='active'" class="info">
                    <div class="base-info">
                        <div class="item-base-info-title">产品编号:</div>
                        <div class="item-base-info-content">{{selectedProduct.productNo}}</div>
                    </div>
                    <div class="base-info">
                            <div class="item-base-info-title">保质期:</div>
                            <div class="item-base-info-content">{{selectedProduct.guarantee}}</div>
                    </div>
                    <div class="base-info">
                        <div class="item-base-info-title">存储方式:</div>
                        <div class="item-base-info-content">{{selectedProduct.storageCondition}}</div>
                    </div>
                    <div class="base-info">
                        <div class="item-base-info-title">净含量:</div>
                        <div class="item-base-info-content">{{selectedProduct.netWeight}}kg</div>
                    </div>
                    <div class="base-info">
                        <div class="item-base-info-title">用法用量:</div>
                        <div class="item-base-info-content">{{selectedProduct.dosage}}</div>
                    </div>
                    <div class="base-info">
                        <div class="item-base-info-title">生产地:</div>
                        <div class="item-base-info-content">{{selectedProduct.originPlace}}</div>
                    </div>
                    <div class="base-info">
                        <div class="item-base-info-title">厂家信息:</div>
                        <div class="item-base-info-sub">
                            <div class="base-info">
                                    <div class="item-base-info-title">厂名：</div>
                                    <div class="item-base-info-content">{{factoryInfo.name}}</div>
                            </div>
                                <div class="base-info">
                                    <div class="item-base-info-title">厂家地址</div>
                                    <div class="item-base-info-content">{{factoryInfo.address}}</div>
                                </div>
                                <div class="base-info">
                                    <div class="item-base-info-title">联系电话</div>
                                    <div class="item-base-info-content">{{factoryInfo.contact}}</div>
                                </div>
                            </div>
                        </div>
                    <div  class="base-info">
                        <div class="item-base-info-title">简介:</div>
                        <div class="item-base-info-content">{{selectedProduct.description}}</div>
                    </div>
                    <div class="pic-show">
                        <img v-if="selectedProduct.instruction" :src="'/resource/static'+selectedProduct.instruction">
                    </div>
                    <div class="pic-show">
                        <img v-if="selectedProduct.poster" :src="'/resource/static'+selectedProduct.poster">
                    </div>
                </div>
                <div v-show="shopActive=='active'" class="shop">
                    <div class="base-info">
                        <div  class="item-base-info-title">店名:</div>
                        <div class="item-base-info-content">{{shopInfo.name}}</div>
                    </div>
                    <div class="base-info">
                        <div class="item-base-info-title">地址:</div>
                        <div class="item-base-info-content">{{shopInfo.address}}</div>
                    </div>
                    <div class="base-info">
                        <div class="item-base-info-title">联系方式:</div>
                        <div class="item-base-info-content">{{shopInfo.mobile}}</div>
                    </div>
                    <div v-if="shopInfo.poster" class="pic-show">
                        <img :src="'/resource/static'+shopInfo.poster">
                    </div>
                </div>
                <div v-show="commentActive=='active'" class="comment">
                    <div v-for="(comment,index) in commentList" class="comment-item">
                        <div class="item-top">
                            <template  v-if="comment.isPublic==1">
                                <img v-if="comment.creator.avatar!=null" class="user-avatar" :src="'/resource/static'+comment.creator.avatar">
                                <img v-else class="user-avatar" src="/resource/static/img/avatar.png">
                                <span  class="user-name">{{comment.creator.nickName}}</span>
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
                            <div @click="thumbUp(comment.mainId,index)" :style="thumbUpOn(index)" class="oper">
                                <img class="oper-pic" :src="thumbUpIcon(index)">
                                赞({{comment.good}})
                            </div>
                            <div @click="reply(comment.mainId,index)" class="oper">
                                <img class="oper-pic" src="/resource/static/img/reply.png">
                                回复({{comment.reply}})
                            </div>
                            <div :style="againstOn(index)" @click="against(comment.mainId,index)" class="oper">
                                <img class="oper-pic" :src="againstIcon(index)">
                                <span class="againstText">举报</span>({{comment.against}})
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>
<script type="text/javascript">
    var index = null;
    var vue = new Vue({
        el:"#app",
        data:{
            selectedProduct:{},
            buyAmount:1,
            currentIndex:0,
            size:5,
            selectedSku:{},
            previewList:[],
            skuList:[],
            preImgUrl:"",
            btnOn:[],
            totalPrice:0,
            hotList:[],
            factoryInfo:{},
            shopInfo:{},
            keyword:null,
            detailActive:"active",
            shopActive:"",
            commentActive:"",
            commentList:[],
            commentCount:0,
            layer:null
        },
        mounted:function(){
            localStorage.removeItem("buyCart");
            if (localStorage.getItem("selectedProduct")==null){
                window.location = "/web/page/list"
            }else {
                this.selectedProduct = JSON.parse(localStorage.getItem("selectedProduct"));

                this.getSku();
                this.previewImg("/resource/static"+this.selectedProduct.defaultImg);
                this.getShopInfo();
                this.getFactoryInfo();
                this.getComment();
                var self = this;
                layui.use('layer', function () {
                    self.layer = layui.layer;
                })

            }
        },
        methods:{
            previewImg(url){
                this.preImgUrl = url;
            },
            selectThisSku(index){
                this.selectedSku = this.skuList[index];
                for (var i in this.btnOn){
                    this.btnOn[i]="";
                }
                this.btnOn[index]="active";
                // this.buyAmount=1;
                console.log(this.btnOn)
            },
            increaseAmount(){
                this.buyAmount++;
            },
            decreaseAmount(){
                this.buyAmount--;
            },
            buyNow(){
                this.selectedProduct.sku =  this.selectedSku;
                this.selectedProduct.amount = this.buyAmount;
                this.totalPrice = this.selectedSku.skuPrice*this.buyAmount;
                var buy = {
                    "product":[this.selectedProduct],
                    "totalPrice":this.totalPrice,
                    "delivery": this.selectedProduct.sku.delivery
                }
                localStorage.setItem("buyCart",JSON.stringify(buy))
                window.location = "/web/page/checkout";
            },
            addInCart(){
                this.$http.post("/web/cart/add/"+this.selectedSku.mainId+"/"+this.buyAmount).then(function (res) {
                    if(res.body.success){
                        cart.countCart();
                        this.layer.msg('添加成功')
                    }else{
                        if (res.body.code==-1){
                            alert("您还没登陆，请先登陆")
                            window.location="/oauth/user/login";
                        }
                    }
                })
            },
            getSku(){
                this.$http.get("/web/product/"+this.selectedProduct.mainId+"/sku").then(function (res) {
                    this.skuList = res.body.data;
                    this.selectedSku = this.skuList[0];
                    this.totalPrice = this.selectedSku.skuPrice*this.buyAmount;
                    this.btnOn.push("active");
                    console.log(this.skuList)
                    for(var i in this.skuList){
                        this.btnOn.push("");
                    }
                })
            },
            getFactoryInfo(){
                if (this.selectedProduct.factory!=null)
                this.factoryInfo = this.selectedProduct.factory;
            },
            getShopInfo(){
                if (this.selectedProduct.shop!=null)
                this.shopInfo = this.selectedProduct.shop;
            },
            setDetailActive(){
                this.detailActive = "active";
                this.shopActive ="";
                this.commentActive="";
            },
            setShopActive(){
                this.detailActive = "";
                this.shopActive ="active";
                this.commentActive="";
            },
            setCommentActive(){
                this.detailActive = "";
                this.shopActive ="";
                this.commentActive="active";
                // this.getComment();
            },
            getComment(){
                this.showLoading();
                this.$http.post("/web/assessment/"+this.selectedProduct.mainId+"?index="+this.currentIndex+"&size="+this.size).then(function (res) {
                    if (res.body.success){
                        this.commentList = res.body.data.content;
                        this.commentCount = res.body.data.totalElements;
                    }
                    this.hideLoading();
                })
            },
            showLoading(){
                layui.use('layer', function () {
                    this.loading = layer.load(2, {
                        shade: false,
                        time: 5 * 1000
                    });
                })
            },
            hideLoading(){
                layui.use('layer', function(){
                    console.log("here")
                    layer.close(this.loading);
                })
            },
            thumbUpOn(index) {
                if (this.commentList[index].giveGood) {
                    return "color:#d81e06";
                }
                return "";
            },
            againstOn(index) {
                if (this.commentList[index].giveAgainst) {
                    return "color:#d81e06";
                }
                return "";
            },
            thumbUpIcon(index){
                if (this.commentList[index].giveGood) {
                    return "/resource/static/img/good-on.png";
                }
                return "/resource/static/img/good.png";
            },
            againstIcon(index){
                if (this.commentList[index].giveAgainst) {
                    $('.againstText').text("已举报")
                    return "/resource/static/img/against-on.png";
                }
                return "/resource/static/img/against.png";
            },
            thumbUp(id,index){
                if (this.commentList[index].giveGood){
                    this.$http.post("/web/user/thumbUp/cancel",{"itemId":id},{emulateJSON:true}).then(function (res) {
                        if (res.body.success){
                            this.commentList[index].good-=1;
                            this.commentList[index].giveGood=false;
                        }else{
                            if (res.body.code==-1){
                                alert(res.body.message);
                                window.location="/oauth/user/login";
                            }
                        }
                    })
                }else{
                    this.$http.post("/web/user/thumbUp",{"itemId":id},{emulateJSON:true}).then(function (res) {
                        if (res.body.success){
                            this.commentList[index].good+=1;
                            this.commentList[index].giveGood=true;
                        }else{
                            if (res.body.code==-1){
                                alert(res.body.message);
                                window.location="/oauth/user/login";
                            }
                        }
                    })
                }

            },
            against(id,index){
                if(this.commentList[index].giveAgainst){
                    layer.msg("您已举报过")
                    return;
                }
                var self = this;
                var div = '<div><textarea style="height: 250px;resize: none;border:none;" lay-verify="required" id="against" placeholder="请输入举报原因" class="layui-textarea"></textarea></div>';
                this.layer.open({
                    type: 1,
                    title:'举报中...',
                    area: ['500px', '300px'],
                    content: div,
                    btn:["确定","取消"],
                    yes: function(idx, layero){
                        if ($("#against").val()==""){
                            layer.msg('举报内容不能为空');
                            return;
                        }
                        $.post("/web/assessment/against",{"id":id,"content":$("#against").val()},function (res) {
                            if (res.success){
                                layer.close(idx);
                                self.commentList[index].against+=1;
                                $('.againstText').text("已举报")
                                layer.msg("举报成功");
                            }else{
                                if (res.code==-1){
                                    alert(res.message);
                                    window.location="/oauth/user/login";
                                }
                            }

                        })
                    }
                    ,btn2: function(index, layero){
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
                this.layer.open({
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
                            $.post("/web/assessment/reply",{"id":id,"content":$("#reply-text").val()},function (res) {
                                if (res.success){
                                    self.commentList[index].reply+=1;
                                    layer.msg("回复成功");
                                    layer.close(idx);
                                } else{
                                    if (res.code==-1){
                                        alert(res.message);
                                        window.location="/oauth/user/login";
                                    }
                                }
                            })
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
        },
        watch:{
            buyAmount:function () {
                if (this.buyAmount<=0){
                    this.buyAmount=1;
                }
            }
        },
        computed:{
            computedBtnOn(){
                return this.btnOn;
            }
        }

    })
</script>


</body>
</html>