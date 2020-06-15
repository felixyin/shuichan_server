package com.jeeplus.modules.sys.web;


import com.google.common.collect.Lists;
import com.jeeplus.common.config.Global;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.common.utils.FileUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.modules.sys.entity.*;
import com.jeeplus.modules.sys.mapper.UserMapper;
import com.jeeplus.modules.sys.service.AreaService;
import com.jeeplus.modules.sys.service.OfficeService;
import com.jeeplus.modules.sys.service.SystemConfigService;
import com.jeeplus.modules.sys.service.SystemService;
import com.jeeplus.modules.sys.utils.UserUtils;
import com.jeeplus.modules.tools.utils.TwoDimensionCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;

/**
 * 用户Controller
 *
 * @author jeeplus
 * @version 2016-8-29
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/register")
public class RegisterController extends BaseController {


    @Resource
    private AreaService areaService;

    @Autowired
    private SystemConfigService systemConfigService;

    @Autowired
    private SystemService systemService;

    @Autowired
    private OfficeService officeService;

    @Autowired
    private UserMapper userMapper;

    @ModelAttribute
    public User get(@RequestParam(required = false) String id) {
        if (StringUtils.isNotBlank(id)) {
            return systemService.getUser(id);
        } else {
            return new User();
        }
    }


    @RequestMapping(value = {"index", ""})
    public String register(User user, Model model) {
        return "modules/sys/login/sysRegister";
    }

    @RequestMapping(value = "registerUser")
    public String registerUser(HttpServletRequest request, HttpServletResponse response, boolean mobileLogin, String randomCode, String factoryName, String roleName, User user, Model model, RedirectAttributes redirectAttributes) {


        //验证手机号是否已经注册

        if (userMapper.findUniqueByProperty("mobile", user.getMobile()) != null) {
            // 如果是手机登录，则返回JSON字符串
            if (mobileLogin) {
                AjaxJson j = new AjaxJson();
                j.setSuccess(false);
                j.setErrorCode("1");
                j.setMsg("手机号已经被使用！");
                return renderString(response, j.getJsonStr());
            } else {
                addMessage(model, "手机号已经被使用!");
                return register(user, model);
            }
        }

        //验证用户是否已经注册
        if (userMapper.findUniqueByProperty("login_name", user.getLoginName()) != null) {
            // 如果是手机登录，则返回JSON字符串
            if (mobileLogin) {
                AjaxJson j = new AjaxJson();
                j.setSuccess(false);
                j.setErrorCode("2");
                j.setMsg("用户名已经被注册！");
                return renderString(response, j.getJsonStr());
            } else {
                addMessage(model, "用户名已经被注册!");
                return register(user, model);
            }
        }

        //验证短信内容
    /*    if (!randomCode.equals(request.getSession().getServletContext().getAttribute(user.getMobile()))) {
            // 如果是手机登录，则返回JSON字符串
            if (mobileLogin) {
                AjaxJson j = new AjaxJson();
                j.setSuccess(false);
                j.setErrorCode("3");
                j.setMsg("手机验证码不正确!");
                return renderString(response, j.getJsonStr());
            } else {
                addMessage(model, "手机验证码不正确!");
                return register(user, model);
            }
        }*/


        // 修正引用赋值问题，不知道为何，Company和Office引用的一个实例地址，修改了一个，另外一个跟着修改。
//        String officeCode = "1000";
//        if (roleName.equals("patient")) {
//            officeCode = "1001";
//        }
        Office office = officeService.findUniqueByProperty("name", factoryName);
        if (null != office && StringUtils.isNotBlank(office.getId())) {
            addMessage(model, "注册用户'" + user.getLoginName() + "'失败，工厂已存在");
            return register(user, model);
        } else {
            office = new Office();
            Area area = areaService.get("a9beb8c645ff448d89e71f96dc97bc09");//  中国根节点
            office.setArea(area);

            Office parentOffice = officeService.get("9330c28235614c8eb5ed146486612a07");// 水产加工厂分类 id
//            if (office.getParent() == null || office.getParent().getId() == null) {
//                office.setParent(parentOffice);
//            }

            office.setParent(parentOffice);
//            if (office.getArea() == null) {
//                office.setArea(user.getOffice().getArea());
//            }
            // 自动获取排序号
            if (StringUtils.isBlank(office.getId()) && office.getParent() != null) {
                int size = 0;
                List<Office> list = officeService.findAll();
                for (int i = 0; i < list.size(); i++) {
                    Office e = list.get(i);
                    if (e.getParent() != null && e.getParent().getId() != null
                            && e.getParent().getId().equals(office.getParent().getId())) {
                        size++;
                    }
                }
                office.setCode(office.getParent().getCode() + StringUtils.leftPad(String.valueOf(size > 0 ? size + 1 : 1), 3, "0"));
            }
            office.setName(factoryName);
            office.setGrade("3");
            office.setUseable("1");
            office.setType("1");

            User adminUser = userMapper.findUniqueByProperty("login_name", "admin");
            office.setCreateBy(adminUser);
            final Date updateDate = new Date();
            office.setCreateDate(updateDate);
            office.setUpdateBy(adminUser);
            office.setUpdateDate(updateDate);
            office.setRemarks("用户自己注册");
            officeService.save(office);
        }

//        Office office = officeService.getByCode(officeCode);
        // 密码MD5加密
        user.setPassword(SystemService.entryptPassword(user.getPassword()));
        if (systemService.getUserByLoginName(user.getLoginName()) != null) {
            addMessage(model, "注册用户'" + user.getLoginName() + "'失败，用户名已存在");
            return register(user, model);
        }

        Role role = systemService.getRole("caacf61017114120bcf7bf1049b6d4c3"); //  水产加工厂管理员角色

        // 角色数据有效性验证，过滤不在授权内的角色
        List<Role> roleList = Lists.newArrayList();
        roleList.add(role);
        user.setRoleList(roleList);
        //保存机构
        user.setCompany(office);
        user.setOffice(office);
        //生成用户二维码，使用登录名
        String realPath = Global.getAttachmentDir() + "qrcode/";
        FileUtils.createDirectory(realPath);
        String name = user.getId() + ".png"; //encoderImgId此处二维码的图片名
        String filePath = realPath + name;  //存放路径
        TwoDimensionCode.encoderQRCode(user.getLoginName(), filePath, "png");//执行生成二维码
        user.setQrCode(Global.getAttachmentUrl() + "qrcode/" + name);
        // 保存用户信息
        systemService.saveUser(user);
        // 清除当前用户缓存
        if (user.getLoginName().equals(UserUtils.getUser().getLoginName())) {
            UserUtils.clearCache();
            //UserUtils.getCacheMap().clear();
        }
        request.getSession().getServletContext().removeAttribute(user.getMobile());//清除验证码

        // 如果是手机登录，则返回JSON字符串
        if (mobileLogin) {
            AjaxJson j = new AjaxJson();
            j.setSuccess(true);
            j.setMsg("注册用户'" + user.getLoginName() + "'成功");
            return renderString(response, j);
        }


        addMessage(redirectAttributes, "注册用户'" + user.getLoginName() + "'成功");
        return "redirect:" + adminPath + "/login";
    }


    /**
     * 获取验证码
     *
     * @param request
     * @param response
     * @param mobile
     * @param model
     * @return
     */
    @RequestMapping(value = "getRegisterCode")
    @ResponseBody
    public AjaxJson getRegisterCode(HttpServletRequest request, HttpServletResponse response, String mobile,
                                    Model model) {

        SystemConfig config = systemConfigService.get("1");

        AjaxJson j = new AjaxJson();

        //验证手机号是否已经注册
        if (userMapper.findUniqueByProperty("mobile", mobile) != null) {

            j.setSuccess(false);
            j.setErrorCode("1");
            j.setMsg("手机号已经被使用！");
            return j;
        }

        String randomCode = String.valueOf((int) (Math.random() * 9000 + 1000));
        try {
            String result = UserUtils.sendRandomCode(config.getSmsName(), config.getSmsPassword(), mobile, randomCode);
            if (!"100".equals(result)) {
                j.setSuccess(false);
                j.setErrorCode("2");
                j.setMsg("短信发送失败，错误代码：" + result + "，请联系管理员。");
            } else {
                j.setSuccess(true);
                j.setErrorCode("-1");
                j.setMsg("短信发送成功!");
                request.getSession().getServletContext().setAttribute(mobile, randomCode);
            }
        } catch (IOException e) {
            j.setSuccess(false);
            j.setErrorCode("3");
            j.setMsg("因未知原因导致短信发送失败，请联系管理员。");
        }
        return j;
    }


    /**
     * web端ajax验证手机验证码是否正确
     */
    @ResponseBody
    @RequestMapping(value = "validateMobileCode")
    public boolean validateMobileCode(HttpServletRequest request,
                                      String mobile, String randomCode) {
        return randomCode.equals(request.getSession().getServletContext().getAttribute(mobile));
    }


}
