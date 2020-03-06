<fieldset class="layui-elem-field">
    <legend>基本信息</legend>
    <div class="layui-field-box">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">商品名</label>
                <div class="layui-input-inline w350">
                    <input type="text" placeholder="必填" v-model="newProduct.name" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">关键词</label>
                <div class="layui-input-inline w350">
                    <input type="text" v-model="newProduct.keywords" class="layui-input">
                </div>
            </div>
        </div>

        <div v-if="isDetailPage" class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">商品编号</label>
                <div class="layui-input-inline">
                    <input type="text" disabled  v-model="newProduct.productNo" class="layui-input">
                </div>
            </div>
        </div>
        <div v-if="isDetailPage"  class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">创建人</label>
                <div class="layui-input-inline">
                    <input type="text" disabled
                           v-model="newProduct.creator==null?null:newProduct.creator.name"
                           class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">创建时间</label>
                <div class="layui-input-inline">
                    <input type="text" disabled v-model="newProduct.createTime" class="layui-input">
                </div>
            </div>
        </div>
        <div  v-if="isDetailPage" class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">审核人</label>
                <div class="layui-input-inline">
                    <input type="text" disabled
                           v-model="newProduct.checker==null?null:newProduct.checker.name"
                           class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">审核通过时间</label>
                <div class="layui-input-inline">
                    <input type="text" disabled v-model="newProduct.createTime" class="layui-input">
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">描述</label>
                <div class="layui-input-block w835">
                    <textarea placeholder="请输入内容" class="layui-textarea" style="min-height: 70px;" v-model="newProduct.description"></textarea>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">图片</label>
                <div class="layui-input-block w835">
                    <div v-show="showAddImg" class="layui-upload-drag w150"  id="addImg">
                        <i class="layui-icon"></i>
                        <p>点击添加，或将文件拖拽到此处</p>
                    </div>
                    <button v-show="showUploadAll" style="margin-bottom: 60px;margin-left: 20px;"  id="upload" type="button"
                                 class="layui-btn layui-btn-danger layui-btn-radius btn">全部上传
                    </button>
                    <div class="layui-upload-list" id="imgList">
                        <#if imgList??>
                            <#list imgList as img>
                                <div class="productImg"  id="upload-${img.mainId}">
                               <span @click="removeThis('${img.mainId}')" class="layui-badge img-delete">x</span>
                               <img  src="/resource/static${img.url}" class="layui-upload-img">
                                <#if img.isDefault??>
                                <#if (img.isDefault)!=1>
                                       <div onclick="setDefaultImg('${img.mainId}')"   style="text-align: center;cursor: pointer">设为封面</div>
                                    <#else>
                                        <div onclick="setDefaultImg('${img.mainId}')"  style="text-align: center;cursor: pointer">封面</div>
                                </#if>
                                    </#if>
                            </div>
                            </#list>
                        </#if>
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">推荐</label>
                <div class="layui-input-block">
                    <input lay-filter="switchCommend" v-model="newProduct.isCommend" type="checkbox" name="close" lay-skin="switch" lay-text="Yes|No">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">热门</label>
                <div class="layui-input-block">
                    <input lay-filter="switchHot" v-model="newProduct.isHot" type="checkbox" name="close" lay-skin="switch"
                           lay-text="Yes|No">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">最新</label>
                <div class="layui-input-block">
                    <input lay-filter="switchNew" v-model="newProduct.isNew" type="checkbox" name="close" lay-skin="switch"
                           lay-text="Yes|No">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">进口</label>
                <div class="layui-input-block">
                    <input lay-filter="switchImport" v-model="newProduct.isImport" type="checkbox" name="close" lay-skin="switch"
                           lay-text="Yes|No">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">上架</label>
                <div  class="layui-input-block">
                    <input lay-filter="switchShow"  v-model="newProduct.isShow" type="checkbox" lay-skin="switch"
                           lay-text="Yes|No">
                </div>
            </div>
        </div>
    </div>
</fieldset>