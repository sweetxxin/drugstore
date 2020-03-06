<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>商品列表</title>
    <link rel="stylesheet" type="text/css" href="/static/css/style-2.css">
    <link rel="stylesheet" type="text/css" href="/static/layui/css/layui.css">
    <script type="text/javascript" src="/static/layui/layui.js"></script>
    <link rel="stylesheet" type="text/css" href="/static/css/main.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
</head>
<body>
<div id="app">
 <#include "common/header.ftl"/>
 <#include "common/search.ftl"/>
<div  class="content content-nav-base commodity-content">
    <div class="main-nav">
        <div class="inner-cont0">
            <div class="inner-cont1 w1200">
                <div class="inner-cont2">
                    <a href="/page/list" class="active">商品列表</a>
                </div>
            </div>
        </div>
    </div>
    <div class="category-wrap">
        <div class="select-top">
            <div class="select-top-l">${(categoryStart.name)!""}></div>
            <div class="select-top-r"></div>
        </div>
        <div class="select-introduce">
            蔬菜商品筛选共123个商品
        </div>
        <div class="select-items">
            <div class="select-item">
                <div class="select-item-l">分类：</div>
                <div class="select-item-r">
                    <#if categoryList??>
                          <#list categoryList as category>
                            <li>${category.name}</li>
                          </#list>
                    </#if>

                </div>
            </div>
            <div class="select-item">
                <div class="select-item-l">品牌：</div>
                <div class="select-item-r">
                    <#--<#if brandList??>-->
                        <#--<#list brandList as brand>-->
                        <#--<a>${brand.name}&nbsp;&nbsp;</a>-->
                        <#--</#list>-->
                    <#--</#if>-->
                    <li v-for="brand in brandList">
                        {{brand.name}}
                    </li>
                </div>
            </div>
            <div class="select-item">
                <div class="select-item-l">包装:</div>
                <div class="select-item-r">
                    <li>简装</li>
                    <li>袋装</li>
                    <li>盒装</li>
                    <li>礼盒装</li>
                </div>
            </div>
            <div class="select-item">
                <div class="select-item-l">售卖方式：</div>
                <div class="select-item-r">
                    <li>单品</li>
                    <li>组合</li>
                </div>
            </div>

        </div>
    </div>
    <div class="commod-cont-wrap">
        <div class="commod-cont layui-clear">
            <div class="right-cont-wrap">
                <div class="right-cont">
                    <div class="sort layui-clear">
                        <a class="active" href="javascript:;" event = 'volume'>综合</a>
                        <a>销量</a>
                        <a href="javascript:;" event = 'price'>价格</a>
                        <a href="javascript:;" event = 'newprod'>新品</a>
                        <#--<a href="javascript:;" event = 'collection'>收藏</a>-->
                        <li @click="nextPage()">></li>
                        <li @click="prePage()"><</li>
                        <li>{{currentIndex}}/{{pageCount}}</li>

                    </div>
                    <div  class="cont-list layui-clear" id="list-cont">
                        <div  v-for="product in productList" class="item" @click="selectProduct(product)">
                            <div :style="getDefaultImg(product)" class="img"></div>
                            <div class="text">
                                <p class="title">{{product.name}}</p>
                                <p class="price">
                                    <span class="pri">￥{{product.marketPrice}}</span>
                                    <span class="nub">{{product.sales}}付款</span>
                                </p>
                            </div>
                        </div>
                    </div>
                    <div id="demo0" style="text-align: center;"></div>
                </div>
            </div>
        </div>
        <div class="select-page">
            <div class="select-page-r">
                <em>共<b>{{pageCount}}</b>页到第</em>
                <input v-model="jumpPageIndex" type="text">
                <em>页</em>
                <button @click="jumpPage()">确定</button>
            </div>
            <div class="select-page-l">
                <li @click="prePage()"><上一页</li>
                <li v-for="pageNum in pageArray">&nbsp; {{pageNum}} &nbsp;</li>
                <li @click="nextPage()">下一页></li>
            </div>
        </div>
        <div class="commod-recommend">
            <hr style="width: 96%;"/>
            <div class="commod-recommend-title"><p>商品精选</p></div>
            <div v-for="recommend in recommendList" class="recommend-item">
                <div class="img"></div>
                <div class="text">
                    <p class="title">{{recommend.name}}</p>
                    <p class="price">
                        <span class="pri">￥{{recommend.skuPrice}}</span>
                        <span class="nub">{{recommend.sales}}付款</span>
                    </p>
                </div>
            </div>
            <hr style="width: 96%;"/>
        </div>
    </div>
</div>
</div>
<#include "common/footer.ftl"/>
<script src="/static/js/vue.js"></script>
<script src="/static/js/vue-resource.min.js"></script>
<script>
    var vue = new Vue({
        el: "#app",
        data(){
          return{
              brandList:[],
              productList:[],
              currentIndex:1,
              productSize:0,
              totalAmount:0,
              cartCount:null,
              pageCount:0,
              jumpPageIndex:2,
              allProductList:[],
              pageArray:[],
              recommendList:[],
              ids:[],
              keyword:null
          }
        },
        mounted:function () {
            this.countCart();
            this.getRecommend();
            <#if ids??>
                <#list ids as id>
                this.ids.push(${id});
                </#list>
                this.getProductInCategory();
                <#else >
                  this.getProduct();
            </#if>
            // this.getProductInCategory();
            localStorage.removeItem("selectedProduct");
        },
        methods:{
            getDetail(){
                window.location = "/page/detail";
            },
            getBrandByCategoryId(id){
                this.$http.get("/product/brand/category/"+id).then(function (res) {
                    this.brandList = res.body.data;
                })
            },
            getProduct(){
                if (typeof(this.allProductList[this.currentIndex])!="undefined"){
                    this.productList=this.allProductList[this.currentIndex];
                } else{
                    this.$http.get("/product/list/"+this.currentIndex).then(function (res) {
                        this.productList = res.data.data.records;
                        this.pageCount = res.data.data.pages;
                        this.allProductList[this.currentIndex]=res.data.data.records;
                    })
                }
            },
            getRecommend(){
                this.$http.get("/product/recommend").then(function (res) {
                    this.recommendList = res.body.data.records;
                })
            },
            prePage(){
              this.currentIndex--;
            },
            nextPage(){
                this.currentIndex++;
            },
            jumpPage(){
                this.currentIndex = this.jumpPageIndex;
            },
            getDefaultImg(product){
                return "background:url("+product.sku[0].skuImg+");background-repeat: no-repeat;background-position: center;";
            },
            selectProduct(product){
                localStorage.setItem("selectedProduct",JSON.stringify(product));
                window.location = "/page/detail"
            },
            countCart(){
                this.$http.get("/cart/count").then(function (res) {
                    if (res.body.success) {
                        this.cartCount = res.body.data;
                    }
                })
            },
            getProductInCategory(){
                this.$http.get("/product/in/"+this.currentIndex,this.ids).then(function (res) {
                    if (res.body.success) {

                    }
                })
            },
            hidePop(){

            },
            searchProduct(){
                this.$http.get("/search/product/"+this.currentIndex+"?keyword="+this.keyword,{emulateJSON: true}).then(function (res) {
                    console.log(res)
                    if (res.body.success) {
                        this.productList = res.body.data.records;
                        this.pageCount = res.body.data.pages;
                    }
                })
            }
        },
        watch:{
            currentIndex(){
                if (this.currentIndex<=0){
                    this.currentIndex=1;
                } else if (this.currentIndex>this.pageCount){
                    this.currentIndex = this.pageCount;
                }
                this.getProduct();
            },
            pageCount(){
                for (var i=1;i<=this.pageCount&&i<=5;i++){
                    this.pageArray.push(i);
                }
                if (this.pageCount>5){
                    this.pageArray.push("...")
                }
            }
        }
    })
</script>
</body>
</html>