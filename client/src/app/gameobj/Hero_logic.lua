--玩家角色
local GameObj = import(".GameObj")
local Hero = class("Hero", GameObj)
local GameEscalatorProp = require "app.gameprop.GameEscalatorProp"
-- local FlySkill = require "app.gameprop.GameFlyProp"
local NoramWH = {width=90, height=140}
local SlipWH = {width=100, height=90}
local HeroX = 400
local herostat = {
	runing = 0,
	jumping = 1,
	sliping = 2,
	flying = 3,
	boardjumping = 4,
	dead = 5,
}
local lifestat = {
	noram = true, --空
	invincible = false,--无敌
	attraction = false,--吸引力
	protect = false,   --被保护
	hurt = false, --受伤
}
local spinepath = {
	nanzhujson  = "spine/nanzhu/nanzhu.json",
	nanzhuatlas = "spine/nanzhu/nanzhu.atlas",
	nvzhujson   = "spine/nvzhu/nvhu.json",
	nvzhuatlas  = "spine/nvzhu/nvhu.atlas",
}
-- s = -Vo2/2a,初速度，加速度，距离的必须满足公式


function Hero:ctor( gamemanager )
    Hero.super.ctor(self)

    self.gamemanager = gamemanager

    self.type = MGameEnum.kObjHero
    self.zorder = 100
	self:setPosition( cc.p(HeroX, 150) )
	self:setWH(NoramWH.width, NoramWH.height)
	self:updateRect()

	self.jumpdirection = MGameEnum.kNan
	self.actstat = herostat.runing
	self.jumptimes = 0--向上跳跃的次数

	self.isEscalator=false
	self.escalatorTime=10

	self.lifestat = lifestat
	self.isdead = false
	self.runsmoganim = nil
end

function Hero:updateRect()
	self.rect.x = self.pos.x+10
	self.rect.y = self.pos.y
	self.rect.width = self.width
	self.rect.height = self.height
	if self.drawnode ~= nil then
		
		self.drawnode:setPosition( cc.p(self.rect.x,self.rect.y) )
		-- local ppp = self.drawnode:getAnchorPoint()
	end
end

function Hero:update( dt )
	if not self:isDead() then
		self:actionUpdate( dt )
	end


	--英雄是否死亡
	-- self.isdead = false

	--扶梯道具控制逻辑
	if self.isEscalator then
		self.gameEscalatorProp:escalatorUpdate( dt )
		self.isEscalator=self.gameEscalatorProp:getIsEscalator()
	elseif self.gameEscalatorProp~=nil then
		-- print("Escalator is deleting............")
		self.gameEscalatorProp=nil
	end
	--跑动的烟雾
	if MGameConfig.kRunAnimPlay then
		if self.objnode~=nil and self.runsmoganim ==nil then
			self.runsmoganim = MAnimationManager.createRunSmogAnim("spine/zjyanwu/zhujueyanwu.json","spine/zjyanwu/zhujueyanwu.atlas",true)
			self.runsmoganim:setPosition(cc.p(-20,5))
			self.objnode:addChild( self.runsmoganim,200)
		end
	else
		if self.runsmoganim~=nil then
			self.runsmoganim:removeFromParent()
			self.runsmoganim = nil
		end
	end
	--巨人震动效果
	if MGameConfig.kDownAnimPlay then
		if self.gamelayer~=nil and self.gamemanager:get_gamepropmanager():get_titanprop():get_titanenter() then
			local act = MAnimationManager.AnimShakyT()
			self.gamelayer:runAction( act)
			MGameConfig.kDownAnimPlay = false
		end
	end
end

--动作更新
function Hero:actionUpdate( dt )
	local deltaY = 0
	if self.actstat == herostat.jumping then

		self.jumptime = self.jumptime + dt
		--公式s=v0*t + a(t*t)/2s
		deltaY = self.jumpv0 * self.jumptime + self.jumpacc * math.pow(self.jumptime, 2)*0.5
		self.jumpv1 = self.jumpv0 + self.jumpacc * self.jumptime
		self.pos.y = self.jumpstartpos.y + deltaY
		-- print("时间,距离",dt,deltaY)
		if self.jumpdirection == MGameEnum.kUp then
			-- print("pos.y", self.pos.y, self.jumpstartpos.y + self.jumpdistince)
			if self.pos.y >= self.jumpstartpos.y + self.jumpdistince then
				self.pos.y = self.jumpstartpos.y + self.jumpdistince
				-- print("Hero jump to top",self.jumptime,self.jumpv0,self.jumpv1)
				self.actstat = herostat.runing
				if self.jumptimes ==1 then
					MSound.playdown1Sound( )--播放音乐
				elseif self.jumptimes ==2 then
					MSound.playdown2Sound( )--播放音乐
				end
				self:jumpDown()
			end
		elseif self.jumpdirection == MGameEnum.kDown then

		end
	elseif self.actstat == herostat.boardjumping then

		self.boardjumptime = self.boardjumptime +dt
		deltaY = self.boardjumpv0 * self.boardjumptime +self.boardjumpacc*math.pow(self.boardjumptime, 2)*0.5
		self.pos.y = self.pos.y + deltaY

		if self.jumpdirection == MGameEnum.kUp then
			if self.pos.y >= self.boardjumpstartpos.y + self.boardjumpdistince then
				self.pos.y = self.boardjumpstartpos.y + self.boardjumpdistince
				print("Hero 弹簧跳",self.boardjumptime)
				-- 速度加速
				MGameConfig.changeSpend(-600,-600)
				self.actstat = herostat.runing
				self:jumpDown()
			end
		end
	elseif self.actstat == herostat.sliping then
		-- self.sliptime = self.sliptime -dt
		if self.slipstat ==0  then--slip 结束
			self:actionRun()
		end
	end

	--hero移到后面了，向前跑一点
	if self.pos.x < HeroX then
		self.pos.x = self.pos.x + 50*dt
		if self.pos.x > HeroX then
			self.pos.x = HeroX
		end
	end

	self:setPosition( self.pos )
	self:updateRect()
end
--向上跳跃
function Hero:jumpUp()
	print("向上跳")
	if self.actstat ~= herostat.flying then
		print("向上跳1")
		self.jumpstartpos = cc.p(self.pos.x, self.pos.y)
		self.jumptime = 0
		self.jumpv0 = 800
		self.jumpacc = -400
		self.jumpdistince = 220  --timr ~=0.45  426

		self.jumpdirection = MGameEnum.kUp
		self.actstat = herostat.jumping
		self.jumptimes = self.jumptimes +1

		self:updateAnim( MGameEnum.kHeroJump )
	end
end
--向下跳跃
function Hero:jumpDown()
	if self.actstat == herostat.runing or self.actstat == herostat.sliping then
		self.jumpstartpos = cc.p(self.pos.x, self.pos.y)
		self.jumptime = 0
		self.jumpv0 = -300
		self.jumpacc = -500
		self.jumpdistince = 220

		self.jumpdirection = MGameEnum.kDown
		self.actstat = herostat.jumping

		-- self:updateAnim( MGameEnum.kHeroRollJump )
	end
end
--二段跳
function Hero:jumpUpTwice()
	if self.actstat == herostat.jumping then
		self.jumpstartpos = cc.p(self.pos.x, self.pos.y)
		self.jumptime = 0
		self.jumpv0 = 250
		self.jumpacc = -100
		self.jumpdistince = 100  --timr ~=0.38  261

		self.jumpdirection = MGameEnum.kUp
		self.actstat = herostat.jumping
		self.jumptimes = self.jumptimes +1

		self:updateAnim( MGameEnum.kHeroRollJump )
	end
end
--踩到物品跳
function Hero:enemyJump(  )
	self.jumpstartpos = cc.p(self.pos.x, self.pos.y)
	self.jumptime =0
	self.jumpv0 = 300
	self.jumpacc = -200
	self.jumpdistince = 100

	self.jumpdirection = MGameEnum.kUp
	self.actstat = herostat.jumping
	self:updateAnim( MGameEnum.kHeroJump )
end
--弹簧跳
function Hero:boardJump( )
	if self.actstat == herostat.jumping or self.actstat == herostat.runing then
		print("kaishile")
		self.boardjumpstartpos = cc.p(self.pos.x, self.pos.y)
		self.boardjumptime =0
		self.boardjumpv0 = 100
		self.boardjumpacc = -9.8
		self.boardjumpdistince = 250

		self.jumpdirection = MGameEnum.kUp
		self.actstat = herostat.boardjumping
		MGameConfig.changeSpend(600,600)   --改变移动速度
		self:updateAnim( MGameEnum.kHeroJump )
	end
end
function Hero:showObj( tlayer )
	self.objnode = cc.Node:create()
	-- tlayer:get_herolayer()
	self.gamelayer = tlayer
	tlayer:get_herolayer():addChild( self.objnode, self.zorder)
	local herojson = nil
	local heroatlas = nil
	if g_playerinfo:get_heroId()==1101 then
		herojson = spinepath.nanzhujson
		heroatlas = spinepath.nanzhuatlas
	elseif g_playerinfo:get_heroId()==1102 then
		herojson = spinepath.nvzhujson
		heroatlas = spinepath.nvzhuatlas
	else
		herojson = spinepath.nanzhujson
		heroatlas = spinepath.nanzhuatlas
	end
	self.heroanim = MAnimationManager.createHeroAnim( herojson,heroatlas)
	self.objnode:addChild( self.heroanim)
	self:updateAnim( MGameEnum.kHeroRun )
end

--停止跳跃
function Hero:jumpStop()
	if self.actstat == herostat.jumping then
		self.jumpstartpos = cc.p(0, 0)
		self.jumptime = 0
		self.jumpv0 = 0
		self.jumpacc = 0
		self.jumpdistince = 0

		self.jumpdirection = MGameEnum.kNan
		self.jumptimes = 0
		-- self:updateAnim( MGameEnum.kHeroRollJumpdown )
		if MGameConfig.kSlipeOn then
			print("按钮还被按着")
			self.actstat = herostat.runing
			self:slip()
		else
			self:actionRun()
		end
	end
end
--将状态切换到跑的状态
function Hero:actionRun()
	self.actstat = herostat.runing
	self:setWH(NoramWH.width, NoramWH.height)
	self:updateRect()
	if C_GetSkeletonAnimationLoop(self.heroanim) == "jump3" then
		print("2段跳下落")
		self:updateAnim( MGameEnum.kHeroRollJumpdown )
	else
		self:updateAnim( MGameEnum.kHeroRun )
	end
	-- print("将状态切换到跑的状态",C_GetSkeletonAnimationLoop(self.heroanim))
	-- self:updateAnim( MGameEnum.kHeroRun )
end

--玩家点击跳
function Hero:jump()
	print("Hero:Jump")
	local tag=g_playerinfo:get_heroId()
	if self.actstat == herostat.runing then
		print("Hero:Jump 1")
		self:jumpUp()
		MSound.playJump1Sound( tag)	--播放音乐
	elseif self.actstat == herostat.jumping then
		if self.jumptimes <= 1 then--二段跳只能条一次
			print("Hero:Jump 2")
			self:jumpUpTwice()
			local pos = {}
			pos.x = self.pos.x
			pos.y = self.pos.y
			MAnimationManager.createSmogAnim( self.gamelayer,pos,"spine/guangquan/guangquan.json","spine/guangquan/guangquan.atlas",false)
			MSound.playJump2Sound( tag)--播放音乐
		end
	end
end

--玩家点击滑
function Hero:slip()
	print("Hero:Slip", self.actstat)
	if self.actstat ~= herostat.runing then
		return
	end

	self.actstat = herostat.sliping
	self.slipstat = 1--滑行预判1为开始 0为结束
	self:setWH(SlipWH.width, SlipWH.height)
	self:updateRect()
	self:updateAnim( MGameEnum.kHeroSlip )
end
function Hero:fly( )
	print("Hero:fly")
	self.actstat = herostat.flying
	-- self.pos.x = 200 --test
	-- self.pos.y = 400 --test
	self:setPosition(cc.p(HeroX,400))
	self:updateRect()
	--飞行特效动画
	self.fly_anim_sp = MAnimationManager.AnimFly( )
	self.fly_anim_sp:setTag(5200)
	self.fly_anim_sp:setPosition(cc.p(-210,60))
	self.objnode:addChild( self.fly_anim_sp,10)
	
	self.pro_anim_sp = MAnimationManager.Animprotect( )--cc.Sprite:create("baohuzhao.png")
	self.pro_anim_sp:setTag(5201)
	self.pro_anim_sp:setAnchorPoint(cc.p(0,0))
	-- self.pro_anim_sp:setScale(0.8)
	self.pro_anim_sp:setPosition(cc.p(-75,-75))   -- -60,-40  -75,-75
	self.objnode:addChild(self.pro_anim_sp,5)

	-- local act = MAnimationManager.AnimCoin()
	-- local sp = cc.Sprite:create()
	-- self.objnode:addChild( sp)
	-- sp:runAction( act)
	self:updateAnim( MGameEnum.kHeroFly )
end
function Hero:flyEnd(  )
	-- print("删除中")
	self.gamemanager:get_gamepropmanager(  ):NoBuyProp( MGameEnum.kPropInvincible,2) 
	if self.fly_anim_sp~=nil then
		self.objnode:removeChildByTag(5200)
		self.objnode:removeChildByTag(5201)
		-- print("删除了")
	end
end
--更新角色动画
function Hero:updateAnim( status )
	-- print("updateAnim", status)
	MAnimationManager.playHeroAnim( self.heroanim, status)
end

function Hero:coinAnim( )
	local function clearanim(  )
		-- print("111111")
		if self.coin_anim_sp~=nil then
			self.objnode:removeChildByTag(5202)
			self.coin_anim_sp=nil
		end
	end 
	-- print("coinAnim")
	if self.coin_anim_sp==nil then
		local act = MAnimationManager.AnimCoin()
		self.coin_anim_sp = cc.Sprite:create()
		self.coin_anim_sp:setTag(5202)
		self.coin_anim_sp:setPosition( cc.p(50,80))
		self.objnode:addChild( self.coin_anim_sp)
		local seq = cc.Sequence:create( act,cc.CallFunc:create(clearanim))
		self.coin_anim_sp:runAction( seq)
	else
		
	end
end
--hero处理碰撞
function Hero:processCollision( collList )
	if self:isDead()  then
		return
	end

	local needjumpdown = false--是否需要跳下来
	local needjumpstop = false

	--当有多个碰撞的时候，计算出绝对值最大的偏移量
	local maxoffx = 0
	local maxoff_absx = 0
	local maxoffy = 0
	local maxoff_absy = 0
	-- local x = 0
	--print( "collList count",#collList)
	for ti,tv in ipairs( collList ) do
		if tv.obj:isCollisionBlock() then
			-- self:collisionWithBlock( tv )
			local collstat = tv.collstat

			if math.abs(collstat.deltax) > maxoff_absx then
				maxoff_absx = math.abs(collstat.deltax)
				maxoffx = collstat.deltax
			end
			if math.abs(collstat.deltay) > maxoff_absy then
				maxoff_absy = math.abs(collstat.deltay)
				maxoffy = collstat.deltay
			end
			-- if self.gamemanager:get_IsBouns() and tv.obj:getType() ==MGameEnum.kObjBlock and tv.obj.IsBouns==nil then
			-- 	print("无地板碰撞")
			-- else
			-- 	if collstat.bottom and not collstat.top then
			-- 		if self.actstat == herostat.jumping and collstat.blockbottom then
			-- 			needjumpstop = true
			-- 		end
			-- 	end
			-- end
			
			if  tv.obj:getType() ==MGameEnum.kObjBlock then
				-- if collstat.bottom and not collstat.top then
					-- x=x+1
					if self.actstat == herostat.jumping and collstat.blockbottom then
						needjumpstop = true
						-- print("YSE")
						-- x=x+1
						-- print("needjumpStop")
					-- elseif collstat.blockbottom then
						-- print("NO")
						-- needjumpstop = true
					end

				-- end	
			end
			
			-- if not self.gamemanager:get_IsBouns() and tv.obj:getType() ==MGameEnum.kObjBlock then
			-- 	if collstat.bottom and not collstat.top then
			-- 		if self.actstat == herostat.jumping and collstat.blockbottom then
			-- 			needjumpstop = true
			-- 		end
			-- 	end	
			-- end

			if tv.obj:getType() ==MGameEnum.kObjRemora and tv.obj:get_remoratype() == MGameEnum.kBottomDrawBoard then
				if collstat.blockbottom and not self.gamemanager:get_IsBouns() then
					-- print("踩住了,弹跳动作")
					self:boardJump()
				elseif maxoffx==0 then
					maxoffx = -30
				end
			elseif tv.obj:getType() ==MGameEnum.kObjRemora and tv.obj:get_remoratype() == MGameEnum.kTopBaffle then
				if maxoffx==0 and collstat.blockright then
					maxoffx = -30
				end
			end
		end
	end
	-- print("youmeiyoupengzhuangkuaia ",x)
	
	if #collList == 0  then
		if self.actstat == herostat.runing or self.actstat == herostat.sliping then
			needjumpdown = true
		end
	end
	
	-- print("pos x, adjust x:", self.pos.x,  maxoffx)
	-- print("pos y, adjust y:", self.pos.y,  maxoffy)

	if  self.actstat == herostat.flying then
	elseif self.gamemanager:get_IsBouns(  ) then
		self.pos.y = self.pos.y + maxoffy
		self:setPosition( self.pos, true)
		self:updateRect()
	else
		self.pos.x = self.pos.x + maxoffx
		self.pos.y = self.pos.y + maxoffy
		self:setPosition( self.pos, true)
		self:updateRect()
	end

	if needjumpstop == true then
		print("jumpStop")
		MGameConfig.kDownAnimPlay = true
		self:jumpStop()
	end

	if needjumpdown == true then
		print("jumpDown")
		self:jumpDown()
	end
end
function Hero:setDeadStste( type )
	-- body
	print("hero is dead hero is dead hero is dead",type)
	if type then
		self.isdead=type
		self.actstat = herostat.dead
	else
		self.isdead=type
		self.actstat = herostat.runing
	end
end

--hero是否死了
function Hero:checkIsDead()
	if self.pos.x < -NoramWH.width*0.6 or self.pos.y < -NoramWH.height*0.6 then
		self.isdead = true
		self.actstat = herostat.dead
		-- MAnimationManager.animStop( self.heroanim )
	end 
end

function Hero:isDead()
	return self.isdead
end

function Hero:doEscalator( escalatorTime)
	self.escalatorTime = escalatorTime
	if not self.isEscalator then
		self.isEscalator=true
		self.gameEscalatorProp=GameEscalatorProp:create( self.escalatorTime,self.gamemanager)
	end
end

return Hero
