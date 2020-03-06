package com.xxin.drugstore.common.enums;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/27 20:07
 * @Description
 */
public enum UserEventType {
    REPLY(2,"回复"),
    AGAINST(3,"举报"),
    THUMB_UP(1,"点赞");
    int code;
    String message;
    UserEventType(int code, String message){
        this.code = code;
        this.message = message;
    }
    public int getCode() {
        return code;
    }
    public String getMessage(){
        return message;
    }
}
