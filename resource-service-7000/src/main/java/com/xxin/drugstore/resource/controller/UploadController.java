package com.xxin.drugstore.resource.controller;


import com.xxin.drugstore.resource.response.Message;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * @author xxin
 * @Created
 * @Date 2019/12/25 14:34
 * @Description
 */
@RestController
public class UploadController {
    private static final Logger LOGGER = LoggerFactory.getLogger(UploadController.class);

    @PostMapping("/upload")
    @ResponseBody
    public Message multiUpload(HttpServletRequest request) {
        List<MultipartFile> files = ((MultipartHttpServletRequest) request).getFiles("file");
        List<String> list = new ArrayList<>();
        Message message = new Message();
        for (int i = 0; i < files.size(); i++) {
            MultipartFile file = files.get(i);
            System.out.println("准备上传第"+(i+1)+"个文件");
            if (!file.isEmpty()){
                String orgName = file.getOriginalFilename();
                String suffixName = orgName.substring(orgName.lastIndexOf("."));
                String fileName= UUID.randomUUID() +suffixName;
                try {
                    File destFile=new File(ResourceUtils.getURL("classpath:").getPath());
                    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                    String date = df.format(new Date());
                    if(destFile.exists()){
                        File upload=new File(destFile.getAbsolutePath()+"/static/upload",date);
                        if(!upload.exists()){
                            upload.mkdirs();
                        }
                        System.out.println("file path=>"+upload.getAbsolutePath());
                        file.transferTo(new File(upload.getAbsolutePath(),fileName));
                    }
                    list.add("/upload/"+date+"/"+fileName);
                    LOGGER.info(orgName+"==>文件上传成功");
                } catch (Exception e) {
                    LOGGER.error(e.toString(), e);
                    message.setMessage("上传" + orgName + "文件失败");
                }
            }
        }
        message.setSuccess(true);
        message.setData(list);
        return message;
    }
}
