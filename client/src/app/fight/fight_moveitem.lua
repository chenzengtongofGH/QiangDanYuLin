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

    self.bool_dir = 1;
    if self.role:getDir() == FACE_DIR.LEFT then 
        self.bool_dir = -1;
    end

    local x,y = self:get_target_role_pos(r);-- r:get_Pos().x, r:get_Pos().y;
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
    --self.map_obj:setScaleX(1);
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
    

    self.bool_hero = false;
    --求出对应的角度
    self.role_rad = -1;
    for k,v in pairs(self.tager_role) do 
        if v.id == Hero_Id then 
            self.bool_hero = true;
            local current_role_x,current_role_y = self:get_target_role_pos(v);
            self.role_rad  = G_RAD_TWO_POINT({x =  self.position.x, y  =self.position.y },{x = current_role_x,y = current_role_y})
        end
    end


    self.white_list = whitelist or {};
    EventSystem:pushEvent("EVENT_ADD_FIGHTITEM_TO_LIST", self);
    EventSystem:pushEvent("EVENT_ADD_FIGHTITEMOBJ_TO_MAP", self.map_obj);
end
function CFightMoveItem:get_pos()
    if G_isUserDataValid(self.map_obj) then 
        return self.map_obj:getPosition();
    end
end
function CFightMoveItem:update(frame_interval)
    if frame_interval == 0 then
        return;
    end
    
    local dx = self.move_speed * frame_interval / 1000;
    local dy = self.y_speed * frame_interval / 1000;
    --获取目标的角色的位置
    local targer_role_pos_X,targer_role_pos_Y ;
    local targer_role_Point ;
    for k,v in pairs(self.tager_role) do 
        if G_isUserDataValid(v) then 
            --targer_role_Point = v:get_Pos();
            targer_role_pos_X,targer_role_pos_Y = self:get_target_role_pos(v);--v:getPosition();
            
        end
    end
    local move_speed = self.move_speed / 100;
    
    if targer_role_pos_X then --目标已经挂了
        --print("ItemX:"..self.position.x..",Y:"..self.position.y..",target_RoleX:"..targer_role_pos_X..",Y:"..targer_role_pos_Y )
        local rad_two = G_RAD_TWO_POINT({x =  self.position.x, y  =self.position.y },{x = targer_role_pos_X,y = targer_role_pos_Y});        
        local next_x = move_speed * math.cos(rad_two) * self.bool_dir;
        local next_y = move_speed * math.sin(rad_two) * self.bool_dir;
        
        if self.bool_hero then 
            next_x = move_speed * math.cos(self.role_rad) * self.bool_dir ;
            next_y = move_speed * math.sin(self.role_rad) * self.bool_dir;
        end

        self.position.x = next_x + self.position.x;
        self.position.y = next_y + self.position.y;
        self:check_explosion();
        if G_isUserDataValid(self.map_obj) then
            self.map_obj:setPosition(self.position);
        end
    else
        EventSystem:pushEvent("EVENT_REMOVE_FIGHTITEM", self.item_type, self.id);
    end
    
    --if self.cur_distance > self.max_distance then
    --  --  EventSystem:pushEvent("EVENT_REMOVE_FIGHTITEM", self.item_type, self.id);
    --end
end
function CFightMoveItem:get_target_role_pos(v)
    local targer_role_pos_X,targer_role_pos_Y = 0,0;
    targer_role_pos_X,targer_role_pos_Y = v:getPosition();
    if v.id == Hero_Id then 
        targer_role_pos_X,targer_role_pos_Y = v:get_Pos().x,v:get_Pos().y;
    end
    return targer_role_pos_X,targer_role_pos_Y;
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

    for k, v in pairs(target_list) do
        local in_white_list = self:is_in_white_list(v.id);
        if v:is_dead() == false and in_white_list == false then
            --local current_Point = v:get_Pos();
            local current_x ,current_y = self:get_target_role_pos(v);
            if math.abs(current_x - self.position.x) < 25 and math.abs(current_y - self.position.y) < 25 then
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

            if current_x < 0 or current_x > Game_Max_Width or current_y<0 or current_y > Game_Max_Heihgt then 
                EventSystem:pushEvent("EVENT_REMOVE_FIGHTITEM", self.item_type, self.id);
            end

        end
    end
end
