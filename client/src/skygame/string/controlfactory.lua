
local strbase = require("skygame.string.stringbase");

local factory = {};

function factory.create(info)
    local control = nil;
    local success = false;
    local t = info.m_type;
    if t == 1 then
        control, success = strbase.createString(info);
    elseif t == 2 then
        control, success = strbase.createChangeLine(info);
    elseif t == 3 then
        control, success = strbase.createMenuLabel(info);
    elseif t == 4 then
        control, success = strbase.createSprite(info);
    elseif t == 5 then
        control, success = strbase.createBMPLabel(info);
    elseif t == 255 then
        control, success = strbase.createUserData(info);
    end
    return control, success;
end
return factory;