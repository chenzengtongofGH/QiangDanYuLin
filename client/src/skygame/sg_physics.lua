-- sg_physics.lua

-- des      :����������ؽӿ�
-- author   :
-- data     :2015��1��13

--���Ӧ �ܶ� ���ָ����� Ħ����
local MATERIAL_DEFAULT = cc.PhysicsMaterial(1, 0, 0)

--[[
des     : ��ӷ�����ײ��
input   : obj �󶨶���
          size ��С(����)
          material ����       
return  : 
autor   : wz
date    : 2015��1��17��09:40:32
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
des     : ��ӹ̶���ײ�壬�����ƶ�
input   : obj �󶨶���
          size ��С(����)
          material ����       
return  : 
autor   : wz
date    : 2015��1��17��09:40:32
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
des     : ��ӹ̶���ײ�ߣ������ƶ�
input   : obj �󶨶���
          p1 λ�����(�����obj)
          p2 λ�ý�����(�����obj)
          material ����
return  : 
autor   : wz
date    : 2015��1��17��09:40:32
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
des     : ���Բ����ײ��
input   : obj �󶨶���
          size ��С(�뾶)
          material ����       
return  : 
autor   : wz
date    : 2015��1��17��09:40:32
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
