--region equip_interface.lua
--Author : Bookse
--Date   : 2016/6/13
--此文件由[BabeLua]插件自动生成
Cequipdb_interface = class("Cequipdb_interface");

local equipdb = nil;
function Cequipdb_interface:ctor(id)
    if not equipdb then
		equipdb = G_Reload("app.conf.equipdb");
	end	
    local info = equipdb[id];

    if not info then
        self.visible = false;
        sg_log.errormsg("Can't find role config:" .. id);
    else
        self.id = id;
        self.equip_name = info[1];
        self.equip_json = info[2];
    end
end




--endregion
