<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <link rel="stylesheet" type="text/css" href="/admin/static/frame/layui/css/layui.css">
    <script type="text/javascript" src="/admin/static/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="/admin/static/frame/layui/layui.js"></script>
    <style>
        /*弹出框*/
        .pop-row{
            display: flex;
            margin-top: 15px;
        }
        .detailAddress{
            width: 500px;
        }
        .cancel-btn,.sure-btn{
            width: 150px;
        }
        .btn-group{
            text-align: right;
            margin-right: 160px;
        }
    </style>
</head>
<body>
<div id="app"  class="popAddress">
    <div class="pop-row">
        <form class="layui-form">
            <div id="all" class="layui-form-item">
                <div id="first" class="layui-inline">
                    <label class="layui-form-label">药品类别</label>
                    <div class="layui-input-inline">
                    <select id="firstCategory" class="firstCategory">
                        <option value="">请选择分类</option>
                    </select>
                </div>
            </div>
                <div id="second" class="layui-inline">
                    <div class="layui-input-inline">
                        <select id="secondCategory" class="secondCategory">
                            <option value="">请选择分类</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
            <label class="layui-form-label">名称</label>
            <div class="layui-input-block">
                <input type="text"  id="name" required="" lay-verify="required" placeholder="请输入名称" autocomplete="off" class="layui-input">
            </div>
            </div>
    </div>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">描述</label>
        <div class="layui-input-block detailAddress">
            <textarea style="min-height: 70px;" id="detail" class="layui-textarea"></textarea>
        </div>
    </div>
    </form>

        <div class="btn-group">
        <button type="button" onclick="hidePop()"  class="layui-btn cancel-btn">取消</button>
        <button type="button" onclick="save()" class="layui-btn layui-btn-danger sure-btn">确定</button>
        </div>

</div>
</body>
<script>
    var type=1;
    var first="";
    var second="";
   window.onload = function (ev) {
       type = getType(location.href);
       if (type==1||type==10||type==20){
           $('#all').remove();
       }else if (type==2||type==1000){
           $('#second').remove();
           this.getFirstCategory();
       }else{
           this.getFirstCategory();
       }
       layui.use(['form','layer'], function() {
           form = layui.form;
           layer=layui.layer;
           //移除select中所有项 赋予初始值
           function removeEle(ele) {
               ele.find("option").remove();
               var optionStar = "<option value=" + "0" + ">" + "请选择" + "</option>";
               ele.append(optionStar);
           }
           form.on('select', function(data){
               if(data.elem.className=="firstCategory"){
                   first = data.value;
                   if (first!=""&&(type==3||type==30)){
                       $.get("/admin/product/category/"+data.value+"/child",function (res){
                           var c = res.data.self;
                           removeEle($('#secondCategory'));
                           for(var i in c){
                               $('#secondCategory').append('<option value="'+c[i].mainId+'">'+c[i].name+'</option>')
                           }
                           form.render();
                       })
                   }
               }else if (data.elem.className=="secondCategory"){
                   second = data.value;
               }
           })
       })
   }
   function hidePop() {
       var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
       parent.layer.close(index);
   }
   function save() {
       if ($('#name').val()==""){
           layer.msg('请填写分类名称');
           return;
       }
        var item={
            name:$('#name').val(),
            description:$('#detail').val(),
            code:type
        };
        if (type==2||type==1000){
            if (first==""){
                layer.msg('请选择父类')
                return;
            }else{
                item.parentId=first;
            }
        }
        if (type==3||type==30){
            if (first==""||second==""){
                layer.msg('请选择父类')
                return;
            }else{
                item.parentId=second;
            }
        }
       $.ajax({
           type:"post",
           url:"/product/category/add",
           data:JSON.stringify(item),
           contentType : "application/json",
           success:function (res) {
               if(res.success){
                   hidePop();
                   layer.msg('添加成功')
                   window.parent.location.reload();//刷新父页面
               }
           }
       })
        console.log(item)
   }
   function getType(str) {
       return str.substr(str.indexOf("=")+1,str.length);
   }
    function getFirstCategory(){
       $.get("/admin/product/category/first",function (res) {
            var c = res.data.category;
            for(var i in c){
                $('#firstCategory').append('<option value="'+c[i].mainId+'">'+c[i].name+'</option>')
            }
            layui.use('form',function(){
                var form = layui.form;
                form.render();
            })

        })
    }
</script>
</html>