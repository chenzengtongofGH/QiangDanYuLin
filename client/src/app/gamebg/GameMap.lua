local Floor = require "app.gameobj.Floor"
local Rope = require "app.gameobj.Rope"
local GameMap = class("GameMap")
local TMX_ROPE_OBJNAME = "relayup"
local TMX_FLOOR_OBJNAME = "floor"
function GameMap:ctor( gamescene,maptb)
	self.objtable = {}
    self.floor = {};
	self.maptable_tmx = maptb
	self.gamescene = gamescene
	print("GameMap")
	self:loadMap( )
end
function GameMap:get_map_table()
    return self.maptable_tmx;
end

function GameMap:loadMap(  )
	for i,v in pairs(self.maptable_tmx) do
		local objgroup = v:getObjectGroup( TMX_ROPE_OBJNAME)
		if objgroup~=nil then --添加绳子
			local obj = objgroup:getObjects()
			for k,v in pairs(obj) do
				-- print("当前是地图",i)
				self:createGameObj(v,i,TMX_ROPE_OBJNAME)
			end
		end

        local objgroup = v:getObjectGroup( TMX_FLOOR_OBJNAME)
        if objgroup~=nil then --添加地板
            local obj = objgroup:getObjects()
            for k1,v1 in pairs(obj) do 
                self:createGameObj(v1,i,v)
            end
        end
	end
end
function GameMap:createGameFloor(objv,obji) 
    obj = Floor.new();
    obj:setWH(objv.width,objv.height)
    obj:setPosition(cc.p(objv.x + obji*MAPWIDTH,objv.y))
    print(obj.pos.x..",Y:"..obj.pos.y);
    table.insert( self.floor, obj )
    
end
function GameMap:createGameObj( objv,obji,add_Type,root_tmx)
    local obj;
    if add_Type == TMX_ROPE_OBJNAME then 
        obj = Rope:create()
        obj:setPosition( cc.p(objv.x+obji*MAPWIDTH,objv.y))
        table.insert( self.objtable, obj )
    
    end
	if  obj then 
	    self.gamescene:get_gameobjmanager():addObj( obj)
    end
end
function GameMap:remove(  )
	-- body
end
function GameMap:update( dt)
	for k,v in pairs(self.objtable) do
		v:update(dt)
	end
   
end
return GameMap