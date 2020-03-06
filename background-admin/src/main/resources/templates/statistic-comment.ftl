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
            <div  class="layui-inline">
                <select class="comment">
                    <option value=""></option>
                    <option value="delivery">物流服务</option>
                    <option value="shop">商家描述</option>
                    <option value="goods">产品相符</option>
                    <option value="service">服务态度</option>
                </select>
            </div>
            <i style="cursor: pointer" @click="reset()" class="layui-icon layui-icon-refresh">重置</i>
            <button v-show="showChange" style="float: right;margin-right: 50px;" @click="changeChart()" type="button" class="layui-btn">{{msg}}</button>
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
            .append("<dd><a href='/admin/page/statistic-product'>商品统计</a>" + "</dd>")
            .append("<dd><a  href='/admin/page/statistic-sale'>销售统计</a>" + "</dd>")
            .append("<dd><a  href='/admin/page/statistic-order'>订单统计</a>" + "</dd>")
            .append("<dd><a style='color:white;background: #009688;' href='/admin/page/statistic-comment'>评价统计</a>" + "</dd>");

    var vue = new Vue({
        el:"#app",
        data:{
            myChart:null,
            commentSelect:"",
            allData:null,
            eachData:null,
            msg:'切换饼状图',
            showChange:true,
            currentShape:"bar"
        },
        mounted:function () {
            var self = this;
            this.getAssessmentStatistic();
            this.myChart = echarts.init(document.getElementById('main'));
            layui.use(['element','layer','form'], function() {
                var element = layui.element;
                var form = layui.form;
                var layer = layui.layer;
                form.on('select', function (data) {
                        self.commentSelect=data.value;
                        self.getAssessmentStatistic();
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
                this.commentSelect="";
                $(".comment").find("option[value='']").prop("selected",true);
                layui.use('form',function () {
                    layui.form.render('select');
                })
                this.getAssessmentStatistic();
            },
            changeChart(){
                if (this.currentShape=="bar"){
                    this.currentShape="pie";
                    this.msg="切换柱形图";
                    this.makePie(this.allData);
                } else{
                    this.currentShape="bar";
                    this.msg="饼状图";
                    this.makeBar(this.allData);
                }

            },
            getAssessmentStatistic(){
                var url = "/admin/assessment/statistic"+(this.commentSelect==""?this.commentSelect:("/"+this.commentSelect));
                this.$http.get(url).then(function (res) {
                        if (res.body.success){
                            if (this.commentSelect!=""){
                                this.makePie(res.body.data);
                                this.eachData=res.body.data;
                                this.showChange=false;
                            } else{
                                this.showChange=true;
                                this.makeBar(res.body.data);
                                this.allData = res.body.data;
                            }
                        }
                })
            },
            makeBar(data){
                var xAxis = [];
                var countVal=[];
                var title=["","极差","差","一般","好","极好"]
                for (var i in data){
                    xAxis.push(title[data[i].name]);
                    countVal.push({"name":title[data[i].name],"value":data[i].countVal});
                }
                var option = {
                    title:{
                        text:'总体评价'
                    },
                    tooltip:{
                        trigger: 'axis'
                    },
                    legend:{
                        data:['评价个数']
                    },
                    xAxis: {
                        type: 'category',
                        data: xAxis,
                        name:'评价'
                    },
                    yAxis: {
                        type: 'value',
                        name:"个数"
                    },
                    series: [
                        {
                            data: countVal,
                            type: 'bar',
                            name:'评价个数',
                            label:{
                                normal:{
                                    formatter:'{c}个',
                                    show: true
                                }
                            }
                        }
                    ]
                };
                this.myChart.setOption(option,true);
            },
            makePie(data){
                var xAxis = [];
                var title=["","极差","差","一般","好","极好"]
                var countVal=[];
                    for (var i in data){
                    xAxis.push(title[data[i].name]);
                    countVal.push({"name":title[data[i].name],"value":data[i].countVal});
                }
                var option = {
                    title:{
                        text:'评价构成',
                        subtext:$(".comment option:selected").text()
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
