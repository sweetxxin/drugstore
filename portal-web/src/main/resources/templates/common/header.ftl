<script src="/web/static/js/jquery-1.8.3.min.js"></script>
<script src="/web/static/js/vue.js"></script>
<script src="/web/static/js/vue-resource.min.js"></script>
<header id="header">
    <div class="top center">
        <div class="left fl">
            <li class="home">
                <img src="/resource/static/img/home.png">
                <a href="/web/page/index" target="_self" >首页</a>
            </li>
            <li class="product-all">
                <img src="/resource/static/img/shopping.png">
                <a href="/web/product/list" target="_self" >全部商品</a>
            </li>
            <li class="product-all">
                <img src="/resource/static/img/keeper.png">
                <a href="/admin/page/index" target="_blank" >卖家平台</a>
            </li>
        </div>
        <div class="right fr">
            <div class="gouwuche fr"><a href="/web/page/self_info">个人中心</a></div>
            <div class="fr">
                <ul>
                            <#if (status.username)??>
                                <li><a style="font-size: 16px;color: black">${status.username}</a></li>
                                <li><a href="/oauth/user/logout?from=user" target="_self">退出登录</a></li>
                            <#else>
                                <li><a href="/oauth/user/login" target="_self">登录</a></li>
                            </#if>
                    <li>|</li>
                    <li><a href="/oauth/user/register" target="_self" >注册</a></li>
                    <li>|</li>
                    <li>

                        <a style="position: relative" href="/web/page/inform">
                            <span v-show="informCount!=0&&informCount!=null" class="countInform">{{informCount}}</span>
                            消息通知
                        </a>
                    </li>
                </ul>
            </div>
            <div class="clear"></div>
        </div>
        <div class="clear"></div>
    </div>
</header>
<script>
    var header = new Vue({
        el:"#header",
        data:{
            informCount:0
        },
        mounted:function(){
            this.countInform();
        },
        methods:{
            countInform(){
                this.$http.get("/web/user/inform/count").then(function (res) {
                    if (res.body.success) {
                        this.informCount = res.body.data;
                        localStorage.setItem("informCount",this.informCount);
                    }
                })
            }
        }
    })
</script>