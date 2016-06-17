--region game_map_ui_layer.lua
--Author : Bookse
--Date   : 2016/6/12
--此文件由[BabeLua]插件自动生成
local game_map_ui_layer = class("game_map_ui_layer", cc.load("mvc").ViewBase)

local Hp_Name_L = "hp:"
local ShouLei_Name_L = "shoulei:";
local Defend_Name_L = "defend:";
local Bomb_Name_L = "Bomb:"
local Score_Name_L = "Score:"
local Time_Name_L = "Time:"
function game_map_ui_layer:ctor()
    self:init();
end

function game_map_ui_layer:init()
    self.root_csb = sg_load_csb("res#csb#ui#game_ui_tips");
    self:addChild(self.root_csb);

    
    local ui_hp_sprite = sg_get_child_by_name(self.root_csb , "Image_hp")--CreateSprite 

    local current_hp_label =  sg_ui.LabelTTF("100");
    ui_hp_sprite:addChild(current_hp_label);
    current_hp_label:setPosition( ui_hp_sprite:getContentSize().width / 2, ui_hp_sprite:getContentSize().height / 2);
    self.current_hp_label = current_hp_label;
 
    local Image_defend = sg_get_child_by_name(self.root_csb , "Image_defend")
    local defend_label = sg_ui.LabelTTF(Defend_Name_L..G_Hero:get_defend());
    Image_defend:addChild(defend_label);
    defend_label:setPosition( Image_defend:getContentSize().width / 2, Image_defend:getContentSize().height / 2);
    self.defend_labelTTF = defend_label;


    local Image_bomb = sg_get_child_by_name(self.root_csb , "Image_bomb")
    local BombCount_label = sg_ui.LabelTTF(Bomb_Name_L..G_Hero:get_Bomb_count());
    Image_bomb:addChild(BombCount_label);
    BombCount_label:setPosition( Image_bomb:getContentSize().width / 2, Image_bomb:getContentSize().height / 2);
    self.BombCount_labelTTF = BombCount_label;

    local Image_count = sg_get_child_by_name(self.root_csb , "Image_count")
    local Score_label = sg_ui.LabelTTF(Score_Name_L..G_Hero:get_Bomb_count());
    Image_count:addChild(Score_label);
    Score_label:setPosition( Image_count:getContentSize().width / 2, Image_count:getContentSize().height / 2);
    self.Score_labelTTF = Score_label;

    local Image_time = sg_get_child_by_name(self.root_csb , "Image_time")
    local Time_label = sg_ui.LabelTTF(Time_Name_L..G_Hero:get_Bomb_count());
    Image_time:addChild(Time_label);
    Time_label:setPosition( Image_time:getContentSize().width / 2, Image_time:getContentSize().height / 2);
    self.Time_labelTTF = Time_label;



    local item_nums_sprite = sg_get_child_by_name(self.root_csb, "Image_shoulei");
    local item_nums_label_TTF = sg_ui.LabelTTF(ShouLei_Name_L..G_Hero:get_item_num(),nil,24);
    item_nums_sprite:addChild(item_nums_label_TTF);
    item_nums_label_TTF:setPosition(item_nums_sprite:getContentSize().width/2,item_nums_sprite:getContentSize().height/2);
    self.item_nums_label_TTF = item_nums_label_TTF;


    local Button_pause = sg_get_child_by_name(self.root_csb, "Button_pause");
    sg_ui.addTouchEventListener_music(Button_pause,function() self:pause_game(); end );

    local bomb_btn = sg_get_child_by_name(self.root_csb,"Button_bomb");
    sg_ui.addTouchEventListener_music(bomb_btn,function() EventSystem:pushEvent("Event_Play_Bomb",ITEM_LIST_TYPE.BOMB_TYPE) end );

    local Button_change_bomb = sg_get_child_by_name(self.root_csb,"Button_change_bomb");
    sg_ui.addTouchEventListener_music(Button_change_bomb,function() self:change_role_bomb() ;end );
    
    

end
function game_map_ui_layer:change_role_bomb()
    EventSystem:pushEvent("Event_Change_Bomb");
end
function game_map_ui_layer:pause_game()
    print("pause_game") ;
end
function game_map_ui_layer:update_Score_count(score_num)
    self.Score_labelTTF:setString(Score_Name_L..score_num);
end

function game_map_ui_layer:update_Time(time)
    self.Time_labelTTF:setString(Time_Name_L..time);
end

function game_map_ui_layer:update_Bomb_count()
    self.BombCount_labelTTF:setString(Bomb_Name_L..G_Hero:get_Bomb_count());
end

function game_map_ui_layer:update_defend()
    self.defend_labelTTF:setString(Defend_Name_L..G_Hero:get_defend());
    
end
function game_map_ui_layer:update_item_count()
    self.item_nums_label_TTF:setString(ShouLei_Name_L..G_Hero:get_item_num());
end
function game_map_ui_layer:set_current_hp(c_hp)
    self.current_hp_label:setString(Hp_Name_L..c_hp);
end


return game_map_ui_layer;
--endregion
