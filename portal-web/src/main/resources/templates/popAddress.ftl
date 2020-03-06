<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <link rel="stylesheet" type="text/css" href="/web/static/layui/css/layui.css">
    <script type="text/javascript" src="/web/static/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="/web/static/layui/layui.js"></script>
    <style>
        /*弹出框*/
        .pop-row{
            display: flex;
            margin-top: 15px;
        }
        .layui-main{
            width: auto;
        }
        .detailAddress{
            width: 500px;
        }
        .select-address-item{
            width: 158px;
        }
        .cancel-btn,.sure-btn{
            width: 150px;
        }
        .btn-group{
            text-align: right;
            margin-right: 160px;
        }
    </style>
    <script type="text/javascript" src="/web/static/js/area.js"></script>
</head>
<body>
<div id="app"  class="popAddress">
    <div class="pop-row">
        <div class="layui-form-item">
            <label class="layui-form-label">收件人</label>
            <div class="layui-input-block">
                <input type="text"  id="receiver" required="" lay-verify="required" placeholder="请输入姓名" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">手机号</label>
            <div class="layui-input-block">
                <input type="text"  id="mobile" required="" lay-verify="required" placeholder="请输入手机号" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <#-- 省市县级联联动 -->
    <div class="layui-main" >
        <form class="layui-form" action="javascript:jg()" method="post" style="margin:50px auto">
            <div class="layui-form-item">
                <label class="layui-form-label">请选择地区</label>
                <div class="layui-inline select-address-item">
                    <select  name="province"  id="province" lay-verify="required" lay-search lay-filter="province">
                        <option id="provinceOpt" value="">省份</option>
                    </select>
                </div>
                <div class="layui-inline select-address-item">
                    <select   name="city" id="city" lay-verify="required" lay-search lay-filter="city">
                        <option value="">地级市</option>
                    </select>
                </div>
                <div class="layui-inline select-address-item">
                    <select   name="district" lay-filter="district" id="district" lay-verify="required" lay-search>
                        <option value="">县/区</option>
                    </select>
                </div>
                <input type="hidden" id="mainId">
            </div>
        </form>
    </div>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">详细地址</label>
        <div class="layui-input-block detailAddress">
            <textarea style="min-height: 70px;" id="detail"  placeholder="请输入详细地址" class="layui-textarea"></textarea>
        </div>
    </div>
    <form class="layui-form">
    <div class="layui-form-item">
        <label class="layui-form-label">设为默认</label>
        <div class="layui-input-block">
            <input type="checkbox" lay-filter="isDefault" id="isDefault" lay-skin="switch" lay-text="ON|OFF">
        </div>
    </div>
    </form>
    <div class="btn-group">
        <button type="button" onclick="hidePop()"  class="layui-btn cancel-btn">取消</button>
        <button type="button" onclick="addNewAddress()" class="layui-btn layui-btn-danger sure-btn">确定</button>
    </div>

</div>
</body>
<script src="/web/static/js/select.js" type="text/javascript"></script>
<script>

    var newAddress = {
        "receiver":null,
        "mobile":null,
        "province":null,
        "city":null,
        "town":null,
        "detail":null,
        "isDefault":null,
        "mainId":null,
        "country":null
    };
    var form = null;

   window.onload = function (ev) {
       layui.use('form', function() {
           form = layui.form;
           var province = $("#province"),
                   city = $("#city"),
                   district = $("#district");
           //初始将省份数据赋予
           for (var i = 0; i < provinceList.length; i++) {
               addEle(province, provinceList[i].name);
           }
           //赋予完成 重新渲染select
           form.render('select');
           //向select中 追加内容
           function addEle(ele, value) {
               var optionStr = "";
               optionStr = "<option value=" + value + " >" + value + "</option>";
               ele.append(optionStr);
           }

           //移除select中所有项 赋予初始值
           function removeEle(ele) {
               ele.find("option").remove();
               var optionStar = "<option value=" + "0" + ">" + "请选择" + "</option>";
               ele.append(optionStar);
           }

           var provinceText,
                   cityText,
                   cityItem;
           //选定省份后 将该省份的数据读取追加上
           form.on('select(province)', function(data) {
               console.log('这里')
               provinceText = data.value;
               $.each(provinceList, function(i, item) {
                   if (provinceText == item.name) {
                       cityItem = i;
                       return cityItem;
                   }
               });
               removeEle(city);
               removeEle(district);
               $.each(provinceList[cityItem].cityList, function(i, item) {
                   addEle(city, item.name);
               })
               newAddress.province = provinceText;
               //重新渲染select
               form.render('select');
           });
           ////选定市或直辖县后 将对应的数据读取追加上
           form.on('select(city)', function(data) {
               cityText = data.value;
               removeEle(district);
               $.each(provinceList, function(i, item) {
                   if (provinceText == item.name) {
                       cityItem = i;
                       return cityItem;
                   }
               });
               $.each(provinceList[cityItem].cityList, function(i, item) {
                   if (cityText == item.name) {
                       for (var n = 0; n < item.areaList.length; n++) {
                           addEle(district, item.areaList[n]);
                       }
                   }
               })
               newAddress.city= cityText;
               //重新渲染select
               form.render('select');
           });
           form.on('select(district)', function(data) {
               newAddress.town = data.value;
           });


           form.on('switch(isDefault)',function (data) {
               newAddress.isDefault = data.elem.checked==true?1:0;
           });
           var seletedAddr =localStorage.getItem("seletedAddr");
           if (seletedAddr!=null){
               newAddress = JSON.parse(seletedAddr);
               $("#isDefault").prop("checked",newAddress.isDefault==1?true:false);
               $("#receiver").val(newAddress.receiver);
               $("#mobile").val(newAddress.mobile);
               $("#detail").val(newAddress.detail);
               $("#mainId").val(newAddress.mainId);
               form.render('checkbox');

               $('#province').siblings("div.layui-form-select").find('dl dd[lay-value=' + newAddress.province + ']').click();
               $('#city').siblings("div.layui-form-select").find('dl dd[lay-value=' + newAddress.city + ']').click();
               $('#district').siblings("div.layui-form-select").find('dl dd[lay-value=' + newAddress.town + ']').click();
           }
       })


   }
   function hidePop() {
       var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
       localStorage.removeItem("seletedAddr");
       parent.layer.close(index);
   }
   function addNewAddress() {
        newAddress.receiver = $("#receiver").val();
        newAddress.mobile = $("#mobile").val();
        newAddress.detail = $("#detail").val();

        console.log(newAddress)
        if (newAddress.province==null||newAddress.town==null||newAddress.detail==null||newAddress.receiver==null||newAddress.city==null){
            alert("请完善物流信息")
            return;
        }
        $.ajax({
            type:"post",
            url:"/web/user/address/save",
            data:JSON.stringify(newAddress),
            contentType : "application/json",
            success:function (res) {
                if(res.success){
                    alert(res.message);
                    hidePop();
                    window.parent.location.reload();//刷新父页面
                }
            }
        })
    }
</script>
</html>