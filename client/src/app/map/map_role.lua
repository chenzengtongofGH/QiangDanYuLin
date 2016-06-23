--region map_role.lua
--Author : Bookse
--Date   : 2016/5/30
--此文件由[BabeLua]插件自动生成
require("app.map.mapnode")
require("app.data.skill")
CMapRole = class("CMapRole", CMapNode)
local maprole_equip = require("app.map.maprole_equip");
local SHOW_DEBUG = true;

function CMapRole:ctor(id, role,scale,fight_layer)
    self.super:ctor();
    self.id = id;               -- 编号
    self.role = role;           -- 对应随从信息
    self.scale = scale or 1;
    self.fight_layer = fight_layer;
    self.H_Stat = Hero_Action_Status.IDLE;
    self.can_attack = false;
    self.Bombing = false;
    self.level = 1;
    self.timeline = 0;
    self.next_use_skill_time = 0;
    self.cur_hp = 1;
    self.next_zhuangdan_time = 0;
    self:init();
    self:create_skill();
    self:set_zidan(Game_role_zidan_count);
end
function CMapRole:get_play_BombIng()
    return self.Bombing;
end
function CMapRole:create_skill()
    self.Skill_data =  CSkill.new(self.role.skill_Id,self.level);
    --print("create_skill");
end
function CMapRole:set_zidan(count)
    self.zidan_count = count;
    if self.id == Hero_Id then 
        G_Hero:set_Bomb_count(count);
        EventSystem:pushEvent("Event_Rome_Zidan_Count");
    end
end
function CMapRole:get_zidan()
    return self.zidan_count;
end
function CMapRole:set_Can_Attack(bool_attack)
    self.can_attack = bool_attack;
end
function CMapRole:get_Can_Attack()
    return self.can_attack;
end
--创建debug 信息
function CMapRole:create_debug_info()
    -- log
    local LOG_W = 100;
    local lc = cc.c4b(0,0,255,128);
    self.log_layer = display.newLayer(lc);
    self.log_layer:setContentSize(LOG_W,LOG_W);
    self.log_layer:setPosition(cc.p(-LOG_W/2, LOG_W*self:get_conf_scale()));
    self.log_layer:setScale(self:get_conf_scale());
    self.log_layer:addTo(self);

    self.ai_state = sg_ui.LabelTTF("-1", nil, 60);
    self.ai_state:setPosition(LOG_W/2, LOG_W/2 + 10);
    self.ai_state:setColor(cc.c3b(255,255,255));

    --self.hp_label = sg_ui.LabelTTF(self.cur_hp .. "/" .. self.max_hp, nil, 32);
    --self.hp_label:setPosition(LOG_W/2, 13);
    --self.hp_label:setColor(cc.c3b(255,255,255));

    self.log_layer:addChild(self.ai_state);
    --self.log_layer:addChild(self.hp_label);
    self.log_layer:setVisible(SHOW_DEBUG);
end
function CMapRole:init()
    self.render = sg_create_armature(self.role.RoleJS);
    self.render:setScale(self:get_conf_scale());
    local render_size = self.render:getContentSize();
    self.render:addTo(self,2);
    local equip_info = self.role.equip_Id_table;

    for k,v in pairs(equip_info) do 
        local Equip_id = math.ceil(v);
        local equip_db = Cequipdb_interface.new(Equip_id);
        self:ChangeLeftWeapon(equip_db.equip_json);
    end
    local bomb_sprite = CreateSprite("res#normal#ui#bomb#8_0");
    bomb_sprite:addTo(self,3);
    bomb_sprite:setVisible(false);
    self.bomb_sprite = bomb_sprite;
    self.bomb_sprite:setPosition(cc.p(0,self.bomb_sprite:getContentSize().height / 2));
    --self:create_render(self.init_modle_info); 
end
function CMapRole:add_bomb_action(item_data)
    
    if item_data then 
        local both_image_name = item_data.item_image;
        local item_image_count = item_data.item_count;
        local animation = cc.Animation:create()
        for i=0,item_image_count do 
            local sprite_name = sg_loadResources(both_image_name..i);
            animation:addSpriteFrameWithFile(sprite_name);
        end
        --local bomb_sprite = CreateSprite(both_image_name .. "0");
        --bomb_sprite:addTo(self,3);
        --self:addChild(bomb_sprite); self.render:getContentSize();
        self.Bombing = true;
        self.bomb_sprite:setVisible(true);
        self.bomb_sprite:setPosition(cc.p(0,self.bomb_sprite:getContentSize().height / 2));
        animation:setDelayPerUnit(0.1);
        local call_back = cc.CallFunc:create(function() self.bomb_sprite:setVisible(false); self.Bombing = false;  end );
        --self.bomb_sprite:setVisible(false)
        self.bomb_sprite:runAction( cc.Sequence:create( cc.Animate:create(animation),call_back ));
    end
    
end
--主手
function CMapRole:ChangeLeftWeapon(reskey)
    self.leftweapon = maprole_equip.change_equip(self.render, BONE_NAME.L_WEAPON, reskey, nil, "061"); 
end

function CMapRole:get_role_info()
    return self.role;
end
function CMapRole:get_Skill_data()
    return self.Skill_data;
end
function CMapRole:get_conf_scale()
    return self.role.modle_scale;
end
function CMapRole:Run()
    --print("Run Run：status :"..self.H_Stat )
    if self.H_Stat ~= Hero_Action_Status.RUN then 
        self.H_Stat = Hero_Action_Status.RUN;
        --self:setWH(NoramWH.width, NoramWH.height)
	    --self:updateRect()
        self:move();
    end
end
function CMapRole:StopRun()
    if self.H_Stat ~= Hero_Action_Status.IDLE then 
        self.H_Stat = Hero_Action_Status.IDLE;
        self:idle();
    end
end
function CMapRole:move()
    self:play_ani(MAPROLE_ACTION_STATE.RUN);
end
function CMapRole:idle()
    self:play_ani(MAPROLE_ACTION_STATE.IDLE);
end

function CMapRole:play_ani(ani_id, param)
    local info = GET_ACT_INFO(ani_id);
    if info and self.render then 
        self.render:getAnimation():play(unpack(info));
    end
end
function CMapRole:attack_emnegy(curtime,target_role)--优化直接发射子弹 发射一个技能
    if not stand then stand = false; end

    if self:get_Can_Attack() then 
        
    end
    if self:get_next_zhuangdan_time() ~= 0 and curtime < self:get_next_zhuangdan_time()  then 
        return ;
    end
    local skill  = self:get_Skill_data();

     local time = skill.conf.detail_delay;

    if time > 0 then -- 是否延迟播放技能
        local function cb()
            skill:use(self.timeline, self);
            EventSystem:pushEvent("EVENT_SHAKE_MAP");
            if SKILL_WORDS[skill.id] then
                EventSystem:pushEvent("EVENT_HIDE_FIGHT_PIC_TIP", MAP_TIP_NAME.SKILLWORD);
            end
        end
        sg_action.delay_call(self.maprole, time/1000, cb);
    else
        local result = skill:use(self.timeline, self,target_role);
        self:set_Can_Attack(false);
        self:set_next_skill_time(curtime);
        self:set_zidan(self.zidan_count - 1);
        if self.zidan_count == 0 then 
            self:set_zhuangdan_time(curtime);
        end        
        --curtime
    end
    skill:play_use_sound(self);
    skill:play_use_effect(self);
    if ani == true then
        local actname = nil;
        if self.can_phy_atk == ATTACK_TYPE.MELEE then
            actname = "zbfuzhuang";
        end    
        if skill.conf.use_action then
            actname = skill.conf.use_action;
        end  
        self.maprole:use_skill(cb, actname);
    end
    --self:set_Can_Attack(false);
    --self:attack();
end
function CMapRole:get_hp()
    return self.cur_hp;
end
function CMapRole:set_hp(hp)
    self.cur_hp = hp;
end
--显示一些受击特效
function CMapRole:be_attack(info)
    local des_hp = info.des_hp or 0;
    self.cur_hp = self:get_hp()  - des_hp;
    if self.id < 500 then  
        EventSystem:pushEvent("Update_Current_Hp",self:get_hp());
        self:play_font_action(des_hp);
    end
    if self.cur_hp<=0 then 
        EventSystem:pushEvent("Remove_Role_In_Map",self.id);
    end
end
function CMapRole:play_font_action(damage_hp)
    local hp_label = sg_ui.LabelTTF("-"..damage_hp,nil,48);
    hp_label:setPosition(0,self.render:getContentSize().height/2)
    self.render:addChild(hp_label,100);
    hp_label:runAction(cc.Sequence:create(cc.MoveBy:create(3,cc.p(0,200)),cc.RemoveSelf:create() ) );
    --local damage_font
end
function CMapRole:set_next_skill_time(current_time)
    self.next_use_skill_time = current_time + self.role.attack_cd * 1000;
end
function CMapRole:set_zhuangdan_time(current_time)
    self.next_zhuangdan_time = current_time + Game_role_zidan_cd * 1000;
    EventSystem:pushEvent("Event_Show_Zhuangdan_TTF");
end
function CMapRole:get_next_zhuangdan_time()
    return self.next_zhuangdan_time;
end
function CMapRole:check_can_use(current_time)
    if current_time > self.next_use_skill_time  then 
        return true;
    end
    return false;
end
function CMapRole:update(interval)
    self.timeline = self.timeline + i;
end
-- skill 技能对象
-- ani   是否播放施法动作
-- cb    施法播放完毕后的回调
function CMapRole:use_skill(skill, ani, cb)
    if not skill then
        return;
    end

end

-- 阵营
function CMapRole:set_camp(c) self.camp = c; end
function CMapRole:get_camp() return self.camp; end

function CMapRole:attack()
    
    self:play_ani(MAPROLE_ACTION_STATE.STAND_ATK);
        --self.ani_fsm:play_ani(MAPROLE_ACTION_STATE.MOV_ATK, {["eff"] = effinfo}); 
end
function CMapRole:Dead_Role()
    self.status = Hero_Action_Status.Dead;
    self:Dead();
    local call_function = cc.CallFunc:create(function() self:remove_self();  end );
    self:runAction(cc.Sequence:create( cc.DelayTime:create(0.8),call_function));
end
function CMapRole:remove_self()
    if G_isUserDataValid(self) then 
        self:removeFromParent();
    end
end
function CMapRole:Dead()
    self:play_ani(MAPROLE_ACTION_STATE.DIE);
end
-- 设置朝向
function CMapRole:setDir(dir)
    if not self.render then return end
    if dir == FACE_DIR.LEFT then
        self.render:setScaleX(-1 * self:get_conf_scale());
    end
    if self.face_dir == FACE_DIR.LEFT and dir == FACE_DIR.RIGHT then
        self.render:setScaleX(1 * self:get_conf_scale());
    end
    self.face_dir = dir;
end
function CMapRole:getDir()
    return self.face_dir;
end
function CMapRole:is_dead()
    return self.cur_hp <= 0;
end
function CMapRole:get_Pos()
    return self.fight_layer:convertToNodeSpace(cc.p(self:getPositionX(),self:getPositionY()));
end
--endregion
