-- sg_basefun.lua

-- des      :基础功能函数
-- author   :wz
-- data     :2015年1月8日

-- 重新加载Lua文件
function G_Reload(filename)
	if package.loaded[filename] ~= nil then
		package.loaded[filename] = nil;
	end
	return require(filename);
end

-- 判断C++对象是否存在
-- @object：UserData对象
function G_isUserDataValid(object)
	if object and not tolua.isnull(object) then
		return true
	end
end

--判断UserData的实际类型
function G_isKindOf(object,className)
	if type(object) == "userdata" then	
		return tolua.type(object) == className
	end
end

-- 将字符串转化为字符table
function string_to_table(str)
	local n = 1;
	local str_table = {};
	while(true) do
		n_pos = n;
		if  isChineseCh(str,n_pos) == 1 then
			n_pos = n + 2;
		end
		local s = string.sub(str,n,n_pos);
		table.insert(str_table, s);
		n = n_pos + 1;
		if n > string.len(str) then
			break;
		end
	end
	return str_table;
end

--数字转为空格
function G_number_to_space(num)
	local size = string.len(tostring(num))
	local str = ""
	for i=1,size*2 do
		str = str .. " "
	end
	return str
end

-- number to chinese
-- 按万取整，余数舍弃
function G_number_to_chinese(num)
    if num < 10000 then
        return tostring(num);
    else
        local n = math.modf(num / 10000);
        local s = n .. G_GetString("place5");
        return s;
    end
end

-- 平台判断
function is_win32()
	if device.platform == "windows" then
		return true;
	else
		return false;
	end
end
function is_ios()
	if device.platform == "ios" then
		return true;
	else
		return false;
	end
end
function is_android()
	if device.platform == "android" then
		return true;
	else
		return false;
	end
end

-- 获取系统时间(毫秒)
function g_gettime()
    return CBaseFun:getTime();
end

-- 按给定字符拆分字符串为table
function lua_string_split(str, split_char, tonum)    
	local strlen = string.len(str)
	local sublen = string.len(split_char)
	if string.sub(str,strlen-sublen,strlen) ~= split_char then
		str = str .. split_char
	end
	
	local sub_str_tab = {}
    for w in string.gmatch(str, "([^"..split_char.."]+)"..split_char) do
		if tonum then
			sub_str_tab[#sub_str_tab + 1] = tonumber(w);
		else
			sub_str_tab[#sub_str_tab + 1] = w;
		end
    end
	return sub_str_tab
end 

-- 合并两个表,忽略值相同的情况
function g_merge_two_table(a, b)
    local c = {};
    for k,v in pairs(a) do
        table.insert(c, v);
    end
    for k,v in pairs(b) do
        local bfind = false;
        for k1, v1 in pairs(c) do
            if v == v1 then
                bfind = true;
                break;
            end
        end
        if bfind == false then
            table.insert(c, v);
        end
    end
    return c;
end

-- lua table deep copy
function g_deep_copy_table(res_t)
    if type(res_t) ~= "table" then
        return nil;
    end
    local des_t = { };
    for k, v in pairs(res_t) do
        local v_type = type(v);
        if v_type == "table" then
            des_t[k] = g_deep_copy_table(v);
        else
            des_t[k] = v;
        end
    end
    return des_t;
end

--注册回调函数
function regFunction(fun)
	local a = CallFunManager:setFunction(fun)
	return a
end

--获取字符串的md5
function g_getmd5(k)
	local md5 = require "md5"
	k = md5.sum(k)
	return (string.gsub(k, ".", function (c)
		   return string.format("%02x", string.byte(c))
		 end))
end

function g_merge_table(...)
    local args = {...};
    local t = {};
    for k,v in pairs(args) do
        for k1,v1 in pairs(v) do
            table.insert(t, v1);
        end
    end
    return t;
end


function Format_time(second,format)
	if second == nil then
		return " ";
	end
	--最大到天
	local nSec = math.floor(math.mod(second,60));
	local nMin = math.floor(math.mod(second/60,60));
	local nHou = math.floor(math.mod(second/3600,24));
	local nDay = math.floor(second/3600/24);
	--指定字符串格式
	if format then
		local pos = string.find(format,"$d")
		local timestr=""
		if pos and nDay > 0 then
			timestr = timestr.. nDay..G_GetString("day")
		end
		if timestr =="" then
			nHou = math.floor(second/3600);
		end
		pos = string.find(format,"$h")
		if pos and nHou > 0 then
			
			timestr = timestr.. nHou..G_GetString("hour")
		end
		if timestr =="" then
			nMin = math.floor(second/60);
		end
		pos = string.find(format,"$m")
		if pos and nMin > 0 then
			
			timestr = timestr.. nMin..G_GetString("minute")
		end
		if timestr =="" then
			nMin = second
		end
		pos = string.find(format,"$s")
		if pos and nSec > 0 then
			
			timestr = timestr.. nSec..G_GetString("second")
		end
		return timestr
	end
	if nDay > 0 then
		return nDay..G_GetString("day")..nHou..G_GetString("hour");
	elseif nHou > 0 then
		return nHou..G_GetString("hour")..nMin..G_GetString("minute");
	elseif nMin > 0 then
		return nMin..G_GetString("minute")..nSec..G_GetString("second");
	else
		return nSec..G_GetString("second");
	end
end
function pattern_time(sec)  --获得00:00:00格式时间
	if not sec then
		return "00:00:00"
	end
	local hour,m = math.floor(sec/3600),math.mod(sec,3600)
	local minute,second = math.floor(m/60),math.mod(m,60)
	local n
	if(hour == 0) then
		n = string.format("%02d:%02d",minute,second)
	else
	    n = string.format("%02d:%02d:%02d",hour,minute,second)
	end
	return n
end
function get_pattern_hour_time(sec)
    if not sec then
		return 0
	end
    local hour = math.floor(sec/3600);
    return hour;
end
function pattern_timeAll(sec)  --获得00:00:00格式时间 固定小时未0时也显示00:01:50
	if not sec then
		return "00:00:00"
	end
	local hour,m = math.floor(sec/3600),math.mod(sec,3600)
	local minute,second = math.floor(m/60),math.mod(m,60)
	local n
	if(hour == 0) then
		n = string.format("%02d:%02d:%02d",0,minute,second)
	else
	    n = string.format("%02d:%02d:%02d",hour,minute,second)
	end
	return n
end
function dayhourminsec_time(sec)  --获得XX天00:00:00格式时间
	if not sec then
		return "00:00:00"
	end
	local nDay,remain = math.floor(sec/3600/24),math.mod(sec,3600*24)
	local n
	if nDay > 0 then
		n = nDay..G_GetString("day")..pattern_time(remain)
	else
		n = pattern_time(remain)
	end
	return n
end
function dayhourminName_time(sec)  --获得XX天00时00分 格式时间
	if not sec then
		return "00:00:00"
	end
	local nDay = math.floor(sec/3600/24)
	local nHour = math.floor((sec/3600/24-nDay)*24)
	local nMin = math.floor(((sec/3600/24-nDay)*24 - nHour)*60)
	local n
	if nDay < 10 and nDay > 0 then
		n = G_GetString("countdown").." "..nDay..G_GetString("day")..nHour..G_GetString("hour2")..nMin..G_GetString("minute2")
	elseif nDay == 0 then
		n = G_GetString("countdown").." 0"..G_GetString("day")..nHour..G_GetString("hour2")..nMin..G_GetString("minute2")
	elseif nDay >= 10 then
		n = G_GetString("countdown")..nDay..G_GetString("day")..nHour..G_GetString("hour2")..nMin..G_GetString("minute2")
	end
	return n
end
--星期转换 1~7对应 周日周一...~周六
function severtime_weekday_chinaday(day) 
    if day == 1 then
        day = 7
    elseif day == 7 then
        day = 6
    else
        day = day - 1
    end
    return day
end

function number_to_string(num, len)
    num  = math.floor(num);
    local s = tostring(num);
    
    local dl = len - string.len(s);
    if dl > 0 then
        for i=1, dl do
            s = 0 .. s;
        end
    end
    return s;
end


function did_enter_background()
    EventSystem:pushEvent("EVENT_PAUSE");
	ccexp.AudioEngine:pauseAll()
end

function will_enter_foreground()
	ccexp.AudioEngine:resumeAll()
end

local RESIDENT_LUA = {
	["json"] = 1,
	["jit.util"] = 1,
	["jit"] = 1,
	["socket.socket"] = 1,
    ["table"] = 1,
	["string"] = 1,
	["os"] = 1,
	["coroutine"] = 1,
	["bit"] = 1,
	["lpeg"] = 1,
	["math"] = 1,
	["debug"] = 1,
	["crypt"] = 1,
};

function IsResidentLua(file)
	if RESIDENT_LUA[file] then
		return true
	end
	return false;
end

function G_ReleaseLua()
	for k,v in pairs(package.loaded) do
		--print(k)
		if IsResidentLua(k) == false then
			package.loaded[k] = nil;
		end
	end
end

local RELOAD_LUA = {
	"skygame.sg_resources",
}
-- 一些需要强制重新加载的文件在这里添加
function G_ReloadLua()
	for i=1,#RELOAD_LUA do
		require(RELOAD_LUA[i])
	end
end

function G_ReleaseObject()
	local gScheduler = require("skygame.scheduler")
	gScheduler.unscheduleAllGlobal()
	EventSystem:release()	
end

function G_ReleaseNetWork()
	local socket = require("socket.socket")
	socket:disconnect();
	--EventSystem:pushEvent("EVENT_RELEASE_NETWORK")
end

function G_log_out()
	--EventSystem:pushEvent("EVENT_LOG_OUT")
	G_ReleaseNetWork()
	G_ReleaseObject()
	G_ReleaseLua()
	G_ReleaseShader()
end

function g_get_sub_table(t, idx_1, idx_2)
    local sub = {};
    idx_1 = idx_1 or 1;
    idx_2 = idx_2 or #t;
    local s_idx = math.max(1, idx_1);
    local e_idx = math.min(idx_2, #t);
    for k,v in pairs(t) do
        if k >= s_idx and k <= e_idx then
            table.insert(sub, v);
        end
    end
    return sub;
end

function g_int_to_bool(i)
    if i==0 then
        return false;
    else
        return true;
    end
end