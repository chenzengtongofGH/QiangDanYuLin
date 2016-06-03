-- skill.lua
-- 技能配置文件
-- 2015年2月2日
-- by wz
require("app.map.map_moveitem")
--require("app.map.mapmulitem")

CSkill = class("CSkill")

function CSkill:ctor(id, lev)
    self.id = id;
    self.conf = CSkilldb_interface.new(id);
    self.level = lev or 0;
    self.cur_num_of_life = self.conf.number_of_life;
    self.last_use_time = -self.conf.cd/2;
end

function CSkill:get_value()
    return self.conf.detail:get_really_value(self.level);
end

function CSkill:reset_cd(curtime)
    self.last_use_time = curtime;
end

-- return:  true 在CD中，不能使用
--          false 不在CD中，可以使用
function CSkill:check_in_cd(curtime)
    if curtime - self.last_use_time >= self.conf.cd then
        return false;
    else
        return true;
    end
end

-- 设置技能下一次使用时间
function CSkill:set_next_use_time(curtime, time)
    self.last_use_time = curtime - self.conf.cd + time;
end
--是否能够用jn
function CSkill:can_use(curtime)
    if self.cur_num_of_life == 0 or self.conf.visible == false then
        return false;
    else
        return not self:check_in_cd(curtime);
    end
end
--获得cd的百分比
function CSkill:get_cd_percent(curtime)
    local pass_time = curtime - self.last_use_time;
    local per = 100 * pass_time / self.conf.cd;
    per = math.min(100, per);
    return per;
end
--更新时间
function CSkill:update(time)
    return self.conf.detail:update(self.param, time);
end
--播放技能释放的声音
function CSkill:play_use_sound(role)
    -- 播放音效
    if g_map_audio == true then
        local sound_count = #self.conf.soundlist;
        if sound_count > 0 then
            local idx = math.random(1, sound_count);
           -- sg_play_sound(self.conf.soundlist[idx]);
        end
    end
end
--播放特效特效
function CSkill:play_use_effect(role)
    local role_pos = role.cur_pos;

    local effect_count = #self.conf.effectlist;
    if effect_count > 0 then
        local effectname = self.conf.effectlist[1];
        local bonename = self.conf.effectlist[2];
        local effectpos = self.conf.effectlist[3];
        --eff, z, pos, scale_ex
        local effect = sg_play_effect(effectname,bonename);
        --role.maprole:add_effect_to_body(effect,1,effectpos)
    end
end
--获得目标
function CSkill:get_targets(t, caster)
    local role_list = {};
    local target_pos = nil;

    if t == SKILL_TARGET.SELF then  -- 进入到这里   攻击其他的敌人
        
    elseif  t == SKILL_TARGET.THE_FIGHT_TOP_ROLE  then -- 冲在最前面的敌人
        --local target = {};
        --local role_pos = caster.cur_pos;
        --local RoleIndex = 1;
        --local cur_pos_x = nil;
        --local enemys = g_fight_get_enemys(caster.maprole:get_camp(), true, true);
        --for k,v in pairs(enemys) do
        --    if v.face_dir == FACE_DIR.LEFT then
        --        if cur_pos_x == nil or v.cur_pos.x < cur_pos_x then 
        --            RoleIndex = k;
        --            cur_pos_x = v.cur_pos.x;
        --        end 
        --    else
        --        if cur_pos_x == nil or v.cur_pos.x > cur_pos_x then 
        --            RoleIndex = k;
        --            cur_pos_x = v.cur_pos.x;
        --        end 
        --    end               
        --end
        --if enemys[RoleIndex] then 
        --    table.insert(target,enemys[RoleIndex]);
        --end
        --role_list = target;
    
    end
    return role_list, target_pos;
end

-- 技能的处理
function CSkill:use(time, role,target_role)
    -- 重置技能的cd
    self:reset_cd(time); 
    if self.cur_num_of_life ~= -1 then
        self.cur_num_of_life = self.cur_num_of_life - 1;
        if self.cur_num_of_life < 0 then
            self.cur_num_of_life = 0;
        end
    end

    local param = {};
    -- 施法者
    param["caster"] = role; 
    -- 技能等级
    param["level"] = self.level; 
    -- 目标(角色/坐标)
    local tr, tp = self:get_targets(self.conf.target_type, role);
    if target_role then 
        table.insert(tr,target_role)
    end
    if tr and #tr > 0 then
        param["target_role"] = tr;
    end
    if tp then  
        param["target_pos"] = tp;
    end 
   
    

    self.param = param;
    return self.conf.detail:process(param);
end

function CSkill:get_three_enemy_role(role)
    local enemy = {};
    for k, v in pairs(g_fight_roles) do
        if v:is_dead() == false and role:is_enemy(v.maprole:get_camp()) then           
            table.insert(enemy, math.random(1, #enemy + 1), v);
        end
    end

    local target = {};
    local count = 0;
    for k, v in pairs(enemy) do
        count = count + 1;
        table.insert(target, v);
        if count >= 3 then
            break;
        end
    end
    return target;
end
function CSkill:get_lowest_per_health_friendly(role)
    local aliveidx = {};
    local friends = g_fight_get_firends(role.maprole:get_camp(), true);
    for k,v in pairs(friends) do
        if v:is_dead() == false then
            table.insert(aliveidx, {k, v.maprole.cur_hp/v.maprole.max_hp});
        end
    end     
    if #aliveidx > 0 then
        local function sortfun(a,b)
            return a[2] < b[2];
        end
        table.sort(aliveidx, sortfun);
    end
    local role_idx = aliveidx[1][1];
    return {friends[role_idx]}; 
end

CPhySkill = class("CPhySkill")
function CPhySkill:ctor(file, name, damage, addroleattr, damage_type, loss, script, level,eff_type,beatk_effect)
    self.eff_file = file;
    self.eff_name = name;
    self.dmg = damge or 0;
    self.addroleattr = addroleattr or 1;
    self.dmg_t = damage_type or DAMAGE_TYPE.PHY;
    self.loss = loss or 1;
    self.script = script or {};
    self.lev = level or 0;
    self.eff_type = eff_type;
    self.beatk_effect = beatk_effect;
end
