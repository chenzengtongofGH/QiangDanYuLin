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
    --子弹数量
    self.zidan_count = 0;
    --当前星星数
    self.get_star_count = 0;
    
end
function CHero:get_money()
    return self.Money;
end
function CHero:get_Star_count()
    return self.get_star_count;
end
function CHero:set_zidan_count(count)
    self.zidan_count  = count;
end
function CHero:get_zidan_count()
    return self.zidan_count ;
end
function CHero:get_test_data()
    
end
function CHero:set_Bomb_count(c)
   self.Bomb_Count = c; 
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
