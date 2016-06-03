-- runframeconf.lua
-- 跑酷 部分配置

local run_frame_conf = {};

-- 跑酷状态
run_frame_conf.STATE = 
{
    CREATE  = 1,    -- 创建
    INIT    = 2,    -- 初始化
    ENTER   = 3,    -- 进场
    READY   = 4,    -- 准备
    RUNNING = 5,    -- 跑步过程中
    FIGHT   = 6,    -- 战斗
    FAILED  = 7,    -- 失败
    SUCCESS = 8,    -- 胜利
    TRAP    = 9,    -- 中陷阱   
    PAUSE   = 10,   -- 暂停
    TRANSMIT = 11,  -- 传送
    MOVIE = 12,     -- 剧情
    NONE    = 13,   -- 空状态(不干任何事情)
}

run_frame_conf.UI_ZORDER = 41;
-- 进入地图时移动的距离
run_frame_conf.ENTER_DIS = 360;
run_frame_conf.CENT_Y = 250;
run_frame_conf.TOP_BORDER_HEIGHT = 180;
run_frame_conf.BOTTOM_BORDER_HEIGHT = 80;
-- 伤害字体
run_frame_conf.DAMGE_FONT = "fonts/strfont_Damage2.fnt"
-- 暴击伤害字体
run_frame_conf.DAMGE_CRIT_FONT = "fonts/strfont_Damage2.fnt"
-- 金钱字体
run_frame_conf.MONEY_FONT = "fonts/number.fnt"
-- 回复生命字体
run_frame_conf.ADD_FONT = "fonts/recoverHp.fnt"
-- 添加钱字体
run_frame_conf.ADD_FONT_FNT = "fonts/strfont_Money.fnt"

return run_frame_conf;