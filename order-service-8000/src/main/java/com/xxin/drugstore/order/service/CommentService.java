package com.xxin.drugstore.order.service;

import com.xxin.drugstore.common.entity.*;
import com.xxin.drugstore.common.enums.OrderStatus;
import com.xxin.drugstore.order.repository.*;
import lombok.experimental.PackagePrivate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * @author xxin
 * @Created
 * @Date 2020/2/20 20:58
 * @Description 待优化
 */
@Service
public class CommentService {
    @Autowired
    private OrderRepository orderRepository;
    @Autowired
    private AssessmentRepository assessmentRepository;
    @Autowired
    private ImgRepository imgRepository;
    @Autowired
    private UserEventRepository eventRepository;
    @Autowired
    private InformRepository informRepository;
    @Transactional
    public Assessment commentOrder(Assessment assessment){
        List<Img> files = assessment.getFiles();
        assessment.setIsShow(1);
        Assessment res = assessmentRepository.save(assessment);
        for (Img file : files) {
            file.setItemId(res.getMainId());

            imgRepository.save(file);
        }
        Order order = orderRepository.getOne(assessment.getOrder().getMainId());
        System.out.println(order);
        order.setCode(OrderStatus.COMMENTED.getCode());
        order.setStatus("已评论");
        order.setFinishTime(new Date());
        orderRepository.save(order);
        Inform inform = new Inform();
        inform.setCreator(order.getUser());
        inform.setUserId(order.getShop().getMainId());
        inform.setTitle("订单评论");
        inform.setOutline("订单评论");
        inform.setContent(assessment.getMsg());
        informRepository.save(inform);
        return res;
    }

    public Page<Assessment> getAssessmentByProductId(String productId,Integer index,Integer size,User user){
        Page<Assessment> page = assessmentRepository.getByProductId(productId, PageRequest.of(index, size, Sort.by("create_time").descending()));
        for (Assessment assessment : page.getContent()) {
            assessment.setImg(imgRepository.getByItemId(assessment.getMainId()));
            assessment.setGood(eventRepository.countByTypeAndItemId(1,assessment.getMainId()));
            assessment.setReply(eventRepository.countByTypeAndItemId(2, assessment.getMainId()));
            assessment.setAgainst(eventRepository.countByTypeAndItemId(3, assessment.getMainId()));
            assessment.setGiveAgainst(eventRepository.countByTypeAndItemIdAndUser(3,assessment.getMainId() , user)>0);
            assessment.setGiveGood(eventRepository.countByTypeAndItemIdAndUser(1,assessment.getMainId(),user)>0);
        }
        return page;
    }

    public Page<Assessment> getAssessmentByUser(User user,Integer index,Integer size){
        Page<Assessment> page =assessmentRepository.getByCreator(user, PageRequest.of(index, size,Sort.by("createTime").descending()));
        for (Assessment assessment : page.getContent()) {
            assessment.setImg(imgRepository.getByItemId(assessment.getMainId()));
            assessment.setGood(eventRepository.countByTypeAndItemId(1,assessment.getMainId()));
            assessment.setReply(eventRepository.countByTypeAndItemId(2, assessment.getMainId()));
            assessment.setAgainst(eventRepository.countByTypeAndItemId(3, assessment.getMainId()));
        }
        return page;
    }
    public Assessment getAssessmentByOrder(Order order){
        Assessment byOrder = assessmentRepository.getByOrder(order);
        if(byOrder==null)return null;
        byOrder.setImg(imgRepository.getByItemId(byOrder.getMainId()));
        return byOrder;
    }
}
