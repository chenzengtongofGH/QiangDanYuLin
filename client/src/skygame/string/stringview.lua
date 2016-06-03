--stringview
require("skygame.string.controldetail")
require("skygame.functions")
local strbase = require("skygame.string.stringbase");
local controlFactory = require("skygame.string.controlfactory")

-- 文字显示
local LeftFlag1 = "<";
local LeftFlag2 = ">";
local RightFlag = "</>";
--[[
	CStringShow = {
		-- 文字详细信息表
		stringDetailInfoTable = {},
		-- 第一个文字信息
		firstinfo = nil,
		-- 前一个控件文字信息
		lastInfo = nil,
		-- 控件表
		controlDetailInfoTable = {},
		-- 第一个控件信息
		firstControlInfo = nil,
		-- 前一个控件信息
		lastControlInfo = nil,
		-- 字符串 字体
		defaultFont = nil,
		-- 字符串 颜色
		defaultColor = nil,
		-- 字符串 大小
		defaultSize = nil,
		-- 行间距
		defaultLineSpace = 0;
		-- 长宽
		stringwh = nil,
		-- 内容尺寸 1 w 2 h
		contentsize = {width=0,height=0},
		cntrolInfoByLine = {},
		--child是否需要被layerzoom
		needzoom = nil,
		hAlignment = 0, --水平对齐方式0:左，1.居中，2.右边
	}
--]]

local MAX_PER_STRING_LENGTH = 40;
local MAX_H_FLAG = "max_height";

CStringShow = class("CStringShow");

function CStringShow:ctor()
	self.defaultLineSpace = 0;
	self.hAlignment = 0
	self.contentsize={width=0,height=0}	
end

function CStringShow:str_view_reset()
	self.stringDetailInfoTable = {};	
	self.controlDetailInfoTable = {};	
	self.cntrolInfoByLine = {}	
end

function CStringShow:str_view_print()
	if self.firstinfo == nil then
		return;
	end
	local e = self.firstinfo;
	while true do
		e:printInfo();
		e = e.m_nextele;
		if e == nil then
			break;
		end
	end
end

function CStringShow:setHAlignment(hAlign)
	self.hAlignment = hAlign
end

--[[
	inputStr:	文字
	font:		字体名
	color:		颜色{r,g,b}
	size:		尺寸
	wh:			宽高{w,h}
	linespace:	行间距
--]]
function CStringShow:str_view_wordwrap(inputStr, font, color, size, wh, linespace, usertable)
    -- 重置属性
    self:str_view_reset();
    inputStr = strbase.parseChgLine(inputStr)
    self.stringwh = wh;
    self.defaultFont = font;
    self.defaultColor = color;
    if size == nil then size = 24 end;
    self.defaultSize = size;
    self.userindex = 1
    self.usertable = usertable

    -- 默认行间距
    if linespace then
        self.defaultLineSpace = linespace;
    end

    local prostr = inputStr;
    -- 循环查找文字，
    while true do
        -- 寻找控件

        -- 搜索 '<'
        local i = string.find(prostr, LeftFlag1);
        if not i then
            --  如果没有 '<' 表明没有脚本
            self:str_view_getinfo_bystr(prostr, false);
            break;
        end


        -- 普通脚本文字
        local nromalstr = string.sub(prostr, 1, i - 1);
        self:str_view_getinfo_bystr(nromalstr, false);

        -- 搜索 "</>" j,k为起止下标
        local j, k = string.find(prostr, RightFlag);
        if j == nil then
            self:str_view_getinfo_bystr(string.sub(prostr, i), false);
            break
        end
        -- 控件脚本文字
        local controlscript = string.sub(prostr, i, k);
        self:str_view_getinfo_bystr(controlscript, true);
        -- 更新查询字符串
        prostr = string.sub(prostr, k + 1);
    end
    self.layer = self:str_view_show_layer();
    self.layer:setContentSize(self.contentsize)
    self.layer:registerScriptHandler( function(e) if (e["name"] == "exit") then self:Del() end end);
    return self.layer;
end
-- 创建链表
function CStringShow:str_view_craete_cdi_list(cdi)
	--  生成链表
	if self.firstinfo == nil then
		self.firstinfo = cdi;
		cdi.m_preele = nil
	else
		self.lastInfo.m_nextele = cdi;
		cdi.m_preele = self.lastInfo;
	end
	self.lastInfo = cdi;
	table.insert(self.stringDetailInfoTable, cdi);
end

function CStringShow:CreateStringDetailInfo()
	local cdi = CString_Detail_Info.new();
	cdi:Init(self.defaultColor,self.defaultSize,self.defaultFont);
	return cdi;
end
function CStringShow:CreateMenuDetailInfo()
	local cdi = Menu_Detail_Info.new()
	cdi:Init(self.defaultColor,self.defaultSize,self.defaultFont);
	return cdi
end
function CStringShow:CreateSpriteDetailInfo()
	local cdi = Sprite_Detail_Info.new()	
	return cdi
end
function CStringShow:CreateBMPDetailInfo()
	local cdi = LabelBMP_Detail_Info.new()
	return cdi
end
function CStringShow:CreateUserDataInfo()
	local cdi = UserData_Detail_Info.new()
	return cdi
end
function isChineseCh(str,i)
	local  a = string.byte(str,i);
	if (a and a >= 0x81 and a <= 0xfe) then --简单判断
		if (string.byte(str,i+1) == '\0') then
			return 0;
		end
		return 1;
	end
	return 0;
end
function CStringShow:SplitStringByLength(str, perlength)
	local strlen = string.len(str);
	local splitedStrs = {};
	local startPos = 1;
	local i = 1;

	while i <= strlen do
		local isChinese = isChineseCh(str,i) == 1--CSpriteBaseFun:IsChinese(str, i-1) == 1;
		if isChinese == true then
			i = i + 1;
		end
		local curSubLength = i - startPos + 1;
		if curSubLength >= perlength then		
			local subString = string.sub(str, startPos, startPos + curSubLength-1 );
			table.insert(splitedStrs, subString);
			startPos = startPos + curSubLength;
		end	
		i = i + 1;
	end
	if startPos <= strlen then
		local lastString = string.sub(str, startPos, strlen);
		table.insert(splitedStrs, lastString);
	end
	--tprint(splitedStrs);
	return splitedStrs;
end
function CStringShow:SplitUtf8StringByLength(str, perlength)
	local strlen = string.utf8len(str);
	local splitedStrs = {};
	local startPos =0;
	local i = 1;

	while perlength < strlen do
		local subString = string.utf8_sub(str, startPos, perlength );
		table.insert(splitedStrs, subString);
		
		startPos = startPos + perlength
		strlen = strlen - perlength
	end
	if strlen > 0 then
		local lastString =string.utf8_sub(str, startPos, strlen );
		table.insert(splitedStrs, lastString);
	end
	--tprint(splitedStrs);
	return splitedStrs;
end
-- 根据文字得到具体信息
-- str		需要显示的文字
-- isScript 是否是脚本
-- 解析文字，并将生成的信息添加到 stringDetailInfoTable 中
function CStringShow:str_view_getinfo_bystr(str, isScript)
	-- 普通文字
	if isScript == false then 
		local splitedStrs = self:SplitUtf8StringByLength(str, MAX_PER_STRING_LENGTH);
		for k,v in ipairs(splitedStrs) do
			-- 如果不是脚本文字，直接对文字详细信息对象进行赋值
			local cdi = self:CreateStringDetailInfo();
			cdi.m_type = 1;
			cdi.m_str = v--CSpriteBaseFun:Lua_g2u(v);
			cdi.m_color = self.defaultColor;
			cdi.m_size = self.defaultSize;
			cdi.m_font = self.defaultFont;
			--  生成链表
			--print("create cdi:"..v);
			self:str_view_craete_cdi_list(cdi);
		end
		return;
	else
		-- 脚本文字
		-- infoTable [1] 是参数key-value表 [2] 是真是文字
		local infoTable = self:str_view_getcontrol_info(str);
		-- 文字变化
		if infoTable[1].st == "Txt" then
			local splitedStrs = self:SplitUtf8StringByLength(infoTable[2], MAX_PER_STRING_LENGTH);
			for k,v in ipairs(splitedStrs) do
				local cdi = self:CreateStringDetailInfo();				
				-- 编码转换 gb2312 -> utf-8
				-- 设置真实文字
				cdi.m_str = v--CSpriteBaseFun:Lua_g2u(v);
				cdi:InitWithTable(infoTable)				
				--  生成链表
				self:str_view_craete_cdi_list(cdi);				
			end
		end 
		
		local cdi
		if infoTable[1].st == "ChgLine" then-- 换行
			cdi = self:CreateStringDetailInfo();
			cdi.m_type = 2;		
		elseif infoTable[1].st == "Menu" then
			cdi = self:CreateMenuDetailInfo();
			cdi.m_str = infoTable[2]--CSpriteBaseFun:Lua_g2u(infoTable[2])
			cdi:InitWithTable(infoTable)						
		elseif infoTable[1].st == "Sprite" then
			cdi = self:CreateSpriteDetailInfo();
			cdi:InitWithTable(infoTable)				
		elseif infoTable[1].st == "Bmp" then
			cdi = self:CreateBMPDetailInfo()
			cdi:InitWithTable(infoTable)	
		elseif infoTable[1].st == "UserData" then
			if self.usertable[self.userindex] then
				cdi = self:CreateUserDataInfo()
				cdi:Init(infoTable,self.usertable[self.userindex])
				self.userindex = self.userindex + 1	
			end
		end
			--  生成链表
		if cdi then self:str_view_craete_cdi_list(cdi); end
		end
end
--[[
 Description: 	解析文字脚本参数
 Input:			str 需要解析的文字
 Output:		table 
				[1] 参数key-value对应表
				[2] 真实文字
 Author:		wz
 Date:			2013.5.24
 Modif Record:	
--]]
function CStringShow:str_view_getcontrol_info(str)
	-- 查找'>'位置
	local i = string.find(str, LeftFlag2);
	-- 查找 "</>"位置
	local j = string.find(str, RightFlag);
	-- 控件参数字符串
	local ci = string.sub(str, 2, i-1);
	-- 安装空格拆各个参数
	local paramPairs = lua_string_split(ci, " ");
	-- 创建一个参数 key-value 对应表
	local paramTable = {};
	-- 遍历拆分结果 对key-value对应表赋值
	for k, v in pairs(paramPairs) do
		-- 格式为key=value,所以这里用“=”进行拆分
		local a = lua_string_split(v, "=");
		paramTable[a[1]] = a[2];
	end
	-- 文字
	local text = nil;
	-- 判断文字是否为空（按钮，图片等可能为空）
	if j > i+1 then
		-- 得到具体文字 位于 '>' 和 "</>"之间
		text = string.sub(str, i+1, j-1);
	end
	--tprint(paramTable);
	return {paramTable, text};
end


-----------------------------------------------------------------------------
--[[
 Description: 	根据文字信息，创建显示文字的层
 Input:			
 Output:		showlayer 显示文字的层
 Author:		wz
 Date:			2013.5.24
 Modif Record:	
--]]
function CStringShow:str_view_show_layer()
	if self.firstinfo == nil then 
		return display.newLayer();
	end
	local showlayer = display.newLayer();
	local e = self.firstinfo;
	-- 遍历所有信息
	while true do
		e:printInfo();
		-- 根据信息，创建文字空间链表，
		--self:str_view_create_control(e);
		self:str_view_create_control_v2(e)
		e = e.m_nextele;
		if e == nil then
			break;
		end
	end
	-- 添加文字控件到显示层
	local tmpCtrl = self.firstControlInfo;
	while tmpCtrl and true do --规避线上BUG
		if tmpCtrl.m_ele then
			showlayer:addChild(tmpCtrl.m_ele);
		end
		tmpCtrl = tmpCtrl.m_nextele;
		if tmpCtrl == nil then
			break;
		end
	end
	-- 修改排版 设置控件位置
	self:str_view_composing(showlayer);
	self:revise_y_when_different_size_in_one_line();
	return showlayer;
end

-- 修正Y方向上的坐标并更新尺寸
function CStringShow:revise_y_when_different_size_in_one_line()
	if not self.firstControlInfo then
		return;
	end
	local curY = self.firstControlInfo.m_posy;

	self.contentsize.height = -curY;
	local contentWidth = self.contentsize.width
	for k,v in pairs(self.cntrolInfoByLine) do
		-- 第一行不处理
		local height = v[MAX_H_FLAG];
		local lineWidth = 0
		self.contentsize.height = self.contentsize.height + height + self.defaultLineSpace;
		if k > 1 then 
			curY = curY - height - self.defaultLineSpace;						
			for k1,v1 in pairs(v) do								
				if k1 ~= MAX_H_FLAG and v1.m_ele then	
					--print("line:"..k..",string:"..CSpriteBaseFun:Lua_u2g(v1.m_stringinfo.m_str)..",H:"..self.contentsize[2]);		
					--v1.m_ele:setPosition(v1.m_posx, curY);
					--if v1.m_type == 4 then --图片
					--	curY = curY - (v1.m_ele:getContentSize().height-height - self.defaultLineSpace)*0.5
					--end
					local y = curY
					local cdi = v1.m_stringinfo
					if cdi.offset then					
						y = curY+cdi.offset.y
					end
				
					v1.m_ele:setPositionY(y);
					lineWidth = lineWidth + v1.m_ele:getContentSize().width
				end
			end			
		else
			for k1,v1 in pairs(v) do								
				if k1 ~= MAX_H_FLAG and v1.m_ele then					
					lineWidth = lineWidth + v1.m_ele:getContentSize().width
				end
			end		
		end 
		local xoffset = 0
		if self.hAlignment == 1 then --居中		
			if lineWidth < contentWidth then
				xoffset = (contentWidth - lineWidth)*0.5				
			end
		elseif self.hAlignment == 2 then --右对齐
			if lineWidth < contentWidth then
				xoffset = contentWidth - lineWidth
			end
		end					
		for k1,v1 in pairs(v) do								
			if k1 ~= MAX_H_FLAG and v1.m_ele then	
				local cdi = v1.m_stringinfo
				local x = xoffset
				if cdi.offset then					
					x = xoffset+cdi.offset.x
				end
				--CCLuaLog("label layer2:posx="..v1.m_posx+xoffset)				
				v1.m_ele:setPositionX(v1.m_posx+x);
			end
		end	
	end
	--self.contentsize[2] = self.contentsize[2] + 10;
end

function CStringShow:get_charsize(str, strwidth)
	--str =  CSpriteBaseFun:Lua_u2g(str);
	local charcount = string.utf8len(str)
	--local charcount = string.len(str);
	local charszie = strwidth / charcount;
	return charszie;
end
--[[
	m_posx, -- x
	m_posy, -- y
	m_w,	-- 宽
	m_h,	-- 高
	m_ele,	-- 控件
	m_preele,
	m_nextele,
	--]]
-- 排版函数
function CStringShow:str_view_composing(parentLayer)
	if not self.firstControlInfo then
		return;
	end

	local lineCtl = {};
	self.cntrolInfoByLine = {};
	
	local tmpCtrl = self.firstControlInfo;
	-- local tmpCtrl = self.controlDetailInfoTable[1];
	-- 遍历所有控件，修改它们的位置，包括换行等等
	while true do
		-- 修改位置
		--print(CSpriteBaseFun:Lua_u2g(tmpCtrl.m_stringinfo.m_str));
		
		if not tmpCtrl.m_preele then
			-- 如果没有父对象，表明是第一个
			-- 设置相对位置为 0,0 
			tmpCtrl.m_posx = 0;
			tmpCtrl.m_posy = 0;
		end
		-- 是否处理拆分标志
		local processsplit = false;
		-- 换行的标志
		local changeline = false;	
		-- 如果此控件信息为 换行(换行也可以作为一种控件信息插入到链表中)
		if tmpCtrl.m_type == 2 then
			-- 直接将换行标志设置为true
			changeline = true;
		end
		-- 行宽
		local lineWidth = 0
		--print(CSpriteBaseFun:Lua_u2g(tmpCtrl.m_stringinfo.m_str)..",posX:"..tmpCtrl.m_posx..",m_w:"..tmpCtrl.m_w..",linewidth:"..lineWidth);
		-- 判断是否有CC控件
		if tmpCtrl.m_ele then
			-- 得到控件宽度 CC函数返回
			local scale = 1
			if tmpCtrl.m_stringinfo.scale then
				scale = tmpCtrl.m_stringinfo.scale.x
			end
			tmpCtrl.m_w = tmpCtrl.m_ele:getContentSize().width * scale;				
			--print("m_posx:" .. tmpCtrl.m_posx .. ",width:" .. tmpCtrl.m_w );
			
			-- 换行处理  
			-- 判断是否设置了行宽，如果有设置，要进行换行处理
			if self.stringwh then	
				-- 行宽		
				lineWidth = self.stringwh[1];
				-- 当前X位置 + 控件宽度 > 行宽 需要换行
				if tmpCtrl.m_posx + tmpCtrl.m_w >  lineWidth then
					if not tmpCtrl:canSplit() then -- 不可拆分控件直接换行
						changeline = true
					else
						local availableLength = lineWidth - tmpCtrl.m_posx;
						local overlength = tmpCtrl.m_w - availableLength
						local stringInfo = tmpCtrl.m_stringinfo;	
						local charsize = self:get_charsize(stringInfo.m_str, tmpCtrl.m_w);
						
						if availableLength < 2 * charsize then --and tmpCtrl.m_w < lineWidth then 
							-- 如果满足上面的条件，表明不需要因为换行而对文字进行拆分，直接换行就好
							changeline = true;
						else		
							--sBaseFun:CCLuaLog("length:"..availableLength.."charsize:"..charsize)
							-- 不满足上面的条件，说明，必须对之前生成的控件进行拆分，才能满足要求
							-- 得到当前行还可以显示的宽度																			
							-- 拆分文字
							local strTable = self:split_utf8_string_by_size(tmpCtrl.m_stringinfo.m_str, {availableLength, lineWidth}, charsize);
							-- 拆分Label
							local splitStrCount = table.getn(strTable);
							if splitStrCount > 1 then
								local splitretun = self:split_stringdetailinfo(stringInfo, strTable);
								-- 将拆分后的信息，生成新的节点
								if splitretun then
									-- 如果有信息，拆分控件,返回拆分后的第一个控件
									tmpCtrl = self:split_controldetailinfo(splitretun, tmpCtrl, parentLayer);
									--processsplit = true;
								end
							end
						end
					end						
					processsplit = true;
				end
			end
		end

		-- 添加控件到行中
		if changeline == true then
			tmpCtrl.m_posx = 0;
			tmpCtrl.m_posy = tmpCtrl.m_posy - tmpCtrl.m_stringinfo.m_size - self.defaultLineSpace;			
			table.insert(self.cntrolInfoByLine,lineCtl);
			lineCtl	= {};
		end
		-- 如果有拆分控件，不进行下面的处理
		if not processsplit then			
			if not lineCtl[MAX_H_FLAG] or lineCtl[MAX_H_FLAG] < tonumber(tmpCtrl.m_stringinfo.m_size) then
				lineCtl[MAX_H_FLAG] = tonumber(tmpCtrl.m_stringinfo.m_size);
			end
			table.insert(lineCtl, tmpCtrl);
			
			--print("===:"..CSpriteBaseFun:Lua_u2g(tmpCtrl.m_stringinfo.m_str)..",x:"..tmpCtrl.m_posx..",y:"..tmpCtrl.m_posy);
			if tmpCtrl.m_ele then			
				local curX,curY = tmpCtrl.m_posx,tmpCtrl.m_posy
				--if tmpCtrl.m_type == 4 then --图片
				--	curY = curY - (tmpCtrl.m_ele:getContentSize().height-self.defaultSize-self.defaultLineSpace)*0.5
				--end
				local cdi = tmpCtrl.m_stringinfo
				if cdi.offset then
					curX = curX+cdi.offset.x
					curY = curY+cdi.offset.y
				end
				tmpCtrl.m_ele:setPosition(curX, curY);

				-- 更新长宽，只要外部指定了宽度，不再动态调整
				--if (not self.stringwh) or (tmpCtrl.m_posx + tmpCtrl.m_w < lineWidth and tmpCtrl.m_posx + tmpCtrl.m_w > self.contentsize.width) then
				if not self.stringwh then
					self.contentsize.width = tmpCtrl.m_posx + tmpCtrl.m_w;
				else
					self.contentsize.width = lineWidth;
				end
				self.contentsize.height = -tmpCtrl.m_posy + tmpCtrl.m_stringinfo.m_size;
			end

			if tmpCtrl.m_nextele then
				tmpCtrl.m_nextele.m_posx = tmpCtrl.m_posx + tmpCtrl.m_w;
				tmpCtrl.m_nextele.m_posy = tmpCtrl.m_posy;
				
				--[[
				if changeline == true then
					tmpCtrl.m_posx = 0;
					tmpCtrl.m_posy = tmpCtrl.m_posy - tmpCtrl.m_stringinfo.m_size - self.defaultLineSpace;
				end	
				--]]
				tmpCtrl = tmpCtrl.m_nextele;
			else
				table.insert(self.cntrolInfoByLine,lineCtl);
				lineCtl	= {};
				break;
			end
		else
			-- 更新控件位置
			if tmpCtrl.m_ele then
				local curX,curY = tmpCtrl.m_posx,tmpCtrl.m_posy
				--if tmpCtrl.m_type == 4 then --图片
				--	curY = curY - (tmpCtrl.m_ele:getContentSize().height-self.defaultSize-self.defaultLineSpace)*0.5
				--end
				local cdi = tmpCtrl.m_stringinfo
				if cdi.offset then
					curX = curX+cdi.offset.x
					curY = curY+cdi.offset.y
				end
				tmpCtrl.m_ele:setPosition(curX, curY);

				-- 更新长宽，只要外部指定了宽度，不再动态调整
				--if (not self.stringwh) or (tmpCtrl.m_posx + tmpCtrl.m_w < lineWidth and tmpCtrl.m_posx + tmpCtrl.m_w > self.contentsize.width) then
				if not self.stringwh then
					-- 返回宽度
					self.contentsize.width = tmpCtrl.m_posx + tmpCtrl.m_w;
				else
					self.contentsize.width = lineWidth;
				end
				self.contentsize.height = -tmpCtrl.m_posy + tmpCtrl.m_stringinfo.m_size;
			end
		end
	end
end
-- 取得大小
function CStringShow:getContentSize()
	return self.contentsize;
end
-- 设置透明度
function CStringShow:setOpacity(value)
	for k,v in pairs(self.controlDetailInfoTable) do
		if v.m_ele then
			v.m_ele:setOpacity(value);
		end
	end
end
-- 动作
function CStringShow:runFadeInAction(par)
	for k,v in pairs(self.controlDetailInfoTable) do
		if v.m_ele then
			local  action1 = cc.FadeIn:create(par);
			v.m_ele:runAction(action1);
		end
	end
end
function CStringShow:runFadeOutAction(par)
	for k,v in pairs(self.controlDetailInfoTable) do
		if v.m_ele then
			local  action1 = cc.FadeOut:create(par);
			v.m_ele:runAction(action1);
		end
	end
end
-- 删除
--local _count=1
function CStringShow:Del()
	local i = 0
	for k,v in pairs(self.controlDetailInfoTable) do
		if v.m_ele and v.m_released==false then
			--sBaseFun:CCLuaLog("Release StringShow control:"..v.m_type.." retaincount="..v.m_ele:retainCount().." count=".._count)
			--_count = _count+1
			v.m_ele:release()
			v.m_released=true
		end
	end
end
--[[
 Description: 	添加一个新的控件信息到控件信息链表中
 Input:			newctrl 新的控件信息
 Output:		
 Author:		wz
 Date:			2013.5.24
 Modif Record:	
--]]
--local count=1
function CStringShow:str_view_craete_newcontrol_list(newctrl)
	if self.firstControlInfo == nil then
		self.firstControlInfo = newctrl;
		newctrl.m_preele = nil
	else
		if self.lastControlInfo then
			self.lastControlInfo.m_nextele = newctrl;
		end
		newctrl.m_preele = self.lastControlInfo;
	end
	self.lastControlInfo = newctrl;
	table.insert(self.controlDetailInfoTable, newctrl);
--[[	if newctrl.m_ele then
		
		sBaseFun:CCLuaLog("Retain StringShow control:"..newctrl.m_type.." retaincount="..newctrl.m_ele:retainCount().." count="..count)
		count=count+1	
	end--]]
	
end

-- 创建控件 version:2
function CStringShow:str_view_create_control_v2(ci)
    local control,success = controlFactory.create(ci);
    if success then
		if control then
			control:retain() -- 防止被删除				
		end				
		-- 创建一个新的控件信息对象，并添加到链表中
		local newControl = CControl_Detail_Info.new({ci.m_type,0,0,0,0,control,nil,nil,ci});						
		self:str_view_craete_newcontrol_list(newControl);
		return newControl;
    else
		sg_log.warning("Invalid control type:"..ci.m_type.." in str_view_create_control_v2");
	end	
	--return newControl;
end
--[[
 Description: 	根据当前行剩余宽度和行宽，将文字按行拆分
 Input:			str 源文字
				perlength [1] 当前行剩余宽度 [2] 后续行宽
				charsize 单个字符宽度
 Output:		每行文字组成的table
 Author:		wz
 Date:			2013.5.24
 Modif Record:	
--]]
function CStringShow:split_string_by_size(str, perlength, charsize)
	-- 编码转换 utf-8 -> gb2312
	str =  CSpriteBaseFun:Lua_u2g(str);
	--print("split_string_by_size:"..str);
	-- 计算当前行能放几个字符
	local lineCharCount = perlength[1] / (charsize);
	-- 如果一个字符都放不下，说明已到行末，并且本次字符长度大于宽度
	-- 后续行每行能放下多少个字符
	if lineCharCount < 1 then
		lineCharCount = perlength[2] / (charsize);
	end
	local returnStrTable = {};
	local tmpStr = str;
	while true do
		if string.len(tmpStr) <= lineCharCount then
			table.insert(returnStrTable, tmpStr);
			break;
		end 
		local curCharIdx = 1;
		local subStrLen = 0;
		while true do
			-- 这里参数减1的原因是:C++中数组编号是从0开始的
			local returnvalue =  isChineseCh(tmpStr,curCharIdx)--CSpriteBaseFun:IsChinese(tmpStr, curCharIdx);
			local addValue = 1;
			if returnvalue == 1 then
				-- 中文字符，一个文字占两个字节
				addValue = 2;
			end
			if curCharIdx -1 + addValue > lineCharCount then
				break;
			else
				-- 更新长度
				subStrLen = curCharIdx + (addValue - 1);
				-- 如果没有超出长度，继续查找
				curCharIdx = curCharIdx + addValue;
				
			end
		end
		if subStrLen ~= 0 then
			subStrLen =  subStrLen --+ 1;
			local lineStr = string.sub(tmpStr, 1, subStrLen);
			table.insert(returnStrTable, lineStr);
			tmpStr = string.sub(tmpStr, subStrLen + 1);
		end
		-- 从第二行开始,使用后续行宽
		lineCharCount = perlength[2]/(charsize);
	end
	--tprint(returnStrTable);
	return returnStrTable;
end
function CStringShow:split_utf8_string_by_size(str, perlength, charsize)

	-- 计算当前行能放几个字符
	local lineCharCount = perlength[1] / (charsize);
	-- 如果一个字符都放不下，说明已到行末，并且本次字符长度大于宽度
	-- 后续行每行能放下多少个字符
	if lineCharCount < 1 then
		lineCharCount = perlength[2] / (charsize);
	end
	lineCharCount = math.floor(lineCharCount)
	local returnStrTable = {};
	local tmpStr = str;
	while true do
		local count = string.utf8len(tmpStr)
		if count <= lineCharCount then
			table.insert(returnStrTable, tmpStr);
			break;
		end 
		local lineStr = string.utf8_sub(tmpStr,0,lineCharCount)
		table.insert(returnStrTable, lineStr);
		tmpStr = string.utf8_sub(tmpStr, lineCharCount,count - lineCharCount);

		-- 从第二行开始,使用后续行宽
		lineCharCount = math.floor(perlength[2]/charsize);
	end
	--tprint(returnStrTable);
	return returnStrTable;
end
-- 将一个stringdetailinfo拆分成多个
-- 参数
-- sid 一个CStringDetailInfo对象
-- stringTable 字符串表
-- 返回值
-- [0] 拆分后的第一个CStringDetailInfo对象
-- [1] 拆分个数
function CStringShow:split_stringdetailinfo(sdi, stringTable)
	local length = table.getn(stringTable);
	if  length <= 1 then
		return nil;
	end
	local lastsdi = sdi.m_preele;
	-- 第一个节点
	local fi = nil;
	for i=1, length do
		local newSdi = CString_Detail_Info.new();
		-- 将原节点内容拷贝一遍
		newSdi:copy(sdi);
		newSdi.m_str = stringTable[i]--CSpriteBaseFun:Lua_g2u(stringTable[i]);	
		if lastsdi then	
			-- 当sdi为第一个的时候，这里lastsdi为空
			lastsdi.m_nextele = newSdi;
		end
		newSdi.m_preele = lastsdi;
		lastsdi = newSdi;
		if not fi then
			fi = newSdi;
		end
		table.insert(self.stringDetailInfoTable, newSdi);
	end
	-- 从表中删除
	table.remove(sdi);
	
	return {fi, length}
end
-- 参数
-- splitretun[1] 拆分后的第一个CStringDetailInfo对象
-- splitretun[2] 拆分个数
function CStringShow:split_controldetailinfo(splitretun, besplitedctrl, parentLayer)
	--print("split_controldetailinfo:" .. CSpriteBaseFun:Lua_u2g(besplitedctrl.m_stringinfo.m_str))
	-- 设置前一个控件为 besplitedctrl 的前一个控件
	self.lastControlInfo = besplitedctrl.m_preele;
	-- 如果第一个控件为要被拆分的控件，则将其清空
	if self.firstControlInfo == besplitedctrl then 
		self.firstControlInfo  = nil;
	end
	local thefinalctrl = nil
	local firstctrl = nil;
	local si = splitretun[1];
	for i = 1, splitretun[2] do
		thefinalctrl = self:str_view_create_control_v2(si)--self:str_view_create_control(si);
		
		--print("thefinalctrl:" .. CSpriteBaseFun:Lua_u2g(thefinalctrl.m_stringinfo.m_str))
		if not thefinalctrl.m_ele then
			print("create ctrl failed!");
		else
			parentLayer:addChild(thefinalctrl.m_ele);
		end 
		
		if not firstctrl  then
			firstctrl = thefinalctrl;
			firstctrl.m_posx = besplitedctrl.m_posx;
			firstctrl.m_posy = besplitedctrl.m_posy;
		end
		si = si.m_nextele;
	end
	if besplitedctrl.m_nextele then
		thefinalctrl.m_nextele =  besplitedctrl.m_nextele;
		thefinalctrl.m_nextele.m_preele = thefinalctrl;
	end
	parentLayer:removeChild(besplitedctrl.m_ele, true);
	table.remove(besplitedctrl);
	return firstctrl;
end
--------------------------------------
--获得menu对象，需要重置响应等级
function CStringShow:getMenus()
	local menus = {}
	for k,v in pairs(self.controlDetailInfoTable) do
		if v.m_type == 3 and v.m_ele then
			menus[#menus+1] = v.m_ele
		end
	end
	return menus
end

function removeScriptTag(str)
	local prostr = str;
	local resultstr = ""
	local ss = CStringShow.new()
	-- 循环查找文字，
	while true do 	
		-- 寻找控件
		
		-- 搜索 '<'
		local i= string.find(prostr, LeftFlag1);
		if not i then
			--  如果没有 '<' 表明没有脚本
			resultstr = resultstr..prostr
			break;
		end
						
		-- 普通脚本文字		
		local nromalstr = string.sub(prostr,1,i-1);
		resultstr = resultstr..nromalstr
		
		-- 搜索 "</>" j,k为起止下标
		local j,k= string.find(prostr, RightFlag);
		if j == nil then
			resultstr = resultstr.. string.sub(prostr,i);
			break
		end
		
		-- 控件脚本文字
		local controlscript = string.sub(prostr, i,k);
		local infoTable = ss:str_view_getcontrol_info(controlscript);
		if infoTable[2] then
			resultstr=resultstr..infoTable[2]
		end			
		
		-- 更新查询字符串
		prostr = string.sub(prostr, k+1);
	end
	return resultstr
end



