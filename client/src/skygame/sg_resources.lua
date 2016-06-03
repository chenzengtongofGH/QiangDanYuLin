-- sg_resources.lua

-- des      :��Դ������ؽӿ�
-- author   :
-- data     :2015��1��8��14:37:15

require "skygame.sg_basefun"

--��ȡ�Զ��ͷŵȼ�
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
--�����Դ�����Զ��ͷ�
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
des     : ����ͼƬ��ʽ(�ù�����ʱֻ֧��android)
input   : format ��ʽ
return  : nil
autor   : 
date    : 2015��1��8��
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

--Ԥ����ͼƬ��Դ
function sg_preloadAsset(key,ft)
	if(key) then
		local pathInfo = sg_getresinfo(key)
		if pathInfo then
			ft = ft or 0
			local format = getPicFormat(pathInfo[3])
			--�ȼ���plist			
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
des     : ������Դ
input   : key - resDB����Դ��Ӧ��key
return  : ��Դ����,��Դ����
autor   : 
date    : 2015��1��8��14:49:58
--]] 
function sg_loadResources(key)
    -- �õ���Դ��ϸ������Ϣ
	local conf = sg_getresinfo(key);
    if not conf then
        return;
    end

    -- restype 0 ɢͼ 1 plist
	local newfile,restype,format = unpack(conf)
     
	local image
	if restype == ccui.TextureResType.localType then	
		image=newfile
	else
		image=key
	end
    -- ����ͼƬ��ʽ
	setPicFormat(format)

    -- ������Դ
	if restype == ccui.TextureResType.localType then
		cc.Director:getInstance():getTextureCache():addImage(image)
	else
		--display.loadSpriteFrames();
        cc.SpriteFrameCache:getInstance():addSpriteFrames(newfile);--���plist
	end
	setPicFormat();
	addToAutoFree(key,newfile,restype)
	return image, restype;
end
-- �����Դ�Ƿ����
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
des     : ��ȡ��Դ��ϸ��Ϣ
input   : key - resDB����Դ��Ӧ��key
return  : ��Դ��ϸ��Ϣtable
autor   : 
date    : 2015��1��8��
--]]
function sg_getresinfo(key)
	if not res_path_table then
		res_path_table = G_Reload("app.conf.resDB");
	end		
	return res_path_table[key]
end

--[[
des     : ��ȡCSB�ļ�
input   : key ��Դ���� resetsize 1 ���� 2 ������
return  : node
autor   : 
date    : 2015��1��13��   
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
des     : ��ȡCSB�ļ�����Ķ���
input   : key ��Դ���� isloop true ѭ�� false��ѭ����Ĭ�ϲ�ѭ��
return  : action
autor   : czt
date    : 2015��1��13��   
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
des     : ��ȡcsb�ļ��е��Ӷ���(�ɵݹ��Ӷ���)
input   : root csb���ض���
          name �Ӷ�����
return  : node
autor   : wz
date    : 2015��2��12��
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
              cb��������
              tab��ť�б�
autor   : czt
date    : 2015��5��16��
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
des     : ��ȡcsb�ļ��ж���ı�ǩ��λ��
          ��Ҫ���ڵ�ͼ��ˢ�ֵص�
input   : root csb���ض���
          name �Ӷ�����
return  : ����ͬ���ֵĶ�����Ϣ��
autor   : wz
date    : 2015��1��13��   
--]]
function sg_get_csb_children(root,name)
    local childTab  = root:getChildren()
    local returnTab = {};
    for  k,v in pairs (childTab) do 
        if v:getName()  == name then 
            local sx = string.format("%.2f",v:getPositionX());
            local sy = string.format("%.2f",v:getPositionY());
            local userdata_str = CBaseFun:get_node_userdata(v);
            local userdata = sg_parse_userdata(userdata_str);
            table.insert(returnTab,{v:getTag(),sx,sy, userdata, v})
        end
    end
    return returnTab;
end

function sg_parse_userdata(str)
    local str_table = lua_string_split(str, ",");
    local userdata = {};
    for k, v in pairs(str_table) do
        local keyvalue = lua_string_split(v, "=");
        if keyvalue and #keyvalue == 2 then
            local key = tostring(keyvalue[1]);
            userdata[key] = keyvalue[2];
        end
    end
    return userdata;
end

--[[
des     : ע�ᶯ���¼�
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

--[[
des     : ����һ��Armature
input   : key ��Դ����
return  : node
autor   : wz
date    : 2015��1��13��   
--]]
function sg_create_armature(key,actionname,loop)
    local conf = sg_getresinfo(key);
    if not conf then 
        sg_log.warning("Can't find armature file:" .. key);
        return;
    end

	local jsonname = conf[1]	
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(jsonname);	
	--����·����ȡ����
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
    if actionname  then
        roleAnimation:getAnimation():play(actionname) 
    end
	return roleAnimation;	
end

function sg_set_aramture_shader(t, armature, ...)   
    if not G_isUserDataValid(armature) then
        return;
    end

    local args = {...};
    local flag = args[1];
	
	G_ShaderArmature(t,armature, ...)

--[[    local children = armature:getSkinList()
    for i, k in pairs(children) do
        local fun = SHADER_FUN[t];
        if fun then
            fun(k, ...);
        end
    end--]]       
end

--[[
des     : ��ȡMapDB
input   : ��Դ����
return  : ��Դ
autor   : czt
date    : 2015��1��14��   
--]]
local MapDB_path_table = nil;
function sg_getMapDBinfo(key)
    if not MapDB_path_table then 
       MapDB_path_table = G_Reload("app.conf.MapDB")
    end
     
    return MapDB_path_table[key]
end

--[[
des     : �滻armature����
input   : armature  ��������
          bonename  ��������
          partname  ��������
return  : node
autor   : wz
date    : 2015��1��13��   
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
    loop = loop or -1;
    if autodel == nil then
        autodel = true;
    end
    local armature = sg_create_armature(file);

    local movement = armature:getAnimation():getAnimationData():getMovement(effname);
    if not movement then
        return nil;
    end

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
des     : �滻armature����
input   : armature  ��������
          bonename  ��������
          partname  ��������
          aniname   ��Ӧ������(������Ů)
return  : node
autor   : wz
date    : 2015��1��13��   
--]]
function sg_change_arature_parts_ex(armature, bonename, partname, aniname,isSmallEquip,EquipId)
    local bone = armature:getBone(bonename);
    if not bone then
        --print("Can't find bone named:" .. bonename);
        return;
    end
    local l = bone:getDisplayRenderNode();
    if not partname or partname == "null" or string.len(partname) == 0 then
        bone:changeDisplayWithIndex(-1, false);
    else
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
                --������С��������
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
    end
end
--[[
des     : ��ȡplist�ļ�
input   : key,remove�Ƴ�
return  : none
autor   : czt
date    : 2015��3��6��   
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

-- ����һ��֡����
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
function sg_get_award_type(str)
    if str == "item.none" then 
        return Award_Type[1];
    end
end