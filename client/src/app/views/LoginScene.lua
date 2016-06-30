-- region LoginScene.lua
-- Author : ky011
-- Date   : 2015/7/15
-- 此文件由[BabeLua]插件自动生成
local LoginScene = class("LoginScene", cc.load("mvc").ViewBase)
local role_layer = require("app.gamelayer.Game_RoleInfo_layer")
function LoginScene:onCreate()
    self:loginGame();
end
function LoginScene:loginGame()
    -- local node = (conf[1])
    self.LoginLayer = sg_load_csb("res#csb#ui#MainLayer");
    self.LoginLayer:addTo(self);

    local function enterGame(sender,eventType)
         if eventType == TOUCH_EVENT_BEGAN then
             self:getApp():enterScene("New_Game_Scene")
         end 
    end
    local Node_servername = sg_get_child_by_name(self.LoginLayer, "Button_shoudongwanwan");
    Node_servername:addTouchEventListener( enterGame ); --view:enterScene("GameScene") end)


    local enter_role_info_btn = sg_get_child_by_name(self.LoginLayer,"Button_Role");
    enter_role_info_btn:addTouchEventListener( function(sender,eventType) self:enter_role_info(sender,eventType)   end  );

    local Image_2 = sg_get_child_by_name(self.LoginLayer,"Image_2");
    local self_money_TTF = sg_ui.LabelTTF("0");
    self_money_TTF:addTo(Image_2);
    self_money_TTF:setPosition(Image_2:getContentSize().width/2,Image_2:getContentSize().height/2);
    

    local Star_image = sg_get_child_by_name(self.LoginLayer,"Image_Star");
    local Star_Count_TTF = sg_ui.LabelTTF("0",nil,64);
    Star_Count_TTF:addTo(Star_image);
    Star_Count_TTF:setPosition(Star_image:getContentSize().width*3/2,Star_image:getContentSize().height/2);


    self.self_money_TTF = self_money_TTF;
    self.Star_Count_TTF = Star_Count_TTF;
    --get_Star_count
end
function LoginScene:enter_role_info(sender,eventType)
    if eventType == TOUCH_EVENT_ENDED then
          local role_layer_1 = role_layer.new();
          self:addChild(role_layer_1);
           --self:getApp():enterScene("New_Game_Scene")
    end 
end
function LoginScene:update_info()
    self.self_money_TTF:setString(G_Hero:get_money());
    self.Star_Count_TTF:setString(G_Hero:get_Star_count());
end
return LoginScene;


-- endregion
