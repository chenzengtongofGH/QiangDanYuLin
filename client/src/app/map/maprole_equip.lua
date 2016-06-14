-- maprole_equip.lua
-- 地图角色的装备处理
-- 2015年1月27日
-- by wz

local MapRole_Equip = {};

--[[
des     : 替换某个位置的装备
input   : modle 模型对象(Armature)
          bonename  骨骼名字
          partkey  部件资源key(resdb)
          partdef_key 默认的部件资源key
          aniname 部件动作名(和模型相关）
return  : 
autor   : wz
date    : 2015年1月27日
--]]
function MapRole_Equip.change_equip(modle, bonename, partkey, partkey_def, aniname,isSmallEquip, flowshine,EquipId)
    local armature = nil;
    local cur_part_key = nil;
	if partkey and type(partkey) == "table" then
		if not flowshine and partkey[2] and partkey[3] then
			flowshine = sg_get_flowshine(partkey[2],partkey[3]) 
		end	
		partkey = partkey[1]
	end
    if not partkey then
		if partkey_def and type(partkey_def) == "table" then
			if not flowshine and partkey_def[2] and partkey_def[3] then
				flowshine = sg_get_flowshine(partkey_def[2],partkey_def[3])
			end	
			partkey_def = partkey_def[1]
		end
        if string.len(partkey_def) > 0 then 
            cur_part_key = partkey_def;
            armature = sg_change_arature_parts_ex(modle, bonename, partkey_def, aniname,EquipId)
        end
    else
        cur_part_key = partkey;
        armature = sg_change_arature_parts_ex(modle, bonename, partkey, aniname,isSmallEquip,EquipId)
    end
    if armature and string.len(aniname) > 0 then
        local ani = armature:getAnimation():getAnimationData();
        local movement = ani:getMovement(aniname);
        if movement then
            armature:getAnimation():play(aniname,-1,-1);
        else --读取默认的动作
            local movementDefault = ani:getMovement(EquipId);

            if movementDefault then
                armature:getAnimation():play(EquipId,-1,-1);
            else
                
            end
            
           -- sg_log.warning("Can't find equip animation:" .. cur_part_key .. "-" .. aniname);
        end
    end
	if armature and flowshine then
		G_UVAnimation(armature,true,flowshine.texturename,flowshine.color,flowshine.speedx,flowshine.speedy,flowshine.texturename2,flowshine.color2,flowshine.speedx2,flowshine.speedy2)
	end
    return armature;
end

return MapRole_Equip;