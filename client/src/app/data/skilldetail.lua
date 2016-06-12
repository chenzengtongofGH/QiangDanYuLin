--region skilldetail.lua
--Author : Bookse
--Date   : 2016/6/2
--此文件由[BabeLua]插件自动生成
local BE_ATTACK_EFF_FILE = "res#json#skill#injury#eff_shouji"
CSkillDetailBase = class("CSkillDetailBase");
function CSkillDetailBase:ctor()
end
function CSkillDetailBase:update()
    return true;
end
function CSkillDetailBase:get_really_value(lev)
    local grow = self.damage_grow or 0;
    local base_dmg = self.damage or 0;
    return base_dmg + lev * grow;
end

---------------
-- 飞弹法术 1 --
---------------
CSDRoleToDir = class("CSDRoleToDir",CSkillDetailBase);
local skilldetaildb = nil;

function CSDRoleToDir:ctor(id)
	if not skilldetaildb then
		skilldetaildb = G_Reload("app.conf.skilldetaildb");
	end	
    local roletodir_conf = skilldetaildb[SKILL_DETAIL.ROLE_TO_DIR];
    if not roletodir_conf then
        return;
    end
    local info = roletodir_conf[id];
    if not info then
        self.visible = false;
    else
        self.visible = true;
        self.id = id;
        self.detail_type = SKILL_DETAIL.ROLE_TO_DIR;
        self.eff_file = info[1];
        self.eff_name = info[2];
        self.beatk_effect = info[3];
        self.beatk_role_eff = info[4];
        self.hit_sound = lua_string_split(info[5], ",");
        self.catcapult = g_int_to_bool(info[6]);
        self.speed = info[7] or FIGHT_PARAM.magic_item_speed;
        self.hit_num = info[8];
        self.max_obj_num = info[9];
        self.damage_type = info[10];
        self.damage = info[11];
        self.damage_grow = info[12];
        local loss = info[13];
        if loss == 0 then
            self.dmg_loss = 1;
            self.add_role_damage = 0;
        else
            self.dmg_loss = loss;
            self.add_role_damage = 1;
        end
        self.hit_script = info[14];
    end
end
--战斗释放技能的处理函数
function CSDRoleToDir:process(param)
    self:create_fightmove_item(param, false, 0);
    self.last_time = nil;
    self.cur_obj_num = self.max_obj_num - 1;
    if self.max_obj_num <= 1 then       
        return true;
    else
        return false;
    end
end

function CSDRoleToDir:get_really_value(lev)
    local grow = self.damage_grow or 0;
    local base_dmg = self.damage or 0;
    return (base_dmg + lev * grow) * self.max_obj_num * self.dmg_loss;
end

function CSDRoleToDir:create_fightmove_item(param, random_y, pierce)
    if not param then 
        return;
    end
    local caster = param.caster;
    local level = param.level;
    local hit_role = param.target_role or {};
    
    local sound_count = #self.hit_sound;
    local sound = "";
    if sound_count > 0 then
        local sound_idx = math.random(1, sound_count);
        sound = self.hit_sound[sound_idx];
    end
    local skill_damage = self:get_really_value(level);
    local function cb(target)--击中目标后的回调
        
        print("create_fightmove_item cb");
        --local script_type = nil;
        --local scirpt_id = nil;
        --if #self.hit_script > 0 then
        --    script_type = self.hit_script[1];
        --    scirpt_id = self.hit_script[2];
        --end
        --if script_type and scirpt_id then
        --    local script = CSkilldb_interface.create_detail(script_type, scirpt_id);
        --    local script_param =
        --    {
        --        ["target_role"] = { target },
        --        ["caster"] = caster,
        --        ["level"] = level,
        --    };
        --    script:process(script_param);
        --end
        --local info = {
        --    ["atk_role"] = caster,
        --    ["dmg_t"] = self.damage_type,
        --    ["beatkeff"] = self.beatk_effect,
        --    ["dmg_point"] = skill_damage,
        --    ["atk_flag"] = nil,
        --    ["dis"] = ATTACK_TYPE.REMOTE,
        --    ["per"] = self.add_role_damage,
        --    ["dmg_l"] = self.dmg_loss,
        --    ["beatksound"] = sound,
        --    ["role_eff"] = self.beatk_role_eff,
        --};
        
        local info = {["des_hp"] = 1,};
        target:be_attack(info);
        
    end
    --(r, speed, effinfo, hitcb,  hitnum, target_type, whitelist) 
    CFightMoveItem.new(caster, self.speed, {self.eff_file, self.eff_name}, cb,  self.hit_num, FIGHT_TARGET_TYPE.ENEMY,nil,hit_role); 
end

function CSDRoleToDir:update(param, time)
    if self.cur_obj_num <= 0 then
        return true;
    end

    if not self.last_time then
        self.last_time = time;
    end
    local INTERVAL = 50;
    if self.last_time - time >= INTERVAL then
        self.last_time = time;
        -- 目前多次攻击，全部在y方向上随机，并有50%几率穿透
        print("create_fightmove_item..");
        --self:create_fightmove_item(param, true, 50)
        self.cur_obj_num = self.cur_obj_num - 1;
    end

    return false;
end

function CSDRoleToDir:is_visible()
    return self.visible;
end


--endregion
