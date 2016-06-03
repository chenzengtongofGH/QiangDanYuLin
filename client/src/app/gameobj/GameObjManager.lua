local MCollision = require "app.gameobj.Collision"
local Hero = require "app.gameobj.Hero"
local GameObjManager = class("GameObjManager")
role_scale = 1;
function GameObjManager:ctor( gamescene,gamelayer)
	self.gamescene = gamescene
	self.gamelayer = gamelayer
    self.eventFun  = nil;
    self:registeEvent();
	self.floorobj_TB={}
    self.role_list = {};
    self.diBantabel = {};
    self.objmap = {};
    self.role = Croledb_interface.new(1000);
	self:init()
end
function GameObjManager:get_objmap()
	return self.objmap
end
function GameObjManager:init( )
    
	self.hero = Hero.new(1,self.role);
	self:addObj( self.hero )
end
function GameObjManager:addObj( obj )
	if obj:getType()==GAMEROPE then

	elseif obj:getType()==GAMEBLOCK then
		self.floorobj_TB[obj:getId()] = obj
        
    --elseif obj:getType() == GAME_HERO then 
        --self.role_list[obj:getId()] = obj;
	end
	obj:showObj(self.gamelayer)
    --
end
function GameObjManager:Begin_Jump()
    self.hero:Jump_up();

end
function GameObjManager:update( dt )
    
    self.hero:update(dt);
    local collList = {};
    if self.IsBouns then
		MCollision.checkHeroObjCollision( self.hero, self.bounsDiBan, collList, dt,self.IsBouns)
	else
		MCollision.checkHeroObjCollision( self.hero, self.floorobj_TB, collList, dt,self.IsBouns)
	end
    MCollision.checkHeroObjCollision( self.hero, self.objmap, collList, dt)
    self.hero:processCollision( collList )
    self.hero:checkIsDead()
	-- body
end
function GameObjManager:release()
    self:removeEvent();
end
local Event_List = {
    "Jump_role"
}
function GameObjManager:registeEvent()
    self.eventFun = function(...) self:OnEvent(...); end	
    for k,v in pairs(Event_List) do
        EventSystem:registEventHanlder(v, self.eventFun)	
    end	  
end
function GameObjManager:removeEvent()
    for k,v in pairs(Event_List) do
       EventSystem:removeEventHandler(v, self.eventFun);
    end	
end
-- 消息相关
function GameObjManager:OnEvent(event,...)
    local args = {...}
	if event=="Jump_role" then
        self:Begin_Jump();
    end
end
return GameObjManager