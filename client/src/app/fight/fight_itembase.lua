-- fight_itembase.lua
local actionManager = cc.Director:getInstance():getActionManager()
CFightItemBase = class("CFightItemBase");

function CFightItemBase:ctor()
end

function CFightItemBase:release()
end

function CFightItemBase:pause_resume(flag)  
    if not G_isUserDataValid(self.map_obj) then
        return;
    end
    if flag == true then
        actionManager:resumeTarget(self.map_obj);
    else
        actionManager:pauseTarget(self.map_obj);
    end  
end

function CFightItemBase:update(frame_interval)
end

function CFightItemBase:stop()
end

function CFightItemBase:get_target_roles(t, camp, check_magic_imm)
    if t == FIGHT_TARGET_TYPE.ENEMY then
        return g_fight_get_enemys(camp, true, check_magic_imm);
    elseif t == FIGHT_TARGET_TYPE.FRIENDLY then
        return g_fight_get_firends(camp, true);
    else
        return g_fight_get_alive_roles(true);
    end
end
