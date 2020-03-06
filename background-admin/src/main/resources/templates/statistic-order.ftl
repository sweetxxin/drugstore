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
        <form  style="margin-top: 20px;" class="layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">最近</label>
        <div class="layui-inline">
                <select  class="selectDay">
                    <option v-for="c in selectDay" :value="c" :selected="c==7">{{c}}</option>
                </select>
        </div>
            <span>天</span>
            <div style="margin-left: 50px;" class="layui-inline">
                <select class="selectElse">
                    <option value=""></option>
                    <option value="area">地区分布</option>
                    <option value="status">订单状态</option>
                </select>
            </div>
            <i style="cursor: pointer" @click="reset()" class="layui-icon layui-icon-refresh">重置</i>
        </div>
    </form>
        <div id="main" style="width: 1000px;height:400px;margin-left: 30px"></div>
    </div>
<#--<#include "common/footer.ftl"/>-->
</div>
<script src="/admin/static/js/jquery-1.8.3.min.js"></script>
<script src="/admin/static/frame/layui/layui.js"></script>
<script src="https://cdn.bootcss.com/echarts/4.6.0/echarts-en.min.js"></script>
<script>
    $('#left-nav-1').html("全部统计");
    $('#left-nav-1-child')
            .append("<dd><a  href='/admin/page/statistic-product'>商品统计</a>" + "</dd>")
            .append("<dd><a  href='/admin/page/statistic-sale'>销售统计</a>" + "</dd>")
            .append("<dd><a  style='color:white;background: #009688;'href='/admin/page/statistic-order'>订单统计</a>" + "</dd>")
            .append("<dd><a  href='/admin/page/statistic-comment'>评价统计</a>" + "</dd>");

    var vue = new Vue({
        el:"#app",
        data:{
            selectDay:[7,8,9,10,11,12,13,14],
            day:"7",
            myChart:null,
            selectElse:""
        },
        mounted:function () {
            var self = this;
            this.getOrderStatistic();
            this.myChart = echarts.init(document.getElementById('main'));
            layui.use(['element','layer','form'], function() {
                var element = layui.element;
                var form = layui.form;
                var layer = layui.layer;
                form.on('select', function (data) {
                     if (data.elem.className == "selectDay") {
                        self.day=data.value;
                        self.getOrderStatistic();
                    }else{
                         self.selectElse=data.value;
                         self.getOrderStatisticBy();
                    }
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
            reset(){
                $(".selectDay").find("option[value='7']").prop("selected",true);
                $(".selectElse").find("option[value='']").prop("selected",true);
                this.selectElse="";
                this.day=7;
                layui.use('form',function () {
                    layui.form.render('select');
                })
                this.getOrderStatistic();
            },
            getOrderStatistic(){
                var url = "/admin/order/recent/"+this.day+"/statistic";
                this.$http.get(url).then(function (res) {
                    if (res.body.success){
                        var xAxis = [];
                        var countVal=[];
                        var sumVal=[];
                        var type='bar';
                        for (var i in res.body.data){
                            xAxis.push(res.body.data[i].name);
                            countVal.push(res.body.data[i].countVal);
                            sumVal.push((res.body.data[i].sumVal));
                        }
                       var option = {
                            title:{
                                text:'最近七天订单'
                            },
                            tooltip:{
                                trigger: 'axis'
                            },
                            legend:{
                                data:['订单量','销售额']
                            },
                            xAxis: {
                                type: 'category',
                                data: xAxis,
                                name:'日期'
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
                                    name:'销售额',
                                    label:{
                                        normal:{
                                            formatter:'{c}元',
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
            getOrderStatisticBy(){
                this.$http.get("/admin/order/"+this.selectElse+"/statistic").then(function (res) {
                    if (res.body.success){
                        this.makePie(res.body.data);
                    }
                })
            },
            makePie(data){
                var xAxis = [];
                var countVal=[];
                var text="购买地分布";
                if (this.selectElse=="status"){
                   text="状态分布";
                }
                    for (var i in data){
                    xAxis.push(data[i].name);
                    countVal.push({"name":data[i].name,"value":data[i].countVal});
                }
                var option = {
                    title:{
                        text:text,
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
