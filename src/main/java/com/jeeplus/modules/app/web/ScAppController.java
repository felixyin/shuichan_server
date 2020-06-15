/**
 * Copyright &copy; 2015-2020 <a href="http://www.qdbak.com/">青岛佰安客科技有限公司</a> All rights reserved.
 */
package com.jeeplus.modules.app.web;

import com.jeeplus.common.config.Global;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.utils.FileUtils;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.modules.app.service.ScAppService;
import com.jeeplus.modules.setting.entity.ScSetting;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 手机接口 Controller
 *
 * @author 尹彬
 * @version 2019-09-09
 */
@Controller
@RequestMapping(value = "${adminPath}/app")
public class ScAppController extends BaseController {

    @Resource
    private ScAppService scAppService;

    /**
     * 获取app版本号
     *
     * @return
     */
    // {"status":200,"data":{"version":"0.0.2","name":"FlutterGo"},"success":true}
    @ResponseBody
    @RequestMapping(value = "getAppVersion")
    public Map<String, Object> getAppVersion(String appName, Model model) throws Exception {
        Map<String, Object> map = new HashMap<>();
        Map<String, String> data = new HashMap<>();
        map.put("data", data);
        map.put("status", 200);
        if ("BakApp".equalsIgnoreCase(appName)) {
            data.put("version", Global.getConfig("app.version"));
            data.put("url", Global.getConfig("app.android.url"));
            data.put("name", Global.getConfig("name"));
            map.put("success", true);
        } else {
            map.put("success", false);
        }
        return map;
    }

    /**
     * 获取app版本号
     *
     * @return
     */
    // {"status":200,"data":{"version":"0.0.2","name":"FlutterGo"},"success":true}
    @ResponseBody
    @RequestMapping(value = "checkLogin")
    public Map<String, Object> checkLogin(String appName, Model model) throws Exception {
        Map<String, Object> map = new HashMap<>();
        Map<String, String> data = new HashMap<>();
        map.put("data", data);
        map.put("status", 200);
        if ("BakApp".equalsIgnoreCase(appName)) {
            data.put("version", "1.0.4");
            data.put("name", "BakApp");
            map.put("success", true);
        } else {
            map.put("success", false);
        }
        return map;
    }

    /**
     * 获取用户信息
     *
     * @param model
     * @return
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "getUserInfo")
    public Map<String, Object> getUserInfo(Model model) throws Exception {
        Map<String, Object> map = new HashMap<>();
        User user = UserUtils.getUser();
        map.put("data", user);
        map.put("status", 200);
        map.put("success", true);
        return map;
    }

    /**
     * 保存用户信息
     *
     * @param model
     * @return
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "saveUserInfo")
    public Map<String, Object> saveUserInfo(/*String userJson,*/User user, Model model) throws Exception {
//        userJson = URLDecoder.decode(userJson, Charsets.UTF_8_NAME);
//        System.out.println(userJson);
//        User user = JsonMapper.getInstance().fromJson(userJson, User.class);
        boolean isSaved = scAppService.saveUserInfo(user);
        Map<String, Object> map = new HashMap<>();
        map.put("status", 200);
        map.put("success", isSaved);
        return map;
    }

    /**
     * 上传包装照片
     *
     * @return
     * @throws IOException
     * @throws IllegalStateException
     */
    @RequestMapping(value = "uploadPhoto")
    @ResponseBody
    public AjaxJson uploadPhoto(HttpServletRequest request, HttpServletResponse response, MultipartFile upload) throws IllegalStateException, IOException {
        AjaxJson j = new AjaxJson();
        User currentUser = UserUtils.getUser();
        // 判断文件是否为空
        logger.error("文件是否为空:" + upload.isEmpty());
        if (!upload.isEmpty()) {
            // 文件保存路径
            String config = Global.getConfig("userfiles.basedir");
            String imagePath = "/userfiles/photos/" + DateUtils.getDate() + "/" + currentUser.getCurrentUser().getLoginName();
            // 创建目录
            String descDirName = config + imagePath;
            FileUtils.createDirectory(descDirName);
            logger.error("创建目录：" + descDirName);
            // 文件相对位置
            String dbPath = imagePath + "/" + upload.getOriginalFilename();

            // 转存文件
            String toFileName = config + dbPath;
            File newFile = FileUtils.getAvailableFile(toFileName, 0);
            logger.error("文件保存位置：" + toFileName);
            upload.transferTo(newFile);

            // 存储图片地址到数据库，更新process字段为包装完毕
            String boxItemId = request.getParameter("boxItemId");
            scAppService.savePhotoInfo(boxItemId, dbPath);

            // 返回上传图片成功信息
            j.setSuccess(true);
            j.setMsg("照片上传成功");

//            map.put("id", newFile.getAbsolutePath());
//            map.put("value", newFile.getName());
//            map.put("type", FileUtils.getFileType(newFile.getName()));
        } else {
            // 返回失败信息
            j.setSuccess(false);
            j.setMsg("照片上传失败！");

        }
        return j;
    }


    /**
     * 包装人员当天代办任务列表查询
     */
    @ResponseBody
    @RequestMapping(value = "findTodoListForPackager")
    public Map<String, Object> findTodoListForPackager(Model model) throws Exception {
        Map<String, Object> map = new HashMap<>();
        List<Map<String, Object>> boxItemList = scAppService.findTodoListForPackager();
        map.put("data", boxItemList);
        map.put("status", 200);
        map.put("success", true);
        return map;
    }


    /**
     * 包装人员当天代办任务列表查询
     */
    @ResponseBody
    @RequestMapping(value = "findHistoryListForPackager")
    public Map<String, Object> findHistoryListForPackager(String historyDateStr, Model model) throws Exception {
        Map<String, Object> map = new HashMap<>();

        List<Map<String, Object>> boxItemList = scAppService.findHistoryListForPackager(historyDateStr);
        map.put("data", boxItemList);
        map.put("status", 200);
        map.put("success", true);
        return map;
    }


    /**
     * 快递人员当天代办任务列表查询
     */
    @ResponseBody
    @RequestMapping(value = "findTodoListForCourier")
    public Map<String, Object> findTodoListForCourier(String factoryId, Model model) throws Exception {
        Map<String, Object> map = new HashMap<>();
        List<Map<String, Object>> boxItemList = scAppService.findTodoListForCourier(factoryId);
        map.put("data", boxItemList);
        map.put("status", 200);
        map.put("success", true);
        return map;
    }


    /**
     * 快递人员当天代办任务列表查询
     */
    @ResponseBody
    @RequestMapping(value = "findHistoryListForCourier")
    public Map<String, Object> findHistoryListForCourier(String historyDateStr, String factoryId, Model model) throws Exception {
        Map<String, Object> map = new HashMap<>();
        List<Map<String, Object>> boxItemList = scAppService.findHistoryListForCourier(historyDateStr, factoryId);
        map.put("data", boxItemList);
        map.put("status", 200);
        map.put("success", true);
        return map;
    }

    /**
     * 查询所有工厂
     */
    @ResponseBody
    @RequestMapping(value = "findAllOffice")
    public Map<String, Object> findAllOffice(Model model) throws Exception {
        Map<String, Object> map = new HashMap<>();
        List<Map<String, String>> list = scAppService.findAllOffice();
        map.put("data", list);
        map.put("status", 200);
        map.put("success", true);
        return map;
    }

    /**
     * 查询用户设置
     */
    @ResponseBody
    @RequestMapping(value = "loadSetting")
    public Map<String, Object> loadSetting(Model model) throws Exception {
        Map<String, Object> map = new HashMap<>();
        ScSetting list = scAppService.loadSetting();
        map.put("body", list);
        map.put("status", 200);
        map.put("success", true);
        return map;
    }

    /**
     * 保存用户设置
     */
    @ResponseBody
    @RequestMapping(value = "saveSetting")
    public Map<String, Object> saveSetting(ScSetting setting, Model model) throws Exception {
        Map<String, Object> map = new HashMap<>();
        scAppService.saveSetting(setting);
        map.put("body", null);
        map.put("status", 200);
        map.put("success", true);
        return map;
    }

}