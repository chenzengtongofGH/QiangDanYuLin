-- sg_physics.lua

-- des      :物理引擎相关接口
-- author   :
-- data     :2015年1月13

--表对应 密度 ，恢复力， 摩擦力
local MATERIAL_DEFAULT = cc.PhysicsMaterial(1, 0, 0)

--[[
des     : 添加方形碰撞体
input   : obj 绑定对象
          size 大小(长宽)
          material 材质       
return  : 
autor   : wz
date    : 2015年1月17日09:40:32
--]] 
function sg_phy_add_box(obj, size, material, mask)
    if not obj then
        return;
    end
    obj:setAnchorPoint(cc.p(0.5,0.5));
    local material = material or MATERIAL_DEFAULT;
    local body = cc.PhysicsBody:createBox(size, material);
    if not mask then
        mask = {1,1,1};
    end
    body:setCategoryBitmask(mask[1]);
    body:setContactTestBitmask(mask[2]);
    body:setCollisionBitmask(mask[3]);
    body:setRotationEnable(false);
    body:setResting(false);
    obj:setPhysicsBody(body);
end

--[[
des     : 添加固定碰撞体，不会移动
input   : obj 绑定对象
          size 大小(长宽)
          material 材质       
return  : 
autor   : wz
date    : 2015年1月17日09:40:32
--]]
function sg_phy_add_edge_box(obj, size, material, mask)
    if not obj then
        return;
    end
    obj:setAnchorPoint(cc.p(0.5,0.5));
    local material = material or MATERIAL_DEFAULT;
    local body = cc.PhysicsBody:createEdgeBox(size, material, 1);
    if not mask then
        mask = {1,1,1};
    end
    body:setCategoryBitmask(mask[1]);
    body:setContactTestBitmask(mask[2]);
    body:setCollisionBitmask(mask[3]);
    obj:setPhysicsBody(body);
end

--[[
des     : 添加固定碰撞线，不会移动
input   : obj 绑定对象
          p1 位置起点(相对于obj)
          p2 位置结束点(相对于obj)
          material 材质
return  : 
autor   : wz
date    : 2015年1月17日09:40:32
--]]
function sg_phy_add_edge_segment(obj, p1, p2, material, mask)
    if not obj then
        return;
    end
    obj:setAnchorPoint(cc.p(0.5,0.5));
    local material = material or MATERIAL_DEFAULT;
    local body = cc.PhysicsBody:createEdgeSegment(p1, p2, material, 1);
    if not mask then
        mask = {1,1,1}
    end
    body:setCategoryBitmask(mask[1]);
    body:setContactTestBitmask(mask[2]);
    body:setCollisionBitmask(mask[3]);
    obj:setPhysicsBody(body);
end

--[[
des     : 添加圆形碰撞体
input   : obj 绑定对象
          size 大小(半径)
          material 材质       
return  : 
autor   : wz
date    : 2015年1月17日09:40:32
--]]
function sg_phy_add_circle(obj, size, material)
    if not obj then
        return;
    end
    obj:setAnchorPoint(cc.p(0.5,0.5));
    local material = material or MATERIAL_DEFAULT;
    local body = cc.PhysicsBody:createCircle(size.height/2, material);
    body:setContactTestBitmask(1);
    body:setCategoryBitmask(1);
    body:setCollisionBitmask(1);
    body:setRotationEnable(false);
    body:setResting(false);
    obj:setPhysicsBody(body);
end
