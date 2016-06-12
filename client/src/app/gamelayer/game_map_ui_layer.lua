--region game_map_ui_layer.lua
--Author : Bookse
--Date   : 2016/6/12
--此文件由[BabeLua]插件自动生成
local game_map_ui_layer = class("game_map_ui_layer", cc.load("mvc").ViewBase)

function game_map_ui_layer:ctor()
    
    self:init();
end

function game_map_ui_layer:init()
    self.bg_sprite = CreateSprite("res#normal#ui#guide#kuang2");
    self:addChild(self.bg_sprite);
    self.bg_sprite:setPosition(display.cx,display.height -  self.bg_sprite:getContentSize().height / 2);
    local ui_hp_sprite = CreateSprite("res#normal#ui#guide#xueping");
    self.bg_sprite:addChild(ui_hp_sprite);
    ui_hp_sprite:setPosition(self.bg_sprite:getContentSize().width/2,self.bg_sprite:getContentSize().height / 2);

    local current_hp_label =  sg_ui.LabelTTF("100");
    ui_hp_sprite:addChild(current_hp_label);
    current_hp_label:setPosition( 100, ui_hp_sprite:getContentSize().height / 2);

    self.current_hp_label = current_hp_label;
end

function game_map_ui_layer:set_current_hp(c_hp)
    self.current_hp_label:setString(c_hp);
end


return game_map_ui_layer;
--endregion
