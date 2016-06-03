sg_action = {};

function sg_action.fadein_fadeout(obj, t, times, cb)
    if not G_isUserDataValid(obj) then
        return;
    end
    t = t or 1;
    obj:setOpacity(0);
    local actions = { };
    table.insert(actions, cc.FadeIn:create(t/2));
    table.insert(actions, cc.FadeOut:create(t/2));
    if not times then
        obj:runAction(cc.RepeatForever:create(cc.Sequence:create(actions)));
    else
        local actions_2 = {};
        table.insert(actions_2, cc.Repeat:create(cc.Sequence:create(actions), times));
        if cb then
            table.insert(actions_2, cc.CallFunc:create(cb));
        end
        obj:runAction(cc.Sequence:create(actions_2));
    end
end

function sg_action.fade_in(obj, t, cb)
    if not G_isUserDataValid(obj) then
        return;
    end
    t = t or 1;
    obj:setOpacity(0);
    local actions = { };
    table.insert(actions, cc.FadeIn:create(t));
    if cb then
        table.insert(actions, cc.CallFunc:create(cb));
    end
    obj:runAction(cc.Sequence:create(unpack(actions)));
end

function sg_action.fade_out(obj, t, cb)
    if not G_isUserDataValid(obj) then
        return;
    end
    t = t or 1;
    local actions = { };
    table.insert(actions, cc.FadeOut:create(t));
    if cb then
        table.insert(actions, cc.CallFunc:create(cb));
    end
    obj:runAction(cc.Sequence:create(unpack(actions)));
end

function sg_action.shake(obj)
    if not G_isUserDataValid(obj) then
        return;
    end
    local a = CCShake:createWithStrength(1.5,3,0);
    obj:runAction(a);
end

function sg_action.delay_call(obj, t, cb)
    if not G_isUserDataValid(obj) then
        return;
    end
    local actions  = {} 
    table.insert(actions, cc.DelayTime:create(t));
    table.insert(actions, cc.CallFunc:create(cb));
    obj:runAction(cc.Sequence:create(unpack(actions)));
end