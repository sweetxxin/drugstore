<fieldset class="layui-elem-field">
    <legend>分类信息</legend>
    <div class="layui-field-box">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">药品类型</label>
                <div class="layui-input-inline" style="width: 250px">
                    <template v-for="(type,index) in typeList">
                        <input v-if="index==0" checked type="radio" name="type" :value="type"  :title="type">
                        <input v-else    type="radio" name="type" :value="type" :title="type">
                    </template>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">使用方式</label>
                <div class="layui-input-inline" style="width: 250px">
                    <input  type="radio"  name="useWay" value="口服" title="口服" checked="">
                    <input  type="radio" name="useWay" value="外用" title="外用">
                    <input  type="radio" name="useWay" value="其他" title="其他">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">药品类别</label>
                <div class="layui-input-inline">
                    <select id="firstCategory" class="firstCategory">
                        <option value="">请选择分类</option>
                        <option v-for="c in firstCategory" :selected="productFirst==c.mainId" :value="c.mainId">{{c.name}}</option>
                    </select>
                </div>
                <div v-show="showSecondCategory" class="layui-input-inline">
                    <select id="secondCategory" class="secondCategory">
                        <option selected value="">请选择分类</option>
                        <option v-for="c in secondCategory" v-if="c.name!='热门品牌'" :value="c.mainId" :selected="productSecond==c.mainId">{{c.name}}</option>
                    </select>
                </div>
                <div v-show="showSecondCategory&&showThirdCategory" class="layui-input-inline">
                    <select id="thirdCategory" class="thirdCategory">
                        <option selected value="">请选择分类</option>
                        <option v-for="c in thirdCategory" :selected="productThird==c.mainId" :value="c.mainId">{{c.name}}</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div v-show="use.length!=0" class="layui-inline">
                <label class="layui-form-label">症状描述</label>
                <div id="symptomDiv" style="float: right;width: 800px;">
                    <input v-for="(c,index) in use" class="symptom" type="checkbox" name="symptom" :value="c.mainId" :title="c.name">
                </div>

            </div>
        </div>
        <div class="layui-form-item">
            <div v-if="childCategory!=null&&childCategory.brand!=null"  class="layui-inline">
                <label class="layui-form-label">药品品牌</label>
                <div class="layui-input-inline">
                    <select class="brandCategory">
                        <option value="">请选择分类</option>
                        <option v-for="b in childCategory.brand" :selected="productBrand==b.mainId" :value="b.mainId">{{b.name}}</option>
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">药品剂型</label>
                <div class="layui-input-inline">
                    <select  class="formCategory">
                        <option value="">请选择分类</option>
                        <option v-for="c in form" :selected="productForm==c.mainId" :value="c.mainId">{{c.name}}</option>
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">主要原料</label>
                <div class="layui-input-inline">
                    <select class="materialCategory">
                        <option value="">请选择分类</option>
                        <option v-for="c in material" :selected="productMaterial==c.mainId" :value="c.mainId">{{c.name}}</option>
                    </select>
                </div>
            </div>
        </div>
        <button v-if="showRefresh" @click="getFirstCategory()" style="float: right;margin-bottom: 10px;" type="button" class="layui-btn layui-btn-normal">刷新</button>
    </div>
</fieldset>