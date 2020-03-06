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
    </style>
</head>
<body class="layui-layout-body">

<div  class="layui-layout layui-layout-admin">
<#include "common/top-nav.ftl"/>
<#include "common/left-nav.ftl"/>
    <div  id="app" class="layui-body">
        <form  style="margin-top: 20px;margin-left: 30px;" class="layui-form">
        <div class="layui-form-item">
        <div class="layui-inline">
                <select  class="selectYear">
                    <option value="">请选择年份</option>
                    <option v-for="c in selectYear" :value="c">{{c}}</option>
                </select>
        </div>
            <span>年</span>
            <div class="layui-inline">
                <select class="selectMonth">
                    <option value="">请选择月份</option>
                    <option v-for="c in selectMonth" :value="c">{{c}}</option>
                </select>
            </div> <span>月</span>
            <div class="layui-inline">
                <select class="selectDay">
                    <option value="">请选择日</option>
                    <option v-for="c in selectDay" :value="c">{{c}}</option>
                </select>
            </div> <span>日</span>
    </div>
    </form>
        <div id="main" style="width: 600px;height:400px;margin-left: 30px"></div>
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
            .append("<dd><a style='color:white;background: #009688;' href='/admin/page/statistic-sale'>销售统计</a>" + "</dd>")
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
            myChart:null
        },
        mounted:function () {
            this.getOrderDate();
            var self = this;
            this.myChart = echarts.init(document.getElementById('main'));
            this.getSale();
            layui.use(['element','layer','form'], function() {
                var element = layui.element;
                var form = layui.form;
                var layer = layui.layer;
                form.on('select', function (data) {
                    if (data.elem.className == "selectYear") {
                        self.year=data.value;
                    } else if (data.elem.className == "selectMonth") {
                        self.month=data.value;
                    } else {
                        self.day=data.value;
                    }
                    self.getSale();
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
            getSale(){
                var url = "/admin/sale/each/year";
                var type="line";
                if (this.day!=""&&this.month!=""&&this.year!=""){
                    url="/admin/sale/"+this.year+"/"+this.month+"/"+this.day;
                }else if (this.day==""&&this.month!=""&&this.year!="") {
                    url="/admin/sale/"+this.year+"/"+this.month;
                }else if (this.day==""&&this.month==""&&this.year!=""){
                    url="/admin/sale/at/"+this.year;
                    type='bar';
                }
                this.$http.get(url).then(function (res) {
                    if (res.body.success){
                        var xAxis = [];
                        var countVal=[];
                        var sumVal=[];

                        for (var i in res.body.data){
                            xAxis.push(res.body.data[i].name);
                            countVal.push(res.body.data[i].countVal);
                            sumVal.push((parseFloat(res.body.data[i].sumVal)/10).toFixed(2));
                        }
                       var option = {
                            title:{
                                text:'销售统计'
                            },
                            tooltip:{
                                trigger: 'axis'
                            },
                            legend:{
                                data:['销售量','销售额']
                            },
                            xAxis: {
                                type: 'category',
                                data: xAxis,
                                name:'年'
                            },
                            yAxis: {
                                type: 'value'
                            },
                            series: [
                                {
                                    data:countVal,
                                    type: type,
                                    name:'销售量',
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
                                            formatter:'{c}万元',
                                            show: true
                                        }
                                    }
                                }
                            ]
                        };
                       this.myChart.setOption(option);
                    }
                })
            }
        }
    })











</script>
