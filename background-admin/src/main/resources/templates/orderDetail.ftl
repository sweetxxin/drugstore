<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房-卖家平台</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
    <style>
        .layui-input, .layui-textarea{
            border: 0px;
        }
    </style>
</head>
<body>
<div class="layui-collapse" lay-accordion>
    <div class="layui-colla-item">
        <h2 class="layui-colla-title">订单信息</h2>
        <div class="layui-colla-content layui-show">
            <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">订单编号</label>
                <div class="layui-input-inline">
                    <input type="text" disabled value="${(order.orderNo)!""}" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">订单状态</label>
                <div class="layui-input-inline">
                    <input type="text" disabled value="${(order.status)!""}" class="layui-input">
                </div>
            </div>
        </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">下单时间</label>
                    <div class="layui-input-inline">
                        <input type="text" disabled value="${(order.createTime)!""}" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">订单总额</label>
                    <div class="layui-input-inline">
                        <input type="text" disabled value="￥${(order.totalPrice)!0}" class="layui-input">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="layui-colla-item">
        <h2 class="layui-colla-title">商品列表</h2>
        <div class="layui-colla-content layui-show">
            <#if product??>
            <#list product as p>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">产品名称</label>
                        <div class="layui-input-inline">
                            <#--${(p.sku.skuName)!""}-->
                            <input type="text" disabled value="${(p.sku.skuName)!""}" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">产品单价</label>
                        <div class="layui-input-inline">
                            <input type="text" disabled value="￥${(p.sku.skuPrice)!""}" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">购买数量</label>
                        <div class="layui-input-inline">
                            <input type="text" disabled value="${(-p.amount)!""}" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">小计</label>
                        <div class="layui-input-inline">
                            <input type="text" disabled value="￥${(-p.amount*p.sku.skuPrice)!""}" class="layui-input">
                        </div>
                    </div>
                </div>
            </#list>
            </#if>
        </div>
    </div>
    <div class="layui-colla-item">
        <h2 class="layui-colla-title">顾客信息</h2>
        <div class="layui-colla-content layui-show">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">姓名</label>
                <div class="layui-input-inline">
                    <input type="text" disabled value="${(customer.name)!""}" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">联系方式</label>
                <div class="layui-input-inline">
                    <input type="text" disabled value="${(customer.mobile)!""}" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">性别</label>
                <div class="layui-input-inline">
                    <input type="text" disabled value="${(customer.gender)!""}" class="layui-input">
                </div>
            </div>
        </div>
    </div>
    </div>
    <div class="layui-colla-item">
        <h2 class="layui-colla-title">物流信息</h2>
        <div class="layui-colla-content layui-show">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">收件人</label>
                    <div class="layui-input-inline">
                        <input type="text" disabled value="${(delivery.toAddress.receiver)!""}" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">联系方式</label>
                    <div class="layui-input-inline">
                        <input type="text" disabled value="${(delivery.toAddress.mobile)!""}" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">物流方式</label>
                    <div class="layui-input-inline">
                        <input type="text" disabled value="${(delivery.delivery)!""}" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">运费</label>
                    <div class="layui-input-inline">
                        <input type="text" disabled value="${(delivery.deliveryFee)!""}" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">配送地址</label>
                    <div class="layui-input-inline">
                        <input type="text" disabled value="${(delivery.toAddress.province)!""}${(delivery.toAddress.city)!""}${(delivery.toAddress.town)!""}${(delivery.toAddress.detail)!""}" class="layui-input">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <#if assessment??>
    <div class="layui-colla-item">
        <h2 class="layui-colla-title">订单评价</h2>
        <div class="layui-colla-content layui-show">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">用户名</label>
                    <div class="layui-input-inline">
                        <input type="text" disabled value="${(assessment.creator.nickName)!""}" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">评论时间</label>
                    <div class="layui-input-inline">
                        <input type="text" disabled value="${(assessment.createTime)!""}" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">评论</label>
                    <div class="layui-input-inline">
                        <input type="text" disabled value="${(assessment.msg)!""}" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">商品描述</label>
                    <div id="descStar"></div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">商店描述</label>
                    <div id="shopStar"></div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">物流服务</label>
                    <div id="deliveryStar"></div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">服务态度</label>
                    <div id="serviceStar"></div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">图片</label>
                <#if (assessment.img)??>
                    <#list assessment.img as img>
                        <img style="height: 100px;width: 100px;" src="/resource/static${img.url}">
                    </#list>
                </#if>
            </div>
        </div>
    </div>
    </#if>
</div>
</body>
<script src="/admin/static/frame/layui/layui.js"></script>
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
    layui.use('element', function(){
        var element = layui.element;
    });
</script>
</html>