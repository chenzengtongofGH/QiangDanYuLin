--region New_Game_Scene.lua
--Author : Bookse
--Date   : 2016/5/30
--此文件由[BabeLua]插件自动生成
require("app.data.globaldata")
require("app.data.skill_interface")
local New_Game_Scene = class("New_Game_Scene", cc.load("mvc").ViewBase)
local GameLayer = require "app.gamelayer.qdylGameLayer"
function New_Game_Scene:onCreate()
    print("on_create"); 
   self.gamelayer = GameLayer.new();
   self:addChild(self.gamelayer);
   
end

return New_Game_Scene;
--endregion
