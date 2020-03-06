package com.xxin.drugstore.common.enums;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/27 20:07
 * @Description
 */
public enum CategoryType{
    FIRST_CATEGORY(1,"一级分类"),
    SECOND_CATEGORY(2,"二级分类"),
    THIRD_CATEGORY(3,"三级分类"),
    DRUG_FORM(10,"剂型"),
    MAIN_MATERIAL(20,"原料"),
    BRAND_NAME(1000,"品牌名称"),
    USE_WAY(30,"症状/用途");
    int code;
    String message;
    CategoryType(int code, String message){
        this.code = code;
        this.message = message;
    }
    public int getCode() {
        return code;
    }
    public String getMessage(){
        return message;
    }
    public static CategoryType getCategoryType (int val) {
        for (CategoryType type : CategoryType .values()) {
            if (type.getCode() == val) {
                return type;
            }
        }
        return null;
    }
}
