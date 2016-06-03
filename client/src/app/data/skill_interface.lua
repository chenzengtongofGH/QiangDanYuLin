--region skill_interface.lua
--Author : Bookse
--Date   : 2016/6/2
--此文件由[BabeLua]插件自动生成
require("app.data.skilldetail")
CSkilldb_interface = class("CSkilldb_interface");

local skilldb = nil;

function CSkilldb_interface:ctor(id)
	if not skill_db then
		skill_db = G_Reload("app.conf.skilldb");
	end	

    local info = skill_db[id];
    if not info then
        self.visible = false;
        sg_log.errormsg("Can't find skill config:" .. id);
    else
        self.visible = true;
        self.id = id;
        self.name = info[1];
        self.describe = info[2];
        self.target_type = info[3];
        
        -- 施法距离配置
        local dist_info_str = info[4];

        if #dist_info_str == 2 then
            self.min_castdist = dist_info_str[1] or 0;
            self.castdist = dist_info_str[2] or 1000;
        else
            self.min_castdist = 0;
            self.castdist = dist_info_str[1] or 600;
        end

        self.cd = info[5]; -- 配置为秒，这里乘以1000
        self.spell_time = info[6];-- 配置为秒，这里乘以1000
        self.using_time = info[7];
        self.icon_key = info[8];
        self.detail = CSkilldb_interface.create_detail(info[9], info[10]);
        if string.len(info[11]) > 0 then self.spell_effect = info[11]; end
        if string.len(info[12]) > 0 then self.spell_action = info[12]; end
        if string.len(info[13]) > 0 then self.use_action = info[13]; end  
        self.shake_screen = info[14];  
        self.detail_delay = info[15];    
        self.number_of_life = -1;
        self.decript = info[16];
        self.soundlist = lua_string_split(info[17], ",");
        self.effectlist = lua_string_split(info[18], ",");
    end
end

function CSkilldb_interface:is_visible()
    return self.visible;
end
function CSkilldb_interface.create_detail(t, id)
    local detail = nil;
    if t == SKILL_DETAIL.ROLE_TO_DIR then
        detail = CSDRoleToDir.new(id);
    end
    return detail;
end
--endregion
