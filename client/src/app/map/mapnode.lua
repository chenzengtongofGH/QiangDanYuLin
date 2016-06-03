-- mapnoad.lua
-- Author : wz
-- Date   : 2015/1/13
-- 地图上的物件基础类型

CMapNode = class("CMapNode",cc.Node)

function CMapNode:ctor()
    -- 渲染对象
    self.render = nil;
    -- 对象的类型 PHY_TAG
    self.nodeTag = 0;
    self.id = 1;
    -- 开关
    self.state = 1;
end

function CMapNode:GetRender()
    return self.render;
end

function CMapNode:getTag()
    return self.nodeTag;
end

-- 碰撞处理函数，碰撞对象使用
function CMapNode:CollisionPro(role, contact, event)
    local result = false;
    if event == cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN then
        result = self:ProBegin(role, contact);
    elseif event == cc.Handler.EVENT_PHYSICS_CONTACT_SEPERATE then
        result = self:ProSeperate(role, contact);
    end
    return result;
end

function CMapNode:ProBegin(role, contact)
    --print("Call CMapNode:ProBegin");
    return false;
end

function CMapNode:ProSeperate(role, contact)
    --print("Call CMapNode:ProSeperate");
    return false;
end

-- 设定是否启用碰撞
-- phy true 启用
--      false 不启用
function CMapNode:SetPhyEnable(phy)
    if self:getPhysicsBody() then 
        self:getPhysicsBody():setEnable(phy);
    end
end

function CMapNode:play_script(state)
end

function CMapNode:release()
    self:removeFromParent(true);
end

function CMapNode:stop()
end