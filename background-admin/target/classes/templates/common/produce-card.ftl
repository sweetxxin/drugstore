<fieldset class="layui-elem-field">
    <legend>生产信息</legend>
    <div class="layui-field-box">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">原产地</label>
                <div class="layui-input-inline">
                    <input type="text" v-model="newProduct.originPlace" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">生产日期</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" id="produce-time" placeholder="yyyy-MM-dd HH:mm:ss">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">保质期</label>
                <div class="layui-input-inline">
                    <input type="text" v-model="newProduct.guarantee" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">厂家名</label>
                <div class="layui-input-inline">
                    <input type="text" v-model="factory.name" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">厂家地址</label>
                <div class="layui-input-inline">
                    <input type="text" v-model="factory.address" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">厂家电话</label>
                <div class="layui-input-inline">
                    <input type="text" v-model="factory.contact" class="layui-input">
                </div>
            </div>
        </div>
    </div>
</fieldset>