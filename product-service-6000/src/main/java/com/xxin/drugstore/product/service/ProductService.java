package com.xxin.drugstore.product.service;

import com.xxin.drugstore.common.entity.*;
import com.xxin.drugstore.common.enums.OrderStatus;
import com.xxin.drugstore.product.repository.*;
import org.bouncycastle.util.Integers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import java.math.BigInteger;
import java.util.*;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/1 15:04
 * @Description
 */
@Service
public class ProductService {
    @Autowired
    private ProductRepository productRepository;
    @Autowired
    private SkuRepository skuRepository;
    @Autowired
    private FactoryRepository factoryRepository;
    @Autowired
    private CategoryProductRepository categoryProductRepository;
    @Autowired
    private ImgRepository imgRepository;
    @PersistenceContext
    private EntityManager entityManager;
    @Autowired
    private OrderProductRepository orderProductRepository;
    @Autowired
    private OrderRepository orderRepository;


    public Page<Product> getProductByShop(Shop shop,Integer display ,int index, int size, String search){
        Pageable page = PageRequest.of(index,size,Sort.by("createTime").descending());
        Page<Product> products = productRepository.getProductByShopAndIsShowEquals(shop, display, page);
        for (Product product : products) {

        }
        return products;
    }
    public List<Sku> getSkuByProductId(String id){
        Product product = new Product();
        product.setMainId(id);
        return skuRepository.getSkuByProduct(product);
    }
    public Page<Product> getProduct(Product product,Integer index,Integer size){
        Example<Product>example = Example.of(product);
        Page<Product> products =  productRepository.findAll(example,PageRequest.of(index,size,Sort.by("createTime").descending()));
        return products;
    }
    public  Page<Product> searchProduct(HashMap<String,Object> param,Integer index,Integer size){
        StringBuffer sql = initSearchSql();
        if (param!=null){
            if (param.get("category")!=null||param.get("symptom")!=null||param.get("form")!=null){
                sql.append("and(b.product_id = some(select e.product_id from(");
                sql.append("select d.product_id");
                sql = parseParam(param,sql ,"category");
                sql = parseParam(param,sql ,"symptom" );
                sql = parseParam(param,sql ,"form");
                sql.append(" from d_category_product d group by d.product_id) e");
                sql.append(" where ");
                sql = setWhereCondition(sql, param,"category","and");
                sql = setWhereCondition(sql, param,"symptom","or");
                sql = setWhereCondition(sql, param,"form","or");
                sql.append("))");

            }
        }
            if (param.get("keyword")!=null){//搜索关键字
                sql.append("and (a.keywords like '%"+param.get("keyword")+"%' or a.`name` LIKE '%"+param.get("keyword")+"%' or a.description like '%"+param.get("keyword")+"%' or a.type like '%"+param.get("keyword")+"%' or a.origin_place like '%"+param.get("keyword")+"%' or a.use_way like '%"+param.get("keyword")+"%' or b.packing like '%"+param.get("keyword")+"%' or b.sku_name like '%"+param.get("keyword")+"%' or b.sale_way like '%"+param.get("keyword")+"%')");
            }
            if (param.get("productType")!=null){//商品类型
                sql.append("and(a.type='"+param.get("productType")+"')");
            }
            if (param.get("useWay")!=null){//商品用途
                sql.append("and(a.use_way='"+param.get("useWay")+"')");
            }
            if (param.get("orderBy")!=null){//排序
                switch (param.get("orderBy").toString()){
                    case "skuPrice":sql.append("order by a.default_price desc");break;
                    case "isNew":sql.append("order by a.is_new desc");break;
                }
            }
        System.out.println("查询的sql=="+sql);
        //创建本地sql查询实例
        Query dataQuery = entityManager.createNativeQuery(sql.toString(), Product.class);
        List<Product> resultList = dataQuery.getResultList();
        int total = resultList.size();
        dataQuery.setFirstResult(index*size);
        dataQuery.setMaxResults(size);
        resultList = dataQuery.getResultList();

        for (Product product : resultList) {
            long sale = orderProductRepository.countSaleByProductId(product.getMainId());
            product.setSales(sale);
        }
        if (param.get("orderBy")!=null&&param.get("orderBy").equals("sale")){
            Collections.sort(resultList,(r1,r2)->{
                return (int)(r2.getSales()-r1.getSales());
            });
        }

        Pageable pageable = PageRequest.of(index,size);
        return new PageImpl<>(resultList,pageable, total);
    }

    private StringBuffer initSearchSql(){
        StringBuffer sql = new StringBuffer();
        sql.append("select DISTINCT a.* from d_product a left join d_sku b on a.main_id = b.product_id left join d_category_product c on a.main_id = c.product_id where a.is_show=1 ");
        return sql;
    }
    private StringBuffer parseParam(HashMap<String,Object> param,StringBuffer sql,String key ){
        if (param!=null) {
            if (param.get(key) != null) {//添加分类
                List<Integer> c = (List<Integer>) param.get(key);
                if (c.size() > 0) {
                    for (int i = 0; i < c.size(); i++) {
                        sql.append(",sum(if(d.`category_id`=" + c.get(i) + ",d.category_id,0))`" + c.get(i) + "`");
                    }
                }
            }
        }
        return sql;
    }
    private StringBuffer setWhereCondition(StringBuffer sql,HashMap<String,Object> param,String key,String andOr){
        if (param.get(key)!=null){
            List<Integer> c = (List<Integer>) param.get(key);
            if (c.size()>0){
                if (sql.toString().endsWith(" where ")){
                    sql.append("(");
                }else{
                    sql.append(" and(");
                }
                for (int i = 0; i < c.size(); i++) {
                    sql.append("e.`"+c.get(i)+"`!=0");
                    if (i!=c.size()-1){
                        sql.append(" "+andOr+" ");
                    }
                }
                sql.append(")");
            }
        }
        return sql;
    }

    public Product updateProductInfo(Product product){
        return productRepository.save(product);
    }

    @Transactional
    public Product createProduct(Product product, Factory factory, List<Sku> skus, Map<String,String> category,List<String>symptom, Collection<Map<String,Object>> productImg, String shopId, String uid){
        //1.存储生产信息
        factory = factoryRepository.save(factory);
      //2.存储产品信息
        product.setFactory(factory);
//        product.setFactoryId(factory.getMainId());
        product.setProductNo(productRepository.getNextProductNo());
        Shop shop = new Shop();
        shop.setMainId(shopId);
        product.setShop(shop);
        User user = new User();
        user.setMainId(uid);
        product.setCreator(user);
        product = productRepository.save(product);
     //3.存储库存规格
        if (skus!=null){
            for (Sku sku : skus) {
                if (sku.getMainId()==null){
                    sku.setSkuNo(skuRepository.getNextSkuNo());
                    sku.setProduct(product);
                    if (sku.getIsDefault()==1){
                        product.setDefaultPrice(sku.getSkuPrice());//设置默认价格
                    }
                }
                skuRepository.save(sku);
            }
        }
        categoryProductRepository.deleteByProductId(product.getMainId());
     //4.存储分类信息
        Collection<String> values = category.values();
        for (String value : values) {
            if (value!=null&&!value.equals("")){
//                CategoryProduct c = categoryProductRepository.getByProductIdAndCategoryId(product.getMainId(), Integer.valueOf(value));
//                if (c==null){
                    CategoryProduct categoryProduct = new CategoryProduct();
                    categoryProduct.setProductId(product.getMainId());
                    categoryProduct.setCategoryId(Integer.valueOf(value));
                    categoryProductRepository.save(categoryProduct);
//                }
            }
        }
        for (String s : symptom) {//症状分类
//            CategoryProduct c = categoryProductRepository.getByProductIdAndCategoryId(product.getMainId(), Integer.valueOf(s));
//            if (c==null){
                CategoryProduct categoryProduct = new CategoryProduct();
                categoryProduct.setProductId(product.getMainId());
                categoryProduct.setCategoryId(Integer.valueOf(s));
                categoryProductRepository.save(categoryProduct);
//            }
        }
        imgRepository.deleteByItemIdAndType(product.getMainId(),1);
        //5.存储展示图片
        for (Map<String,Object> s : productImg) {
//            Img i = imgRepository.getByItemIdAndUrl(product.getMainId(), s.get("url").toString());
//            if (i==null){
                Img img = new Img();
                img.setItemId(product.getMainId());
                img.setUrl(s.get("url").toString());
                img.setType(1);
                img.setIsDefault(Integer.parseInt(s.get("isDefault").toString()));
                if (img.getIsDefault()==1){
                    product.setDefaultImg(img.getUrl());//设置默认图片
                }else {
                    img.setIsDefault(0);
                }
                imgRepository.save(img);
//            }
        }
        return productRepository.save(product);
    }

    public List<Sku> searchProductSku(HashMap<String,Object> param){
        List<Sku> skus = skuRepository.searchProductSku(param.get("keyword").toString());
        for (Sku sku : skus) {
            sku.setStock(orderProductRepository.sumStock(param.get("shopId").toString(),sku.getMainId()));
        }
        return skus;
    }
    @Transactional
    public Order addSku(String skuId,String uid,String shopId,Integer num){
        Order order = new Order();
        order.setShortIn("增加库存");
        order.setType(0);
        Shop shop = new Shop();
        shop.setMainId(shopId);
        order.setShop(shop);
        User user = new User();
        user.setMainId(uid);
        order.setUser(user);
        order = orderRepository.save(order);
        OrderProduct product = new OrderProduct();
        Sku sku = new Sku();
        sku.setMainId(skuId);
        product.setSku(sku);
        product.setOrderId(order.getMainId());
        product.setShopId(shopId);
        product.setAmount(num);
        product.setType(0);
        orderProductRepository.save(product);
        return order;
    }
}
