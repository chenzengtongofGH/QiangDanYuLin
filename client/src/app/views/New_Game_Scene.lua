--region New_Game_Scene.lua
--Author : Bookse
--Date   : 2016/5/30
--此文件由[BabeLua]插件自动生成
require("app.data.globaldata")
require("app.data.skill_interface")
local New_Game_Scene = class("New_Game_Scene", cc.load("mvc").ViewBase)
local GameLayer = require "app.gamelayer.qdylGameLayer"
local envent_id_list = 
{
    "EVENT_Close_game_layer",
}

function New_Game_Scene:onCreate()
   print("on_create"); 
   self:registeEvent();
   self.gamelayer = GameLayer.new();
   g_game_layer = self.gamelayer;
   self:addChild(self.gamelayer);
end

function New_Game_Scene:OnEvent(event, ...)
    local args = { ...}
    if event == "EVENT_Close_game_layer" then
        self:realse();
    end 
end
function New_Game_Scene:registeEvent()
    self.eventFun = function(...) self:OnEvent(...); end	
    for k,v in pairs(envent_id_list) do
        EventSystem:registEventHanlder(v, self.eventFun)	
    end	  
end
function New_Game_Scene:removeEvent()
    for k,v in pairs(envent_id_list) do
       EventSystem:removeEventHandler(v, self.eventFun);
    end	
end
function New_Game_Scene:realse()
    self.gamelayer:realse();
    self:removeEvent();
    self:getApp():enterScene("LoginScene")
end
return New_Game_Scene;
--endregion
