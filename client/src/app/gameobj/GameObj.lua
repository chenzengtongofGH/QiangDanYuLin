local GameObj = class("GameObj")
local debugshowrect = true--控制显示碰撞形状的 
local ObjIdAcc = 0--游戏对象的id
function GameObj:ctor(  )
	ObjIdAcc = ObjIdAcc +1
	self.objid = ObjIdAcc
    self.oldpos = cc.p(0, 0)
	self.pos = cc.p(0,0)
    self.posoff=cc.p(0,0) --偏移值
    self.width = 100
	self.height = 100
	self.type = nil --类型
	self.zorder = 0 --层级
	self.objnode = nil--显示节点
    self.rect = cc.rect(0,0, 0, 0)
    self:updateRect()
    
    self.drawnode = nil--用来显示碰撞形状的
end
--设置对象的宽度和高度
function GameObj:setWH( width, height )
	self.width = width
	self.height = height
	self:updateRect()

	if self.drawnode ~= nil then
		self.drawnode:clear()
		self.drawnode:drawSolidRect( cc.p(0, 0), cc.p(self.rect.width, self.rect.height), cc.c4f(1, 1, 1, 0.5) )
	end
end
--是否是碰撞快，会与hero产生碰撞效果
--地板 2 砖块6 挡板 0 跳板11
function GameObj:isCollisionBlock()
	if self.type == GAMEBLOCK or self.type == MGameEnum.kObjBrick or self.type == MGameEnum.kTopBaffle or self.type == MGameEnum.kObjRemora or self.type == MGameEnum.kObjEnemy then
		return true
	end
	return false
end
--重新绘制区域
function GameObj:redrawRect()
	if self.drawnode ~= nil then
		self.drawnode:clear()
		self.drawnode:drawSolidRect( cc.p(0, 0), cc.p(self.rect.width, self.rect.height), cc.c4f(1, 0, 0, 0.5) )
	end
end
function GameObj:showRect( tlayer )
	if debugshowrect and self.drawnode == nil then
		self.drawnode = cc.DrawNode:create()
		tlayer:addChild( self.drawnode ,12)
		print("floor_Pos:"..self.pos.x,self.pos.y,self.width,self.height )
        --self.drawnode:setPosition(cc.p( self.pos.x, self.pos.y));
	end
	self:setPosition( self.pos )
	self:setWH( self.width, self.height )

end
function GameObj:getType()
	return self.type
end
function GameObj:getId()
	return self.objid
end
function GameObj:getRect()
	return self.rect
end
function GameObj:get_oldpos()
	return self.oldpos
end
function GameObj:setclearUp( judge )
	-- 能否被消除
	self.clearup = judge
end
function GameObj:getclearUp(  )
	-- 能否被消除
	return self.clearup 
end

function GameObj:setPosition( tpos ,isforce)
    
    self.oldpos.x = self.rect.x--todo 会有bug，修改
	self.oldpos.y = self.rect.y

    if isforce == true then
		self.oldpos.x = tpos.x
		self.oldpos.y = tpos.y
	end

	self.pos = tpos
    self:updateRect();
	if self.objnode ~= nil then
        local temPos = cc.p(self.pos.x+self.posoff.x , self.pos.y+self.posoff.y)
		self.objnode:setPosition( temPos )
	end

	if self.drawnode ~= nil then
		self.drawnode:setPosition( self.pos )
	end
end
--更新矩形区域框, 用于半段碰撞，
function GameObj:updateRect()
	self.rect.x = self.pos.x
	self.rect.y = self.pos.y
	self.rect.width = self.width
	self.rect.height = self.height
end
--显示对象函数，要重载
function GameObj:showObj( tlayer )
	-- body
end
function GameObj:remove( ... )
	if self.objnode ~= nil then
		self.objnode:removeFromParent()
		self.objnode=nil
	end
end
return GameObj