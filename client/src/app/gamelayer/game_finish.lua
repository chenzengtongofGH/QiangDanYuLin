--region game_finish.lua
--Author : Bookse
--Date   : 2016/6/12
--此文件由[BabeLua]插件自动生成
local game_finish = class("game_finish",cc.load("mvc").ViewBase)

function game_finish:ctor()
    self.root_csb = sg_load_csb("res#csb#ui#GameLoseLayer");
    self:addChild(self.root_csb);

    local continue_game = sg_get_child_by_name(self.root_csb,"Button_6");

   

    local quit_game = sg_get_child_by_name(self.root_csb, "Button_5")


     sg_ui.addTouchEventListener_music(continue_game,function()  self:close_game(); end );
     sg_ui.addTouchEventListener_music(quit_game,function()  self:close_game(); end );

end

function game_finish:close_game()
    EventSystem:pushEvent("EVENT_Close_game_layer");
end

return game_finish;
--endregion
