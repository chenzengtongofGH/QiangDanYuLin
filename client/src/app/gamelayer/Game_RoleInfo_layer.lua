--region Game_RoleInfo_layer.lua
--Author : Bookse
--Date   : 2016/6/30
--此文件由[BabeLua]插件自动生成
local Game_RoleInfo_layer = class("Game_RoleInfo_layer", cc.load("mvc").ViewBase)

function Game_RoleInfo_layer:onCreate()
    self.root_csb = sg_load_csb("res#csb#ui#Game_Role_Detail");

    local function closeGame(sender,eventType)
         if eventType == TOUCH_EVENT_ENDED then
             self:close();
         end 
    end

    local close_btn = sg_get_child_by_name(self.root_csb,"Button_back");
    close_btn:addTouchEventListener(closeGame);

    self:addChild(self.root_csb);
end

function Game_RoleInfo_layer:close()
    self:removeFromParent(true);
end

return Game_RoleInfo_layer;
--endregion
