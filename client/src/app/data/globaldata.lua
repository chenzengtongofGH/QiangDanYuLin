--region globaldata.lua
--Author : Bookse
--Date   : 2016/6/2
--此文件由[BabeLua]插件自动生成
require("app.data.G_Hero");

G_Hero = nil;
function g_init_gamedata()
    G_Hero = CHero.new();
end

-- 详细类型
SKILL_DETAIL = 
{
    ROLE_TO_DIR = 1,    -- 角色发射一个对象
    ADD_TRAP = 2,       -- 创建一个陷阱(可以绑定到人身上 旋风护盾)
    REPLACE_MELEE = 3,  -- 替代近战的
    ADD_BUFF = 4,       -- 添加BUFF
    EXPLOSIVE = 5,      -- 爆炸物
    HEAL = 6,           -- 治疗术
    REBIRTH = 7,        -- 复活
    RING = 8,           -- 环状技能
    CHAIN = 9,          -- 链状技能
    POINT_TO_POINT = 10,-- 点对点抛物线
    DIRECT_DAMAGE = 11,--点对点直接伤害
    CALLFRIEND = 12,--召唤
}

-- 地图物件类型
MAP_ITEM =
{
    MOVE = 1,       -- 移动
    AOE = 2,        -- AOE
    EXPLOSIVE = 3,  -- 炸弹
    CHAIN = 4,      -- 链
    P2P = 5,        -- 点到点
    TRAP = 6,       -- 陷阱
}
--技能目标
SKILL_TARGET = 
{
    NONE_ONE = 1,                   -- 不需要目标
    SELF = 2,                       -- 自己
    RANDOM_ENEMY = 3,               -- 随机敌人
    FRONT_GROUND = 4,               -- 脚下地面
    FOOT_GROUND = 5,                -- 身前地面
    ALL_RETINUES = 6,               -- 所有右方随从
    THE_LOWEST_PER_HEALTH = 7,      -- 友方百分比血量最低
    ALL_ENEMY = 8,                  -- 所有敌人
    ENEMY_IN_RANGE = 9,             -- 施法距离内所有敌人
    THE_RANDOW_OUR_ROLE = 10 ,      -- 己方随机一个英雄，近战优先
    THE_FIGHT_TOP_ROLE = 11,        -- 战斗最前线的
    THE_RANDOW_THREE_ENEMY = 12 ,   -- 敌方随机3个
}

FIGHT_TARGET_TYPE = 
{
    FRIENDLY = 1,   -- 友军
    ENEMY = 2,      -- 敌军
    ALL = 3;        -- 所有角色
}

-- 阵营
CAMP_TYPE=
{
    -- 联盟
    ALLIANCE = 1,
    -- 部落
    HORDE = 2,
}

-- 地图的Z坐标
MAP_Z =
{
    BG = 1,
    CSB = 10,
    CLOUND = 20,
    ITEM = 30,
    ROLE_SHADOW = 39,
    ROLE = 40,
    TRAP = 42,
    SHADE = 45,
    SPOILS = 46,
    MOVE_ITEM = 80,
    ERUPT_ROLE = 90,
    WORDS = 96,
}
--endregion
