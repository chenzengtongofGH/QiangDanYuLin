-- 需要跨平台支持的一些函数
-- ios:C++与Object-c混编
-- android:luaj
-- by wz 2015.6.17
local ANDROID_OS_CLASS = "org/cocos2dx/lua/OSInterface"
local pl_fun = {};
local luaj = nil;
if is_android() == true then
    luaj = require "cocos.cocos2d.luaj"
end

--[[
    des:    获取APP版本号
    return: 字符串
--]]
function pl_fun.get_package_version()
    local version_str = "";
	if  is_android() == true then        
        local ok, str = luaj.callStaticMethod(ANDROID_OS_CLASS, "GetPackageVersion", {},"()Ljava/lang/String;");
        version_str = str;
	elseif is_ios() == true then
	    version_str = COSInterface:getInstance():GetPackageVersion();
    else
        version_str = "1.0.0";
	end
    return version_str;
end

--[[
    des:    设置本地通知
    input:  idx 通知ID
            str 文字
            time 时间
--]]
function pl_fun.set_notifications(idx, str, time)
	if  is_android() == true then
	elseif is_ios() == true then		
    else
	end
end

--[[
    des: ios 删除通知
         android 删除定时器和通知
    input: idx 通知ID
--]]
function pl_fun.cancel_notifications(idx)
	if  is_android() == true then
	elseif is_ios() == true then		
    else
	end
end

--[[
    des:ios 清除角标
        android 删除消息列表中的消息
--]]
function pl_fun.clear_iconbadeg_number()
	if  is_android() == true then
	elseif is_ios() == true then		
    else
	end
end

--[[
    des:   ios 删除通知
           android 无
--]]
function pl_fun.clear_all_notifi()
	if  is_android() == true then
	elseif is_ios() == true then		
    else
	end
end

--[[
    des:得到引擎版本号
    return:int
--]]
function pl_fun.get_engine_version()

end 

--[[
    des:在应用内创建一个网页(唯一)
    input: url 网址
           x,y 坐标
           w,h 界面尺寸
--]]
function pl_fun.open_web_page(url, x, y, w, h)
	if  is_android() == true then
	elseif is_ios() == true then		
    else
	end
end

--[[
    des:关闭当前网页
--]]
function pl_fun.close_web_page()
    
end

--[[
    des:跳转到某个页面
    input: url 网址
--]]
function pl_fun.open_url(url)
	if  is_android() == true then
	elseif is_ios() == true then		
    else
	end
end

--[[
    des:获取贴图占用内存
    return: double
--]]
function pl_fun.get_used_texture_memory()
	if  is_android() == true then
	elseif is_ios() == true then		
    else
	end
end

--[[
    des: 获取设备名
    return: string
--]]
function pl_fun.get_device_modle()
    local modle_name = "";
 	if  is_android() == true then
        local ok, str = luaj.callStaticMethod(ANDROID_OS_CLASS, "GetDeviceModle", {},"()Ljava/lang/String;");
        modle_name = str;
	elseif is_ios() == true then
        modle_name = COSInterface:getInstance():GetDeviceModle();
    else
        modle_name = "PC";
	end   
    return modle_name;
end

--[[
    des: 获取设备系统版本号
    return: string
--]]
function pl_fun.get_device_sys_version()
    local sys_ver = "";
 	if  is_android() == true then
        local ok, str = luaj.callStaticMethod(ANDROID_OS_CLASS, "GetDeviceSysVersion", {},"()Ljava/lang/String;");
        sys_ver = str;        
	elseif is_ios() == true then
        sys_ver = COSInterface:getInstance():GetDeviceSysVersion();
    else
        sys_ver = "";
	end  
    return sys_ver; 
end


--[[ 
    des: 获取设备唯一ID
    return: string
--]]
function pl_fun.get_device_sole_id()
    local sole_id = "";
 	if is_android() == true then
        local ok, str = luaj.callStaticMethod(ANDROID_OS_CLASS, "GetDevicesSoleId", {},"()Ljava/lang/String;");
        sole_id = str;        
	elseif is_ios() == true then
        sole_id = COSInterface:getInstance():GetDevicesSoleId();
    else
        sole_id = COSInterface:getInstance():GetDevicesSoleId();
	end   
    return sole_id;
end

--[[
	des: 删除可写目录的文件夹
	input: path 需要删除的目录
]]
function pl_fun.remove_dir(path)
    local result = false;
    sg_log.info("remove dir:" .. path);
    if is_android() == true then
        local ok, suc = luaj.callStaticMethod(ANDROID_OS_CLASS, "deleteDir", { path }, "(Ljava/lang/String;)Z");
        result = suc;
    elseif is_ios() == true then
        result = COSInterface:getInstance():DeleteFolder(path);
    else
        result = COSInterface:getInstance():DeleteFolder(path);
    end
    sg_log.info("remove dir:" .. path .. " complete!");
    return result;
end

return pl_fun;


