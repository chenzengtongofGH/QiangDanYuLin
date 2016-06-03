local GameObj = import(".GameObj")
local Floor = class("Floor",GameObj)
function Floor:ctor( isBouns )
	Floor.super.ctor(self)
    self.type = GAMEBLOCK;
    if isBouns then 
        self.isBouns = true;
    end
end
function Floor:getIsBouns()
	return self.IsBouns
end
function Floor:setObjnode(objnode)
	self.objnode=objnode
end
function Floor:getObjnode(tlayer)
    if self.objnode~=nil then
        tlayer:addChild( self.objnode,View_Ozder.Map)
		--tlayer:get_maplayer():addChild( self.objnode, 5)	
	end
end

function Floor:update(dt)
	self.pos.x=self.pos.x-GAMESPEED*dt
	self:setPosition(self.pos)

	if self.objnode~=nil then
		self.objnode:setPosition(self.pos )
	end
end
function Floor:showObj( tlayer )
    
	if self.objnode~=nil then
        tlayer:addChild( self.objnode,View_Ozder.Map)
		--tlayer:get_maplayer():addChild( self.objnode, 5)	
	end
end
return Floor