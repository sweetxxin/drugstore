package com.xxin.drugstore.user.controller;

import com.xxin.drugstore.common.entity.WebSetting;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.user.service.WebSettingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/29 16:47
 * @Description
 */
@RestController
public class WebSettingController {
    @Autowired
    private WebSettingService settingService;

    @GetMapping("/ad/rotation")
    public Message getRotationImg(){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(settingService.getRotationImg());
        return message;
    }
    @PostMapping("/ad/rotation/save")
    public Message saveRotationImg(@RequestBody List<WebSetting> settings){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(settingService.saveRotationImg(settings));
        message.setMessage("保存成功");
        return message;
    }
    @GetMapping("/ad/article")
    public Message getArticle(){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(settingService.getArticle());
        return message;
    }
    @PostMapping("/ad/article/update")
    public Message updateArticle(@RequestBody WebSetting webSetting){
        System.out.println(webSetting);
        Message message = new Message();
        message.setData(settingService.updateArticle(webSetting));
        message.setSuccess(true);
        return message;
    }
    @PostMapping("/ad/article/del")
    public Message delArticle(@RequestBody WebSetting webSetting){
        System.out.println(webSetting);
        Message message = new Message();
        settingService.delArticle(webSetting);
        message.setSuccess(true);
        return message;
    }
    @GetMapping("/against/all")
    public Message getAgainst(@RequestParam("index")Integer index,@RequestParam("size")Integer size){
        Message message = new Message();
        message.setSuccess(true);
        message.setData(settingService.getAgainst(index-1,size));
        return message;
    }
}
