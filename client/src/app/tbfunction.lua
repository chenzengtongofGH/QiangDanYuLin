-- sg_resources.lua
require("skygame.sg_basefun")
-- 判断C++对象是否存在
-- @object：UserData对象
function G_isUserDataValid(object)
	if object and not tolua.isnull(object) then
		return true
	end
end

-- des      :资源管理相关接口
-- author   :czt
-- data     :2015年1月8日14:37:15
--获取自动释放等级
function getAutoFreeLevel(key)
	if not g_get_autofreeinfo or not g_get_autofreeinfo() then
		return 300
	end
	if(key) then
		local freeInfo = g_get_autofreeinfo()[key]
		if(freeInfo) then
			return freeInfo[3]
		end
	end
	return 300
end
-- 平台判断
function is_win32()
	if device.platform == "windows" then
		return true;
	else
		return false;
	end
end
--添加资源进入自动释放
function addToAutoFree(key,assetName,at)
	local freelevel
	if(at == 2) then
		local asset = string.gsub(assetName,".plist","")
		freelevel = getAutoFreeLevel(asset)
	else
		freelevel = getAutoFreeLevel(key)
	end
	if(freelevel) then
		CResourceManager:getInstance():addAsset(assetName,at,freelevel)
	end
end

--[[
des     : 设置图片格式(该功能暂时只支持android)
input   : format 格式
return  : nil
autor   : 
date    : 2015年1月8日
--]]
function setPicFormat(format)
	if is_win32() then
		return 
	end
	if format == "rgb565" then
		cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565)
	elseif format == "rgba4444" then
		cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444)			
	else
		cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	end							
end

function getPicFormat(format)
	if format == "rgb888" then
		return cc.TEXTURE2_D_PIXEL_FORMAT_RG_B888
	elseif format == "rgba4444" then
		return cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444		
	else
		return cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888
	end								
end

--预加载图片资源
function sg_preloadAsset(key,ft)
	if(key) then
		local pathInfo = sg_getresinfo(key)
		if pathInfo then
			ft = ft or 0
			local format = getPicFormat(pathInfo[3])
			--先加载plist			
			local at = pathInfo[2]
			local newfile = pathInfo[1]
			if format then
				CResourceManager:getInstance():addAssetToPreload(newfile,at,ft,format)
			else
				CResourceManager:getInstance():addAssetToPreload(newfile,at,ft)
			end
		end
	end
end

--[[
des     : 加载资源
input   : key - resDB中资源对应的key
return  : 资源索引,资源类型
autor   : 
date    : 2015年1月8日14:49:58
--]] 
function sg_loadResources(key)
    -- 得到资源详细配置信息
	local conf = sg_getresinfo(key);
    if not conf then
        return;
    end

    -- restype 0 散图 1 plist
	local newfile,restype,format = unpack(conf)
     
	local image
	if restype == ccui.TextureResType.localType then	
		image=newfile
	else
		image=key
	end
    -- 设置图片格式
	setPicFormat(format)

    -- 加载资源
	if restype == ccui.TextureResType.localType then
		cc.Director:getInstance():getTextureCache():addImage(image)
	else 
		--display.loadSpriteFrames();
        cc.SpriteFrameCache:getInstance():addSpriteFrames(newfile);--添加plist
	end
	setPicFormat();
	--addToAutoFree(key,newfile,restype)
	return image, restype;
end

-- 检查资源是否存在
function sg_checkResExist(key)
	if not key then
		sg_log.errormsg("[dmx]key is nil");
		return false;
	end	
	
	local conf = getResInfo(key);
	if not conf then
		sg_log.warning("[dmx]Can't find config:" .. key);
		return false;
	end
	
	if cc.FileUtils:getInstance():isFileExist(conf[1]) then
		return true;
	else
		local newconf = string.gsub(conf[1],".png",".plist")
		if cc.FileUtils:getInstance():isFileExist(newconf) then
			return true
		end
		sg_log.warning("[dmx]File is not exist:" .. conf[1]);
		return false;
	end	
end

local res_path_table = nil;
--[[
des     : 获取资源详细信息
input   : key - resDB中资源对应的key
return  : 资源详细信息table
autor   : 
date    : 2015年1月8日
--]]
function sg_getresinfo(key)
	if not res_path_table then
		res_path_table = require("app.conf.resDB");
	end		
	return res_path_table[key]
end

--[[
des     : 读取CSB文件
input   : key 资源索引 resetsize 1 重置 2 不重置
return  : node
autor   : 
date    : 2015年1月13日   
--]]
function sg_load_csb(key, resetsize)
    if not key then
        return;
    end
    resetsize = resetsize or 1;
    local conf = sg_getresinfo(key);
    if not conf then 
        sg_log.warning("Can't find csb file:" .. key);
        return;
    end
    local node = cc.CSLoader:createNode(conf[1])
    if not node then
        sg_log.warning("load csb file failed:" .. key);
        return;
    end
    if resetsize == 1 then
        node:setContentSize(display.width, display.height);

        ccui.Helper:doLayout(node);
--        local ctrls = node:getChildren();
--        for k,v in pairs(ctrls) do
--            local com = v:getComponent("__ui_layout");
--            if com then
--                com:refreshLayout();
--            end
--        end
    end
    return node;
end
--[[
des     : 读取CSB文件里面的动画
input   : key 资源索引 isloop true 循环 false不循环，默认不循环
return  : action
autor   : czt
date    : 2015年1月13日   
--]]
function sg_load_csb_action(key,isloop)
    if not key then
        return;
    end
    local conf = sg_getresinfo(key);
     if not conf then 
        sg_log.warning("Can't find csb file:" .. key);
        return;
    end
    local action = cc.CSLoader:createTimeline(conf[1])
    if not action then
        sg_log.warning("load csb file failed:" .. key);
        return;
    end
    local isloop  = isloop or false;
 
    action:gotoFrameAndPlay(0,isloop)
--    local node = cc.CSLoader:createNode(conf[1])
--    node:setContentSize(display.width, display.height);
--    ccui.Helper:doLayout(node);
    return action;
end
--[[
des     : 获取csb文件中的子对象(可递归子对象)
input   : root csb返回对象
          name 子对象名
return  : node
autor   : wz
date    : 2015年2月12日
--]]
function sg_get_child_by_name(obj, name)
    local children = obj:getChildren();
    for k,v in pairs(children) do
        if v:getName() == name then
            return v;
        else 
            local n = sg_get_child_by_name(v, name);
            if n then
                return n;
            end 
        end
    end
    return nil;
end
--[[
sg_get_button_by_name_Table_addTouchListen
input   : root csb
              cb触摸函数
              tab按钮列表
autor   : czt
date    : 2015年5月16日
--]]
function sg_get_button_by_name_Table_addTouchListen(obj, tab,cb)
    for k,v in pairs (tab) do 
        local btn = sg_get_child_by_name(obj,v);
        if cb then 
            btn:addTouchEventListener(cb);
        end
    end
end
--[[
des     : 获取csb文件中对象的标签和位置
          主要用于地图中刷怪地点
input   : root csb返回对象
          name 子对象名
return  : 所有同名字的对象信息表
autor   : wz
date    : 2015年1月13日   
--]]
function sg_get_csb_children(root,name)
    local childTab  = root:getChildren()
    local returnTab = {};
    for  k,v in pairs (childTab) do 
        if v:getName()  == name then 
            local sx = string.format("%.2f",v:getPositionX());
            local sy = string.format("%.2f",v:getPositionY());
            local userdata = CBaseFun:get_node_userdata(v);
            table.insert(returnTab,{v:getTag(),sx,sy, userdata})
        end
    end
    return returnTab;
end

--[[
des     : 注册动画事件
input   : 
return  : 
autor   : 
date    :    
--]]
function  sg_regist_movementevent_complete_callfunc(armature, aniname, startcb, completecb, loopcompletecb)
    if not armature then
        return;
    end
    armature:getAnimation():setMovementEventCallFunc(function (arm, eventType, movmentID)
         if aniname == movmentID then
             if eventType == ccs.MovementEventType.start then
                if startcb then
                    startcb();
                end
             elseif eventType == ccs.MovementEventType.complete then
                if completecb then
                    completecb();
                end;
             elseif eventType == ccs.MovementEventType.loopComplete then
                if loopcompletecb then
                    loopcompletecb();
                end
             end 
         end
         end);
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
--[[
des     : 创建一个Armature
input   : key 资源索引
return  : node
autor   : wz
date    : 2015年1月13日   
--]]
function sg_create_armature(key)
    local conf = sg_getresinfo(key);
    if not conf then 
        sg_log.warning("Can't find armature file:" .. key);
        return;
    end

	local jsonname = conf[1]	
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(jsonname);	
	--根据路径获取名称
	local tempname = conf[1]
	tempname = string.gsub(tempname,"/",".")	
	local temptable = lua_string_split(tempname,"%.")	
	if table.getn(temptable) <= 2 then
		return nil
	end
	local name = temptable[table.getn(temptable)-1]	
	roleAnimation = ccs.Armature:create(name);
	if not roleAnimation then
		sg_log.warning("create animation " .. key .. " failed!");
		return nil;
	end	
	return roleAnimation;	
end

function sg_set_aramture_shader(t, armature, ...)   
    if not G_isUserDataValid(armature) then
        return;
    end

    local args = {...};
    local flag = args[1];
    if flag == false then
        G_SetShader(armature, nil, false);
    else
        local children = armature:getSkinList()
        for i, k in pairs(children) do
            local fun = SHADER_FUN[t];
            if fun then
                fun(k, ...);
            end
        end       
    end
end

--[[
des     : 读取MapDB
input   : 资源索引
return  : 资源
autor   : czt
date    : 2015年1月14日   
--]]
local MapDB_path_table = nil;
function sg_getMapDBinfo(key)
    if not MapDB_path_table then 
       MapDB_path_table = require("app.conf.MapDB")
    end
     
    return MapDB_path_table[key]
end

--[[
des     : 替换armature部件
input   : armature  动画对象
          bonename  骨骼名字
          partname  部件索引
return  : node
autor   : 
date    : 2015年1月13日   
--]]
function sg_change_arature_parts(armature, bonename, partname)
    local bone = armature:getBone(bonename);
    if not bone then
        --print("Can't find bone named:" .. bonename);
        return;
    end
    local l = bone:getDisplayRenderNode();
    if partname and string.len(partname) ~= 0 then      
        if l then     
            l:setVisible(true);
        end
        local resinfo = sg_getresinfo(partname);
        
        local skin = nil;
        local restype = resinfo[2];
        local respath = resinfo[1];
        if restype == ccui.TextureResType.localType then
            skin = ccs.Skin:create(respath);
        else
            skin = ccs.Skin:createWithSpriteFrameName(respath);
        end
        bone:addDisplay(skin, 0);
        bone:changeDisplayWithIndex(0, true);
    else
        if l then
            l:setVisible(false);
        end
    end
end

function sg_play_effect(file, effname, autodel, loop, cb)
    if not file or not effname or string.len(file) == 0 or string.len(effname) == 0 then
        return nil;
    end
    --sg_log.info("play effect:" .. file .. " -- " .. effname);
    loop = loop or -1;
    if autodel == nil then
        autodel = true;
    end
    local armature = sg_create_armature(file);
    armature:getAnimation():play(effname,-1, loop);
    local function completcb()
        if cb then
            cb()
        end
        if autodel == true and G_isUserDataValid(armature) then
            armature:removeFromParent(true);
        end
    end
    sg_regist_movementevent_complete_callfunc(armature, effname, nil, completcb, completcb);
    return armature;
end

function sg_create_particle(key)
    local conf = sg_getresinfo(key);
    if not conf then 
        sg_log.warning("Can't find particle file:" .. key);
        return;
    end

    local plist_name = conf[1];
    local particel_node = cc.ParticleSystemQuad:create(plist_name);
    return particel_node;
end

function sg_add_node_to_armature_bone(armature, bonename, node)
    if not G_isUserDataValid(armature) then
        return;
    end
    local bone = armature:getBone(bonename);
    if not bone then
        --print("Can't find bone named:" .. bonename);
        return;
    end
    if node then      
        bone:addDisplay(node, 0);    
        bone:changeDisplayWithIndex(0, true);
    else
        bone:changeDisplayWithIndex(-1, true);
    end
end
--[[
des     : 替换armature部件
input   : armature  动画对象
          bonename  骨骼名字
          partname  部件索引
          aniname   对应动作名(种族男女)
return  : node
autor   : 
date    : 2015年1月13日   
--]]
function sg_change_arature_parts_ex(armature, bonename, partname, aniname,isSmallEquip,EquipId)
    local bone = armature:getBone(bonename);
    if not bone then
        --print("Can't find bone named:" .. bonename);
        return;
    end
    local l = bone:getDisplayRenderNode();
    if partname and string.len(partname) ~= 0 then      
        if l then     
           l:setVisible(true);
        end
        local resinfo = sg_getresinfo(partname);
        if resinfo then
            local skin = nil;
            local restype = resinfo[2];
            local respath = resinfo[1];

            local armature = sg_create_armature(partname); 
            if armature then
                local ani = armature:getAnimation():getAnimationData();
                local movement = ani:getMovement(aniname);
                if not movement and EquipId  then 
                        movement =ani:getMovement(EquipId);
                end
                --以下做小部件处理
                if isSmallEquip then 
                    if movement then 
                        bone:addDisplay(armature, 0);    
                        bone:changeDisplayWithIndex(0, true);
                        return armature; 
                    else 
                        return;
                    end
                else
                    bone:addDisplay(armature, 0);    
                    bone:changeDisplayWithIndex(0, true);
                    return armature; 
                end
            end
        end
    else
        bone:changeDisplayWithIndex(-1, false);
    end
end
--[[
des     : 读取plist文件
input   : key,remove移除
return  : none
autor   : czt
date    : 2015年3月6日   
--]]
function sg_SpriteFrames(key,remove)
     local info = sg_getresinfo(key);
     if not info then
        return;
     end
     local plisttype  =1 ;
     if info[2] ~= plisttype then 
        return ;
     end
     local Nplist= info[1];
     local Npng = string.gsub(Nplist, ".plist", ".png");
     if remove == true then 
        display.removeSpriteFrames(Nplist,Npng);
     else
        display.loadSpriteFrames(Nplist,Npng);
     end   
end

-- 创建一个帧动画
function sg_frame_animation(key, format, framecount, interval)
    sg_SpriteFrames(key);

    interval = interval or 0.03;

    local first_sprite = string.format(format, 1);
    local render = cc.Sprite:createWithSpriteFrameName(first_sprite)

    local anim_frames = { }
    for i = 1, framecount do
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format(format, i));
        anim_frames[i] = frame;
    end
    local animation = cc.Animation:createWithSpriteFrames(anim_frames, interval);
    render:runAction(cc.RepeatForever:create(cc.Animate:create(animation)));
    return render;
end

function sg_get_child_by_name_addToNode (obj,name,Addobj)
    local Node_killmonster = sg_get_child_by_name(obj,name);
    Addobj:addTo(Node_killmonster);
    return Addobj;
end
--[[
des     : 创建一个sprite
input   : key
return  : Sprite
autor   : czt
date    : 2015年3月6日   
--]]
function CreateSprite(key)
    local conf = sg_getresinfo(key);
    if not conf then
        return;
    end

    --local source, restype = sg_loadResources(key);
    local Sp = display.newSprite(conf[1]);
    return Sp;
end

--[[
des     : 创建一个sprite
input   : key
return  : Sprite
autor   : czt
date    : 2015年3月6日   
--]]
function CreateScale9Sprite(key,fullRect,insetRect)
    local conf = sg_getresinfo(key);
    if not conf then
        return;
    end
    local Sp=nil
    if fullRect==nil then
        Sp = ccui.Scale9Sprite:create(conf[1])
    else
        Sp = ccui.Scale9Sprite:create(conf[1],fullRect,insetRect)--display.newSprite(conf[1]);
    end
    return Sp;
end

-- 重新加载Lua文件
function G_Reload(filename)
	if package.loaded[filename] ~= nil then
		package.loaded[filename] = nil;
	end
	return require(filename);
end

function G_RAD_TWO_POINT(b_role,e_role)
    local des_x = e_role.x - b_role.x ;
    local des_y = e_role.y - b_role.y ;
    if des_x == 0 and des_y == 0 then 
        return 0;
    end

    if des_x > 0 and des_y == 0 then
        return 0;
    end

    if des_x < 0 and des_y == 0 then
        return math.pi;
    end

    if des_x == 0 and des_y > 0 then 
        return math.pi / 2;
    end
    if des_x == 0 and des_y < 0 then 
        return math.pi / 2 * 3;
    end

    if des_x > 0 and des_y > 0 then 
        return math.atan(des_y / des_x);
    end

    if des_x < 0 and des_y > 0 then 
        return math.pi  - math.atan(des_y / -des_x);
    end

    if des_x < 0 and des_y < 0 then 
        return math.pi + math.atan(-des_y / -des_x);
    end

    if des_x > 0 and des_y < 0 then 
        return math.pi * 2 - math.atan(-des_y / des_x);
    end


    return 0;
end

function G_TWO_ROLE_POINT(b_role,e_role) 
    local des_x =  e_role.x - b_role.x;
    local des_y =  e_role.y - b_role.y;

    if des_x == 0 and des_y>0 then 
        return Role_DIR_Point.NONE_TOP;
    elseif des_x == 0 and des_y<0 then
        return Role_DIR_Point.NONE_BUTTOM;
    elseif des_x > 0 and des_y==0 then
        return Role_DIR_Point.RIGHT_NONE;
    elseif des_x < 0 and des_y==0 then
        return Role_DIR_Point.LEFT_NONE;
    elseif des_x >0 and des_y>0 then --1
        return Role_DIR_Point.RIGHT_TOP;
    elseif des_x<0 and des_y>0 then --2
        return Role_DIR_Point.LEFT_TOP;
    elseif des_x >0 and des_y<0 then --4
        return Role_DIR_Point.RIGHT_BUTTOM;
    elseif des_x<0 and des_y<0 then --3
        return Role_DIR_Point.LEFT_BUTTOM;
    end

end
function G_TWO_ROLE_Next_POINT(b_role,e_role,speed)
        local monster_speed = speed;
        local des_x =  e_role.x - b_role.x;
        local des_y =  e_role.y - b_role.y;

        local three_line = math.sqrt(des_x*des_x + des_y*des_y);
        local x_rad =  des_y / three_line;
        local y_rad = des_x / three_line;
        local speedx = 0;
        local speedy = 0;

        local need_line = 6;

        if des_x >0 and des_y>0 then --1
            speedx = monster_speed * math.cos(x_rad);
            speedy = monster_speed * math.sin(x_rad);
        elseif des_x<0 and des_y>0 then --2
            speedx = -monster_speed * math.cos(x_rad);
            speedy = monster_speed * math.sin(x_rad);
        elseif des_x >0 and des_y<0 then --4
            speedx = monster_speed * math.cos(y_rad);
            speedy = -monster_speed * math.sin(y_rad);
        elseif des_x<0 and des_y<0 then --3
            speedx = -monster_speed * math.cos(y_rad);
            speedy = monster_speed * math.sin(y_rad);
        end

        if math.abs(des_x) <= need_line and des_y ~= 0 then 
            if des_y >0 then --人要向上
                speedy = monster_speed;--地图向下
            else
                speedy = -monster_speed;
            end
            speedx = 0;
        end

        if des_x~=0 and math.abs(des_y)<= need_line then 
            if des_x >0 then --人要向右
                speedx = monster_speed;--地图向左
            else
                speedx = -monster_speed;
            end
            speedy = 0;
        end

        return b_role.x + speedx,b_role.y + speedy

end

--[[
des     : 文字配置
input   : id
return  : 文字
autor   : czt
date    : 2016年6月23日
--]]
function G_GetString(id)
 	if not string_db then
		string_db = G_Reload("app.conf.stringdb").stringName;
	end		
    local str = string_db[id];
    if not str then
        sg_log.warning("Can't find string config:" .. id);
        return nil;
    end
	return str;   
end