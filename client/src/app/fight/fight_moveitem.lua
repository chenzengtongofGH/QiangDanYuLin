-- fight_moveitem.lua
-- 战斗中移动的物件(火球等)
-- 可以影响友方目标也可以影响敌方目标，通过target_type决定

-- 2015年2月2日
-- by wz
local MOVE_ITEM_ID = 1;
local DEFAULT_DISTANCE = 1500;
local DEFAULT_HITNUM = 1;

CFightMoveItem = class("CFightMoveItem", CFightItemBase);
--对应的人物，移动速度,特效名字,命中回调,是否随机偏移,是否穿透,打中的个数,目标类型，是否弹射
function CFightMoveItem:ctor(r, speed, effinfo, hitcb,  hitnum, target_type, whitelist,target_role) 
    self.id = MOVE_ITEM_ID;
    MOVE_ITEM_ID = MOVE_ITEM_ID + 1;
    self.role = r;
    self.item_type = MAP_ITEM.MOVE;
    -- 位置
    local y_offset = 0;
    if randomy then
        y_offset = math.random(0, 40);
        y_offset = y_offset - 20;
    end

    local x,y = r:get_Pos();
    self.position = cc.p(x, y);    
    self.move_speed = speed;
    self.y_speed = speed;
    self.catcapult = catcapult or false;
    self.map_obj = CMapMoveItem.new(effinfo);
    self.map_obj:setPosition(self.position);
    if r.face_dir == FACE_DIR.LEFT then
        self.move_speed = - self.move_speed;      
    end
    if self.move_speed < 0 then
        self.map_obj:setScaleX(-1);
    end
    self.target_type = target_type or FIGHT_TARGET_TYPE.ENEMY;
    
    self.hit_callback = hitcb;
    -- 飞行距离
    self.max_distance = dis or DEFAULT_DISTANCE;
    self.cur_distance = 0;

    -- 影响个数
    self.max_hit_num = hitnum or DEFAULT_HITNUM;
    self.cur_hit_num = 0;

    self.camp = self.role:get_camp();
    self.tager_role = target_role or {};

    self.white_list = whitelist or {};
    EventSystem:pushEvent("EVENT_ADD_FIGHTITEM_TO_LIST", self);
    EventSystem:pushEvent("EVENT_ADD_FIGHTITEMOBJ_TO_MAP", self.map_obj);
end

function CFightMoveItem:update(frame_interval)
    if frame_interval == 0 then
        return;
    end
    
    local dx = self.move_speed * frame_interval / 1000;
    local dy = self.y_speed * frame_interval / 1000;
    --获取目标的角色的位置
    local targer_role_pos_X,targer_role_pos_Y ;
    for k,v in pairs(self.tager_role) do 
        if G_isUserDataValid(v) then 
            targer_role_pos_X,targer_role_pos_Y = v:getPosition();
        end
    end
    if targer_role_pos_X then 
        print("ItemX:"..self.position.x..",Y:"..self.position.y..",target_RoleX:"..targer_role_pos_X..",Y:"..targer_role_pos_Y )
        local Point_dir = G_TWO_ROLE_POINT({x =  self.position.x, y  =self.position.y },{x = targer_role_pos_X,y = targer_role_pos_Y});
        self.cur_distance = self.cur_distance + math.abs(dx);
        self.position.x = self.position.x + dx*Point_dir[1];
        self.position.y = self.position.y + dy*Point_dir[2];
        self:check_explosion();
        if G_isUserDataValid(self.map_obj) then
            self.map_obj:setPosition(self.position);
        end
    end
    
    --if self.cur_distance > self.max_distance then
    --  --  EventSystem:pushEvent("EVENT_REMOVE_FIGHTITEM", self.item_type, self.id);
    --end
end

function CFightMoveItem:is_in_white_list(id)
    for k,v in pairs(self.white_list) do
        if v == id then
            return true;
        end
    end
    return false;
end

function CFightMoveItem:release()
    if G_isUserDataValid(self.map_obj) then 
        self.map_obj:removeFromParent(true);
    end
end

function CFightMoveItem:get_random_role(list)
    local alive_list = {};
    for k,v in pairs(list) do
        if v:is_dead() == false then
            table.insert(alive_list, v);
        end
    end
    local count = #alive_list;
    if count == 0 then
        return;
    end
    local idx = math.random(1, count);
    return alive_list[idx];
end

function CFightMoveItem:catapult_to_random_role(list)
    local t_roles = { };
    for k1, v1 in pairs(list) do
        local in_white_list = self:is_in_white_list(v1.id);
        if in_white_list == false and v1:is_dead() == false then
            table.insert(t_roles, v1);
        end
    end

    if #t_roles == 0 then
        EventSystem:pushEvent("EVENT_REMOVE_FIGHTITEM", self.item_type, self.id);
    end

    local t_r = self:get_random_role(t_roles);
    self.target_list = {t_r};

    local dx = t_r.cur_pos.x - self.position.x;
    if dx > 0 and self.move_speed < 0 then
        self.move_speed = -self.move_speed;
        self.map_obj:setScaleX(1);
    elseif dx < 0 and self.move_speed > 0 then
        self.move_speed = -self.move_speed;
        self.map_obj:setScaleX(-1);        
    end
    if self.y_speed == 0 then
        self.y_speed = 50;
    end
    self.y_speed = -self.y_speed;
end

function CFightMoveItem:check_explosion()
    local target_list = self.tager_role;
   -- local target_list = self:get_target_roles(self.target_type, self.camp, true);
    for k, v in pairs(target_list) do
        local in_white_list = self:is_in_white_list(v.id);
        if v:is_dead() == false and in_white_list == false then
            if math.abs(v:getPositionX() - self.position.x) < 25 and math.abs(v:getPositionY() - self.position.y) < 25 then
                -- 只要碰撞就进入白名单，保证一个目标只影响一次
                table.insert(self.white_list, v.id);
                local hit = true;
                 if self.hit_callback then
                       self.hit_callback(v);
                 end
                 self.cur_hit_num = self.cur_hit_num + 1;
                 if self.cur_hit_num >= self.max_hit_num and self.max_hit_num ~= -1 then
                      EventSystem:pushEvent("EVENT_REMOVE_FIGHTITEM", self.item_type, self.id);
                 else
                      if self.catcapult == true then
                          self:catapult_to_random_role(target_list);
                      end
                end
                break;
                
            end
        end
    end
end
