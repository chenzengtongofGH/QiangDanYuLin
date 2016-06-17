--region GHero.lua
--Author : Bookse
--Date   : 2016/6/15
--此文件由[BabeLua]插件自动生成
CHero = class("CHero")

function CHero:ctor()
    -- 等级
    self.level = 1
    --钞票
    self.Money = 10000;
    -- 名字
    self.name = "Jack"
    -- 道具数量
    self.ItemNums = 10;
    -- 钻石
    self.diamond = 0;
    -- 体力
    self.Power = 0;
    --护甲
    self.defend = 0;
    --炸弹量
    self.Bomb_Count = 0;

end

function CHero:get_test_data()
    
end
function CHero:get_Bomb_count()
    return self.Bomb_Count ;
end
function CHero:get_defend()
    return self.defend ;
end
function CHero:set_item_num(Item_num)
    self.ItemNums = Item_num;
end
function CHero:get_item_num()
    return self.ItemNums;
end
--endregion
