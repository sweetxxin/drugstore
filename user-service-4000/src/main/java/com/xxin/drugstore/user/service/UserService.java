package com.xxin.drugstore.user.service;

import com.xxin.drugstore.common.entity.Inform;
import com.xxin.drugstore.common.entity.ReadInform;
import com.xxin.drugstore.common.entity.User;
import com.xxin.drugstore.user.repository.InformRepository;
import com.xxin.drugstore.user.repository.ReadInformRepository;
import com.xxin.drugstore.user.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * @author xxin
 * @Created
 * @Date 2019/11/27 17:29
 * @Description
 */
@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private InformRepository informRepository;
    @Autowired
    private ReadInformRepository readInformRepository;

    public User getUserInfoByUserName(String username){
        return userRepository.getUserByUsername(username);
    }
    public User getUserInfoById(String id){
        Optional<User> user = userRepository.findById(id);
        return user.orElse(null);
    }
    public User updateUserInfo(User user){
        return userRepository.save(user);
    }
    public User createUser(User user){
        User u = userRepository.getUserByUsername(user.getUsername());
        if (u!=null){
            return null;
        }else{
            return userRepository.save(user);
        }
    }


    public Page<Inform> getNewInform(Integer index, Integer size, String uid){
        Page<Inform> newInform = informRepository.getNewInform(uid, PageRequest.of(index, size,Sort.by("createTime").descending()));
        return newInform;
    }
    public Page<Inform> getInform(Integer index, Integer size, String uid){
        return informRepository.getInform(uid,PageRequest.of(index, size, Sort.by("createTime").descending()));
    }
    public Page<Inform> getReadInform(Integer index, Integer size, String uid){
        Page<Inform> newInform = informRepository.getReadInform(uid, PageRequest.of(index, size,Sort.by("createTime").descending()));
        return newInform;
    }
    public Integer countNewInform(String uid){
        return informRepository.countNewInform(uid);
    }
    public Inform readInform(Inform inform){
        ReadInform byUserId = readInformRepository.getByUserIdAndInform(inform.getUserId(),inform);
        if (byUserId!=null){
            return inform;
        }else{
            ReadInform readInform = new ReadInform();
            readInform.setIsRead(1);
            readInform.setInform(inform);
            readInform.setUserId(inform.getUserId());
            readInformRepository.save(readInform);
            inform.setIsRead(1);
            inform.setReadTime(new Date());
            return inform;
        }
    }
    public User verifyInfo(String id,String name,String idNum){
        User user = userRepository.getOne(id);
        user.setName(name);
        user.setIdNum(idNum);
        user.setIsVerify(1);
        return userRepository.save(user);
    }
}
