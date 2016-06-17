--region Game_Rocker.lua
--Author : Bookse
--Date   : 2016/6/17
--此文件由[BabeLua]插件自动生成

local Game_Rocker = class("Game_Rocker",cc.load("mvc").ViewBase)
function Game_Rocker:ctor()
    self:init();
end

function Game_Rocker:init()
    local rock_sprite = CreateSprite("res#normal#ui#rock_layer#yaogan");
    self:addChild(rock_sprite);

    local point_sprite = CreateSprite("res#csb#ui#equipment#point2");
    rock_sprite:addChild(point_sprite);
   
    self.position =cc.p (rock_sprite:getContentSize().width/2,rock_sprite:getContentSize().height/2)
    point_sprite:setPosition(self.position);
end
--启动摇杆 
function Game_Rocker:startRocker()
    
end
--停止摇杆 
function Game_Rocker:stopRocker()
    
end
--得到两坐标的角度值
function Game_Rocker:getRad()
    
end
function Game_Rocker:GTouchBegan()
    
end
function Game_Rocker:GTouchMoved()
    
end
function Game_Rocker:GTouchEnded()
    
end
--得到与角度对应的半径为r的圆上一坐标点 
function Game_Rocker:getAnglePosition()
    
end
return Game_Rocker;
--endregion
