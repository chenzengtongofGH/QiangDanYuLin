--region role_interface.lua
--Author : Bookse
--Date   : 2016/1/4
--此文件由[BabeLua]插件自动生成
Croledb_interface = class("Croledb_interface");

local roledb = nil;
function Croledb_interface:ctor(id)
    if not roledb then
		roledb = G_Reload("app.conf.roledb");
	end	
    local info = roledb[id];

    if not info then
        self.visible = false;
        sg_log.errormsg("Can't find role config:" .. id);
    else
        self.visible = true;
        self.id = id;
        self.name = info[1];            -- 名字
        self.headicon = info[2];        -- 头像
        self.race = info[3];            -- 种族
        self.profession = info[4];      -- 职业
        self.sex = info[5];             -- 性别
        self.modle = info[6];           -- 模型
        self.modle_scale = info[7];--模型比例
        self.Equip_List   = info[8];--装备链表
        self.melee        = info[9];
        self.speed        = info[10];
        self.RoleDes      = info[11];
        self.Role_Speaking= info[12];
        self.RoleJS       = info[13];
        self.attack_cd    = info[14];--攻击速度
        self.attack_range = info[15];--攻击范围
        self.skill_Id        = info[16];--技能id
        self.equip_Id_table  = info[17];
    end
end


--endregion
