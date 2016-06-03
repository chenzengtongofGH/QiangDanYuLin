--stringview
require("skygame.string.controldetail")
require("skygame.functions")
local strbase = require("skygame.string.stringbase");
local controlFactory = require("skygame.string.controlfactory")

-- ������ʾ
local LeftFlag1 = "<";
local LeftFlag2 = ">";
local RightFlag = "</>";
--[[
	CStringShow = {
		-- ������ϸ��Ϣ��
		stringDetailInfoTable = {},
		-- ��һ��������Ϣ
		firstinfo = nil,
		-- ǰһ���ؼ�������Ϣ
		lastInfo = nil,
		-- �ؼ���
		controlDetailInfoTable = {},
		-- ��һ���ؼ���Ϣ
		firstControlInfo = nil,
		-- ǰһ���ؼ���Ϣ
		lastControlInfo = nil,
		-- �ַ��� ����
		defaultFont = nil,
		-- �ַ��� ��ɫ
		defaultColor = nil,
		-- �ַ��� ��С
		defaultSize = nil,
		-- �м��
		defaultLineSpace = 0;
		-- ����
		stringwh = nil,
		-- ���ݳߴ� 1 w 2 h
		contentsize = {width=0,height=0},
		cntrolInfoByLine = {},
		--child�Ƿ���Ҫ��layerzoom
		needzoom = nil,
		hAlignment = 0, --ˮƽ���뷽ʽ0:��1.���У�2.�ұ�
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
	inputStr:	����
	font:		������
	color:		��ɫ{r,g,b}
	size:		�ߴ�
	wh:			���{w,h}
	linespace:	�м��
--]]
function CStringShow:str_view_wordwrap(inputStr, font, color, size, wh, linespace, usertable)
    -- ��������
    self:str_view_reset();
    inputStr = strbase.parseChgLine(inputStr)
    self.stringwh = wh;
    self.defaultFont = font;
    self.defaultColor = color;
    if size == nil then size = 24 end;
    self.defaultSize = size;
    self.userindex = 1
    self.usertable = usertable

    -- Ĭ���м��
    if linespace then
        self.defaultLineSpace = linespace;
    end

    local prostr = inputStr;
    -- ѭ���������֣�
    while true do
        -- Ѱ�ҿؼ�

        -- ���� '<'
        local i = string.find(prostr, LeftFlag1);
        if not i then
            --  ���û�� '<' ����û�нű�
            self:str_view_getinfo_bystr(prostr, false);
            break;
        end


        -- ��ͨ�ű�����
        local nromalstr = string.sub(prostr, 1, i - 1);
        self:str_view_getinfo_bystr(nromalstr, false);

        -- ���� "</>" j,kΪ��ֹ�±�
        local j, k = string.find(prostr, RightFlag);
        if j == nil then
            self:str_view_getinfo_bystr(string.sub(prostr, i), false);
            break
        end
        -- �ؼ��ű�����
        local controlscript = string.sub(prostr, i, k);
        self:str_view_getinfo_bystr(controlscript, true);
        -- ���²�ѯ�ַ���
        prostr = string.sub(prostr, k + 1);
    end
    self.layer = self:str_view_show_layer();
    self.layer:setContentSize(self.contentsize)
    self.layer:registerScriptHandler( function(e) if (e["name"] == "exit") then self:Del() end end);
    return self.layer;
end
-- ��������
function CStringShow:str_view_craete_cdi_list(cdi)
	--  ��������
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
	if (a and a >= 0x81 and a <= 0xfe) then --���ж�
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
-- �������ֵõ�������Ϣ
-- str		��Ҫ��ʾ������
-- isScript �Ƿ��ǽű�
-- �������֣��������ɵ���Ϣ��ӵ� stringDetailInfoTable ��
function CStringShow:str_view_getinfo_bystr(str, isScript)
	-- ��ͨ����
	if isScript == false then 
		local splitedStrs = self:SplitUtf8StringByLength(str, MAX_PER_STRING_LENGTH);
		for k,v in ipairs(splitedStrs) do
			-- ������ǽű����֣�ֱ�Ӷ�������ϸ��Ϣ������и�ֵ
			local cdi = self:CreateStringDetailInfo();
			cdi.m_type = 1;
			cdi.m_str = v--CSpriteBaseFun:Lua_g2u(v);
			cdi.m_color = self.defaultColor;
			cdi.m_size = self.defaultSize;
			cdi.m_font = self.defaultFont;
			--  ��������
			--print("create cdi:"..v);
			self:str_view_craete_cdi_list(cdi);
		end
		return;
	else
		-- �ű�����
		-- infoTable [1] �ǲ���key-value�� [2] ����������
		local infoTable = self:str_view_getcontrol_info(str);
		-- ���ֱ仯
		if infoTable[1].st == "Txt" then
			local splitedStrs = self:SplitUtf8StringByLength(infoTable[2], MAX_PER_STRING_LENGTH);
			for k,v in ipairs(splitedStrs) do
				local cdi = self:CreateStringDetailInfo();				
				-- ����ת�� gb2312 -> utf-8
				-- ������ʵ����
				cdi.m_str = v--CSpriteBaseFun:Lua_g2u(v);
				cdi:InitWithTable(infoTable)				
				--  ��������
				self:str_view_craete_cdi_list(cdi);				
			end
		end 
		
		local cdi
		if infoTable[1].st == "ChgLine" then-- ����
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
			--  ��������
		if cdi then self:str_view_craete_cdi_list(cdi); end
		end
end
--[[
 Description: 	�������ֽű�����
 Input:			str ��Ҫ����������
 Output:		table 
				[1] ����key-value��Ӧ��
				[2] ��ʵ����
 Author:		wz
 Date:			2013.5.24
 Modif Record:	
--]]
function CStringShow:str_view_getcontrol_info(str)
	-- ����'>'λ��
	local i = string.find(str, LeftFlag2);
	-- ���� "</>"λ��
	local j = string.find(str, RightFlag);
	-- �ؼ������ַ���
	local ci = string.sub(str, 2, i-1);
	-- ��װ�ո���������
	local paramPairs = lua_string_split(ci, " ");
	-- ����һ������ key-value ��Ӧ��
	local paramTable = {};
	-- ������ֽ�� ��key-value��Ӧ��ֵ
	for k, v in pairs(paramPairs) do
		-- ��ʽΪkey=value,���������á�=�����в��
		local a = lua_string_split(v, "=");
		paramTable[a[1]] = a[2];
	end
	-- ����
	local text = nil;
	-- �ж������Ƿ�Ϊ�գ���ť��ͼƬ�ȿ���Ϊ�գ�
	if j > i+1 then
		-- �õ��������� λ�� '>' �� "</>"֮��
		text = string.sub(str, i+1, j-1);
	end
	--tprint(paramTable);
	return {paramTable, text};
end


-----------------------------------------------------------------------------
--[[
 Description: 	����������Ϣ��������ʾ���ֵĲ�
 Input:			
 Output:		showlayer ��ʾ���ֵĲ�
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
	-- ����������Ϣ
	while true do
		e:printInfo();
		-- ������Ϣ���������ֿռ�����
		--self:str_view_create_control(e);
		self:str_view_create_control_v2(e)
		e = e.m_nextele;
		if e == nil then
			break;
		end
	end
	-- ������ֿؼ�����ʾ��
	local tmpCtrl = self.firstControlInfo;
	while tmpCtrl and true do --�������BUG
		if tmpCtrl.m_ele then
			showlayer:addChild(tmpCtrl.m_ele);
		end
		tmpCtrl = tmpCtrl.m_nextele;
		if tmpCtrl == nil then
			break;
		end
	end
	-- �޸��Ű� ���ÿؼ�λ��
	self:str_view_composing(showlayer);
	self:revise_y_when_different_size_in_one_line();
	return showlayer;
end

-- ����Y�����ϵ����겢���³ߴ�
function CStringShow:revise_y_when_different_size_in_one_line()
	if not self.firstControlInfo then
		return;
	end
	local curY = self.firstControlInfo.m_posy;

	self.contentsize.height = -curY;
	local contentWidth = self.contentsize.width
	for k,v in pairs(self.cntrolInfoByLine) do
		-- ��һ�в�����
		local height = v[MAX_H_FLAG];
		local lineWidth = 0
		self.contentsize.height = self.contentsize.height + height + self.defaultLineSpace;
		if k > 1 then 
			curY = curY - height - self.defaultLineSpace;						
			for k1,v1 in pairs(v) do								
				if k1 ~= MAX_H_FLAG and v1.m_ele then	
					--print("line:"..k..",string:"..CSpriteBaseFun:Lua_u2g(v1.m_stringinfo.m_str)..",H:"..self.contentsize[2]);		
					--v1.m_ele:setPosition(v1.m_posx, curY);
					--if v1.m_type == 4 then --ͼƬ
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
		if self.hAlignment == 1 then --����		
			if lineWidth < contentWidth then
				xoffset = (contentWidth - lineWidth)*0.5				
			end
		elseif self.hAlignment == 2 then --�Ҷ���
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
	m_w,	-- ��
	m_h,	-- ��
	m_ele,	-- �ؼ�
	m_preele,
	m_nextele,
	--]]
-- �Ű溯��
function CStringShow:str_view_composing(parentLayer)
	if not self.firstControlInfo then
		return;
	end

	local lineCtl = {};
	self.cntrolInfoByLine = {};
	
	local tmpCtrl = self.firstControlInfo;
	-- local tmpCtrl = self.controlDetailInfoTable[1];
	-- �������пؼ����޸����ǵ�λ�ã��������еȵ�
	while true do
		-- �޸�λ��
		--print(CSpriteBaseFun:Lua_u2g(tmpCtrl.m_stringinfo.m_str));
		
		if not tmpCtrl.m_preele then
			-- ���û�и����󣬱����ǵ�һ��
			-- �������λ��Ϊ 0,0 
			tmpCtrl.m_posx = 0;
			tmpCtrl.m_posy = 0;
		end
		-- �Ƿ����ֱ�־
		local processsplit = false;
		-- ���еı�־
		local changeline = false;	
		-- ����˿ؼ���ϢΪ ����(����Ҳ������Ϊһ�ֿؼ���Ϣ���뵽������)
		if tmpCtrl.m_type == 2 then
			-- ֱ�ӽ����б�־����Ϊtrue
			changeline = true;
		end
		-- �п�
		local lineWidth = 0
		--print(CSpriteBaseFun:Lua_u2g(tmpCtrl.m_stringinfo.m_str)..",posX:"..tmpCtrl.m_posx..",m_w:"..tmpCtrl.m_w..",linewidth:"..lineWidth);
		-- �ж��Ƿ���CC�ؼ�
		if tmpCtrl.m_ele then
			-- �õ��ؼ���� CC��������
			local scale = 1
			if tmpCtrl.m_stringinfo.scale then
				scale = tmpCtrl.m_stringinfo.scale.x
			end
			tmpCtrl.m_w = tmpCtrl.m_ele:getContentSize().width * scale;				
			--print("m_posx:" .. tmpCtrl.m_posx .. ",width:" .. tmpCtrl.m_w );
			
			-- ���д���  
			-- �ж��Ƿ��������п���������ã�Ҫ���л��д���
			if self.stringwh then	
				-- �п�		
				lineWidth = self.stringwh[1];
				-- ��ǰXλ�� + �ؼ���� > �п� ��Ҫ����
				if tmpCtrl.m_posx + tmpCtrl.m_w >  lineWidth then
					if not tmpCtrl:canSplit() then -- ���ɲ�ֿؼ�ֱ�ӻ���
						changeline = true
					else
						local availableLength = lineWidth - tmpCtrl.m_posx;
						local overlength = tmpCtrl.m_w - availableLength
						local stringInfo = tmpCtrl.m_stringinfo;	
						local charsize = self:get_charsize(stringInfo.m_str, tmpCtrl.m_w);
						
						if availableLength < 2 * charsize then --and tmpCtrl.m_w < lineWidth then 
							-- ��������������������������Ҫ��Ϊ���ж������ֽ��в�֣�ֱ�ӻ��оͺ�
							changeline = true;
						else		
							--sBaseFun:CCLuaLog("length:"..availableLength.."charsize:"..charsize)
							-- �����������������˵���������֮ǰ���ɵĿؼ����в�֣���������Ҫ��
							-- �õ���ǰ�л�������ʾ�Ŀ��																			
							-- �������
							local strTable = self:split_utf8_string_by_size(tmpCtrl.m_stringinfo.m_str, {availableLength, lineWidth}, charsize);
							-- ���Label
							local splitStrCount = table.getn(strTable);
							if splitStrCount > 1 then
								local splitretun = self:split_stringdetailinfo(stringInfo, strTable);
								-- ����ֺ����Ϣ�������µĽڵ�
								if splitretun then
									-- �������Ϣ����ֿؼ�,���ز�ֺ�ĵ�һ���ؼ�
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

		-- ��ӿؼ�������
		if changeline == true then
			tmpCtrl.m_posx = 0;
			tmpCtrl.m_posy = tmpCtrl.m_posy - tmpCtrl.m_stringinfo.m_size - self.defaultLineSpace;			
			table.insert(self.cntrolInfoByLine,lineCtl);
			lineCtl	= {};
		end
		-- ����в�ֿؼ�������������Ĵ���
		if not processsplit then			
			if not lineCtl[MAX_H_FLAG] or lineCtl[MAX_H_FLAG] < tonumber(tmpCtrl.m_stringinfo.m_size) then
				lineCtl[MAX_H_FLAG] = tonumber(tmpCtrl.m_stringinfo.m_size);
			end
			table.insert(lineCtl, tmpCtrl);
			
			--print("===:"..CSpriteBaseFun:Lua_u2g(tmpCtrl.m_stringinfo.m_str)..",x:"..tmpCtrl.m_posx..",y:"..tmpCtrl.m_posy);
			if tmpCtrl.m_ele then			
				local curX,curY = tmpCtrl.m_posx,tmpCtrl.m_posy
				--if tmpCtrl.m_type == 4 then --ͼƬ
				--	curY = curY - (tmpCtrl.m_ele:getContentSize().height-self.defaultSize-self.defaultLineSpace)*0.5
				--end
				local cdi = tmpCtrl.m_stringinfo
				if cdi.offset then
					curX = curX+cdi.offset.x
					curY = curY+cdi.offset.y
				end
				tmpCtrl.m_ele:setPosition(curX, curY);

				-- ���³���ֻҪ�ⲿָ���˿�ȣ����ٶ�̬����
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
			-- ���¿ؼ�λ��
			if tmpCtrl.m_ele then
				local curX,curY = tmpCtrl.m_posx,tmpCtrl.m_posy
				--if tmpCtrl.m_type == 4 then --ͼƬ
				--	curY = curY - (tmpCtrl.m_ele:getContentSize().height-self.defaultSize-self.defaultLineSpace)*0.5
				--end
				local cdi = tmpCtrl.m_stringinfo
				if cdi.offset then
					curX = curX+cdi.offset.x
					curY = curY+cdi.offset.y
				end
				tmpCtrl.m_ele:setPosition(curX, curY);

				-- ���³���ֻҪ�ⲿָ���˿�ȣ����ٶ�̬����
				--if (not self.stringwh) or (tmpCtrl.m_posx + tmpCtrl.m_w < lineWidth and tmpCtrl.m_posx + tmpCtrl.m_w > self.contentsize.width) then
				if not self.stringwh then
					-- ���ؿ��
					self.contentsize.width = tmpCtrl.m_posx + tmpCtrl.m_w;
				else
					self.contentsize.width = lineWidth;
				end
				self.contentsize.height = -tmpCtrl.m_posy + tmpCtrl.m_stringinfo.m_size;
			end
		end
	end
end
-- ȡ�ô�С
function CStringShow:getContentSize()
	return self.contentsize;
end
-- ����͸����
function CStringShow:setOpacity(value)
	for k,v in pairs(self.controlDetailInfoTable) do
		if v.m_ele then
			v.m_ele:setOpacity(value);
		end
	end
end
-- ����
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
-- ɾ��
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
 Description: 	���һ���µĿؼ���Ϣ���ؼ���Ϣ������
 Input:			newctrl �µĿؼ���Ϣ
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

-- �����ؼ� version:2
function CStringShow:str_view_create_control_v2(ci)
    local control,success = controlFactory.create(ci);
    if success then
		if control then
			control:retain() -- ��ֹ��ɾ��				
		end				
		-- ����һ���µĿؼ���Ϣ���󣬲���ӵ�������
		local newControl = CControl_Detail_Info.new({ci.m_type,0,0,0,0,control,nil,nil,ci});						
		self:str_view_craete_newcontrol_list(newControl);
		return newControl;
    else
		sg_log.warning("Invalid control type:"..ci.m_type.." in str_view_create_control_v2");
	end	
	--return newControl;
end
--[[
 Description: 	���ݵ�ǰ��ʣ���Ⱥ��п������ְ��в��
 Input:			str Դ����
				perlength [1] ��ǰ��ʣ���� [2] �����п�
				charsize �����ַ����
 Output:		ÿ��������ɵ�table
 Author:		wz
 Date:			2013.5.24
 Modif Record:	
--]]
function CStringShow:split_string_by_size(str, perlength, charsize)
	-- ����ת�� utf-8 -> gb2312
	str =  CSpriteBaseFun:Lua_u2g(str);
	--print("split_string_by_size:"..str);
	-- ���㵱ǰ���ܷż����ַ�
	local lineCharCount = perlength[1] / (charsize);
	-- ���һ���ַ����Ų��£�˵���ѵ���ĩ�����ұ����ַ����ȴ��ڿ��
	-- ������ÿ���ܷ��¶��ٸ��ַ�
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
			-- ���������1��ԭ����:C++���������Ǵ�0��ʼ��
			local returnvalue =  isChineseCh(tmpStr,curCharIdx)--CSpriteBaseFun:IsChinese(tmpStr, curCharIdx);
			local addValue = 1;
			if returnvalue == 1 then
				-- �����ַ���һ������ռ�����ֽ�
				addValue = 2;
			end
			if curCharIdx -1 + addValue > lineCharCount then
				break;
			else
				-- ���³���
				subStrLen = curCharIdx + (addValue - 1);
				-- ���û�г������ȣ���������
				curCharIdx = curCharIdx + addValue;
				
			end
		end
		if subStrLen ~= 0 then
			subStrLen =  subStrLen --+ 1;
			local lineStr = string.sub(tmpStr, 1, subStrLen);
			table.insert(returnStrTable, lineStr);
			tmpStr = string.sub(tmpStr, subStrLen + 1);
		end
		-- �ӵڶ��п�ʼ,ʹ�ú����п�
		lineCharCount = perlength[2]/(charsize);
	end
	--tprint(returnStrTable);
	return returnStrTable;
end
function CStringShow:split_utf8_string_by_size(str, perlength, charsize)

	-- ���㵱ǰ���ܷż����ַ�
	local lineCharCount = perlength[1] / (charsize);
	-- ���һ���ַ����Ų��£�˵���ѵ���ĩ�����ұ����ַ����ȴ��ڿ��
	-- ������ÿ���ܷ��¶��ٸ��ַ�
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

		-- �ӵڶ��п�ʼ,ʹ�ú����п�
		lineCharCount = math.floor(perlength[2]/charsize);
	end
	--tprint(returnStrTable);
	return returnStrTable;
end
-- ��һ��stringdetailinfo��ֳɶ��
-- ����
-- sid һ��CStringDetailInfo����
-- stringTable �ַ�����
-- ����ֵ
-- [0] ��ֺ�ĵ�һ��CStringDetailInfo����
-- [1] ��ָ���
function CStringShow:split_stringdetailinfo(sdi, stringTable)
	local length = table.getn(stringTable);
	if  length <= 1 then
		return nil;
	end
	local lastsdi = sdi.m_preele;
	-- ��һ���ڵ�
	local fi = nil;
	for i=1, length do
		local newSdi = CString_Detail_Info.new();
		-- ��ԭ�ڵ����ݿ���һ��
		newSdi:copy(sdi);
		newSdi.m_str = stringTable[i]--CSpriteBaseFun:Lua_g2u(stringTable[i]);	
		if lastsdi then	
			-- ��sdiΪ��һ����ʱ������lastsdiΪ��
			lastsdi.m_nextele = newSdi;
		end
		newSdi.m_preele = lastsdi;
		lastsdi = newSdi;
		if not fi then
			fi = newSdi;
		end
		table.insert(self.stringDetailInfoTable, newSdi);
	end
	-- �ӱ���ɾ��
	table.remove(sdi);
	
	return {fi, length}
end
-- ����
-- splitretun[1] ��ֺ�ĵ�һ��CStringDetailInfo����
-- splitretun[2] ��ָ���
function CStringShow:split_controldetailinfo(splitretun, besplitedctrl, parentLayer)
	--print("split_controldetailinfo:" .. CSpriteBaseFun:Lua_u2g(besplitedctrl.m_stringinfo.m_str))
	-- ����ǰһ���ؼ�Ϊ besplitedctrl ��ǰһ���ؼ�
	self.lastControlInfo = besplitedctrl.m_preele;
	-- �����һ���ؼ�ΪҪ����ֵĿؼ����������
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
--���menu������Ҫ������Ӧ�ȼ�
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
	-- ѭ���������֣�
	while true do 	
		-- Ѱ�ҿؼ�
		
		-- ���� '<'
		local i= string.find(prostr, LeftFlag1);
		if not i then
			--  ���û�� '<' ����û�нű�
			resultstr = resultstr..prostr
			break;
		end
						
		-- ��ͨ�ű�����		
		local nromalstr = string.sub(prostr,1,i-1);
		resultstr = resultstr..nromalstr
		
		-- ���� "</>" j,kΪ��ֹ�±�
		local j,k= string.find(prostr, RightFlag);
		if j == nil then
			resultstr = resultstr.. string.sub(prostr,i);
			break
		end
		
		-- �ؼ��ű�����
		local controlscript = string.sub(prostr, i,k);
		local infoTable = ss:str_view_getcontrol_info(controlscript);
		if infoTable[2] then
			resultstr=resultstr..infoTable[2]
		end			
		
		-- ���²�ѯ�ַ���
		prostr = string.sub(prostr, k+1);
	end
	return resultstr
end



