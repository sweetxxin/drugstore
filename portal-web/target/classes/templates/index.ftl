<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
        <meta name="author" content="www.sweetxxin.top"/>
		<title>益和药房</title>
		<link rel="stylesheet" type="text/css" href="/web/static/css/swiper.min.css">
        <link rel="stylesheet" type="text/css" href="/web/static/css/index.css">
        <link rel="stylesheet" type="text/css" href="/web/static/css/header.css">
        <link rel="stylesheet" type="text/css" href="/web/static/css/search.css">
		<script src="/web/static/js/swiper.min.js"></script>
        <script src="/web/static/layui/layui.js"></script>
        <style>
            .swiper-container{
                --swiper-theme-color: hsla(0,0%,100%,.5);
            }
        </style>
	</head>
	<body>
	<!-- start header -->
		 <#include "common/header.ftl"/>
	<!--end header -->
    <!-- start banner_x -->
        <#include "common/search.ftl"/>
    <!-- end banner_x -->
    <div id="app">
	<!-- start banner_y -->
        <div class="banner_y center" >
            <div v-show="isShowPop"  class="pop">
                <div class="category-container">
                    <div v-for="c in currentCategory"  class="category-div">
                            <div class="category-title"><a :href="'/web/product/list/'+c.parentId+'/'+c.mainId">{{c.name}}</a></div>
                            <div class="category-content">
                                <ul v-if="c.name!='热门品牌'">
                                    <li  v-for="d in categoryDetail[c.mainId]">
                                        <a :href="'/web/product/list/'+c.parentId+'/'+d.parentId+'/'+d.mainId">{{d.name}}</a>
                                    </li>
                                </ul>
                                <ul v-else>
                                    <li  v-for="d in categoryDetail.brand">
                                        <a>{{d.name}}</a>
                                    </li>
                                </ul>
                            </div>
                    </div>
                </div>
            </div>
			<div  class="nav">
				<ul>
					<li  v-for="(c,index) in categoryList"  @mouseover="showPop(index)">
						<div class="nav-logo" :class="selectCategory(index)"></div>
						<a class="nav-text" :href="'/web/product/list/'+c.mainId">&nbsp;&nbsp;{{c.name}}&nbsp;&nbsp;></a>
						<div  class="nav-hot">
							<a>补肾</a>/
                            <a>瘦身减肥</a>/
                            <a>皮肤癣症</a>
						</div>
					</li>
				</ul>
			</div>
			<div class="card">
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <template v-for="img in rotationImg">
                            <div class="swiper-slide"><img :src="img.url"></div>
                        </template>
                    </div>
                    <!-- 如果需要分页器 -->
                    <div class="swiper-pagination"></div>
                    <!-- 如果需要导航按钮 -->
                    <div class="swiper-button-prev"></div>
                    <div class="swiper-button-next"></div>
                    <!-- 如果需要滚动条 -->
                    <#--<div class="swiper-scrollbar"></div>-->
                </div>
			</div>
			<div @mouseover="hidePop()" class="tip-r">
				<div class="recommend">
					<div class="re-title">-今日推荐-</div>
					<div>
						<li><a>大家都在买葡萄</a></li>
                        <li><a>高邮咸鸭蛋</a></li>
                        <li><a>大闸蟹</a></li>
					</div>
				</div>
				<div class="notice">
                    <div class="re-title">-生鲜常识-</div>
                    <div>
                        <li><a>冬季应该吃的水果</a></li>
                        <li><a>吃海鲜注意的问题</a></li>
                        <li><a>不宜混合吃的食物搭配</a></li>
                    </div>
				</div>
			</div>
		</div>
    <!-- end banner_y -->

        <div @mouseover="hidePop()" id="hot" class="hot-recommend">
            <div class="hot-recommend-title">
                <span>-</span>热门推荐<span>-</span>
            </div>
            <div  class="hot-recommend-content">
                <div v-for="hot in hotProduct"  @click="toDetail(hot)" class="hot-recommend-item">
                    <div class="item-img">
                        <img :src="'/resource/static'+hot.defaultImg">
                    </div>
                    <div class="item-text">
                        <p class="item-name">{{hot.name}}</p>
                        <p class="item-price">￥{{hot.defaultPrice}}</p>
                    </div>
                </div>
            </div>
        </div>
        <div id="new" class="hot-recommend">
            <div class="hot-recommend-title">
                <span>-</span>新品推荐<span>-</span>
            </div>
            <div  class="hot-recommend-content">
                <div v-for="n in newProduct"  @click="toDetail(n)" class="hot-recommend-item">
                    <div class="item-img">
                        <img :src="'/resource/static'+n.defaultImg">
                    </div>
                    <div class="item-text">
                        <p class="item-name">{{n.name}}</p>
                        <p class="item-price">￥{{n.defaultPrice}}</p>
                    </div>
                </div>
            </div>
        </div>
        <div id="recommend" class="hot-recommend">
            <div class="hot-recommend-title">
                <span>-</span>精选推荐<span>-</span>
            </div>
            <div  class="hot-recommend-content">
                <div v-for="recommend in recommendProduct" class="hot-recommend-item" @click="toDetail(recommend)">
                    <div class="item-img">
                        <img :src="'/resource/static'+recommend.defaultImg">
                    </div>
                    <div class="item-text">
                        <p class="item-name">{{recommend.name}}</p>
                        <p class="item-price">￥{{recommend.defaultPrice}}</p>
                    </div>
                </div>
            </div>
        </div>
        <#include "common/footer.ftl" />
        </div>
	</body>
    <script>
        var index = new Vue({
			el:"#app",
            data(){
			    return{
                    rotationImg:[],
                    categoryList:{},
                    isShowPop:false,
                    categoryCache:[],
                    currentCategory:[],
                    categoryDetail:[],
                    cartCount:null,
                    keyword:null,
                    hotProduct:[],
                    recommendProduct:[],
                    newProduct:[],
                    loading:null,
                    articles:[]
                }
            },
        	mounted:function () {
			    localStorage.removeItem("cartCount");
                this.getRotation();
                this.getArticle();
        		this.getCategoryList();
                var _self = this;
                $(window).scroll(function() {
                    var wScrollY = window.scrollY; // 当前滚动条位置
                    var wInnerH = window.innerHeight; // 设备窗口的高度（不会变）
                    var bScrollH = document.body.scrollHeight; // 滚动条总高度
                    if (wScrollY + wInnerH + 400 >= bScrollH) {
                        if (_self.hotProduct.length == 0) {
                            _self.showLoading();
                            _self.getHotProduct();
                        } else if (_self.newProduct.length == 0) {
                            _self.showLoading();
                            _self.getNewProduct();
                        } else if (_self.recommendProduct.length == 0) {
                            _self.showLoading();
                            _self.getCommendProduct();
                        }
                    }
                })
            },
        	methods:{
			    getRotation(){
			        this.showLoading();
			        this.$http.get("/user/ad/rotation").then(function (res) {
                        if (res.body.success){
                            this.rotationImg = res.body.data;
                            this.$forceUpdate();
                            this.hideLoading();
                            this.$nextTick(function () {var mySwiper = new Swiper('.swiper-container', {
                                    direction: 'horizontal', // 垂直切换选项
                                    loop: true, // 循环模式选项
                                    autoplay: true,
                                    // 如果需要分页器
                                    pagination: {
                                        el: '.swiper-pagination',
                                    },
                                    // 如果需要前进后退按钮
                                    navigation: {
                                        nextEl: '.swiper-button-next',
                                        prevEl: '.swiper-button-prev',
                                    },
                                    // 如果需要滚动条
                                    scrollbar: {
                                        el: '.swiper-scrollbar'
                                    },
                                })
                            })
                        }
                    })
                },
                getArticle(){
                    this.$http.get("/user/ad/article").then(function (res) {
                        if (res.body.success){
                            this.articles = res.body.data;
                        }
                    })
                },
                getCategoryList:function () {
                    this.$http.get("/web/product/category/first").then(function (res) {
                        if (res.body.success) {
                            this.categoryList = res.body.data.category;
                        }
                    })
                },
                selectCategory(index){
                    return "nav-logo-"+(index+1);
                },
                showPop(index){
                    if (this.categoryCache[index]){
                        this.currentCategory = this.categoryCache[index].self;
                        this.categoryDetail = this.categoryCache[index];
                    }else{
                        this.currentCategory=[];
                        this.categoryCache[index]=[];
                        this.$http.get("/web/product/category/"+this.categoryList[index].mainId+"/child").then(function (res) {
                            if (res.body.success) {
                                this.currentCategory = res.body.data.self;
                                this.categoryDetail = res.body.data;
                                this.categoryCache[index] =  res.body.data;
                            }
                        })
                    }
                    this.isShowPop=true;
                },
                hidePop(index){
                    this.isShowPop=false;
                },
                countCart(){
                    if (localStorage.getItem("cartCount")==null){
                        this.$http.get("/cart/count").then(function (res) {
                            if (res.body.success) {
                                this.cartCount = res.body.data;
                                localStorage.setItem("cartCount",this.cartCount);
                            }
                        })
                    } else{
                        this.cartCount=localStorage.getItem("cartCount");
                    }
                },
                getHotProduct(){
                    var _self = this;
                    this.getProduct("updateHotProduct","hotProduct","/web/product/hot?index=0&size=8","hotProduct").then(function (value) {
                        _self.hideLoading();
                    });
                },
                getCommendProduct(){
                    var _self = this;
                    this.getProduct("updateRecommendProduct","recommendProduct","/web/product/recommend?index=0&size=8","recommendProduct").then(function (value) {
                        _self.hideLoading();
                    });
                },
                getNewProduct(){
                    var _self = this;
                   this.getProduct("updateNewProduct","newProduct","/web/product/new?index=0&size=8","newProduct").then(function (value) {
                       _self.hideLoading();
                   });
                },
                getProduct(cookie,storage,url,item){
                    var _self = this;
                    return new Promise(function(resolve,reject){
                        if (_self.getCookie(cookie)!=null) {
                            console.log("系统更新了广告")
                            _self.$http.get(url).then(function (res) {
                                _self[item] = res.body.data.content;
                                localStorage.setItem(storage,JSON.stringify(res.body.data.content));
                                resolve(res.body.data.content);
                            })
                            _self.delCookie(cookie);
                        }else {
                            if (localStorage.getItem(storage)!=null&&JSON.parse(localStorage.getItem(storage)).length!=0){
                                _self[item] = JSON.parse(localStorage.getItem(storage));
                                console.log("本地缓存了广告");
                                resolve(_self[item]);
                            } else{
                                console.log("加载广告产品")
                                _self.$http.get(url).then(function (res) {
                                    _self[item] = res.body.data.content;
                                    localStorage.setItem(storage,JSON.stringify(res.body.data.content));
                                    _self.delCookie(cookie);
                                    resolve(res.body.data.content);
                                })
                            }
                        }
                    })
                },
                getCookie(name){
                    var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
                    if(arr=document.cookie.match(reg))
                        return unescape(arr[2]);
                    else
                        return null;
                },
                delCookie(name) {
                    var exp = new Date();
                    exp.setTime(exp.getTime() - 1);
                    var cval=this.getCookie(name);
                    if(cval!=null)
                    document.cookie= name + "="+cval+";expires="+exp.toGMTString();
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
                toDetail(product){
                    localStorage.setItem("selectedProduct",JSON.stringify(product));
                    window.location = "/web/page/product/detail?id="+product.mainId;
                    console.log(product)
                }
            },
            watch:{
            },
            computed: {
			}
        })
    </script>
</html>