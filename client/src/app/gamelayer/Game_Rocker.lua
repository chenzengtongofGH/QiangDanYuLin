--region Game_Rocker.lua
--Author : Bookse
--Date   : 2016/6/17
--此文件由[BabeLua]插件自动生成

local Game_Rocker = class("Game_Rocker",cc.load("mvc").ViewBase)
local SJ_PI = 3.14159265359
local SJ_PI_X_2 = 6.28318530718;
local SJ_RAD2DEG  = 180/SJ_PI;
local SJ_DEG2RAD  = SJ_PI/180
local numberOfDirections = 4;
local degrees = 0;
local stickPosition = cc.p(0,0);
local velocity = stickPosition;
function round(r)
    if r>0 then 
        return math.floor(r+0.5);
    else
        return math.ceil(r-0.5);
    end
end
function Game_Rocker:ctor()
    self.joystickRadius = 0;
    self.joystickRadiusSq = 0;
    self.thumbRadius = 0;
    self.thumbRadiusSq = 0;
    self.deadRadius = 0;
    self.deadRadiusSq = 0;
    self.autoCenter = true;
    self.isDPad = false;
    self.hasDeadzone = false;
    self:init();
end

function Game_Rocker:init()
    local rock_sprite = CreateSprite("res#csb#ui#ui_tips#circle_image");
    self:addChild(rock_sprite);
    rock_sprite:setPosition(cc.p(100,100));
    self.rock_sprite = rock_sprite;
    local R_rad = rock_sprite:getContentSize().width / 2 ;

    self:setJoystickRadius(R_rad);
    self:setThumbRadius(32);
    self:setDeadRadius(0);

    local point_sprite = CreateSprite("res#csb#ui#ui_tips#ui_circle_center");
    
    self.point_sprite = point_sprite;

    self.position =cc.p (rock_sprite:getContentSize().width/2,rock_sprite:getContentSize().height/2)
    self.offset_x = 100;
    self.offset_y = 100;
    --point_sprite:setPosition(self.position);
    sg_ui.swallow_touches(self)
    local RL = display.newLayer(cc.c4b(255,0,0,0),cc.size(rock_sprite:getContentSize().width/2,rock_sprite:getContentSize().width/2));
    self:addChild(RL,100);
    RL:setPosition(100,100)
    RL:addChild(point_sprite);
    --rock_sprite:setTouchEnabled(true);
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function(touch, event) return self:TouchLayerB(touch, event) end,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(function(touch, event) return self:TouchLayerM(touch, event) end,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(function(touch, event) return self:TouchLayerE(touch, event) end,cc.Handler.EVENT_TOUCH_ENDED )
    listener:registerScriptHandler(function(touch, event) return self:TouchLayerC(touch, event) end,cc.Handler.EVENT_TOUCH_CANCELLED )
    local eventDispatcher = RL:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, RL) 

end
--启动摇杆 
function Game_Rocker:startRocker()
    
end
--停止摇杆 
function Game_Rocker:stopRocker()
    
end
function Game_Rocker:setIsDPad(b)
    self.isDPad = b;
    if self.isDPad then
		self.hasDeadzone = true;
		self:setDeadRadius(10);
	end
end

function Game_Rocker:updateVelocity(point)
    local dx = point.x;
    local dy = point.y;
    local dSq = dx *dx + dy*dy;
    if dSq <= self.deadRadiusSq then 
        velocity = cc.p(0,0);
        degrees = 0
        stickPosition = point
        self.point_sprite:setPosition(stickPosition);
        g_game_layer.sin_angle = 0;
        g_game_layer.cos_angle = 0;
        return ;
    end
    local angle = math.atan2(dx, dy);
    if angle <0  then 
        angle = angle + SJ_PI_X_2;
    end
    local cosAngle;
	local sinAngle;
    if self.isDPad then 
		local anglePerSector = 360 / numberOfDirections * SJ_DEG2RAD;
		angle = round(angle/anglePerSector) * anglePerSector;
	end
    cosAngle = math.cos(angle);-- cosf(angle);
	sinAngle = math.sin(angle);
    if dSq > self.joystickRadiusSq or self.isDPad then 
		dx = cosAngle * self.joystickRadius;
		dy = sinAngle * self.joystickRadius;
	end
    velocity = cc.p(dx/self.joystickRadius, dy/self.joystickRadius);
    degrees = angle * SJ_RAD2DEG;
    stickPosition = cc.p(dx, dy);

    self.point_sprite:setPosition(stickPosition);
    --set_Map_Move
    g_game_layer.sin_angle = sinAngle;
    g_game_layer.cos_angle = cosAngle;
    --g_game_layer:setRole_Pos(sinAngle,cosAngle);
end
--设置圆的面积
function Game_Rocker:setJoystickRadius(r)
    self.joystickRadius = r;
    self.joystickRadiusSq = r*r;
end
function Game_Rocker:setThumbRadius(r)
    self.thumbRadius = r;
    self.thumbRadiusSq = r*r;
end
function Game_Rocker:setDeadRadius(r)
    self.deadRadius = r;
    self.deadRadiusSq = r*r;
end
--得到两坐标的角度值
function Game_Rocker:getRad()
    
end
function Game_Rocker:TouchLayerB(touches, event)
    local target = event:getCurrentTarget();
    local Nodelocation = target:convertToNodeSpace(touches:getLocation());

    if Nodelocation.x < -self.joystickRadius or  Nodelocation.x > self.joystickRadius 
		or Nodelocation.y < -self.joystickRadius or Nodelocation.y > self.joystickRadius then 
        return false;
    else
        local dSq = Nodelocation.x*Nodelocation.x + Nodelocation.y*Nodelocation.y;
        if self.joystickRadiusSq > dSq then 
			self:updateVelocity(Nodelocation);
			return true;
		end
    end
    return false;
end
function Game_Rocker:TouchLayerM(touches, event)
    local target = event:getCurrentTarget();
    local  location = target:convertToNodeSpace(touches:getLocation());
    if location.x < -self.joystickRadius or  location.x > self.joystickRadius 
		or location.y < -self.joystickRadius or location.y > self.joystickRadius then 
        return false;
    else
        self:updateVelocity(location);
    end
    	
end
function Game_Rocker:TouchLayerE(touches, event)
    local  location = cc.p(0,0);
    if not self.autoCenter then 
         local target = target:getCurrentTarget();
         location = target:convertToNodeSpace(touches:getLocation());
         --location.x = location.x + self.offset_x;
         --location.y = location.y + self.offset_y;
    end

	self:updateVelocity(location);
end
function Game_Rocker:TouchLayerC(touches, event)
    self:TouchLayerE(touches, event);
end
--得到与角度对应的半径为r的圆上一坐标点 
function Game_Rocker:getAnglePosition()
    
end
return Game_Rocker;
--endregion
