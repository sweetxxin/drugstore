package com.xxin.drugstore.user.service;

import com.xxin.drugstore.common.entity.Assessment;
import com.xxin.drugstore.common.entity.UserEvent;
import com.xxin.drugstore.common.entity.WebSetting;
import com.xxin.drugstore.common.enums.UserEventType;
import com.xxin.drugstore.common.response.Message;
import com.xxin.drugstore.user.repository.AssessmentRepository;
import com.xxin.drugstore.user.repository.UserEventRepository;
import com.xxin.drugstore.user.repository.WebSettingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/29 16:49
 * @Description
 */
@Service
public class WebSettingService {
    @Autowired
    private WebSettingRepository settingRepository;
    @Autowired
    private UserEventRepository eventRepository;
    @Autowired
    private AssessmentRepository assessmentRepository;

    public List<WebSetting> getRotationImg(){
        return settingRepository.getByTypeOrderBySort(1);
    }
    public List<WebSetting> getArticle(){
        return settingRepository.getByTypeOrderBySort(2);
    }
    @Transactional
    public List<WebSetting> saveRotationImg(List<WebSetting> settings){
       settingRepository.deleteByType(1);
        return settingRepository.saveAll(settings);
    }
    public WebSetting updateArticle(WebSetting setting){
        return settingRepository.save(setting);
    }
    public void delArticle(WebSetting setting){
        settingRepository.delete(setting);
    }
    public Page<UserEvent> getAgainst(int index,int size){
        Page<UserEvent> byType = eventRepository.getByType(UserEventType.AGAINST.getCode(), PageRequest.of(index, size));
        for (UserEvent event : byType) {
            Assessment assessment = assessmentRepository.getOne(event.getItemId());
            System.out.println(assessment);
            event.setItem(assessment.getMsg());
        }
        return byType;
    }
}
