<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房-卖家平台</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
    <style>
        .myProduct{
            color: white !important;
            background: #5FB878;
        }
        #skukList::-webkit-scrollbar{
            display: none;
        }
    </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
<#include "common/top-nav.ftl"/>
   <#include "common/left-nav.ftl"/>
    <div id="app" class="layui-body">
        <!-- 内容主体区域 -->
        <div style="padding: 15px;">
            <div class="layui-inline">
                <label class="layui-form-label">输入商品信息</label>
                <div class="layui-input-inline">
                    <input type="text" placeholder="商品编号/名称/关键词" v-model="keyword" class="layui-input">
                </div>
                <div class="layui-input-inline">
                    <button type="button" @click="searchProductSku()" class="layui-btn layui-btn-fluid">搜索</button>
                </div>
            </div>
            <div id="skukList" style="height: 500px;overflow: scroll;overflow-x: hidden">
                <form v-for="(stock,index) in stockList" class="layui-form" action="">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">库存名称</label>
                            <div style="width: 300px;" class="layui-input-inline">
                                <input  type="text" v-model="stock.skuName" class="layui-input">
                            </div>
                        </div>
                        <div  class="layui-inline">
                            <label class="layui-form-label">当前库存</label>
                            <div style="width: 50px;" class="layui-input-inline">
                                <input type="text" v-model="stock.stock" disabled class="layui-input">
                            </div>
                        </div>
                        <div  class="layui-inline">
                            <label class="layui-form-label">添加数量</label>
                            <div style="width: 80px;" class="layui-input-inline">
                                <input type="number" v-model="stock.num" class="layui-input">
                            </div>
                        </div>
                        <div  class="layui-inline">
                            <button type="button" @click="addProduct(index)" class="layui-btn layui-btn-normal">添加</button>
                        </div>
                    </div>
                </form>
            </div>

        </div>
    </div>
</div>
</body>
<script src="/admin/static/frame/layui/layui.js"></script>
<script src="/admin/static/js/jquery-1.8.3.min.js"></script>
<script src="/admin/static/js/vue.js"></script>
<script src="/admin/static/js/vue-resource.min.js"></script>
<script>
    var  vue = new Vue({
        el:"#app",
        data:{
            productNo:null,
            stockList:[],
            keyword:"",
            currentIndex:1
        },
        methods:{
            searchProduct() {
                var param = {"keyword":this.keyword}
                this.$http.post("/admin/product/search?index=" + this.currentIndex + "&size=15", JSON.stringify(param)).then(function (res) {
                    console.log(res)
                    if (res.body.success) {
                        this.productList = res.body.data.content;
                        this.pageCount = res.body.data.totalPages;
                        this.totalAmount = res.body.data.totalElements;
                    }
                })
            },

            searchProductSku(){
                var param = {"keyword":this.keyword};
                this.$http.post("/admin/product/sku/search",JSON.stringify(param)).then(function (res){
                    this.stockList = res.body.data;
                })
            },
            addProduct(index){
                var stock = this.stockList[index];
                this.$http.post("/admin/product/sku/add",{"skuId":stock.mainId,"num":stock.num},{emulateJSON:true}).then(function (res){
                    if (res.body.success){
                        this.stockList[index].stock=parseInt(this.stockList[index].num)+parseInt( this.stockList[index].stock);
                        this.stockList[index].num=0;
                        layer.msg("添加成功")
                    }
                })
            }
        }
    })
    $(document).ready(function () {
        $('#left-nav-1').html("我的商品");
        $('#left-nav-1-child')
                .append("<dd><a  href='/admin/page/product-on'>上架商品</a>" + "</dd>")
                .append("<dd><a href='/admin/page/product-off'>下架商品</a>" + "</dd>")
                .append("<dd><a  href='/admin/page/product-add'>新增商品</a>" + "</dd>")
                .append("<dd><a style='color:white;background: #009688;' href='/admin/page/product-expand'>进货</a>" + "</dd>")
    })
    //JavaScript代码区域
    layui.use(['element','form'], function(){
        var element = layui.element;
        var form = layui.form;

    });
</script>
</html>