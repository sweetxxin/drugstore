package com.xxin.drugstore.product.repository;

import com.xxin.drugstore.common.entity.Categories;
import com.xxin.drugstore.product.service.CategoryService;
import org.junit.Test;
import org.junit.experimental.categories.Category;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.Assert.*;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/27 14:09
 * @Description
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class CategoryRepositoryTest {
 @Autowired
 private CategoryRepository categoryRepository;
 @Autowired
 private CategoryService service;

 @Test
 public void save(){
     String s =
             "白带量多 阴部瘙痒 月经不调 口干口苦 心悸失眠 产后体虚 眩晕头痛 乳汁不通 烦躁易怒 黄褐斑 畏寒肢冷 头晕头痛 乳腺红肿 乳房胀痛 乳房包块 行经后错 小腹冷痛 月经量少 白带异味 分泌物增多 乳腺发热 尿频尿痛 其它";
     String[] key = s.split(" ");
     int i = 1900;
         for (int j = 0; j < key.length; j++) {
             Categories categories = new Categories();
             categories.setParentId(109);
             categories.setName(key[j]);
             categories.setIsDisplay(1);
             categories.setMainId(++i);
             categories.setCode(30);
             categories.setType("症状/用途");
             categories = categoryRepository.saveAndFlush(categories);
     }
 }
 @Test
 public void save2(){
     String s = "美妆个护,家庭保健, 环境清洁,热门品牌";
     String[] array = new String[]{
             "洁面卸妆 沐浴露 爽肤水 乳液 精华 面膜 眼部护理 防晒 脱毛膏 身体乳霜 手足护理 私处护理 止汗除味 按摩护理 洗发护发 口腔护理 唇膏 祛痘除疤",
             "温灸艾柱 口罩防护 急救消毒 活络刮痧 便厕用具 助行拐杖 家庭药箱 护具绷带 健身测重 按摩器材 养生煎药 成人纸尿裤",
             "消毒液 洗手液 洗衣用品 花露水 湿巾 清洗剂",
             "森田面膜 片仔癀 薇婷 相宜本草 滴露 施巴 丝塔芙 曼秀雷敦 妮维雅 李医生 康如 怡思丁 云南白药 舒适达 高露洁 3M 喜辽复 妇炎洁 西尼 可孚"
     };
     int i=5001;
     String[] key = s.split(",");
     for (int j = 0; j < key.length; j++) {
         String[] ss = array[j].split(" ");
         for (int k = 0; k < ss.length; k++) {
             Categories cate = new Categories();
             cate.setName(ss[k]);
             cate.setIsDisplay(1);
             cate.setParentId(501+j);
             cate.setMainId(i++);
             categoryRepository.saveAndFlush(cate);
         }
     }
 }
 @Test
 public void get(){
     System.out.println(service.getAllCategoryByFirstId(1));
 }

 @Test
    public void save3(){
//     Categories categories = new Categories();
//     categories.setParentId(1);
//     categories.setName("热门品牌");
//     categories.setMainId(110);
//     categories.setIsDisplay(1);
//     categoryRepository.saveAndFlush(categories);

     String s = "江西汇仁 同仁堂 九芝堂 东阿阿胶 太极 白云山 999 仁和 爱乐维 斯利安 康王 钙尔奇 珍视明 辅舒良 朗迪 艾丽 雅塑 盘龙云海 马应龙 江中";
     String[] strings = s.split(" ");
     for (int i = 0; i < strings.length; i++) {
         Categories cate = new Categories();
         cate.setParentId(110);
         cate.setName(strings[i]);
         cate.setMainId(1071+i);
         cate.setIsDisplay(1);
         categoryRepository.saveAndFlush(cate);
     }
 }
}