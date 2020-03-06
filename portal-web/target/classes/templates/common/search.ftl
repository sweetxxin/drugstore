<div id="search" @mouseover="hidePop()" class="banner_x center">
    <a href="/web/page/index" target="_blank"><div class="logo fl"></div></a>
    <div class="nav fl">
    </div>
    <div class="search fl">

            <div class="text fl">
                <input type="text" v-model="keyword" @keyup.enter="searchProduct()" class="shuru"  placeholder="养生">
            </div>
            <div class="submit fl">
                <input type="button" @click="searchProduct()" class="sousuo" value="搜索"/>
            </div>
            <div class="clear"></div>

        <div class="clear"></div>
        <div class="keywords">
            <li><a href="/web/product/list?keyword=感冒">感冒药</a></li>
            <li><a href="/web/product/list?keyword=咳嗽">咳嗽</a></li>
            <li><a href="/web/product/list?keyword=居家">居家</a></li>
        </div>
    </div>
    <a href="/web/page/cart">
        <div @click="goToCart()" class="cart">
            <div class="cart-icon">
            </div>
            <div v-show="cartCount!=0" id="cart-count" class="cart-count">{{cartCount}}</div>
            <div class="cart-text"><a href="/web/page/cart">我的购物车</a></div>
        </div>
    </a>
</div>
<script>
    var cart = new Vue({
        el:"#search",
        data:{
            cartCount:null,
            keyword:null
        },
        created() {
            // var lett = this;
            // document.onkeydown = function (e) {
            //     var key = window.event.keyCode;
            //     if (key == 13) {
            //         console.log("enter 按下")
            //         lett.searchProduct();
            //     }
            // }
        },
        mounted:function(){
            this.getCart();
        },
        methods:{
            getCart(){
                if (localStorage.getItem("cartCount")!=null){
                    this.cartCount =localStorage.getItem("cartCount");
                    return;
                }
                this.countCart();
            },
            countCart(){
                this.$http.get("/web/cart/count").then(function (res) {
                    if (res.body.success) {
                        this.cartCount = res.body.data;
                        localStorage.setItem("cartCount",this.cartCount);
                    }else{
                        this.cartCount=0;
                    }
                })
            },
            hidePop(){
                if (index!=null){
                    index.hidePop();
                }
            },
            searchProduct(){
                if ("undefined"== typeof list) {
                    if (this.keyword!=null){
                        console.log("这里")
                        window.location = "/web/product/list?keyword="+this.keyword;
                    }else {
                        console.log("where")
                        window.location = "/web/product/list";
                    }

                }else{
                    console.log("zhere")
                    list.searchProduct(this.keyword);
                }

            },
            goToCart(){
                window.location = "/web/page/cart";
            }
        }
    })
</script>