
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"
require("gameconfig")
require("app.common.init")
require("app.data.role_interface")
require("app.data.equip_interface")
require("app.data.itemdb_interface")
g_game_layer  = nil;
local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
