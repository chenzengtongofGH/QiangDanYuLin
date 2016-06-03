--local GameLayer = class("GameLayer")
local GameLayer = class("GameLayer", cc.load("mvc").ViewBase)
function GameLayer:ctor()
	self.layer = cc.Layer:create()
	self:addChild(self.layer,View_Ozder.UI_Z)
    self:init();
end
function GameLayer:init()
    self.jump_btn = sg_ui.create_button(function() self:jump_btn_event() end , {"res#normal#ui#mapbg#Runup","res#normal#ui#mapbg#Runup","res#normal#ui#mapbg#Runup"});
    self.layer:addChild(self.jump_btn);
    

    self.jump_btn:setPosition(cc.p(display.width - self.jump_btn:getContentSize().width/2,self.jump_btn:getContentSize().height/2));
    --local x,y = self.jump_btn:getPosition();
    self.Calculate_km = sg_ui.LabelTTF("123321");
    self.layer:addChild(self.Calculate_km);
    self.Calculate_km:setPosition(cc.p(display.width - self.jump_btn:getContentSize().width/2,display.height - 200));
end
function GameLayer:jump_btn_event()
    EventSystem:pushEvent("Jump_role");
end
function GameLayer:get_layer()
	return self.layer
end
return GameLayer