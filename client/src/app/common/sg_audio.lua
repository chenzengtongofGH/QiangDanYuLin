--region sg_audio.lua
--Author : ky011
--Date   : 2015/5/27
--此文件由[BabeLua]插件自动生成
require("cocos.cocosdenshion.AudioEngine")
local BackMusic  = {};
BackMusic._audioID = 0;
BackMusic.later_audioID = 0;
BackMusic._EffectId = 0;
BackMusic.musicName = "";
Music_Volume = cc.UserDefault:getInstance():getIntegerForKey("music_volume", 0) or 100;
Play_Music = cc.UserDefault:getInstance():getBoolForKey("music_play") or true ;
local  Music_Fight = ""  ;
function sg_play_Backmusic(key,loop,volume,cb)

    if not key then 
        return ;
    end
    local conf = sg_getresinfo(key);
    if not conf then
        return;
    end
    local music_file_path = conf[1];
    if string.len(music_file_path) <= 0 then
        return;
    end
    local L = loop or false;
    local V = volume or 1;
    --BackMusic.musicName  = music_file_path;
    --cc.SimpleAudioEngine:getInstance():playMusic(music_file_path,L);
    --得到音乐路径
    --AudioEngine.playMusic(music_file_path,L)
    BackMusic._audioID = ccexp.AudioEngine:play2d(music_file_path,L,V);
    if cb then 
            sg_setFinishCallback(BackMusic._audioID,cb);
    end
    GLOBAL_MUSIC = BackMusic._audioID;
    return BackMusic._audioID;
end

function sg_stop_Backmusic(key)
    local conf = sg_getresinfo(key);
    if not conf then
        return;
    end
    local music_file_path = conf[1];
    ccexp.AudioEngine:stop(BackMusic._audioID)
    BackMusic._audioID = cc.AUDIO_INVAILD_ID
    sg_uncache(music_file_path);
end
--设置音量
function sg_set_music_Volume(V)
    local volume = V or 0 ;
    Music_Volume =volume ;
    cc.UserDefault:getInstance():setIntegerForKey("music_volume", Music_Volume)
    cc.UserDefault:getInstance():flush();
    ccexp.AudioEngine:setVolume(BackMusic._audioID,volume);
    --cc.SimpleAudioEngine:getInstance():setMusicVolume(volume)
end
--获得音量
function sg_get_music_Volume()
    return ccexp.AudioEngine:getVolume();
end
--获得音效音量
function sg_getEffectsVolume()
    return ccexp.AudioEngine:getVolume();
end
--停止所有效果
function sg_stopAll()
    ccexp.AudioEngine:stopAll();
end
--function stop(audioID)
--    ccexp.AudioEngine:stop(audioID);
--end
--暂停所有
function sg_pauseAll()
    ccexp.AudioEngine:pauseAll();
end
--暂停
function sg_pause(audioID)
     ccexp.AudioEngine:pause(audioID);
end
--唤醒
function sg_resume(audioID)
    ccexp.AudioEngine:resume(audioID);
end
--唤醒所有
function sg_resumeAll()
    ccexp.AudioEngine:resumeAll();
end
--设置音乐时间
--return bool

function sg_setCurrentTime( audioID,  time)
    return ccexp.AudioEngine:setCurrentTime( audioID,  time);
end
--获取当前时间
--return float
function sg_getCurrentTime(audioID)
    return ccexp.AudioEngine:getCurrentTime(audioID)
end
--绑定声音结束回调
function sg_setFinishCallback(audioID,callback)
    ccexp.AudioEngine:setFinishCallback(audioID,callback);
end
--销毁
function sg_uncache(filePath)
    ccexp.AudioEngine:uncache(filePath);
end
--销毁全部
function sg_uncacheAll()
    ccexp.AudioEngine:uncacheAll();
end
--是否有播放音乐
function sg_isMusicPlaying()
    return AudioEngine.isMusicPlaying();
end

function sg_remove_music(music)
    if  music and music ~= "" then 
        ccexp.AudioEngine:uncache(music)
    end
end
function sg_set_NeedCallBack()
    Music_Fight = "";
end
function sg_change_Backmusic(key,loop,cb)
    if Music_Fight == "" or Music_Fight ~= key then
        sg_stop_Backmusic(key);
        local V = cc.UserDefault:getInstance():getIntegerForKey("music_volume", 0) ;
        local musicId = sg_play_Backmusic(key,loop,V);
        if cb then 
            sg_setFinishCallback(BackMusic._audioID,cb);
        end
        Music_Fight = key;
        return musicId;
    end
    return pre_music;
end
--判断是战斗还是其他界面
function sg_Music_CallBack()
    Music_Fight = "";
    if SELECT_CURRENT_LAYER_NUMS  == CURRENT_LAYER_ID.Running then --如果还是为战斗界面
        local V = cc.UserDefault:getInstance():getIntegerForKey("music_volume", 0) ;
        sg_play_Backmusic("res#audio#FightLayer",false,V,sg_Music_CallBack);
    elseif SELECT_CURRENT_LAYER_NUMS  == CURRENT_LAYER_ID.Running_2 then
        local V = cc.UserDefault:getInstance():getIntegerForKey("music_volume", 0) ;
        sg_play_Backmusic("res#audio#bossmusic",false,V,sg_Music_CallBack);        
    else
        sg_play_Backmusic("res#audio#NormalLayer",true);
        Music_Fight = "";
    end
end
--文件名
--是否循环
--pitch
--pan
--gain
function sg_play_sound(key,loop,V)
    if not key then 
        return ;
    end
    local conf = sg_getresinfo(key);
    if not conf then
        return;
    end
    local music_file_path = conf[1];
    if string.len(music_file_path) <= 0 then
        return;
    end
    local l = loop or false;
    local Music_V=  cc.UserDefault:getInstance():getIntegerForKey("music_volume") or 1 ;
    local musicId = ccexp.AudioEngine:play2d(music_file_path,l,Music_V);
    return musicId;
    --sg_play_Backmusic(music_file_path);
    --cc.SimpleAudioEngine:getInstance():playEffect(music_file_path,l);
end
--endregion
