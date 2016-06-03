--stringview control
local DEFAULT_FONT = "Droid Sans Fallback"
local DEFAULT_FONTSIZE = 24
local DEFAULT_FONTCOLOR = {0xff,0xff,0xff}

-- 控件信息
CControl_Detail_Info=class("CControl_Detail_Info")

function CControl_Detail_Info:ctor(t)
	self.m_type = t[1];
	self.m_posx = t[2];
	self.m_posy = t[3];
	self.m_w = t[4];
	self.m_h = t[5];
	self.m_ele = t[6];-- 控件
	self.m_released = false
	self.m_preele = t[7];-- 前一个控件
	self.m_nextele = t[8]; -- 后一个控件
	self.m_stringinfo = t[9]; -- 对应文字信息
end
--是否可以拆分
function CControl_Detail_Info:canSplit()
	if self.m_type == 1 then
		return true
	end
end

-- 文字信息
CString_Detail_Info = class("CString_Detail_Info")
function CString_Detail_Info:ctor()
	self.m_type = 1	--类型 1 文字
	self.m_str = "" --文字
	self.m_color = DEFAULT_FONTCOLOR -- 颜色
	self.m_size = DEFAULT_FONTSIZE	-- 大小
	self.m_font = DEFAULT_FONT	-- 字体
	--m_preele,
	--m_nextele,
end		
-- 通过对象创建
function CString_Detail_Info:copy(sdi)
	self.m_type = sdi.m_type;
	self.m_str = sdi.m_str;
	self.m_color = sdi.m_color;
	self.m_size = sdi.m_size;
	self.m_font = sdi.m_font;
	self.m_preele = sdi.m_preele;
	self.m_nextele = sdi.m_nextele;
end
function CString_Detail_Info:Init(color, size, font)
	self.m_type = 1;
	self.m_str = "";
	self.m_color = color;
	self.m_size = size;
	self.m_font = font;
	self.m_preele = nil;
	self.m_nextele = nil;
end
function CString_Detail_Info:InitWithTable(infoTable)
	if infoTable[1].color then 
		local colorstrlen = string.len(infoTable[1].color);
		local colorstr = string.sub(infoTable[1].color, 2, colorstrlen - 1);
		local paramPairs = lua_string_split(colorstr, ",");
		self.m_color = {tonumber(paramPairs[1]),tonumber(paramPairs[2]), tonumber(paramPairs[3])};		
	end
	if infoTable[1].color2 then 
		local colorstrlen = string.len(infoTable[1].color2);
		local colorstr = string.sub(infoTable[1].color2, 2, colorstrlen - 1);
		local paramPairs = lua_string_split(colorstr, ",");
		self.m_color2 = {tonumber(paramPairs[1]),tonumber(paramPairs[2]), tonumber(paramPairs[3])};					
	end
	-- 尺寸
	if infoTable[1].size then self.m_size = infoTable[1].size end;
	-- 字体
	if infoTable[1].font then self.m_font = infoTable[1].font end;
	--阴影
	if infoTable[1].ssize then self.m_ssize = infoTable[1].ssize end;
	if infoTable[1].scolor then
		local colorstrlen = string.len(infoTable[1].scolor);
		local colorstr = string.sub(infoTable[1].scolor, 2, colorstrlen - 1);
		local paramPairs = lua_string_split(colorstr, ",");
		self.m_scolor = {tonumber(paramPairs[1]),tonumber(paramPairs[2]), tonumber(paramPairs[3]), tonumber(paramPairs[4])};
	end
end
function CString_Detail_Info:printInfo()
	--print("type:" .. self.m_type .. ",str:" .. self.m_str);
end

--UI MENU
Menu_Detail_Info = class("Menu_Detail_Info")
function Menu_Detail_Info:ctor()
	self.m_type = 3	--类型 3 Menu
	self.m_str = "" --文字
	self.m_color =DEFAULT_FONTCOLOR -- 颜色
	self.m_size = DEFAULT_FONTSIZE	-- 大小
	self.m_font = DEFAULT_FONT	-- 字体
end
function Menu_Detail_Info:copy(mdi)
	self.m_type = mdi.m_type;
	self.m_str = mdi.m_str;
	self.m_color = mdi.m_color;
	self.m_size = mdi.m_size;
	self.m_font = mdi.m_font;
	self.m_preele = mdi.m_preele;
	self.m_nextele = mdi.m_nextele;
end
function Menu_Detail_Info:Init(color,size,font)
	self.color = color;
	self.m_size = size;
	self.font = font;
	self.m_preele = nil;
	self.m_nextele = nil;
end
function Menu_Detail_Info:InitWithTable(infoTable)
	if infoTable[1].color then
		local colorstrlen = string.len(infoTable[1].color);
		local colorstr = string.sub(infoTable[1].color, 2, colorstrlen - 1);
		local paramPairs = lua_string_split(colorstr, ",");
		self.m_color = {tonumber(paramPairs[1]),tonumber(paramPairs[2]), tonumber(paramPairs[3])};
	end
	-- 尺寸
	if infoTable[1].size then self.m_size = infoTable[1].size end;
	-- 字体
	if infoTable[1].font then self.m_font = infoTable[1].font end;
	-- 响应函数
	if infoTable[1].func then self.func = infoTable[1].func end;
	-- tag
	if infoTable[1].tag then self.tag = infoTable[1].tag end
end
function Menu_Detail_Info:printInfo()
	--sBaseFun:CCLuaLog("create Menu:"..self.m_str)
end
--CCSprite
Sprite_Detail_Info = class("Sprite_Detail_Info")
function Sprite_Detail_Info:ctor()
	self.m_type = 4 --图片
	self.image=""--图片位置
end
function Sprite_Detail_Info:copy(sdi)
	self.image=sdi.image
	self.m_preele=sdi.m_preele
	self.m_nextele=sdi.m_nextele
end
function Sprite_Detail_Info:Init(image)
	self.image = image
	self.m_preele = nil;
	self.m_nextele = nil;
end
function Sprite_Detail_Info:InitWithTable(infoTable)
	if infoTable[1].image then	self.image = infoTable[1].image	end
		
	if infoTable[1].scale then  
		local scalestrlen = string.len(infoTable[1].scale);
		local scalestr = string.sub(infoTable[1].scale, 2, scalestrlen - 1);
		local paramPairs = lua_string_split(scalestr, ",");
		self.scale=cc.p(tonumber(paramPairs[1]),tonumber(paramPairs[2]))  
	end		
	if infoTable[1].offset then
		local offsetstrlen = string.len(infoTable[1].offset);
		local offsetstr = string.sub(infoTable[1].offset, 2, offsetstrlen - 1);
		local paramPairs = lua_string_split(offsetstr, ",");
		self.offset=cc.p(tonumber(paramPairs[1]),tonumber(paramPairs[2])) 
	end
	self.m_preele = nil;
	self.m_nextele = nil;
end
function Sprite_Detail_Info:printInfo()
	--sBaseFun:CCLuaLog("create Sprite:"..self.image)
end
--BMP label
LabelBMP_Detail_Info = class("LabelBMP_Detail_Info")
function LabelBMP_Detail_Info:ctor()
	self.m_type = 5 	
end
function LabelBMP_Detail_Info:copy(sdi)
	self.m_str=sdi.m_str
	self.m_font=sdi.m_font
	self.m_preele=sdi.m_preele
	self.m_nextele=sdi.m_nextele
end
function LabelBMP_Detail_Info:Init(str,font)
	self.m_str=str
	self.m_font=font
	self.m_preele = nil;
	self.m_nextele = nil;
end
function LabelBMP_Detail_Info:InitWithTable(infoTable)
	if infoTable[1].font then
		self.m_font = infoTable[1].font
	end
	self.m_str = infoTable[2]
	
	return self
end
function LabelBMP_Detail_Info:printInfo()
	--CCLuaLog("create Sprite:"..self.image)
end
--UserData
UserData_Detail_Info = class("UserData_Detail_Info")
function UserData_Detail_Info:ctor()
	self.m_type = 255 --图片
end
function UserData_Detail_Info:copy(sdi)
	self.data=sdi.data
	self.m_preele=sdi.m_preele
	self.m_nextele=sdi.m_nextele
	self.offset = sdi.offset
	self.scale = sdi.scale
end
function UserData_Detail_Info:Init(infoTable,data)
	self.data = data
	if infoTable[1].scale then  
		local scalestrlen = string.len(infoTable[1].scale);
		local scalestr = string.sub(infoTable[1].scale, 2, scalestrlen - 1);
		local paramPairs = lua_string_split(scalestr, ",");
		self.scale=cc.p(tonumber(paramPairs[1]),tonumber(paramPairs[2]))  
	end	
	if infoTable[1].offset then
		local offsetstrlen = string.len(infoTable[1].offset);
		local offsetstr = string.sub(infoTable[1].offset, 2, offsetstrlen - 1);
		local paramPairs = lua_string_split(offsetstr, ",");
		self.offset=cc.p(tonumber(paramPairs[1]),tonumber(paramPairs[2])) 
	end
	self.m_preele = nil;
	self.m_nextele = nil;
end
function UserData_Detail_Info:printInfo()
	--sBaseFun:CCLuaLog("create UserData:"..self.image)
end