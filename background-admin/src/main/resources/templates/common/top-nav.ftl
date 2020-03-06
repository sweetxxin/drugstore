<div id="header" class="layui-header">
    <div class="layui-logo">益和药房后台</div>
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <ul class="layui-nav layui-layout-left">
        <#if userInfo.type==1>
        <li class="layui-nav-item"><a class="myShop" href="/admin/page/shop">我的药店</a></li>
        <li class="layui-nav-item"><a class="myProduct" href="/admin/page/product-on">药品管理</a></li>
        <li class="layui-nav-item">
            <a class="myOrder" href="/admin/page/order-to-deal">订单中心</a>
            <dl class="layui-nav-child">
                <dd><a href="/admin/page/order-to-deal">新订单</a></dd>
                <dd><a href="/admin/page/order-prepare">揽件中</a></dd>
                <dd><a href="/admin/page/order-transport">运输中</a></dd>
                <dd><a href="/admin/page/order-receive">待收货</a></dd>
                <dd><a href="/admin/page/order-finish">已完成</a></dd>
            </dl>
        </li>
        <li class="layui-nav-item"><a class="myStatistic" href="/admin/page/statistic-order">统计分析</a></li>
        <#else >
        <li class="layui-nav-item"><a class="myWeb" href="/admin/page/rotation-setting">网站设置</a></li>
         <li class="layui-nav-item"><a class="categorySetting" href="/admin/page/first-category-setting">分类设置</a></li>
        <li class="layui-nav-item"><a class="allShop" href="/admin/page/shop-verifying">药店审核</a></li>
        <li class="layui-nav-item"><a class="allAgainst" href="/admin/page/all-against">举报内容</a></li>
        </#if>
        <li class="layui-nav-item"><a href="/web/page/index" target="_blank">买家平台</a></li>
    </ul>
    <ul class="layui-nav layui-layout-right">
        <li class="layui-nav-item">
            <a href="javascript:;">
                <#if userInfo.avatar??>
                     <img src="${userInfo.avatar}" class="layui-nav-img">
                <#else>
                      <img src="http://t.cn/RCzsdCq" class="layui-nav-img">
                </#if>
                ${(userInfo.username)!""}
            </a>
            <dl class="layui-nav-child">
                <#if userInfo.type==1>
                    <dd><a href="/admin/page/verify">商家认证</a></dd>
                </#if>
                <dd><a href="/admin/page/info">基本资料</a></dd>
            </dl>
        </li>
        <li class="layui-nav-item"><a class="myInform" href="/admin/page/inform-new">消息中心<span style="top:0px;margin:0px;right: -10px;" v-show="informsCount>0" class="layui-badge">{{informsCount}}</span></a></li>
        <li class="layui-nav-item"><a href="/oauth/user/logout?from=admin">退出登陆</a></li>
    </ul>
</div>
<script src="/admin/static/js/jquery-1.8.3.min.js"></script>
<script src="/admin/static/js/vue.js"></script>
<script src="/admin/static/js/vue-resource.min.js"></script>
<script>
    var header = new Vue({
        el:"#header",
        data:{
            informsCount:0
        },
        mounted:function(){
            this.countInform();
        },
        methods:{
            countInform(){
                this.$http.get("/admin/user/inform/count").then(function (res) {
                    if (res.body.success) {
                        this.informsCount = res.body.data;
                        localStorage.setItem("informsCount",this.informCount);
                    }
                })
            }
        }
    })
</script>