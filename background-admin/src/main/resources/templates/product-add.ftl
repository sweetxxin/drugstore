<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房后台管理</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
    <style>
        .myProduct {
            color: white !important;
            background: #5FB878;
        }

        .w80 {
            width: 80px !important;
        }

        .w100 {
            width: 100px !important;
        }

        .w150 {
            width: 150px !important;
        }

        .w180 {
            width: 180px !important;
        }

        .w250 {
            width: 250px !important;
        }
        .w350{
            width: 350px !important;
        }
        .w480 {
            width: 480px !important;
        }
        .w835 {
            width: 835px !important;
        }
        .wAuto {
            width: auto;
        }

        .btn {
            width: 100px;
        }
        .hide {
            display: none;
        }
        #imgList img{
            height: 150px;
            width: 150px;
            margin-bottom: 10px;
            margin-right: 15px;
        }
        .layui-form-item{
            display: flex;
        }
        .fr{
            float: right;
        }
        .layui-badge{
            position: absolute;
            margin-left: 145px;
            margin-top: -5px;
            cursor: pointer;
        }
    </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
<#include "common/top-nav.ftl"/>
<#include "common/left-nav.ftl"/>
    <div id="app" class="layui-body" style="bottom: 0px">
        <!-- 内容主体区域 -->
        <div class="layui-card">
            <div class="layui-card-body" style="margin-top: 10px;">
                <form class="layui-form" v-bind:class="showForm(0)" >
                   <#include "common/basic-card.ftl" />
                    <div style="text-align: right;margin-bottom: 10px">
                        <button  @click="changeForm(0,1)" type="button"
                                class="layui-btn layui-btn-danger layui-btn-radius btn">下一步
                        </button>
                    </div>
                </form>
                <form  class="layui-form" v-bind:class="showForm(1)">
                    <#include "common/sku-card.ftl" />
                    <div style="text-align: right">
                        <button @click="changeForm(1,0)" type="button"
                                class="layui-btn layui-btn-normal layui-btn-radius btn">上一步
                        </button>
                        <button @click="changeForm(1,2)" type="button"
                                class="layui-btn layui-btn-danger layui-btn-radius btn">下一步
                        </button>
                    </div>
                </form>
                <form class="layui-form" v-bind:class="showForm(2)">
                    <#include "common/category-card.ftl" />
                    <#include "common/produce-card.ftl" />
                    <#include "common/else-card.ftl" />
                    <div style="text-align: right">
                        <button @click="changeForm(2,1)" type="button"
                                class="layui-btn layui-btn-danger layui-btn-radius btn">上一步
                        </button>
                        <button @click="saveProduct()" type="button" class="layui-btn layui-btn-normal layui-btn-radius btn">保存</button>
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
    $(document).ready(function () {
        $('#left-nav-1').html("我的商品");
        $('#left-nav-1-child')
                .append("<dd><a  href='/admin/page/product-on'>上架商品</a>" + "</dd>")
                .append("<dd><a href='/admin/page/product-off'>下架商品</a>" + "</dd>")
                .append("<dd><a style='color:white;background: #009688;' href='/admin/page/product-add'>新增商品</a>" + "</dd>")
                .append("<dd><a href='/admin/page/product-expand'>进货</a>" + "</dd>")
    })
    var vue = new Vue({
        el: "#app",
        data: {
            newProduct: {
                isShow:0,
                isNew:0,
                isImport:0,
                isCommend:0,
                isHot:0,
            },
            isDetailPage:false,
            factory:{},
            typeList:["西药","中药","其他"],
            productImg:{},
            productCategory:{},
            symptom:[],
            productSku: [{"saleWay":"single","packing":"box","isDefault":1,"delivery":{}}],
            currentForm:0,
            uploadObj:[],
            isLoading:true,
            showUploadAll:false,
            showAddImg:true,
            deliveryList:[],
            tempCategory:{},
            form:[],
            material:[],
            use:[],
            childCategory:null,
            firstCategory:null,
            secondCategory:null,
            secondCategoryName:null,
            thirdCategory:null,
            showSecondCategory:false,
            showThirdCategory:false,
            errorCount:0,
            layer:null,
            imgCallBack:[],
            showRefresh:true,
            productFirst:null,
            productSecond:null,
            productThird:null,
            productBrand:null,
            productForm:null,
            productMaterial:null
        },
        mounted: function () {
            var _self = this;
            this.getShopDelivery();
            layui.use(['element', 'laydate','form','upload',"layer"], function () {
                var element = layui.element;
                var form = layui.form;
                var upload = layui.upload;
                var layer = layui.layer;
                _self.layer =  layui.layer;

                var laydate = layui.laydate;
                laydate.render({
                    elem: '#produce-time'
                    ,type: 'datetime'
                });
                form.on('switch(switchHot)', function(data){
                    _self.newProduct.isHot = data.elem.checked==true?1:0;
                });
                form.on('switch(switchNew)', function(data){
                    _self.newProduct.isNew = data.elem.checked==true?1:0;
                });
                form.on('switch(switchCommend)', function(data){
                    _self.newProduct.isCommend = data.elem.checked==true?1:0;
                });
                form.on('switch(switchShow)', function(data){
                    _self.newProduct.isShow = data.elem.checked==true?1:0;
                });
                form.on('switch(switchImport)', function(data){
                    _self.newProduct.isImport = data.elem.checked==true?1:0;
                });
                form.on('select', function(data){
                    if (data.elem.className=="saleWay"){
                        var index = data.elem.attributes[0].nodeValue;
                        _self.productSku[index].saleWay = data.value;
                    }else if (data.elem.className=="packingWay"){
                        var index = data.elem.attributes[0].nodeValue;
                        _self.productSku[index].packing = data.value;
                    }else if (data.elem.className=="deliveryWay"){
                        var index = data.elem.attributes[0].nodeValue;
                        _self.productSku[index].delivery = {"mainId":data.value};
                    }else if(data.elem.className=="firstCategory"){
                        if (data.value!=""){
                            if (_self.tempCategory[data.value]==null){
                                _self.$http.get("/admin/product/category/"+data.value+"/child").then(function (res){
                                    _self.childCategory = res.body.data;
                                    _self.secondCategory = res.body.data.self;
                                    _self.tempCategory[data.value] = _self.childCategory;
                                })
                            }else{
                                _self.secondCategory =_self.tempCategory[data.value].self;
                                _self.childCategory=_self.tempCategory[data.value];
                            }
                            _self.productCategory['first']=data.value;
                            _self.showSecondCategory = true;
                        }else {
                            _self.secondCategory=null;
                            _self.showSecondCategory = false;
                        }
                        $("#secondCategory").find("option[value='']").prop("selected",true);
                        _self.use=[];
                        _self.showThirdCategory=false;
                    }else if (data.elem.className=="secondCategory"){
                        if (data.value!=""){
                            _self.thirdCategory = _self.childCategory[data.value];
                            _self.use = _self.childCategory[data.value+"-use"];
                            _self.showThirdCategory=true;
                        }else {
                            _self.showThirdCategory=false;
                            _self.thirdCategory = null;
                        }
                        _self.productCategory['second']=data.value;
                        $("#thirdCategory").find("option[value='']").prop("selected",true);
                    }else if (data.elem.className=="thirdCategory") {
                        if (data.value != "") {
                            _self.productCategory['third'] = data.value;
                        }
                    }
                });

                var uploadListIns = upload.render({
                    elem: '#addImg'
                    , url: '/resource/upload/'
                    , multiple: true
                    , auto:false
                    , drag:true
                    , number:5
                    ,accept: 'images' //只允许上传图片
                    ,acceptMime: 'image/*' //只筛选图片
                    ,bindAction: "#upload"
                    ,choose:function (obj) {
                        _self.uploadObj = obj.pushFile();
                        _self.showUploadAll=true;
                        var imgList = $('#imgList')
                        obj.preview(function (index, file, result) {
                            var files = this.files = obj.pushFile();
                            console.log("pre"+index)
                            // obj.preview(function (index, file, result) {
                                var div = $(['<div  id="upload-'+ index +'" style="display: inline-block;text-align: center;vertical-align:top;"> ' +
                                '<span class="layui-badge img-delete">x</span> ' +
                                '<img  src="'+ result +'" class="layui-upload-img"> ' +
                                '<div  style="text-align: center">待上传</div>'+
                                '<a class="wait-to-upload layui-btn layui-btn-xs img-reload">上传</a>'+
                                '</div>'].join(''));

                                div.find('.img-reload').on('click', function () {
                                    obj.upload(index, file);
                                });
                                div.find('.img-delete').on('click', function () {
                                    delete files[index]; //删除对应的文件
                                    div.remove();
                                    uploadListIns.config.elem.next()[0].value = '';
                                    delete _self.productImg[index];
                                });
                                imgList.append(div);
                        });
                        if (Object.keys(_self.uploadObj).length>=5){
                            _self.showAddImg = false;
                        }else{
                            _self.showAddImg=true;
                        }
                    }
                    ,before: function(obj){
                       if (_self.isLoading)
                            layer.load(); //上传loading
                    }
                    , done: function (res, index, upload) {
                        layer.closeAll('loading'); //关闭loading
                        if(res.success){ //上传成功
                            var div = $('#imgList').find('div#upload-'+ index);
                            var child = div.children();
                            child.eq(0).remove();
                            child.eq(2).html('<span style="color: #5FB878;">上传成功</span>');
                            child.eq(3).remove();
                            for(var key  in _self.productImg){
                                var d = $('#imgList').find('div#upload-'+ key);
                                var c = d.children();
                                c.eq(2).text("设为封面");
                                _self.productImg[key].isDefault=0;
                            }
                            div.append('<span onclick="setDefaultImg('+"'"+index+"'"+')"'+' style="color: red;cursor: pointer">封面</span>');
                            _self.productImg[index]={"url":res.data[0],"isDefault":1};
                            _self.newProduct.defaultImg =res.data[0];
                            return delete files[index]; //删除文件队列已经上传成功的文件
                        }
                        this.error(index, upload);
                    }
                    ,error: function(index, upload){
                        layer.closeAll('loading'); //关闭loading
                        var div = $('#imgList').find('div#upload-'+ index);
                        var child = div.children();
                        child.eq(2).html('<span style="color: #FF5722;">上传失败</span>');
                        child.eq(3).html('<span style="color: #FF5722;">重试</span>');
                    }
                    ,allDone: function(obj){ //当文件全部被提交后，才触发
                        if (obj.total==obj.successful){
                            _self.isLoading=false;
                            _self.showUploadAll=false;
                        }
                        if (_self.productImg.length==5) {
                            _self.showAddImg=false;
                        }
                    }
                    ,progress: function(n){
                        var percent = n + '%' //获取进度百分比
                        element.progress('demo', percent); //可配合 layui 进度条元素使用
                    }
                });
                var uploadIntroduce = upload.render({
                    elem: '#introduce'
                    , url: '/resource/upload/'
                    , multiple: true
                    , auto:false
                    , number:1
                    ,accept: 'images' //只允许上传图片
                    ,acceptMime: 'image/*' //只筛选图片
                    ,choose:function (obj) {
                        obj.preview(function (index, file, result) {
                            $('#intro-img').attr('src', result);
                            $('.upload-list-1').append('<button  type="button" class="layui-btn layui-btn-xs upload-introduce">点击上传</button>'
                            )
                            $('.upload-list-1').find('.upload-introduce').on('click', function () {
                                obj.upload(index, file);
                            });
                        })
                    }
                    ,done: function (res, index, upload){
                        if(res.success){
                            $('#introduce-text').text("上传成功");
                            $('.upload-list-1').find('.upload-introduce').remove();
                            _self.newProduct.instruction=res.data[0];
                        }
                    }
                })
                var uploadPoster = upload.render({
                    elem: '#poster'
                    , url: '/resource/upload/'
                    , multiple: true
                    , auto:false
                    , number:1
                    ,accept: 'images' //只允许上传图片
                    ,acceptMime: 'image/*' //只筛选图片
                    ,choose:function (obj) {
                        obj.preview(function (index, file, result) {
                            $('#poster-img').attr('src', result);
                            $('.upload-list-2').append('<button  type="button" class="layui-btn layui-btn-xs upload-poster">点击上传</button>'
                            )
                            $('.upload-list-2').find('.upload-poster').on('click', function () {
                                obj.upload(index, file);
                            });
                        })
                    }
                    ,done: function (res, index, upload){
                        if(res.success){
                            $('#poster-text').text("上传成功");
                            $('.upload-list-2').find('.upload-poster').remove();
                            _self.newProduct.poster=res.data[0];
                        }
                    }
                })
            })
        },
        updated:function(){
            layui.use(['element','form'], function(){
                var form = layui.form;
                form.render();
                var element = layui.element;
                element.init();
            })
        },
        methods: {
            setDefaultImg(index){
                for(var key  in this.productImg){
                        var d = $('#imgList').find('div#upload-'+ key);
                        var c = d.children();
                        c.eq(2).text("设为封面");
                    this.productImg[key].isDefault=0;
                }
                var div = $('#imgList').find('div#upload-'+ index);
                var child = div.children();
                child.eq(2).text("封面");
                this.productImg[index].isDefault=1;
                this.newProduct.defaultImg = this.productImg[index].url;
            },
            delSku(index){
                this.productSku[0].isDefault=1;
                $("input[type='radio']").first().attr("checked",'true');
                this.productSku.splice(index,1);
                // this.$forceUpdate();
            },
            addNewSku(){
                console.log($("input[name='defaultSku']:checked"))
              this.productSku.push({"saleWay":"single","isDefault":1,"packing":"box","delivery":{"mainId":this.productSku[0].deliveryId}});

            },
            changeForm(from,to) {
                console.log($("input[name='defaultSku']:checked").val())
                switch (from) {
                    case 0:
                        if (this.newProduct.name==null){
                            this.layer.msg("请完善商品信息");
                            return;
                        }
                        if ($('.wait-to-upload').length!=0){
                            this.layer.msg("请将图片上传");
                            return;
                        }
                        if (Object.keys(this.productImg).length==0) {
                            this.layer.msg("请添加展示图片");
                            return;
                        }
                        break;
                    case 1:
                        if (to!=0){
                            for(var i in this.productSku){
                                if(this.productSku[i].skuName==null||this.productSku[i].skuName==""||this.productSku[i].skuPrice==null||this.productSku[i].delivery=={}||this.productSku[i].deliveryId==""){
                                    this.layer.msg("请完善套餐/规格信息");
                                    return;
                                }
                            }
                        } break;
                }
                console.log(this.productImg);
                this.currentForm = to;
                if (to==2&&this.firstCategory==null){
                    this.getFirstCategory();
                }
            },
            getFirstCategory(){
                this.$http.get("/admin/product/category/first").then(function (res){
                    this.firstCategory = res.body.data.category;
                    this.material = res.body.data.material;
                    this.form = res.body.data.form;
                    this.showRefresh = false;
                    this.errorCount = 0;
                },function (err) {
                    this.errorCount++;
                    if (this.errorCount>5){
                        alert("获取分类信息出错！,尝试刷新重新获取");
                        this.showRefresh = true;
                    } else{
                        this.getFirstCategory();
                    }
                })
            },
            saveProduct(){
                var self = this;
                this.productCategory.form = $('.formCategory').val();
                this.productSku[parseInt($("input[name='defaultSku']:checked").val())].isDefault=1;
                self.symptom=[];

                $("input[name='symptom']:checked").each(function(){
                    console.log($(this))
                    self.symptom.push($(this).val())
                })

                this.productCategory.material = $('.materialCategory').val();
                this.productCategory.brand = $('.brandCategory').val();
                this.newProduct.produceTime = $('#produce-time').val();

                this.newProduct.type=$("input[name='type']:checked").val();
                this.newProduct.useWay=$("input[name='useWay']:checked").val();
                console.log(this.newProduct);
                console.log(this.productSku);
                console.log(this.productImg);
                console.log(this.productCategory);
                this.$http.post("/admin/product/add",JSON.stringify({
                    "newProduct":JSON.stringify(this.newProduct),
                    "productSku":JSON.stringify(this.productSku),
                    "productImg":JSON.stringify(this.productImg),
                    "productCategory":this.productCategory,
                    "factory":JSON.stringify(this.factory),
                    "symptom":this.symptom
                })).then(function (res){
                    console.log(res);
                    layer.msg(res.body.message);
                    if (res.body.success){
                        setTimeout(function () {
                            window.location="/admin/page/product-add";
                        },1000);
                    }
                },function (err) {
                });
            },
            getSaleWay(index){
                return "saleWay"+index;
            },
            getShopDelivery(){
                this.$http.get("/admin/shop/delivery").then(function (res){
                    this.deliveryList = res.body.data;
                    this.errorCount=0;
                    if (this.deliveryList.length>0)
                        this.productSku[0].deliveryId = this.deliveryList[0].mainId;

                },function (err) {
                    this.errorCount++;
                    if (this.errorCount>5){
                        alert("获取物流信息出错！！！");
                    } else{
                        this.getFirstCategory();
                    }
                })
            },
            addNewDelivery(){
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
        },
        computed: {
            showForm() {
                return function (index) {
                    return {
                        hide: this.currentForm != index
                    }
                }
            }
        }
    })
    //JavaScript代码区域
    function setDefaultImg(index) {
        vue.setDefaultImg(index);
    }

</script>
</html>