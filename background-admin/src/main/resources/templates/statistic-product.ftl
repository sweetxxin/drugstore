<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>益和药房-卖家平台</title>
    <link rel="stylesheet" href="/admin/static/frame/layui/css/layui.css">
    <style>
        .myStatistic{
            color: white !important;
            background: #5FB878;
        }
        .w150{
            width: 150px;
        }
    </style>
</head>
<body class="layui-layout-body">

<div  class="layui-layout layui-layout-admin">
<#include "common/top-nav.ftl"/>
<#include "common/left-nav.ftl"/>
    <div  id="app" class="layui-body">
        <form  style="margin-top: 20px;margin-left: 30px;" class="layui-form">
        <div class="layui-form-item">
        <div class="layui-inline w150">
                <select  class="selectYear">
                    <option value="">请选择年份</option>
                    <option v-for="c in selectYear" :value="c">{{c}}</option>
                </select>
        </div>
            <span>年</span>
            <div class="layui-inline w150">
                <select class="selectMonth">
                    <option value="">请选择月份</option>
                    <option v-for="c in selectMonth" :value="c">{{c}}</option>
                </select>
            </div> <span>月</span>
            <div class="layui-inline w150">
                <select class="selectDay">
                    <option value="">请选择日</option>
                    <option v-for="c in selectDay" :value="c">{{c}}</option>
                </select>
            </div> <span>日</span>
            <div style="margin-left: 50px;" class="layui-inline">
                <select class="selectElse">
                    <option value=""></option>
                    <option value="category">药品分类比例</option>
                    <option value="brand">品牌分布比例</option>
                </select>
            </div>
            <i style="cursor: pointer" @click="reset()" class="layui-icon layui-icon-refresh">重置</i>
        </div>
    </form>
        <div id="main" style="width: 900px;height:400px;margin-left: 30px"></div>
    </div>
<#--<#include "common/footer.ftl"/>-->
</div>
<script src="/admin/static/js/jquery-1.8.3.min.js"></script>
<script src="/admin/static/frame/layui/layui.js"></script>
<script src="https://cdn.bootcss.com/echarts/4.6.0/echarts-en.min.js"></script>
<script>
    $('#left-nav-1').html("全部统计");
    $('#left-nav-1-child')
            .append("<dd><a  style='color:white;background: #009688;'href='/admin/page/statistic-product'>商品统计</a>" + "</dd>")
            .append("<dd><a  href='/admin/page/statistic-sale'>销售统计</a>" + "</dd>")
            .append("<dd><a  href='/admin/page/statistic-order'>订单统计</a>" + "</dd>")
            .append("<dd><a  href='/admin/page/statistic-comment'>评价统计</a>" + "</dd>");

    var vue = new Vue({
        el:"#app",
        data:{
            selectYear:[],
            selectMonth:[],
            selectDay:[],
            showRefresh:true,
            errorCount:0,
            year:"",
            month:"",
            day:"",
            pieSelect:null,
            myChart:null
        },
        mounted:function () {
            var self = this;
            this.getOrderDate();
            this.myChart = echarts.init(document.getElementById('main'));
            this.getTopProduct();
            layui.use(['element','layer','form'], function() {
                var element = layui.element;
                var form = layui.form;
                var layer = layui.layer;
                form.on('select', function (data) {
                    if (data.elem.className == "selectYear") {
                        self.year=data.value;
                    } else if (data.elem.className == "selectMonth") {
                        self.month=data.value;
                    } else if (data.elem.className == "selectDay") {
                        self.day=data.value;
                    }else{
                        self.pieSelect=data.value;
                        console.log(data)
                        self.getProductCompose();
                        return;
                    }
                    self.getTopProduct();
                });

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
        methods:{
            getOrderDate(){
                this.$http.get("/admin/order/date").then(function (res) {
                    if (res.body.success){
                        this.selectDay = res.body.data["day"];
                        this.selectMonth = res.body.data["month"];
                        this.selectYear = res.body.data['year'];
                    }
                })
            },
            reset(){
                this.year="";
                this.month="";
                this.day="";
                this.pieSelect="";
                $(".selectYear").find("option[value='']").prop("selected",true);
                $(".selectMonth").find("option[value='']").prop("selected",true);
                $(".selectDay").find("option[value='']").prop("selected",true);
                $(".selectElse").find("option[value='']").prop("selected",true);
                layui.use('form',function () {
                    layui.form.render('select');
                })
                this.getTopProduct();

            },
            getProductCompose(){
                this.$http.get("/admin/product/compose/"+this.pieSelect).then(function (res) {
                    if (res.body.success){
                        this.makePie(res.body.data);
                    }
                })
            },
            getTopProduct(){
                var url = "/admin/product/top/10";
                var type="bar";
                if (this.day!=""&&this.month!=""&&this.year!=""){
                    url+="/"+this.year+"/"+this.month+"/"+this.day;
                }else if (this.day==""&&this.month!=""&&this.year!="") {
                    url+="/"+this.year+"/"+this.month;
                }else if (this.day==""&&this.month==""&&this.year!=""){
                    url+="/"+this.year;
                }
                this.$http.get(url).then(function (res) {
                    if (res.body.success){
                        var xAxis = [];
                        var countVal=[];
                        var sumVal=[];
                        for (var i in res.body.data){
                            xAxis.push(res.body.data[i].name);
                            countVal.push(res.body.data[i].countVal);
                            sumVal.push(-parseInt(res.body.data[i].sumVal));
                        }
                       var option = {
                            title:{
                                text:'Top10商品排行'
                            },
                            tooltip:{
                                trigger: 'axis'
                            },
                            legend:{
                                data:['订单量','销售量']
                            },
                            xAxis: {
                                type: 'category',
                                data: xAxis,
                                name:'商品名称',
                                axisLabel: {
                                    interval: 0,
                                    formatter: function (value) {
                                        var valueDetal = value.split("-").join("");
                                        var ret = ""; //拼接加\n返回的类目项
                                        var maxLength = 8; //每项显示文字个数
                                        var valLength = valueDetal.length; //X轴类目项的文字个数
                                        var rowN = Math.ceil(valLength / maxLength); //类目项需要换行的行数
                                        if (rowN > 1) { //如果类目项的文字大于3,
                                            for (var i = 0; i < rowN; i++) {
                                                var temp = ""; //每次截取的字符串
                                                var start = i * maxLength; //开始截取的位置
                                                var end = start + maxLength; //结束截取的位置
                                                //这里也可以加一个是否是最后一行的判断，但是不加也没有影响，那就不加吧
                                                temp = valueDetal.substring(start, end) + "\n";
                                                ret += temp; //凭借最终的字符串
                                            }
                                            return ret;
                                        } else {
                                            return valueDetal;
                                        }
                                    }
                                }
                            },
                            yAxis: {
                                type: 'value'
                            },
                            series: [
                                {
                                    data:countVal,
                                    type: type,
                                    name:'订单量',
                                    label:{
                                        normal:{
                                            formatter:'{c}单',
                                            show: true
                                        }
                                    }
                                },
                                {
                                    data: sumVal,
                                    type: type,
                                    name:'销售量',
                                    label:{
                                        normal:{
                                            formatter:'{c}份',
                                            show: true
                                        }
                                    }
                                }
                            ]
                        };
                        this.myChart.setOption(option,true);
                    }
                })
            },
            makePie(data){
                var xAxis = [];
                var countVal=[];
                    for (var i in data){
                    xAxis.push(data[i].name);
                    countVal.push({"name":data[i].name,"value":data[i].countVal});
                }
                var option = {
                    title:{
                        text:'产品构成',
                        subtext:$(".selectElse option:selected").text()
                    },
                    tooltip:{
                        trigger: 'item',
                        formatter: '{a} <br/>{b} : {c} ({d}%)'
                    },
                    legend:{
                        data:xAxis
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            mark: {show: true},
                            dataView: {show: true, readOnly: false},
                            magicType: {
                                show: true,
                                type: ['pie', 'funnel']
                            },
                            restore: {show: true},
                            saveAsImage: {show: true}
                        }
                    },
                    series: [
                        {
                            name: '占比',
                            type: 'pie',
                            radius: [20, 110],
                            center: ['25%', '50%'],
                            roseType: 'radius',
                            label: {
                                show: false,
                            },
                            emphasis: {
                                label: {
                                    show: true
                                }
                            },
                            data: countVal,
                            itemStyle: {
                                emphasis: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                },
                                normal:{
                                    label:{
                                        show: true,
                                        formatter: '{b} : {c}',
                                        position: 'outer'
                                    },
                                    labelLine :{show:true}
                                }
                            }
                        },
                        {
                            name: '占比',
                            type: 'pie',
                            radius: [20, 110],
                            center: ['25%', '50%'],
                            roseType: 'radius',
                            label: {
                                show: false,
                            },
                            emphasis: {
                                label: {
                                    show: true
                                }
                            },
                            data: countVal,
                            itemStyle: {
                                emphasis: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                },
                                normal:{
                                    label:{
                                        show: true,
                                        formatter: function (p) {
                                            return p.percent + "%";
                                        },
                                        position: 'inner'
                                    },
                                    labelLine :{show:true}
                                }
                            }
                        },
                        {
                            name: '占比',
                            type: 'pie',
                            radius: [30, 110],
                            center: ['75%', '50%'],
                            roseType: 'area',
                            data: countVal,
                            itemStyle: {
                                emphasis: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                },
                                normal:{
                                    label:{
                                        show: true,
                                        formatter: '{b} : {c} ({d}%)'
                                    },
                                    labelLine :{show:true}
                                }
                            }
                        }
                    ]
                };
                this.myChart.setOption(option,true);
            }
        }
    })











</script>
