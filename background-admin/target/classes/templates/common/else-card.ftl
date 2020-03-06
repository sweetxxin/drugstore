<fieldset class="layui-elem-field">
    <legend>其他信息</legend>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">保存条件</label>
            <div class="layui-input-inline">
                <input type="text" v-model="newProduct.storageCondition" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">用法用量</label>
            <div class="layui-input-inline">
                <input style="width: 400px" type="text" v-model="newProduct.dosage" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">毛重</label>
            <div class="layui-input-inline">
                <input type="number"  v-model="newProduct.netWeight" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">净重</label>
            <div class="layui-input-inline">
                <input type="number"v-model="newProduct.weight" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div style="margin-left: 110px;display: inline-block">
            <button type="button" class="layui-btn" id="introduce">上传说明书</button>
            <div class="upload-list-1" style="margin-top: 20px;text-align: center;">
                <img class="layui-upload-img" style="max-height: 250px;max-width: 150px;" id="intro-img">
                <p id="introduce-text"></p>
            </div>
        </div>
        <div style="margin-left: 210px;display: inline-block">
            <button type="button" class="layui-btn" id="poster">上传药品海报</button>
            <div class="upload-list-2" style="margin-top: 20px;text-align: center;">
                <img class="layui-upload-img" style="max-height: 250px;max-width: 150px;" id="poster-img">
                <p id="poster-text"></p>
            </div>
        </div>
    </div>

</fieldset>