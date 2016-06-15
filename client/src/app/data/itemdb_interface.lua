--region itemdb_interface.lua
--Author : Bookse
--Date   : 2016/6/15
--此文件由[BabeLua]插件自动生成
Citemdb_interface = class("Citemdb_interface");

local itemdb = nil;
function Citemdb_interface:ctor(id)
    if not itemdb then
		itemdb = G_Reload("app.conf.itemdb");
	end	
    local info = itemdb[id];

    if not info then
        self.visible = false;
        sg_log.errormsg("Can't find role config:" .. id);
    else
        self.id = id;
        self.item_name = info[1];
        self.item_image = info[2];
        self.item_count = info[3];
        self.item_damage     = info[4];
    end
end

--

--endregion
