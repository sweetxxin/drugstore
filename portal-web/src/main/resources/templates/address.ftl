<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="author" content="order by xxin"/>
    <title>益和药房-个人中心</title>
    <#--<link rel="stylesheet" type="text/css" href="/static/css/style.css">-->
    <link rel="stylesheet" type="text/css" href="/web/static/css/header.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/self_info.css">
    <link rel="stylesheet" type="text/css" href="/web/static/css/address.css">
    <style>
        .my-address{
            color:#ff6700!important;font-weight:bold;
        }
    </style>
    <script type="text/javascript" src="/web/static/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="/web/static/layui/layui.js"></script>
    <script src="/web/static/js/select.js" type="text/javascript"></script>
</head>
<body>
<!-- start header -->
 <#include "common/header.ftl"/>
<!--end header -->
<!-- self_info -->
<div id="app" class="grzxbj">
    <div class="selfinfo center">
       <#include "common/left-nav.ftl"/>
        <div class="rtcont fr">
            <div class="ddzxbt">
                我的收货地址({{addrCount}})
                <button @click="addNewAddress()" class="update-btn">添加</button>
            </div>
            <div class="address-scroll">
                <div v-for="addr in addressList"  class="address">
                    <div class="address-name">{{addr.receiver}}</div>
                    <div class="address-mobile">{{addr.mobile}}</div>
                    <div class="address-1">
                        <span>{{addr.province}}</span>
                        <span>{{addr.city}}</span>
                        <span>{{addr.town}}</span>
                    </div>
                    <div class="address-2">{{addr.detail}}</div>

                    <div  class="address-update">
                        <a v-if="addr.isDefault==1" style="position: absolute;left: 0px;color:#28447a;cursor: none">默认地址</a>
                        <a @click="setDefaultAddress(addr)" v-else style="position: absolute;left: 0px;">设为默认</a>
                        <a @click="updateAddress(addr)">修改</a>
                        <a @click="deleteAddress(addr.mainId)">删除</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- self_info -->
 <#include "common/footer.ftl"/>
<script src="/static/js/vue.js"></script>
<script src="/static/js/vue-resource.min.js"></script>
<script>
    var vue = new Vue({
        el: "#app",
        data:{
            addressList:{},
            currentIndex:1,
            isShowUpdate:false,
            layer:null,
            addrCount:0
        },
        mounted:function () {
            this.getAddress();
        },
        methods:{
            getAddress(){
                this.$http.get("/web/user/address").then(function (res) {
                    this.addressList = res.body.data;
                    this.addrCount = res.body.data.length;
                })
            },
            addNewAddress(){
              localStorage.clear();
              this.popAddress();
            },
            selectAddress(){
                this.isShowUpdate = true;
            },
            popAddress(){
                layui.use('layer', function(){
                    this.layer = layui.layer;
                    var idx = layer.open({
                        type : 2,
                        title : '新增收货地址',
                        area : [ '650px', '450px' ],
                        fix : false,
                        content : '/web/page/popAddress',
                        // btn: ['确定', '取消'],
                        end : function() {
                        }
                    });
                });
            },
            deleteAddress(id){
                if (confirm("确定删除吗")){
                    this.$http.get("/web/user/address/"+id+"/delete").then(function (res) {
                        alert(res.body.message);
                        if (res.body.success){
                            // location. reload();
                            this.getAddress();
                        }
                    })
                }
            },
            setDefaultAddress(addr){
                addr.isDefault=1;
                this.saveAddress(addr);
            },
            saveAddress(addr){
                this.$http.post("/web/user/address/save",JSON.stringify(addr)).then(function (res) {
                    if (res.body.success){
                        this.getAddress();
                    }
                })
            },
            updateAddress(addr){
                localStorage.setItem("seletedAddr",JSON.stringify(addr));
                this.popAddress()
            }
        }
    })
</script>
</body>
</html>