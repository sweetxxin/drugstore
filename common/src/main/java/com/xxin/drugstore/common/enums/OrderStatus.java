package com.xxin.drugstore.common.enums;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/20 23:07
 * @Description
 */
public enum OrderStatus {
    CANCEL(-1,"已取消"),
    WAITING_PAY(0,"待支付"),
    WAITING_DEALING(1,"待处理"),
    DEALING(2,"揽件中"),
    TRANSPORTING(3,"运输中"),
    ARRIVE(4,"待收货"),
    RECEIVED(5,"待评论"),
    COMMENTED(6,"已完成");

    int code;
    String message;
    OrderStatus(int code,String message){
        this.code = code;
        this.message = message;
    }
    public int getCode() {
        return code;
    }
    public String getMessage(){
        return message;
    }
    public static OrderStatus getOrderStatus (int val) {
        for (OrderStatus type : OrderStatus .values()) {
            if (type.getCode() == val) {
                return type;
            }
        }
        return null;
    }
}
