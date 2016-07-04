--region map_main.lua
--Author : admin
--Date   : 2016/7/3
--此文件由[BabeLua]插件自动生成
CMapMain = class("CMapMain")
local BLOCK_NODE_NAME = "block";
local blockidx = 1;
function CMapMain:ctor(id)
    self:create(id);
    self.pos = cc.p(0,0);
end
function CMapMain:create(id)
    if G_isUserDataValid(self.root_layer) then
        self.root_layer:removeFromParent(true);
    end
    self.root_layer = display.newLayer();
    self.id = id;
    self.config = sg_getMapDBinfo(id);
    Map_Data_Info = self.config;
    self.csb_table = {};
    self.tmxs = {};
    local draw = cc.DrawNode:create()
    self.root_layer:addChild(draw, 10)
    self.draw = draw;
    for k,v in pairs(self.config[5]) do 
        local csb_temp = sg_load_csb(v);
        self.tmxs = self:read_tmx_info(csb_temp)
        --table.insert(self.tmxs,self:read_tmx_info(csb_temp))
        self.root_layer:addChild(csb_temp);
        table.insert(self.csb_table,csb_temp);
    end
    -- 读取碰撞信息
    self.block_infos = self:read_block_info(self.tmxs);
end
function CMapMain:get_size()
    local size_talbe = {};
    local w,h = 0,0;
    for k,v in pairs(self.tmxs) do 
        w = w+ v:getContentSize().width;
        h = h+ v:getContentSize().height;
    end
    size_talbe["width"] = w;
    size_talbe["height"] = h;
    return size_talbe;
end
function CMapMain:read_tmx_info(csbnode)
    local tmxs = {};
    local i = 6;
    while true do 
        local pmap = csbnode:getChildByName(string.format("Map_%d",i));
        if pmap == nil then 
            break;
        end
        if G_isUserDataValid(pmap) and pmap.getObjectGroup then
            table.insert(tmxs,pmap);
        end

        i = i + 1 ;
        
    end
    return tmxs;
end

function CMapMain:read_block_info(tmxs)
    local block_infos = {}
    local cur_pos_x = 0;

    for k,v in pairs(tmxs) do 
        local group = v:getObjectGroup(BLOCK_NODE_NAME);
        if group then 
            local objects = group:getObjects();
            local len  = table.getn(objects);
            for i=0,len-1,1 do 
                local dict = objects[i + 1];
                local x = dict["x"];
                local y = dict["y"]
                local width = dict["width"]
                local height = dict["height"]
                local pointlinePoint = dict["polylinePoints"] or {};
                local posX = x+width/2 + cur_pos_x;                
                local posY = y+height; 
                local info = self:create_block_conf_info(blockidx, width, posX, posY,height,pointlinePoint);
                
                --draw a rectangle
                self.draw:drawRect(cc.p(posX - width/2,posY - height), cc.p(posX+width/2,posY), cc.c4f(1,0,0,1))
                table.insert(block_infos,info);
                blockidx = blockidx + 1; 
            end
        end
    end
    -- 合并两个连接起来的碰撞信息
    --block_infos = self:process_blocks(block_infos);
    return block_infos;
end
function CMapMain:create_block_conf_info(idx, w, x,y,h,pointlinePoint)
    local info = {};
    info["idx"] = idx;
    info["w"] = w;
    info["x"] = x;
    info["y"] = y;
    info["h"] = h;
    info["pointlinePoint"] = pointlinePoint;
    return info;
end
-- 处理碰撞
function CMapMain:update_blocks(Role_x,Role_y,rect_role)
    local bool_crash = false;
    --print("Role_x:"..Role_x..",Role_y:"..Role_y);
    for k,v in pairs(self.block_infos) do 
        if v then 
            local rect = cc.rect(v.x-v.w/2,v.y-v.h,v.w,v.h);
            --dead_rect2,cc.p(v:getPositionX(),v:getPositionY())  intersectsRect
            if cc.rectIntersectsRect(rect,rect_role) then 
            --if cc.rectContainsPoint(rect,cc.p(Role_x,Role_y)) then 
                bool_crash = true;
                --print("update_blocks:Role_X"..Role_x);
                break;
            end
            --local rect = 
        end
    end
    return bool_crash;
end
function CMapMain:update_tmx()
    
end
--endregion
