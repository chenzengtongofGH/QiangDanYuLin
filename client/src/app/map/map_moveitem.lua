--region map_moveitem.lua
--Author : Bookse
--Date   : 2016/6/2
--此文件由[BabeLua]插件自动生成
require("app.map.mapnode")

CMapMoveItem = class("CMapMoveItem", CMapNode)

-- 创建
function CMapMoveItem:ctor(effinfo)
    self.super:ctor();      
    if effinfo then
        self.render = sg_create_armature(effinfo[1]);
        self.render:getAnimation():play(effinfo[2],-1);
        self.render:addTo(self);
    end
end

function CMapMoveItem:get_size()
    if G_isUserDataValid(self.render) then
        return self.render:getContentSize();
    else
        return cc.size(0,0);
    end
end


--endregion
