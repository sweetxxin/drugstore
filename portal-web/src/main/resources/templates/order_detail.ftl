<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="author" content="order by xxin"/>
    <title>订单详情-益和药房</title>
    <link rel="stylesheet" type="text/css" href="/web/static/css/header.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/cart.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/checkout.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/pay.css">
    <script type="text/javascript" src="/web/static/layui/layui.js"></script>
    <script type="text/javascript" src="/web/static/js/jquery-1.8.3.min.js"></script>
    <link rel="stylesheet" type="text/css" href="/web/static/layui/css/layui.css">
    <style>
        .info,.comment{
            padding-left: 110px;
            padding-top: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #ccc;
        }
        .comment{
            margin-bottom: 50px;
        }
        .info-title{
            width: 110px;
            display: inline-block;
        }
    </style>
</head>
<body>
 <#include "common/header.ftl"/>
<div class="banner_x center">
    <div class="wdgwc fl ml40">订单详情</div>
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
                <div   class="delivery-content">
                    <div class="receiver">${(delivery.toAddress.receiver)!""}</div>
                    <div>${(delivery.toAddress.mobile)!""}</div>
                    <div class="address">${(delivery.toAddress.province)!""}&nbsp;&nbsp;${(delivery.toAddress.city)!""}&nbsp;&nbsp;${(delivery.toAddress.town)!""}&nbsp;&nbsp;${(delivery.toAddress.detail)!""}</div>
                </div>
            </div>
        </div>
        <div class="product-div">
            <#if product??><#list product as p>
            <div class="content2 center">
                <div class="sub_content fl "></div>
                <div class="sub_content fl"><img src="/resource/static${(p.sku.product.defaultImg)!""}"></div>
                <div class="sub_content fl ft20">${p.sku.skuName!""}</div>
                <div class="sub_content fl ">￥${p.sku.skuPrice!""}</div>
                <div class="sub_content fl">
                    x${-p.amount!""}
                </div>
                <div class="sub_content fl">￥${(-p.amount*p.sku.skuPrice)!""}</div>
                <div class="clear"></div>
            </div>
         </#list></#if>
        </div>
        <div class="info">
            <div><span class="info-title">订单编号:</span><span>${(order.orderNo)}</span></div>
            <div><span class="info-title">创建时间:</span><span>${(order.createTime)}</span></div>
            <div><span class="info-title">支付时间:</span><span>${(order.payTime)!""}</span></div>
            <div><span class="info-title">状态:</span><span>${(order.status)}</span></div>
            <div><span class="info-title">物流方式:</span><span>${(order.delivery.delivery)!""}</span></div>
            <div><span class="info-title">运费:</span><span>${(order.delivery.deliveryFee)!"0"}元</span></div>
        </div>
        <div class="clear"></div>
        <#if assessment??>
                  <form class="layui-form">
                      <div class="comment">
                          <div>
                              <span>描述相符：</span>
                              <div id="descStar"></div>
                          </div>
                          <div>
                              <span>店铺评价：</span>
                              <div id="shopStar"></div>
                          </div>
                          <div>
                              <span>物流服务：</span>
                              <div id="deliveryStar"></div>
                          </div>
                          <div>
                              <span>服务态度：</span>
                              <div id="serviceStar"></div>
                          </div>
                          <div>评论内容:<span style="margin-left: 15px;width: 500px;display: inline-block">${(assessment.msg)!""}</span></div>
                          <div style="margin-top: 10px;padding-left: 75px;">
                <#if (assessment.img)??>
                               <#list assessment.img as i>
                    <img style="height: 100px;width: 100px" src="/resource/static${i.url}">
                               </#list>
                </#if>

                          </div>
                      </div>
                  </form>
        </#if>

    </div>
    <div class="jiesuandan mt20 center">
        <div class="tishi fl ml20">
            <ul>
                <#if (order.code)==0>
                    <li><a onclick="cancelOrder()">取消订单</a></li>
                    <li>|</li>
                </#if>
                <li><a href="/web/page/order" target="_self">全部订单</a></li>
                <li>|</li>
                <li><a href="/web/product/list" target="_self">继续购物</a></li>
                <li>|</li>
                <li>共<span>${(product?size)!0}</span>件商品</li>
                <div class="clear"></div>
            </ul>
        </div>
        <div class="jiesuan fr">
            <div class="jiesuanjiage fl">合计(含运费${(order.delivery.deliveryFee)!"0"}元)：<span>${(order.totalPrice)!""}元</span></div>
            <div class="jsanniu fr">
            <#if (order.code)== 0>
                <input class="jsan"  type="button" onclick="payOrder()"  value="立即支付"/>
                <#elseif (order.code)== 4>
                 <input class="jsan" onclick="changeOrderStatus()" type="submit" name="jiesuan"  value="确认收货"/>
                <#elseif (order.code)== 5>
                 <input class="jsan" onclick="commentOrder()" type="submit" name="jiesuan"  value="去评价"/>
                <#elseif (order.code)== 6>
                 <input class="jsan" disabled type="submit" name="jiesuan"  value="已完成"/>
                <#else >
                   <input class="jsan" disabled type="submit" name="jiesuan"  value="待处理"/>
            </#if>
            </div>
            <div class="clear"></div>
        </div>
        <div class="clear"></div>
    </div>
</div>

<script>
    <#if assessment??>
    layui.use(['rate','form'], function(){
        var form = layui.form;
        var rate = layui.rate;
        //主题色
        rate.render({
            elem: '#shopStar'
            ,value: '${(assessment.shopStar)!5}'
            ,text:true
            ,readonly:true
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
            elem: '#serviceStar'
            ,value: '${(assessment.serviceStar)!5}'
            ,text:true
            ,readonly:true
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
            elem: '#deliveryStar'
            ,value: '${(assessment.deliveryStar)!5}'
            ,text:true
            ,readonly:true
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
            elem: '#descStar'
            ,value: '${(assessment.goodsStar)!5}'
            ,text:true
            ,readonly:true
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
    });
    </#if>
   if ('${order.code}'=='0'){
       layui.use('util', function() {
                var util = layui.util;
                var endTime = getDate('${order.payDeadline}').getTime();
                var serverTime = new Date().getTime();
                util.countdown(endTime, serverTime, function(date,serverTime,timer){
                    var str = date[2] + ':' + date[3];
                    if (endTime<=serverTime){
                        console.log(endTime)
                        console.log(serverTime)
                        alert('截止时间到，订单自动取消');
                        cancelOrder();
                    } else{
                        layui.$('.timing').html(str);
                    }
                });
            });
   }

   function getDate(strdate) {
            var arr = strdate.split(/[- : \/]/);
            date = new Date(arr[0], arr[1]-1, arr[2], arr[3], arr[4], arr[5]);
            return date;
    }
   function payOrder() {
         var order = '${orderJson}';
          console.log(JSON.parse(order))
        $.ajax({
            url: "/web/order/pay",
            data: order,
            type: "POST",
            dataType: "json",
            contentType:"application/json",
            success:function (res) {
                if (res.success){
                    alert("支付成功");
                    window.location = "/web/page/order";
                }
            }
        })
    }
   function commentOrder(){
        window.location = "/web/page/assessment?id="+'${order.mainId}';
    }
   function changeOrderStatus(id){
        $.get("/web/order/"+'${order.mainId}'+"/update/",{},function (res) {
            if(res.success){
                window.location = "/web/page/success?id="+'${order.mainId}';
            }
        })
    }
   function cancelOrder(){
        console.log('取消订单');
        $.post('/web/order/cancel',{"id":'${order.mainId}'},function (res) {
            if (res.success){
                window.location = "/web/page/order";
            }
        })
    }
</script>
</body>
</html>
