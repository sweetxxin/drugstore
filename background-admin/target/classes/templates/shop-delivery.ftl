<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房后台管理</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
    <style>
        .myShop{
            color: white !important;
            background: #5FB878;
        }
    </style>
</head>
<body class="layui-layout-body">
<div id="app" class="layui-layout layui-layout-admin">
<#include "common/top-nav.ftl"/>
<#include "common/left-nav.ftl"/>
    <div class="layui-body">
        <!-- 内容主体区域 -->
        <div style="padding: 15px;margin-top: 30px;">
            <template v-for="(delivery,index) in deliveryList">
                <fieldset  style="display: inline-block;margin-right:20px;position: relative" class="layui-elem-field">
                    <legend><input v-model="delivery.title" style="width: 100px;border: 0px">
                        <span @click="updateDelivery(delivery)" class="layui-badge" style="position: absolute;top: 0px;right: 20px;cursor: pointer">√</span>
                        <span @click="delDelivery(index,delivery.mainId)" class="layui-badge" style="position: absolute;top: 0px;right: -10px;cursor: pointer">×</span>
                    </legend>
                    <div id="delivery-input" style="padding-top: 10px">
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">物流公司</label>
                                <div class="layui-input-inline">
                                    <input v-model="delivery.company" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">运费</label>
                                <div class="layui-input-inline">
                                    <input v-model="delivery.fee" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">联系方式</label>
                                <div class="layui-input-inline">
                                    <input type="tel" v-model="delivery.contact" name="phone" lay-verify="required|phone" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">配送地址</label>
                                <div class="layui-input-inline">
                                    <input v-model="delivery.fromAddress" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                        </div>
                    </div>
                </fieldset>
            </template>
            <div>
                <button @click="addDelivery()" type="button" class="layui-btn layui-btn-warm">添加</button>
            </div>

        </div>
    </div>
<#include "common/footer.ftl"/>


</div>
<script src="/admin/static/frame/layui/layui.js"></script>
<script src="/admin/static/js/jquery-1.8.3.min.js"></script>
<script src="/admin/static/js/vue.js"></script>
<script src="/admin/static/js/vue-resource.min.js"></script>
<script>

    var vue = new Vue({
        el:"#app",
        data:{
            deliveryList:[],
        },
        mounted:function () {
            $('#left-nav-1').html("我的商店");
            $('#left-nav-1-child')
                    .append("<dd><a href='/admin/page/shop'>基本信息</a>" + "</dd>")
                    .append("<dd><a href='/admin/page/customer'>商店用户</a>" + "</dd>")
                    .append("<dd><a href='/admin/page/shop-activity'>商店活动</a>" + "</dd>")
                    .append("<dd><a style='color:white;background: #009688;'href='/admin/page/shop-delivery'>物流信息</a>" + "</dd>")
                    .append("<dd><a href='/admin/page/verify'>商家认证</a>" + "</dd>");
            var _self = this;
            layui.use(['element','form'], function(){
                var element = layui.element;
                var form = layui.form;
            });
            this.getShopDelivery();
        },
        methods:{
            getShopDelivery(){
                this.$http.get("/admin/shop/delivery").then(function (res){
                    this.deliveryList = res.body.data;
                })
            },
            updateDelivery(delivery){
                this.$http.post("/admin/shop/delivery/update",JSON.stringify(delivery)).then(function (res){
                    if (res.body.success){
                        layer.msg("更新成功")
                    }
                    console.log(res)
                })
            },
            delDelivery(idx,id){
                var _self = this;
                layer.confirm('删除操作不可逆，确定删除吗', {
                    time: 20000, //20s后自动关闭
                    btn: ['确定', '取消'],
                    title:"警告",
                    btn1: function(index, layero){
                        _self.$http.get("/admin/shop/delivery/"+id+"/del").then(function (res){
                            if (res.body.success){
                                _self.deliveryList.splice(idx,1);
                                layer.msg("删除成功");
                            }
                            layer.closeAll("confirm");
                        })
                    }
                });

            },
            addDelivery(){
                var pop = '<div id="newDelivery-pop" style="padding-top: 10px">\n' +
                        '    <div class="layui-form-item">\n' +
                        '        <div class="layui-inline">\n' +
                        '            <label class="layui-form-label">标题</label>\n' +
                        '            <div class="layui-input-inline">\n' +
                        '                <input v-model="newDelivery.title" autocomplete="off" class="layui-input">\n' +
                        '            </div>\n' +
                        '        </div>\n' +
                        '    </div>\n' +
                        '    <div class="layui-form-item">\n' +
                        '        <div class="layui-inline">\n' +
                        '            <label class="layui-form-label">物流公司</label>\n' +
                        '            <div class="layui-input-inline">\n' +
                        '                <input v-model="newDelivery.company" autocomplete="off" class="layui-input">\n' +
                        '            </div>\n' +
                        '        </div>\n' +
                        '    </div>\n' +
                        '    <div class="layui-form-item">\n' +
                        '        <div class="layui-inline">\n' +
                        '            <label class="layui-form-label">运费</label>\n' +
                        '            <div class="layui-input-inline">\n' +
                        '                <input v-model="newDelivery.fee" autocomplete="off" class="layui-input">\n' +
                        '            </div>\n' +
                        '        </div>\n' +
                        '    </div>\n' +
                        '    <div class="layui-form-item">\n' +
                        '        <div class="layui-inline">\n' +
                        '            <label class="layui-form-label">联系方式</label>\n' +
                        '            <div class="layui-input-inline">\n' +
                        '                <input type="tel" v-model="newDelivery.contact" name="phone" lay-verify="required|phone" autocomplete="off" class="layui-input">\n' +
                        '            </div>\n' +
                        '        </div>\n' +
                        '    </div>\n' +
                        '    <div class="layui-form-item">\n' +
                        '        <div class="layui-inline">\n' +
                        '            <label class="layui-form-label">配送地址</label>\n' +
                        '            <div class="layui-input-inline">\n' +
                        '                <input v-model="newDelivery.fromAddress" autocomplete="off" class="layui-input">\n' +
                        '            </div>\n' +
                        '        </div>\n' +
                        '    </div>\n' +
                        '</div>';
                var _self = this;
                layui.use(['layer'], function(){
                    var layer = layui.layer;
                    layer.open({
                        type: 1
                        ,content: pop
                        ,btn: ['确定','取消']
                        ,title:"新增物流"
                        ,area: ['400px', '400px']
                        ,btnAlign: 'c' //按钮居中
                        ,shade: 0 //不显示遮罩
                        ,yes: function(){
                            if (popVue.newDelivery.title==null){
                                layer.msg("请完善内容");
                                return;
                            }
                            layer.closeAll();
                            _self.$http.post("/admin/shop/delivery/add",JSON.stringify(popVue.newDelivery)).then(function (res){
                                if (res.body.success){
                                    _self.deliveryList.push(res.body.data);
                                    layer.msg("添加成功")
                                }
                            })
                        },
                        success:function () {
                            popVue = new Vue({
                                el:"#newDelivery-pop",
                                data:{
                                    newDelivery:{}
                                }

                            });
                        }
                    });
                })
            }
        }
    })
</script>