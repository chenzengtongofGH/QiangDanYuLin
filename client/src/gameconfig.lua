--region czt.lua
--Author : ky011
--Date   : 2015/7/15
--此文件由[BabeLua]插件自动生成
--配置一些全局函数
MAPLAYER  = 500 --这个是背景的z轴
GAMESPEED = 300 --map移动速度
MAPWIDTH  =1920 --单张map宽度
MAPHEIGHT = 640 --单张map高度
GAMEROPE = 0 --绳子
GAMEBLOCK = 1 --地板形状对象
GAME_HERO = 2


View_Ozder = 
{
    Map  = 2,
    Role = 3,
    UI_Z = 4,
    Top_UI_Z = 5,
}

Jump_distance = 220;
Jump_acc = -400;
Jump_v0 = 800;
Jump_Time = 0;

-- 地图角色动作类型
MAPROLE_ACTION_STATE = 
{
    IDLE        = 1,
    RUN         = 2,
    JUMP        = 3,
    DIE         = 4,
    MOV_ATK     = 5,
    SKILL       = 6,
    BE_ATK      = 7,
    SPELL       = 8,
    BE_ATK2     = 9,
    VIGILANCE   = 10,
    STAND_ATK   = 11,
    COMMON      = 12, -- 通用动作状态
}
ACT_INFO = {
    { MAPROLE_ACTION_STATE.IDLE, "daiji", - 1 },
    { MAPROLE_ACTION_STATE.RUN, "yidong", - 1 },
    { MAPROLE_ACTION_STATE.JUMP, "tiaoyue", - 1 },
    { MAPROLE_ACTION_STATE.DIE, "siwang", - 1 },
    { MAPROLE_ACTION_STATE.MOV_ATK, "ydgongji", - 1 },
    { MAPROLE_ACTION_STATE.SKILL, "mfgongji", - 1 },
    { MAPROLE_ACTION_STATE.BE_ATK, "sjjiangzhi", - 1 },
    { MAPROLE_ACTION_STATE.SPELL, "ychang", - 1 },
    { MAPROLE_ACTION_STATE.BE_ATK2, "sjfangun", - 1 },
    { MAPROLE_ACTION_STATE.VIGILANCE, "jingjue", - 1 },
    { MAPROLE_ACTION_STATE.STAND_ATK, "zlgongji", 1 },
    { MAPROLE_ACTION_STATE.COMMON, "daiji", -1 },
}

-- 战斗参数
FIGHT_PARAM = 
{
    -- 被击退初速度(像素/秒)
    retreat_speed = 400,
    boos_retreat_speed = 900,
    rush_retreat_speed = 500,
    -- 被击退减速加速度(像素/秒)/秒
    retreat_acceleration = 600,
    -- 向前移动速度(像素/秒)
    move_speed = 300,
    -- 物理攻击间隔(秒）
    phy_attack_cd = 1,
    boss_phy_atk_cd = 2,
    -- 法术效果飞行速度(像素/秒)
    magic_item_speed = 500,
    -- 回到出生点速度(像素/秒)
    move_to_birth_speed = 400,	
	--加速播放攻击动作
	meleeAtkAni_speed = 2,
    -- 战斗时间(秒)
    duration = 100,
    -- 怪物波之间的时间间隔(秒)
    wave_interval = 10,
    -- 所有怪物出现之后战斗时间(秒)
    wave_time_limit = 30,
}

function GET_ACT_INFO(id)
    for k,v in pairs(ACT_INFO) do
        if id == v[1] then
            return {v[2], v[3]};
        end
    end
    return nil;
end
-- 朝向
FACE_DIR = 
{
    LEFT = 1,
    RIGHT= 2,
}

Hero_Action_Status = 
{
    IDLE = 0,
    RUN = 1,
    JUMP_Up = 2,
    JUMP_DOWN = 3,
    Dead  = 4 ,
}
MGame_Status = 
{
    kUp = 1,
    kDown=2,
    kObjBlock=3,
    kNan = 4,
}
Role_Brith_Pos = {x=100,y=100}


Role_Begin_Pos = {x  = display.cx, y  = display.cy};

Role_Move_Speed = 5;

Dead_line = 10;

Role_DIR_Point = 
{
    RIGHT_NONE = {1,0},
    RIGHT_TOP = {1,1},
    NONE_TOP = {0,1},
    LEFT_TOP = {-1,1},
    LEFT_NONE = {-1,0},
    LEFT_BUTTOM = {-1,-1},
    NONE_BUTTOM = {0,-1},
    RIGHT_BUTTOM =  {1,-1}
}
Game_Max_Width = 1136 * 2;
Game_Max_Heihgt = 640 *2 ;


Hero_Id = 1;
--endregion
