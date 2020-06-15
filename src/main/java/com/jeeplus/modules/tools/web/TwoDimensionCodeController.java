/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.tools.web;

import com.jeeplus.common.config.Global;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.common.utils.FileUtils;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.security.SystemAuthorizingRealm.Principal;
import com.jeeplus.modules.sys.service.SystemService;
import com.jeeplus.modules.sys.utils.UserUtils;
import com.jeeplus.modules.tools.utils.TwoDimensionCode;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;

/**
 * 二维码Controller
 *
 * @author jeeplus
 * @version 2015-11-30
 */
@Controller
@RequestMapping(value = "${adminPath}/tools/TwoDimensionCodeController")
public class TwoDimensionCodeController extends BaseController {

    @Autowired
    private SystemService systemService;

    /**
     * 二维码页面
     */
    @RequestMapping(value = {"index", ""})
    public String index() throws Exception {
        return "modules/tools/qrcode/TwoDimensionCode";
    }

    /**
     * 生成二维码
     *
     * @param args
     * @throws Exception
     */
    @RequestMapping(value = "createTwoDimensionCode")
    @ResponseBody
    public AjaxJson createTwoDimensionCode(HttpServletRequest request, String encoderContent) {
        AjaxJson j = new AjaxJson();
        Principal principal = UserUtils.getPrincipal();
        User user = UserUtils.getUser();
        if (principal == null) {
            j.setSuccess(false);
            j.setErrorCode("0");
            j.setMsg("没有登录");
        }
        String realPath = Global.getAttachmentDir() + "qrcode/";
        FileUtils.createDirectory(realPath);
        String name = "test.png"; //encoderImgId此处二维码的图片名
        try {
            String filePath = realPath + name;  //存放路径
            TwoDimensionCode.encoderQRCode(encoderContent, filePath, "png");//执行生成二维码
            user.setQrCode(Global.getAttachmentUrl() + "qrcode/" + name);
            systemService.updateUserInfo(user);
            j.setSuccess(true);
            j.setMsg("二维码生成成功");
            j.put("filePath", Global.getAttachmentUrl() + "qrcode/" + name);
        } catch (Exception e) {

        }
        return j;
    }

    /**
     * 生成二维码流
     *
     * @param args
     * @throws Exception
     */
    @RequestMapping(value = "createTwoDimensionCodeStream")
    public void createTwoDimensionCodeStream(@Param("url") String url, HttpServletRequest request, HttpServletResponse response) throws Exception {
        OutputStream out = null;
        try {
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Cache-Control", "no-cache");
            response.setDateHeader("Expires", 0);
            response.setContentType("image/jpeg");
            out = response.getOutputStream();
            TwoDimensionCode.encoderQRCode(url, out);//执行生成二维码
            out.flush();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (out != null) {
                try {
                    out.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 生成二维码流
     *
     * @param args
     * @throws Exception
     */
    @RequestMapping(value = "createTwoDimensionCodeStream2")
    public void createTwoDimensionCodeStream2(@Param("url") String url, HttpServletRequest request, HttpServletResponse response) throws Exception {
        OutputStream out = null;
        try {
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Cache-Control", "no-cache");
            response.setDateHeader("Expires", 0);
            response.setContentType("image/jpeg");
            out = response.getOutputStream();
            TwoDimensionCode.encoderQRCode2(url, out);//执行生成二维码
            out.flush();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (out != null) {
                try {
                    out.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

}