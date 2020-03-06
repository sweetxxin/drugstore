<fieldset class="layui-elem-field">
        <legend>规格/套餐</legend>
        <div id="collapse-box" class="layui-field-box">
            <div v-for="(sku,index) in productSku" class="layui-collapse" lay-accordion="" style="margin-bottom: 10px;" >
                <div class="layui-colla-item">
                    <h2 class="layui-colla-title">规格{{index+1}}</h2>
                    <div class="layui-colla-content layui-show">
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">规格名</label>
                                <div class="layui-input-inline">
                                    <input placeholder="必填" type="text" v-model="sku.skuName" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">销售方式</label>
                                <div class="layui-input-inline">
                                    <select class="saleWay" :lay-reqText="index" :lay-filter="index">
                                        <option :selected="sku.saleWay=='single'" value="single">单品</option>
                                        <option :selected="sku.saleWay=='compose'" value="compose">组合</option>
                                    </select>
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">包装方式</label>
                                <div class="layui-input-inline">
                                    <select class="packingWay" :lay-reqText="index">
                                        <option  :selected="sku.packing=='box'" value="box">盒装</option>
                                        <option :selected="sku.packing=='bottle'" value="bottle">瓶装</option>
                                        <option :selected="sku.packing=='pot'"  value="pot">罐装</option>
                                        <option :selected="sku.packing=='piece'" value="piece">片/粒</option>
                                        <option :selected="sku.packing=='bag'" value="bag">包</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">市场价</label>
                                <div class="layui-input-inline">
                                    <input placeholder="￥" min="0" type="number" v-model="sku.marketPrice" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">现价</label>
                                <div class="layui-input-inline">
                                    <input placeholder="￥ 必填"  min="0" type="number" v-model="sku.skuPrice" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">折扣价</label>
                                <div class="layui-input-inline">
                                    <input placeholder="￥" min="0" type="number" v-model="sku.discountPrice" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">起购量</label>
                                <div class="layui-input-inline">
                                    <input type="number" min="1" v-model="sku.lowerLimit" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">限购量</label>
                                <div class="layui-input-inline">
                                    <input type="number" min="1" v-model="sku.upperLimit" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">物流方式</label>
                                <div class="layui-input-inline">
                                    <select class="deliveryWay" :lay-reqText="index">
                                        <option v-for="d in deliveryList" :value="d.mainId" :selected="sku.delivery.mainId==d.mainId" >{{d.title}}</option>
                                    </select>
                                </div>
                                <i @click="addNewDelivery()" class="layui-icon layui-icon-add-circle" style="margin-top: 7px;display: inline-block;font-size: 25px;color: #1E9FFF;cursor: pointer"></i>
                                <i @click="getShopDelivery()" class="layui-icon layui-icon-refresh"  style="margin-top: 7px;display: inline-block;font-size: 25px;margin-left:10px;color: #1E9FFF;cursor: pointer"></i>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">默认规格</label>
                                <input type="radio" :checked="sku.isDefault==1" :value="index" lay-filter="defaultSku"  name="defaultSku" class="defaultSku" lay-skin="switch" lay-text="YES|NO">
                            </div>
                        </div>
                        <div v-if="productSku.length!=1" class="layui-form-item">
                            <button @click="delSku(index)" type="button"
                                    class="layui-btn layui-btn-danger layui-btn-radius" style="margin: 0px 90%">删除
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <button @click="addNewSku()" style="display: block;margin: 10px auto;" type="button"
                    class="layui-btn layui-btn-normal layui-btn-radius">新增库存类型
            </button>
        </div>
    </fieldset>
