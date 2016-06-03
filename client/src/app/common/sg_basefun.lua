-- sg_basefun.lua

-- des      :�������ܺ���
-- author   :wz
-- data     :2015��1��8��

-- ���¼���Lua�ļ�
function G_Reload(filename)
	if package.loaded[filename] ~= nil then
		package.loaded[filename] = nil;
	end
	return require(filename);
end

-- �ж�C++�����Ƿ����
-- @object��UserData����
function G_isUserDataValid(object)
	if object and not tolua.isnull(object) then
		return true
	end
end

--�ж�UserData��ʵ������
function G_isKindOf(object,className)
	if type(object) == "userdata" then	
		return tolua.type(object) == className
	end
end

-- ���ַ���ת��Ϊ�ַ�table
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

--����תΪ�ո�
function G_number_to_space(num)
	local size = string.len(tostring(num))
	local str = ""
	for i=1,size*2 do
		str = str .. " "
	end
	return str
end

-- number to chinese
-- ����ȡ������������
function G_number_to_chinese(num)
    if num < 10000 then
        return tostring(num);
    else
        local n = math.modf(num / 10000);
        local s = n .. G_GetString("place5");
        return s;
    end
end

-- ƽ̨�ж�
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

-- ��ȡϵͳʱ��(����)
function g_gettime()
    return CBaseFun:getTime();
end

-- �������ַ�����ַ���Ϊtable
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

-- �ϲ�������,����ֵ��ͬ�����
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

--ע��ص�����
function regFunction(fun)
	local a = CallFunManager:setFunction(fun)
	return a
end

--��ȡ�ַ�����md5
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
	--�����
	local nSec = math.floor(math.mod(second,60));
	local nMin = math.floor(math.mod(second/60,60));
	local nHou = math.floor(math.mod(second/3600,24));
	local nDay = math.floor(second/3600/24);
	--ָ���ַ�����ʽ
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
function pattern_time(sec)  --���00:00:00��ʽʱ��
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
function pattern_timeAll(sec)  --���00:00:00��ʽʱ�� �̶�Сʱδ0ʱҲ��ʾ00:01:50
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
function dayhourminsec_time(sec)  --���XX��00:00:00��ʽʱ��
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
function dayhourminName_time(sec)  --���XX��00ʱ00�� ��ʽʱ��
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
--����ת�� 1~7��Ӧ ������һ...~����
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
-- һЩ��Ҫǿ�����¼��ص��ļ����������
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