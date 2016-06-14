--region qdylGameLayer.lua
--Author : Bookse
--Date   : 2016/5/30
--此文件由[BabeLua]插件自动生成
local qdylGameLayer = class("qdylGameLayer", cc.load("mvc").ViewBase)
local gScheduler = require("skygame.scheduler")
local monster_manager = require("app.map.monster_manager")
local RUN_CONF = require("app.map.runframeconf");
local Map_UI_Layer = require("app.gamelayer.game_map_ui_layer")
local game_finish_layer = require("app.gamelayer.game_finish")
require("app.map.map_role")
require("app.fight.fight_itembase");
require("app.fight.fight_moveitem");
local envent_id_list = 
{
    "EVENT_ADD_FIGHTITEM_TO_LIST",
    "EVENT_REMOVE_FIGHTITEM",
    "EVENT_ADD_FIGHTITEMOBJ_TO_MAP",
    "Remove_Role_In_Map",
    "Update_Current_Hp",
    "Event_Play_Bomb",
}

function qdylGameLayer:ctor()
    self:registeEvent();
    self.begin_pos = Role_Begin_Pos;
    self.Move_pos = {x=0,y=0};
    self.current_Touch_pos = {x = 0,y = 0};
    self.Role_Pos_Conver_Space ={x=0,y=0};
    self.bool_touch = false;
    self.Game_status = RUN_CONF.STATE.RUNNING;
    self.all_maprole_AI = {};
    self.fight_items = {};
    self:init();
    
    self.monster_manager_list = monster_manager.new(self.UILayer);
   
end
function qdylGameLayer:realse()
    self:removeEvent();
    self:removeFromParent(true);

end
function qdylGameLayer:TouchLayerB(touch, event)
    --print("~~~~~~~TouchLayerB")
    self.begin_pos.x = self.map_hero:getPositionX();
    self.begin_pos.y = self.map_hero:getPositionY();
    local PosTab = touch:getLocation();
    self.Move_pos.x = PosTab.x;
    self.Move_pos.y= PosTab.y;
    self.bool_touch = true;
    self.current_Touch_pos = PosTab;
   -- print("TouchLayerB X:"..PosTab.x..",Y:"..PosTab.y);

   -- print("UILayer X:"..self.UILayer:getPositionX()..",Y:"..self.UILayer:getPositionY());
    return true;
end
function qdylGameLayer:TouchLayerM(touch, event)
    local PosTab = touch:getLocation();
    local NowPosX = PosTab.x;
    local NowPosY = PosTab.y;
    self.Move_pos.x = PosTab.x;
    self.Move_pos.y = PosTab.y;
    self.current_Touch_pos = PosTab;
    --print("TouchLayerB X:"..PosTab.x..",Y:"..PosTab.y);
end
function qdylGameLayer:TouchLayerE(touch, event)
    local PosTab = touch:getLocation();
    self.Move_pos.x = PosTab.x;
    self.Move_pos.y = PosTab.y;
    self.current_Touch_pos = PosTab;
    --print("TouchLayerB X:"..PosTab.x..",Y:"..PosTab.y);
    self.bool_touch = false;
end
function qdylGameLayer:update()
    if self.map_hero:is_dead() then 
        gScheduler.unscheduleGlobal(self.updatetimer);
        self:game_over();
    end
    if self.bool_touch then 
           local des_x =  self.current_Touch_pos.x - display.cx;
           local des_y = self.current_Touch_pos.y - display.cy;
           --print("DesX:"..des_x..",DesY:"..des_y);
           local three_line = math.sqrt(des_x*des_x + des_y*des_y);
           local x_rad =  des_y / three_line;
           local y_rad = des_x / three_line;
           local speedx = 0;
           local speedy = 0;

           --print("CosX :"..math.cos(x_rad)..",SinX:"..math.sin(x_rad));
           
           if des_x >0 and des_y>0 then --1
                speedx = -Role_Move_Speed * math.cos(x_rad);
                speedy = -Role_Move_Speed * math.sin(x_rad);
           elseif des_x<0 and des_y>0 then --2
                speedx = Role_Move_Speed * math.cos(x_rad);
                speedy = -Role_Move_Speed * math.sin(x_rad);
           elseif des_x >0 and des_y<0 then --4
                speedx = -Role_Move_Speed * math.cos(y_rad);
                speedy = Role_Move_Speed * math.sin(y_rad);
           elseif des_x<0 and des_y<0 then --3
                speedx = Role_Move_Speed * math.cos(y_rad);
                speedy = -Role_Move_Speed * math.sin(y_rad);
           end

           self.map_hero:Run();
           local need_line = 6;
           if des_x >=0 then 
             self.map_hero:setDir(FACE_DIR.RIGHT);
           else
             self.map_hero:setDir(FACE_DIR.LEFT); 
           end
           
           if math.abs(des_x) <= need_line and des_y ~= 0 then 
               if des_y >0 then --人要向上
                    speedy = -1*Role_Move_Speed;--地图向下
               else
                    speedy = Role_Move_Speed;
               end
               speedx = 0;
           end

           if des_x~=0 and math.abs(des_y)<= need_line then 
               if des_x >0 then --人要向右
                    speedx = -1*Role_Move_Speed;--地图向左
               else
                    speedx = Role_Move_Speed;
               end
               speedy = 0;
           end

           local ui_layer_posX = self.UILayer:getPositionX();
           local ui_layer_posY = self.UILayer:getPositionY();
           if ui_layer_posX + speedx >-(Game_Max_Width - display.width)   and ui_layer_posX + speedx < 0 then--到达x的边界 
                self.UILayer:setPositionX(ui_layer_posX+speedx);
           end

           
           if ui_layer_posY + speedy < 0 and ui_layer_posY + speedy > -(Game_Max_Heihgt - display.height) then --到达y边界
                self.UILayer:setPositionY(ui_layer_posY+speedy);
           end
           --convertToNodeSpace
           self.Role_Pos_Conver_Space = self.UILayer:convertToNodeSpace(cc.p(self.map_hero:getPositionX(),self.map_hero:getPositionY()));
           --local pos_2 = self.UILayer:convertToNodeSpace(cc.p(self.map_hero:getPositionX(),self.map_hero:getPositionY()));
           --local pos = self.map_hero:convertToNodeSpace(cc.p(ui_layer_posX,ui_layer_posY));
           --print("Role:PosX:"..pos.x..",Pos2:"..pos_2.x);
           --self.UILayer:setPosition(ui_layer_posX+speedx,ui_layer_posY+speedy);

    else
        self.map_hero:StopRun();
    end
    self.monster_manager_list:update_monster(self.Role_Pos_Conver_Space.x,self.Role_Pos_Conver_Space.y);
    
    self:process_Ai(cur_frame_interval);
    local curtime = g_gettime();
    if self.last_update_time1 == nil then
        self.last_update_time1 = curtime;
    end
    local cur_frame_interval = curtime - self.last_update_time1;

    --更新移动的物体
    for k,v in pairs(self.fight_items) do 
        v:update(cur_frame_interval);
    end
end
function qdylGameLayer:process_Ai(cur_frame_interval)
    local curtime = g_gettime();

    if self.map_hero:check_can_use(curtime) then 
        self.map_hero:set_Can_Attack(true);
    end

    if self.last_update_time == nil then
        self.last_update_time = curtime;
    end
    --print("self.last_update_time:"..(curtime - self.last_update_time) / 1000);
    --if (curtime - self.last_update_time) / 1000 > self.map_hero:get_role_info().attack_cd  then --and (not self.map_hero:get_Can_Attack())
    --    self.map_hero:set_Can_Attack(true);
    --    self.last_update_time = curtime;
    --end
    --英雄打怪兽
    self.monster_manager_list:process(curtime,self.map_hero,self.Role_Pos_Conver_Space.x,self.Role_Pos_Conver_Space.y);--self.Role_Pos_Conver_Space
    --self.monster_manager_list
    --for k,v in pairs(t) do 
        
    --end
    --local cur_frame_interval = curtime - self.last_update_time;-- / 1000为1s
    --self.last_update_time = curtime;
end
function qdylGameLayer:Play_Bomb_Action()
    local bomb_action_pos = self.Role_Pos_Conver_Space;

    local jumpTo1 =  cc.JumpTo:create(0.1,cc.p(5,5),10,1);
    local jumpTo2  = cc.JumpTo:create(0.1,cc.p(-5,-5),10,1);
    local jumpTo3  = cc.JumpTo:create(0.1,cc.p(5,-5),10,1);
    local jumpTo4  = cc.JumpTo:create(0.1,cc.p(-5,5),10,1);
    local jumpTo5  = cc.JumpTo:create(0.1,cc.p(0,0),10,1);
    self:runAction(cc.Sequence:create(jumpTo1,jumpTo2,jumpTo3,jumpTo4,jumpTo5));
 
    local animation = cc.Animation:create()
    for i=0,5 do 
        local sprite_name = sg_loadResources("res#normal#ui#bomb#8_"..i);
        animation:addSpriteFrameWithFile(sprite_name);
    end
    local bomb_sprite = CreateSprite("res#normal#ui#bomb#8_0");
    self:addChild(bomb_sprite);
    bomb_sprite:setPosition(bomb_action_pos);
    animation:setDelayPerUnit(0.1);
    --local animation = cc.Animation:createWithSpriteFrames(animFrames, 0.3)
    bomb_sprite:runAction( cc.Sequence:create( cc.Animate:create(animation),cc.RemoveSelf:create() ));
    --print("play_bomb");
end
function qdylGameLayer:ready()
    self.Game_status = RUN_CONF.STATE.READY
    for k,v in pairs(self.monster_manager_list) do 
        v:StopRun();
    end
end
function qdylGameLayer:game_over()
    self.finish = game_finish_layer.new();
    self:addChild(self.finish,View_Ozder.Game_Finish);
end
function qdylGameLayer:init()
    self.rootLayer = display.newLayer();
    self:addChild(self.rootLayer);

    self.map_db = sg_getMapDBinfo(101);
    self.UILayer = display.newLayer();
    --self.UILayer:setAnchorPoint(0,0);
    self.rootLayer:addChild(self.UILayer);
    local image1 = CreateSprite(self.map_db[1]);
    --image1:setAnchorPoint(0,0);
    self.UILayer:addChild(image1);
    image1:setPosition(image1:getContentSize().width/2,image1:getContentSize().height/2);

    local image2 = CreateSprite(self.map_db[2]);
    self.UILayer:addChild(image2);
    image2:setPosition(image1:getContentSize().width +image2:getContentSize().width/2 ,image1:getContentSize().height/2);
   
    local image3 = CreateSprite(self.map_db[3]);
    self.UILayer:addChild(image3);
    image3:setPosition(image3:getContentSize().width/2 ,image1:getContentSize().height + image3:getContentSize().height / 2);
 

    local image4 = CreateSprite(self.map_db[4][1]);
    self.UILayer:addChild(image4);
    image4:setPosition(image3:getContentSize().width +image4:getContentSize().width/2 ,image3:getContentSize().height + image4:getContentSize().height / 2);

    print("self.UILayer：　ｐｏｓ："..self.UILayer:getPositionX());
    --self.UILayer:setPosition(-1136 / 2,-640 / 2);
    self.Role_obj_Layer = display.newLayer();
    self.rootLayer:addChild(self.Role_obj_Layer);
    self.role = Croledb_interface.new(1000);
    self.map_hero = CMapRole.new(1,self.role,nil,self.UILayer);
    self.map_hero:set_camp(CAMP_TYPE.ALLIANCE);
	self.Role_obj_Layer:addChild( self.map_hero );
    self.map_hero:setPosition(display.cx,display.cy);
    self.map_hero:set_hp(10);
    self.Role_Pos_Conver_Space = self.UILayer:convertToNodeSpace(cc.p(self.map_hero:getPositionX(),self.map_hero:getPositionY()));
    
    --   self.map_hero:convertToNodeSpace(cc.p(self.UILayer:getPositionX(),self.UILayer:getPositionY()));
    Role_Move_Speed =  self.role.speed /100;
    self.touch_layer = display.newLayer(cc.c4b(255,255,255,255),cc.size(1136 * 2,640*2));
    self.rootLayer:addChild(self.touch_layer);
    self.touch_layer:setAnchorPoint(0,0);
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function(touch, event) return self:TouchLayerB(touch, event) end,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(function(touch, event) return self:TouchLayerM(touch, event) end,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(function(touch, event) return self:TouchLayerE(touch, event) end,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self.UILayer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.UILayer) 

    self.updatetimer = gScheduler.scheduleGlobal(function() if G_isUserDataValid(self) then self:update() end end, 0)


    self.Map_Ui_Layer = Map_UI_Layer.new();
    self:addChild(self.Map_Ui_Layer,View_Ozder.Top_UI_Z);
    self:update_current_role_hp(self.map_hero:get_hp());

end
function qdylGameLayer:update_current_role_hp(hp)
    local role_hp = hp or  0;
    self.Map_Ui_Layer:set_current_hp(role_hp);
end

function qdylGameLayer:add_fightitem(item)
    table.insert(self.fight_items, item);
end
function qdylGameLayer:add_move_item(item,z)
    if not item then 
        return ;
    end
    z = z or MAP_Z.MOVE_ITEM;
    self.UILayer:addChild(item, z);
end
function qdylGameLayer:remove_fightitem(t, id)
    for k,v in pairs(self.fight_items) do
        if v.id == id and v.item_type == t then
            v:release();
            if G_isUserDataValid(v.map_obj) then
                v.map_obj:removeFromParent(true);
            end
            table.remove(self.fight_items, k);
            break;
        end
    end
end
function qdylGameLayer:remove_role_in_map(roleId)
    if roleId then 
        self.monster_manager_list:del_monster(roleId);    
    end
end
function qdylGameLayer:OnEvent(event, ...)
    local args = { ...}
    if event == "EVENT_ADD_FIGHTITEM_TO_LIST" then
        self:add_fightitem(args[1]); 
    elseif event == "EVENT_ADD_FIGHTITEMOBJ_TO_MAP" then 
        self:add_move_item(args[1], args[2]);
    elseif event == "EVENT_REMOVE_FIGHTITEM" then   
        self:remove_fightitem(args[1], args[2]); 
    elseif event == "Remove_Role_In_Map" then 
        self:remove_role_in_map(args[1],args[2]);
    elseif event == "Update_Current_Hp" then 
        self:update_current_role_hp(args[1]);
    elseif event == "Event_Play_Bomb" then 
        self:Play_Bomb_Action();
    end 
end

function qdylGameLayer:registeEvent()
    self.eventFun = function(...) self:OnEvent(...); end	
    for k,v in pairs(envent_id_list) do
        EventSystem:registEventHanlder(v, self.eventFun)	
    end	  
end
function qdylGameLayer:removeEvent()
    for k,v in pairs(envent_id_list) do
       EventSystem:removeEventHandler(v, self.eventFun);
    end	
end

return qdylGameLayer;
--endregion
