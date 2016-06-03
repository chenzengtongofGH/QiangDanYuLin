-- ��Ҫ��ƽ̨֧�ֵ�һЩ����
-- ios:C++��Object-c���
-- android:luaj
-- by wz 2015.6.17
local ANDROID_OS_CLASS = "org/cocos2dx/lua/OSInterface"
local pl_fun = {};
local luaj = nil;
if is_android() == true then
    luaj = require "cocos.cocos2d.luaj"
end

--[[
    des:    ��ȡAPP�汾��
    return: �ַ���
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
    des:    ���ñ���֪ͨ
    input:  idx ֪ͨID
            str ����
            time ʱ��
--]]
function pl_fun.set_notifications(idx, str, time)
	if  is_android() == true then
	elseif is_ios() == true then		
    else
	end
end

--[[
    des: ios ɾ��֪ͨ
         android ɾ����ʱ����֪ͨ
    input: idx ֪ͨID
--]]
function pl_fun.cancel_notifications(idx)
	if  is_android() == true then
	elseif is_ios() == true then		
    else
	end
end

--[[
    des:ios ����Ǳ�
        android ɾ����Ϣ�б��е���Ϣ
--]]
function pl_fun.clear_iconbadeg_number()
	if  is_android() == true then
	elseif is_ios() == true then		
    else
	end
end

--[[
    des:   ios ɾ��֪ͨ
           android ��
--]]
function pl_fun.clear_all_notifi()
	if  is_android() == true then
	elseif is_ios() == true then		
    else
	end
end

--[[
    des:�õ�����汾��
    return:int
--]]
function pl_fun.get_engine_version()

end 

--[[
    des:��Ӧ���ڴ���һ����ҳ(Ψһ)
    input: url ��ַ
           x,y ����
           w,h ����ߴ�
--]]
function pl_fun.open_web_page(url, x, y, w, h)
	if  is_android() == true then
	elseif is_ios() == true then		
    else
	end
end

--[[
    des:�رյ�ǰ��ҳ
--]]
function pl_fun.close_web_page()
    
end

--[[
    des:��ת��ĳ��ҳ��
    input: url ��ַ
--]]
function pl_fun.open_url(url)
	if  is_android() == true then
	elseif is_ios() == true then		
    else
	end
end

--[[
    des:��ȡ��ͼռ���ڴ�
    return: double
--]]
function pl_fun.get_used_texture_memory()
	if  is_android() == true then
	elseif is_ios() == true then		
    else
	end
end

--[[
    des: ��ȡ�豸��
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
    des: ��ȡ�豸ϵͳ�汾��
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
    des: ��ȡ�豸ΨһID
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
	des: ɾ����дĿ¼���ļ���
	input: path ��Ҫɾ����Ŀ¼
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


