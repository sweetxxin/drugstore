<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>商品列表</title>
    <link rel="stylesheet" type="text/css" href="/web/static/css/header.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/list.css">
    <link rel="stylesheet" type="text/css" href="/web/static/layui/css/layui.css">
    <script type="text/javascript" src="/web/static/layui/layui.js"></script>
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
    <style>
        .select-page-l li, .select-page-l {
            cursor: pointer;
        }
        button {
            cursor: pointer;
        }
        .select-labels div {
            margin-right: 20px;
            display: inline-block;
            padding: 5px 10px;
            margin-bottom: 10px;
            position: relative;
            background: #009688;
            color: white;
        }

        .cancel {
            position: absolute;
            width: 20px;
            height: 20px;
            top: -10px;
            right: -10px;
            cursor: pointer;
        }
    </style>
</head>
<body>
 <#include "common/header.ftl"/>
 <#include "common/search.ftl"/>
<div id="app">
    <div class="content content-nav-base commodity-content">
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
            <#if titles??>
                <#list titles as title>
                <div class="select-top-l row"><a href="${title.url}">${(title.name)!""}></a></div>
                </#list>
                <template v-for="(t,index) in title">
                    <div class="select-top-l row" :class="'r'+(index+2)"><a :href="t.url">{{t.name}}</a></div>
                </template>

                <#if firstCategory??>
                <div v-show="showFirst" class="row">
                    <select v-model="firstCategory">
                        <option value="">请选择分类</option>
                        <#list firstCategory as f>
                            <option value="${f.mainId?c}">${(f.name)!""}</option>
                        </#list>
                    </select>
                </div>
                </#if>
                <div v-show="showSecond" class="row">
                    <select v-model="secondCategory" v-if="firstCategory!=''">
                        <option value="">请选择</option>
                        <option v-for="c in secondCategoryList" v-if="c.code!=100" :value="c.mainId">
                            <a>{{c.name}}</a>
                        </option>
                    </select>
                </div>
                <div v-show="showThird" class="row">
                    <select v-model="thirdCategory" v-if="secondCategory!=''">
                        <option value="">请选择</option>
                        <option v-for="c in thirdCategoryList" :value="c.mainId">
                            <a>{{c.name}}</a>
                        </option>
                    </select>
                </div>

            </#if>
                <div class="select-top-r"></div>
            </div>
            <div class="select-introduce">
                <div v-show="selectedLabel" class="select-labels">
                    <div v-for="(value, key, index) in selectedLabel">
                        <img @click="removeLabel(key)" src="/resource/static/img/cancel.png" class="cancel">
                        {{value}}
                    </div>
                </div>
                <div> 商品筛选共{{totalAmount}}个商品</div>
            </div>
            <div class="select-items">
                <div class="select-item" v-if="brandList">
                    <div class="select-item-l">品牌：</div>
                    <div class="select-item-r">
                        <li v-for="brand in brandList">
                            <a @click="getProductBy('brand',brand.name,brand.mainId)">{{brand.name}}</a>
                        </li>
                    </div>
                </div>
                <div class="select-item">
                    <div class="select-item-l">类别：</div>
                    <div class="select-item-r">
                        <ul>
                            <li><a @click="getProductBy('productType','中药')">中药</a></li>
                            <li><a @click="getProductBy('productType','西药')">西药</a></li>
                            <li><a @click="getProductBy('productType','其他')">其他</a></li>
                        </ul>
                    </div>
                </div>
                <div class="select-item">
                    <div class="select-item-l">使用方法：</div>
                    <div class="select-item-r">
                        <li><a @click="getProductBy('useWay','口服')">口服</a></li>
                        <li><a @click="getProductBy('useWay','外用')">外用</a></li>
                        <li><a @click="getProductBy('useWay','其他')">其他</a></li>
                    </div>
                </div>
                <div class="select-item">
                <form class="layui-form" style="position: relative;">
                    <div class="select-item-l">剂型：</div>
                    <div class="select-item-r">
                    <#if forms??>
                          <#list forms as form>
                              <li><input type="checkbox" :value="'${form.mainId}'" name="form" lay-skin="primary" title="${form.name}"></li>
                          </#list>
                        <div class="sure-btn">
                            <button @click="searchProduct(keyword)" type="button" class="layui-btn">确定</button>
                        </div>
                    </#if>
                </form>
                </div>
            </div>
            <div class="select-item" v-if="useCategory&&useCategory.length!=0">
                <form class="layui-form" style="position: relative">
                    <div class="select-item-l">适用症状:</div>
                    <div class="select-item-r">
                        <li v-for="use in useCategory">
                            <input type="checkbox" name="symptom" :value="use.mainId" lay-skin="primary" :title="use.name">
                        </li>
                        <div class="sure-btn">
                            <button type="button" @click="searchProduct(keyword)" class="layui-btn">确定</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <div style="text-align: center;margin-top: 20px;" class="resetSearch">
            <button @click="resetSearch()" type="button" class="layui-btn layui-btn-normal">重置查询条件</button>
        </div>
    </div>
    <div class="commod-cont-wrap">
        <div class="commod-cont layui-clear">
            <div class="right-cont-wrap">
                <div class="right-cont">
                    <div class="sort layui-clear">
                        <a :class="multipleActive" @click="orderBy('multiple')">综合</a>
                        <a :class="saleActive" @click="orderBy('sale')">销量</a>
                        <a :class="skuPriceActive" @click="orderBy('skuPrice')" >价格</a>
                        <a :class="isNewActive" @click="orderBy('isNew')" >新品</a>
                        <li style="cursor: pointer" @click="nextPage()">></li>
                        <li style="cursor: pointer" @click="prePage()"><</li>
                        <li>{{currentIndex}}/{{pageCount}}</li>
                    </div>
                    <div class="cont-list layui-clear" id="list-cont">
                        <div class="item" v-for="product in productList" @click="selectProduct(product)">
                            <div class="img">
                                <img style="height: 100%;width: 100%" :src="'/resource/static'+product.defaultImg">
                            </div>
                            <div class="text">
                                <p class="title">{{product.name}}</p>
                                <p class="price">
                                    <span class="pri">{{product.defaultPrice}}￥</span>
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
                <li @click="prePage()">
                    <上一页
                </li>
                <li v-for="pageNum in pageArray" @click="selectPage(pageNum)">&nbsp; {{pageNum}} &nbsp;</li>
                <li @click="nextPage()">下一页></li>
            </div>
        </div>
        <div class="commod-recommend">
            <hr style="width: 96%;"/>
            <div class="commod-recommend-title"><p>商品精选</p></div>
            <div v-for="recommend in recommendList" @click="selectProduct(recommend)" class="recommend-item">
                <div class="img">
                    <img style="height: 100%;width: 100%" :src="'/resource/static'+recommend.defaultImg">
                </div>
                <div class="text">
                    <p class="title">{{recommend.name}}</p>
                    <p class="price">
                        <span class="pri">￥{{recommend.defaultPrice}}</span>
                        <span class="nub">{{recommend.sales}}付款</span>
                    </p>
                </div>
            </div>
            <hr style="width: 96%;"/>
        </div>
    </div>
</div>

<#include "common/footer.ftl"/>
</div>

<script>
    var index = null;
    var list = new Vue({
        el: "#app",
        data() {
            return {
                brandList: null,
                productList: [],
                currentIndex: 1,
                productSize: 0,
                totalAmount: 0,
                cartCount: null,
                pageCount: 0,
                jumpPageIndex: null,
                allProductList: [],
                pageArray: [],
                recommendList: [],
                ids: [],
                firstCategory: "",
                secondCategory: "",
                thirdCategory: "",
                secondCategoryList: [],
                thirdCategoryList: [],
                useCategory: null,
                categoryCache: {},
                showFirst: true,
                showSecond: true,
                showThird: true,
                title: [],
                form: null,
                keyword: null,
                selectedLabel: {},
                selectedCategory: {},
                selectedBrand:null,
                orderByVal:null,
                multipleActive:"active",
                isNewActive:"",
                skuPriceActive:"",
                saleActive:""
            }
        },
        mounted: function () {
            if ("${(firstSelected)!''}" != "") {
                this.firstCategory = "${firstSelected!''}";
                this.showFirst = false;
                console.log(this.secondCategory)
            }
            layui.use(['form'], function () {
                this.form = layui.form;
            });
            <#if productsJson??>
                var data = JSON.parse('${productsJson}');
                this.productList = data.content;
                this.pageCount = data.totalPages;
                this.totalAmount = data.totalElements;
            </#if>
            <#if keyword??>
                this.keyword = '${keyword}';
            </#if>
            this.getRecommend();
            localStorage.removeItem("selectedProduct");
        },
        updated: function () {
            layui.use(['element', 'form'], function () {
                var form = layui.form;
                form.render();
                var element = layui.element;
                element.init();
            })
        },
        methods: {
            getRecommend() {
                this.$http.get("/web/product/recommend?index=0&size=5").then(function (res) {
                    this.recommendList = res.body.data.content;
                })
            },
            prePage() {
                this.currentIndex--;
            },
            nextPage() {
                this.currentIndex++;
            },
            jumpPage() {
                this.currentIndex = this.jumpPageIndex;
            },
            selectPage(index) {
                if (index != "...")
                    this.currentIndex = index;
            },
            getDefaultImg(product) {
                if (product.defaultImg) {
                    return "background:url(/resource/static" + product.defaultImg + ");background-repeat: no-repeat;background-position: center;background-size:cover";
                }
            },
            selectProduct(product) {
                localStorage.setItem("selectedProduct", JSON.stringify(product));
                console.log(product)
                window.location = "/web/page/product/detail?id=" + product.mainId;
            },
            searchProduct(keyword) {
                this.showLoading();
                this.keyword = keyword;
                var category = [];
                if (this.firstCategory != "") {
                    category.push(this.firstCategory)
                }
                if (this.secondCategory) {
                    category.push(this.secondCategory)
                }
                if (this.thirdCategory != "") {
                    category.push(this.thirdCategory)
                }
                if (this.selectedBrand!=null){
                    category.push(this.selectedBrand)
                }
                var param = {
                    "keyword": this.keyword,
                    "orderBy":this.orderByVal
                };
                if (category.length>0){
                    param.category = category;
                }
                for (var key in this.selectedLabel) {
                    if (key=="brand")continue;
                    param[key] = this.selectedLabel[key];
                }
                var form = [];
                $("input[name='form']:checked").each(function(){
                    form.push($(this).val());
                })
                if (form.length>0)
                    param.form=form;
                var symptom = [];
                $("input[name='symptom']:checked").each(function(){
                    symptom.push($(this).val());
                })
                if (symptom.length>0)
                    param.symptom = symptom;
                this.$http.post("/web/product/search?index=" + this.currentIndex + "&size=15", JSON.stringify(param)).then(function (res) {
                    console.log(res)
                    if (res.body.success) {
                        this.productList = res.body.data.content;
                        this.pageCount = res.body.data.totalPages;
                        this.totalAmount = res.body.data.totalElements;
                    }
                    this.hideLoading();
                })
            },
            getProductBy(key, val,index) {
                if (key=="brand"){
                    this.selectedBrand = index;
                }
                this.selectedLabel[key] = val;
                this.searchProduct(this.keyword);
            },
            removeLabel(key) {
                Vue.delete(this.selectedLabel, key);
                if (key=="brand"){
                    this.selectedBrand=null;
                }
                this.searchProduct(this.keyword)
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
            orderBy(val){
                this.isNewActive ="";
                this.skuPriceActive="";
                this.saleActive="";
                this.multipleActive="";
                this[val+'Active'] = "active";
                this.orderByVal = val;
                this.searchProduct(this.keyword)
            },
            resetSearch(){
                $("input[name='form']").each(function(){
                    $(this).prop('checked', false);
                });
                $("input[name='symptom']").each(function(){
                    $(this).prop('checked', false);
                });
                this.keyword = null;
                this.firstCategory="";
                this.secondCategory="";
                this.thirdCategory="";
                this.orderByVal = null;
                this.selectedLabel = {};
                this.selectedCategory={};
                this.selectedBrand=null;
                this.orderBy("multiple");
                // this.searchProduct();
                // location.reload();
            }
        },
        watch: {
            firstCategory() {
                this.secondCategory = "";
                if (this.categoryCache[this.firstCategory]) {
                    this.secondCategoryList = this.categoryCache[this.firstCategory].self;
                    this.brandList = this.categoryCache[this.firstCategory].brand;
                } else {
                    if (this.firstCategory != "") {
                        this.$http.get("/web/product/category/" + this.firstCategory + "/child").then(function (res) {
                            if (res.body.success) {
                                this.brandList = res.body.data.brand;
                                this.categoryCache[this.firstCategory] = res.body.data;
                                this.secondCategoryList = this.categoryCache[this.firstCategory].self;
                                if ("${(secondSelected)!''}" != "") {
                                    this.secondCategory = "${secondSelected!''}";
                                    this.showSecond = false;
                                    for (var c in this.secondCategoryList) {
                                        if (this.secondCategoryList[c].mainId == this.secondCategory) {
                                            this.title.push({
                                                "name": this.secondCategoryList[c].name + '>',
                                                "url": "/web/product/list/" + this.firstCategory + "/" + this.secondCategory
                                            })
                                            break;
                                        }
                                    }
                                }
                            }
                        })
                    }
                }
                this.searchProduct(this.keyword);

            },
            secondCategory() {
                if (this.secondCategory != "") {
                    this.thirdCategory = "";
                    this.thirdCategoryList = this.categoryCache[this.firstCategory][this.secondCategory];
                    this.useCategory = this.categoryCache[this.firstCategory][this.secondCategory + '-use'];
                    if ("${(thirdSelected)!''}" != "") {
                        this.thirdCategory = "${(thirdSelected?c)!''}";
                        this.showThird = false;
                        for (var c in this.thirdCategoryList) {
                            if (this.thirdCategoryList[c].mainId == this.thirdCategory) {
                                this.title.push({
                                    "name": this.thirdCategoryList[c].name,
                                    "url": "/web/product/list/" + this.firstCategory + "/" + this.secondCategory + "/" + this.thirdCategory
                                })
                                break;
                            }
                        }
                    }
                    this.searchProduct(this.keyword);
                } else {
                    this.useCategory = null;
                }
            },
            thirdCategory(){
                if (this.thirdCategory!="")
                this.searchProduct(this.keyword);
            },
            currentIndex() {
                if (this.currentIndex <= 1) {
                    this.currentIndex = 1;
                } else if (this.currentIndex > this.pageCount) {
                    this.currentIndex = this.pageCount;
                }
                this.searchProduct(this.keyword);
            },
            pageCount() {
                for (var i = 1; i <= this.pageCount && i <= 5; i++) {
                    this.pageArray.push(i);
                }
                if (this.pageCount > 5) {
                    this.pageArray.push("...")
                }
            }
        }
    })
</script>
</body>
</html>