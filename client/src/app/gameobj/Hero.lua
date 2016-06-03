local GameObj = import(".GameObj")
local Hero = class("Hero",GameObj)
local HeroX = 400
local NoramWH = {width=90, height=140}
local SlipWH = {width=100, height=90}

function Hero:ctor(id,role)
	Hero.super.ctor(self)
    --self.objnode = cc.Node:create();
    self.type = GAME_HERO;
	self:setPosition( cc.p(HeroX, 150) )
    self.scale = scale or 1;
    self.role = role;
    self.isdead = false;
    self.H_Stat = Hero_Action_Status.IDLE;
    self.jumptimes = 0
    --self:init();
end
function Hero:init()
    self.render = sg_create_armature(self.role.RoleJS);
    self.render:setScale(self:get_conf_scale());
    local render_size = self.render:getContentSize();
    self.render:addTo(self.objnode,2);

end
function Hero:get_conf_scale()
    return self.role.modle_scale;
end
function Hero:idle()
   self:play_ani(MAPROLE_ACTION_STATE.IDLE);
end
function Hero:move()
    self:play_ani(MAPROLE_ACTION_STATE.RUN);
end
function Hero:attack()
    self:play_ani(MAPROLE_ACTION_STATE.MOV_ATK);
end
function Hero:dead()
    self:play_ani(MAPROLE_ACTION_STATE.DIE);
end
function Hero:beattck()
    self:play_ani(MAPROLE_ACTION_STATE.BE_ATK);
end
function Hero:Jump()
    self:play_ani(MAPROLE_ACTION_STATE.JUMP);
end

function Hero:play_ani(ani_id, param)
    local info = GET_ACT_INFO(ani_id);
    if info and self.objnode then 
        self.objnode:getAnimation():play(unpack(info));
    end
end
function Hero:showObj( tlayer)
    self.objnode = sg_create_armature(self.role.RoleJS);
    self.objnode:setScale(self:get_conf_scale());
    local render_size = self.objnode:getContentSize();
    self.objnode:addTo(tlayer,View_Ozder.Role);
    self.objnode:setPosition( Role_Brith_Pos);
    self:idle();
	print(name)
end
function Hero:isDead()
	return self.isdead
end
function Hero:update( dt )
    if not self:isDead() then
		self:actionUpdate( dt )
	end
end
function Hero:Jump_up()
    self:Jump();
    self.H_Stat = Hero_Action_Status.JUMP_Up;
    self.jumptime = Jump_Time
    self.jumpv0 = Jump_v0
    self.jumpacc =Jump_acc
    self.jumpdistince =Jump_distance
    self.jumptimes = self.jumptimes +1
    self.jumpstartpos = cc.p(self.pos.x, self.pos.y)
    self.jumpdirection = MGame_Status.kUp;
end
function Hero:jumpDown()
    if self.H_Stat == Hero_Action_Status.RUN then 
        self.jumpstartpos = cc.p(self.pos.x, self.pos.y)
		self.jumptime = 0
		self.jumpv0 = -300
		self.jumpacc = -500
		self.jumpdistince = 220

		self.jumpdirection = MGame_Status.kDown;
		self.H_Stat = Hero_Action_Status.JUMP_Up
    end
end
function Hero:jumpStop()
    if self.H_Stat == Hero_Action_Status.JUMP_Up then 
        self.jumpstartpos = cc.p(0, 0)
		self.jumptime = 0
		self.jumpv0 = 0
		self.jumpacc = 0
		self.jumpdistince = 0
        self.jumpdirection = MGame_Status.kNan
		self.jumptimes = 0

        --播放跑步的动画
        self:actionRun()
    end
end
function Hero:actionRun()
    self.H_Stat = Hero_Action_Status.RUN;
    self:setWH(NoramWH.width, NoramWH.height)
	self:updateRect()
    self:move();
end
function Hero:actionUpdate(dt)
    local deltaY = 0
    if self.H_Stat == Hero_Action_Status.JUMP_Up then 
        self.jumptime = self.jumptime + dt
        deltaY = self.jumpv0 * self.jumptime + self.jumpacc * math.pow(self.jumptime, 2)*0.5
        self.pos.y = self.jumpstartpos.y + deltaY

        if self.jumpdirection == MGame_Status.kUp then
            if self.pos.y >= self.jumpstartpos.y + self.jumpdistince then
			    self.pos.y = self.jumpstartpos.y + self.jumpdistince
			    -- print("Hero jump to top",self.jumptime,self.jumpv0,self.jumpv1)
			    self.H_Stat = Hero_Action_Status.RUN;
			    --if self.jumptimes ==1 then
			    --	MSound.playdown1Sound( )--播放音乐
			    --elseif self.jumptimes ==2 then
			    --	MSound.playdown2Sound( )--播放音乐
			    --end
			    self:jumpDown()
		    end
        end

    end
    if self.pos.x < HeroX then
		self.pos.x = self.pos.x + 50*dt
		if self.pos.x > HeroX then
			self.pos.x = HeroX
		end
	end
    self:setPosition( self.pos )
	self:updateRect()
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
    
	for ti,tv in ipairs( collList ) do
        print("collList")
		if tv.obj:isCollisionBlock() then

			local collstat = tv.collstat

			if math.abs(collstat.deltax) > maxoff_absx then
				maxoff_absx = math.abs(collstat.deltax)
				maxoffx = collstat.deltax
			end
			if math.abs(collstat.deltay) > maxoff_absy then
				maxoff_absy = math.abs(collstat.deltay)
				maxoffy = collstat.deltay
			end

			--print("isCollisionBlock")
			if  tv.obj:getType() == GAMEBLOCK then
	
					if self.H_Stat == Hero_Action_Status.JUMP_Up then
						needjumpstop = true
                        print("跳跃结束")
					end


			end
			
			--if tv.obj:getType() ==MGameEnum.kObjRemora and tv.obj:get_remoratype() == MGameEnum.kBottomDrawBoard then
			--	if collstat.blockbottom and not self.gamemanager:get_IsBouns() then
			--		-- print("踩住了,弹跳动作")
			--		self:boardJump()
			--	elseif maxoffx==0 then
			--		maxoffx = -30
			--	end
			--elseif tv.obj:getType() ==MGameEnum.kObjRemora and tv.obj:get_remoratype() == MGameEnum.kTopBaffle then
			--	if maxoffx==0 and collstat.blockright then
			--		maxoffx = -30
			--	end
			--end
		end
	end

	
	if #collList == 0  then
        if self.H_Stat == Hero_Action_Status.RUN then 
			needjumpdown = true
		end
	end
	
    self.pos.x = self.pos.x + maxoffx
	self.pos.y = self.pos.y + maxoffy
	self:setPosition( self.pos, true)
	self:updateRect()
	--if  self.actstat == herostat.flying then
	--elseif self.gamemanager:get_IsBouns(  ) then
	--	self.pos.y = self.pos.y + maxoffy
	--	self:setPosition( self.pos, true)
	--	self:updateRect()
	--else
		
	--end

	if needjumpstop == true then
		print("jumpStop")
		--MGameConfig.kDownAnimPlay = true
		self:jumpStop()
	end

	if needjumpdown == true then
		print("jumpDown")
		self:jumpDown()
	end
end

function Hero:checkIsDead()
    if self.pos.x < -NoramWH.width*0.6 or self.pos.y < -NoramWH.height*0.6 then
		--self.isdead = true
		--self.H_Stat =Hero_Action_Status.Dead;
		-- MAnimationManager.animStop( self.heroanim )
	end 
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

return Hero