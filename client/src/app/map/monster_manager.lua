--region monster_manager.lua
--Author : Bookse
--Date   : 2016/5/31
--此文件由[BabeLua]插件自动生成
local monster_manager = class("monster_manager")
function monster_manager:ctor(root_layer)
    self.Index_Id = 1000;
    self.monster_list = {};
    self.root_layer = root_layer;
    self.root_width = root_layer:getContentSize().width;
    self.root_height = root_layer:getContentSize().height;
    self.play = false;
    self.monster_z_order = 1;
end
function monster_manager:add_monster()
    local monster_db = Croledb_interface.new(10001);
    self.Index_Id = self.Index_Id  + 1;
    local monster_role = CMapRole.new(self.Index_Id,monster_db,0.3,self.root_layer);
    monster_role:set_camp(CAMP_TYPE.HORDE);
    monster_role:set_hp(1);
    local current_role= g_game_layer.map_hero:get_Pos();
    local rand_Min_width,rand_Max_width = current_role.x - display.cx,current_role.x + display.cx;
    local rand_Min_height,rand_Max_height = current_role.y - display.cy,current_role.y + display.cy;
    
    local rand_1 = math.random(0,100);
    local rand_2 = math.random(0, 100)
    local birth_x,birth_y = 0 , 0;
    if rand_1< 50 then --左边
        birth_x = math.random(0, rand_Min_width);
    else
        birth_x = math.random(rand_Max_width, Game_Max_Width);
    end
    if rand_2 < 50 then 
        birth_y = math.random(0, rand_Min_height);
    else
        birth_y = math.random(rand_Max_height, Game_Max_Heihgt);    
    end
     
    --这里需要移除创建人物在当前的显示界面  
    monster_role:setPosition(birth_x,birth_y);
    self.root_layer:addChild(monster_role);
    table.insert(self.monster_list,monster_role);
    monster_role:Run();
end
function monster_manager:del_monster(roleId,bool_crash)
    for k,v in pairs(self.monster_list) do 
        if G_isUserDataValid(v) and v.id == roleId then 
            v:Dead_Role();
            table.remove(self.monster_list, k);
        end
    end
end
function monster_manager:get_role_list()
    return self.monster_list;
end
function monster_manager:process(curtime,map_role,role_x,role_y)
    
    local attack_space = map_role:get_role_info().attack_range;--map_role:get_role_info().attack_range; attack_range;

    for k,v in pairs(self.monster_list) do --判断圈的范围
        local des_x = v:getPositionX() - role_x;
        local des_y = v:getPositionY() - role_y;
        local three_line = math.sqrt(des_x*des_x + des_y*des_y);
        if three_line < attack_space then 
            if map_role:get_Can_Attack() then--发射一个子弹 
                --如果子弹不够则不能攻击
                map_role:attack_emnegy(curtime,v);
            end
        end


        local dead_rect2 = cc.rect(role_x - Dead_line ,role_y-Dead_line,Dead_line*2,Dead_line*2);
        if cc.rectContainsPoint(dead_rect2,cc.p(v:getPositionX(),v:getPositionY())) then --进入自爆阶段 
            --怪物直接炸死主角,主角口血，怪物死亡
            self:del_monster(v.id,true);
            local info = {
            ["des_hp"] = 1,
            };
            map_role:be_attack(info);
            break;
       
        end
        --加入怪物攻击人类
        --怪物打人
        if v:check_can_use(curtime) then 
            v:set_Can_Attack(true);
        end

        local emeny_space = v:get_role_info().attack_range;
        if three_line < emeny_space then 
            if v:get_Can_Attack() then--发射一个子弹 
                v:attack_emnegy(curtime,map_role);
            end
        end
    end
end
function monster_manager:clear_space_role(role,item_data)
    local damage = item_data.item_damage or 0;
    local point_pos = role:get_Pos();
    local attack_space = role:get_role_info().attack_range;
    local currentRole_pos_X,currentRole_pos_Y = point_pos.x,point_pos.y;
    for k,v in pairs(self.monster_list) do 
        local des_x =  v:getPositionX() - currentRole_pos_X;
        local des_y = v:getPositionY() - currentRole_pos_Y;
        local three_line = math.sqrt(des_x*des_x + des_y*des_y);

        if three_line < attack_space then 
            --info.des_hp
            local info = {
            ["des_hp"] = damage;
            }
            v:be_attack(info);
            --self:del_monster(v.id);
        end
    end
end
function monster_manager:update_monster(rolex,roley)
     if #self.monster_list < 10 then --在地图上随机产生
        self:add_monster();
    end
    
    local currentRole_pos_X = rolex;--self.root_layer:getPositionX() +  self.root_width * 3 / 2 
    local currentRole_pos_Y =roley;--self.root_layer:getPositionY() +self.root_height *3 / 2;

    for k,v in pairs(self.monster_list) do --所有有东西朝一个点跑过去
        local monster_speed = v:get_role_info().speed / 100;

        local des_x =  v:getPositionX() - currentRole_pos_X;
        local des_y = v:getPositionY() - currentRole_pos_Y;
        local three_line = math.sqrt(des_x*des_x + des_y*des_y);
        local x_rad =  des_y / three_line;
        local y_rad = des_x / three_line;
        local speedx = 0;
        local speedy = 0;

        if des_x >0 and des_y>0 then --1
            speedx = -monster_speed * math.cos(x_rad);
            speedy = -monster_speed * math.sin(x_rad);
        elseif des_x<0 and des_y>0 then --2
            speedx = monster_speed * math.cos(x_rad);
            speedy = -monster_speed * math.sin(x_rad);
        elseif des_x >0 and des_y<0 then --4
            speedx = -monster_speed * math.cos(y_rad);
            speedy = monster_speed * math.sin(y_rad);
        elseif des_x<0 and des_y<0 then --3
            speedx = monster_speed * math.cos(y_rad);
            speedy = -monster_speed * math.sin(y_rad);
        end
        
        local need_line = 6;
        if des_x <=0 then 
            v:setDir(FACE_DIR.RIGHT);
        else
            v:setDir(FACE_DIR.LEFT); 
        end
           
        if math.abs(des_x) <= need_line and des_y ~= 0 then 
            if des_y >0 then --人要向上
                speedy = -1*monster_speed;--地图向下
            else
                speedy = monster_speed;
            end
            speedx = 0;
        end

        if des_x~=0 and math.abs(des_y)<= need_line then 
            if des_x >0 then --人要向右
                speedx = -1*monster_speed;--地图向左
            else
                speedx = monster_speed;
            end
            speedy = 0;
        end
        local z_order = 1000000 - v:getPositionY();
        if math.abs(v:getPositionX()  - currentRole_pos_X) >= 10 or  math.abs(v:getPositionY()  - currentRole_pos_Y) >= 10  then 
            v:setPosition(v:getPositionX() + speedx,v:getPositionY() + speedy);
            v:setLocalZOrder(z_order)
        end          
    end
    self:check_offset_Position();
end
function monster_manager:check_offset_Position()
    for k,v in pairs(self.monster_list) do --设置重叠的偏移量
        if G_isUserDataValid(v) then 
            local need_offset_count = 0;
            for k1,v1 in pairs(self.monster_list) do 
                if k~=k1 then --跟每个进行比较
                    if math.abs(v1:getPositionX() - v:getPositionX()) < Monster_des_width  and  math.abs(v1:getPositionY() - v:getPositionY()) < Monster_des_width then 
                        v1:setPositionX(v1:getPositionX() - Monster_offset_width);
                        --need_offset_count = need_offset_count + 1;
                    end
                end
            end
            --if need_offset_count ~= 0 then 
            --    v:setPositionX(v:getPositionX() -  need_offset_count * Monster_offset_width);
            --end 
        end
    end
end
return monster_manager;
--endregion
