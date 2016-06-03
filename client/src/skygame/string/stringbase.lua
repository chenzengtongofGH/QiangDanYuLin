-- stringbase.lua
require("skygame.sg_ui")
local DEFAULT_FONT = "Droid Sans Fallback"
local DEFAULT_FONTSIZE = 24
local DEFAULT_FONTCOLOR = {0xff,0xff,0xff}

local strbase = {};

-- 换行符
function strbase.getScriptChgLine()
	return "<st=ChgLine></>"
end
function strbase.createChangeLine(ci)
	return nil,true
end
function strbase.parseChgLine(inputstr)
	if type(inputstr) == "string" then
		return string.gsub(inputstr,"\n","<st=ChgLine></>")
	end
	return inputstr
end
---------------------------------------------------------------
--文本控件
function strbase.getScriptStr(color,s,size,ssize,scolor,color2)--文字变色
	if not color or #color~=3 then
		color=DEFAULT_FONTCOLOR
	end
	if not size then
		size = DEFAULT_FONTSIZE
	end
--[[	if size < 20 then
		size = 20
	end--]]
	if not s then
		s = "error"
	end
	if ssize and scolor or color2 then
		if not color2 then
			color2=color
		end
		local format = "<st=Txt color={%d,%d,%d} color2={%d,%d,%d} size=%d scolor={%d,%d,%d,%d} ssize=%d>%s</>"
		return string.format(format,color[1],color[2],color[3],color2[1],color2[2],color2[3],size,scolor[1],scolor[2],scolor[3],scolor[4],ssize,s)
	else
	return string.format("<st=Txt color={%d,%d,%d} size=%d>%s</>",color[1],color[2],color[3],size,s)
	end
	
end

function strbase.createString(ci)
	if not ci then
		return 
	end		
	-- 根据文字信息得到一些控件需要的属性
	local font = ci.m_font or DEFAULT_FONT;
	local size = ci.m_size or DEFAULT_FONTSIZE;
	local color = ci.m_color or DEFAULT_FONTCOLOR;
	local ssize = ci.m_ssize
	local scolor = ci.m_scolor
	local color2 = ci.m_color2 or color

	-- 创建文字控件
	local strLable 
	if ssize and scolor then
		scolor=cc.c4b(unpack(scolor))
		strLable = sg_ui.LabelTTFOutline(ci.m_str,font,size,ssize,1);	
		strLable:setColor2(cc.c3b(color[1],color[2],color[3]),cc.c3b(color2[1],color2[2],color2[3]));
	else
		strLable = sg_ui.LabelTTF(ci.m_str,font,size);	
		strLable:setColor(cc.c3b(color[1],color[2],color[3]));
	end
	
	strLable:setAnchorPoint(cc.p(0,0)); 					
	
	return strLable,true	
end
--labelbmp
function strbase.getScriptBMP(str,font)
	str = str or "0"
	font= font or "fonts/vipnumfont.fnt"
	return string.format("<st=Bmp font=%s>%s</>",font,str)
end
function strbase.createBMPLabel(ci)
	if ci then
		local labelbmp = UI.newControl("labelbmf",ci.m_str, ci.m_font)
		labelbmp:setAnchorPoint(cc.p(0,0)); 	
		ci.m_size = labelbmp:getContentSize().height
		return labelbmp,true
	end
	return nil,false
end
-----------------------------------------------------------------
-- UI Menu
function strbase.getSrciptMenu(color,str,funcStr,tag) --Menu脚本
	if not color or #color~=3 then
		color=DEFAULT_FONTCOLOR
	end
	if not str then str = "error" end
	if not tag then	tag = 1	end
	return string.format("<st=Menu color={%d,%d,%d} func=%s tag=%d>%s</>",color[1],color[2],color[3],funcStr,tag,str)
end
function strbase.createMenuLabel(ci)
	local font = ci.m_font or DEFAULT_FONT;
	local size = ci.m_size or DEFAULT_FONTSIZE;
	local color = ci.m_color or DEFAULT_FONTCOLOR;
	local func = ci.func;
	local tag = ci.tag or 1
	
	-- 创建文字控件
	local strLable = CCLabelTTF:create(ci.m_str,font,size);
	strLable:setColor(cc.c3b(color[1],color[2],color[3]));

	local menuitem = UI.newControl("menuLabel",strLable)
	menuitem:setTag(tag)
	menuitem:setAnchorPoint(cc.p(0,0))
	if ci.func then
		local gFunc = _G[ci.func]
		if gFunc then
			menuitem:registerScriptTapHandler(gFunc)
		end			
	end		
	local menu = UI.newControl("menu",menuitem)
	menu:setTag(tag)
	menu:setAnchorPoint(cc.p(0,0)); 
	menu:setContentSize(menuitem:getContentSize())
	
	return menu,true
end
---------------------------------------------------------------
--sprite
function strbase.getScriptSprite(image,scale,offset)
	local script="<st=Sprite image="..image
	if scale then
		if type(scale) == "number" then
			scale=cc.p(scale,scale)
		end
		script=script..string.format(" scale={%.2f,%.2f}",scale.x,scale.y)		
	end
	if offset then
		script=script..string.format(" offset={%.2f,%.2f}",offset.x,offset.y)		
	end
	script=script.."></>"
	return script
end
function strbase.createSprite(ci)
	local image = ci.image	
	local sprite = display.newSprite(image)	
	if sprite then
		sprite:setAnchorPoint(cc.p(0,0));
		if ci.scale then
			sprite:setScaleX(sprite:getScaleX()*ci.scale.x)
			sprite:setScaleY(sprite:getScaleY()*ci.scale.y)
			ci.m_size = sprite:getContentSize().height*sprite:getScaleY()
		else
			ci.m_size = sprite:getContentSize().height
		end
		
		return sprite,true
	end
	return nil,true
end
--UserData
function strbase.getUserData(scale,offset)
	local script="<st=UserData "
	if scale then
		if type(scale) == "number" then
			scale=cc.p(scale,scale)
		end
		script=script..string.format(" scale={%.2f,%.2f}",scale.x,scale.y)		
	end
	if offset then
		script=script..string.format(" offset={%.2f,%.2f}",offset.x,offset.y)		
	end
	script=script.."></>"
	return script
end
function strbase.createUserData(ci)
	local data = ci.data	
	if data then
		data:setAnchorPoint(cc.p(0,0));	
		ci.m_size = data:getContentSize().height*data:getScaleY()
		return data,true
	end
	return nil,true
end

return strbase;