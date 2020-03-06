package com.xxin.drugstore.user.service;

import com.xxin.drugstore.common.entity.Assessment;
import com.xxin.drugstore.common.entity.Inform;
import com.xxin.drugstore.common.entity.User;
import com.xxin.drugstore.common.entity.UserEvent;
import com.xxin.drugstore.user.repository.AssessmentRepository;
import com.xxin.drugstore.user.repository.InformRepository;
import com.xxin.drugstore.user.repository.UserEventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/21 13:30
 * @Description
 */
@Service
public class UserEventService {
    @Autowired
    private UserEventRepository eventRepository;
    @Autowired
    private AssessmentRepository assessmentRepository;
    @Autowired
    private InformRepository informRepository;

    public UserEvent thumbUp(String uid,String itemId){
        UserEvent event = new UserEvent();
        User user = new User();
        user.setMainId(uid);
        event.setUser(user);
        event.setItemId(itemId);
        event.setType(1);
        Inform inform = new Inform();
        inform.setCreator(user);
        User u = assessmentRepository.getOne(itemId).getCreator();
        inform.setUserId( u.getMainId());
        inform.setTitle("评论点赞");
        inform.setOutline(u.getNickName()+"点赞了你的评论");
        inform.setContent(u.getNickName()+"点赞了你的评论");
        informRepository.save(inform);
        return eventRepository.save(event);
    }
    public void cancelThumbUp(String uid,String itemId){
        User user = new User();
        user.setMainId(uid);
        UserEvent byItemIdAndUserId = eventRepository.getByItemIdAndUserAndType(itemId, user,1);
        if (byItemIdAndUserId!=null)
        eventRepository.delete(byItemIdAndUserId);
    }
    public UserEvent against(String uid,String itemId,String content){
        UserEvent event = new UserEvent();
        User user = new User();
        user.setMainId(uid);
        event.setUser(user);
        event.setItemId(itemId);
        event.setType(3);
        event.setDetail(content);
        return eventRepository.save(event);
    }
    public UserEvent reply(String uid,String itemId,String content){
        UserEvent event = new UserEvent();
        User user = new User();
        user.setMainId(uid);
        event.setUser(user);
        event.setItemId(itemId);
        event.setType(2);
        event.setDetail(content);

        Inform inform = new Inform();
        inform.setCreator(user);
        User u = assessmentRepository.getOne(itemId).getCreator();
        inform.setUserId(u.getMainId());
        inform.setTitle("评论回复");
        inform.setOutline(u.getNickName()+"回复了你的评论");
        inform.setOutline(u.getNickName()+"回复评论："+content);
        informRepository.save(inform);
        return eventRepository.save(event);
    }

    public List<UserEvent> getReply(String id){
        return eventRepository.getByItemIdAndTypeOrderByCreateTimeDesc(id, 2);
    }

}
