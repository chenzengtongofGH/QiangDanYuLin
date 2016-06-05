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
end
function monster_manager:add_monster()
    local monster_db = Croledb_interface.new(10001);
    self.Index_Id = self.Index_Id  + 1;
    local monster_role = CMapRole.new(self.Index_Id,monster_db,0.3,self.root_layer);
    monster_role:set_camp(CAMP_TYPE.HORDE);
    monster_role:setPosition(math.random(0,1136*2),math.random(0,640*2));
    self.root_layer:addChild(monster_role);
    table.insert(self.monster_list,monster_role);
    monster_role:Run();
end
function monster_manager:del_monster()
    
end
function monster_manager:process(curtime,map_role,role_x,role_y)
    
    local attack_space = 80;--map_role:get_role_info().attack_range;
    for k,v in pairs(self.monster_list) do --判断圈的范围
        local monster_role_x = v:getPositionX();
        local monster_role_y = v:getPositionY();
        local rect_1 = cc.rect(role_x-attack_space,role_y-attack_space,attack_space*2,attack_space*2);
        if cc.rectContainsPoint(rect_1,cc.p(monster_role_x,monster_role_y)) then 
            if map_role:get_Can_Attack() then--发射一个子弹 
                map_role:attack_emnegy(curtime,v);
            end
            --print("attack");
        end
        local dead_rect2 = cc.rect(role_x - Dead_line ,role_y-Dead_line,Dead_line*2,Dead_line*2);
        if cc.rectContainsPoint(dead_rect2,cc.p(monster_role_x,monster_role_y)) then --进入自爆阶段 
            --怪物直接炸死主角,主角口血，怪物死亡
            v:Dead_Role();
            table.remove(self.monster_list, k);
            --print("dead_dead");
        end
        --if rect_1:containsPoint(cc.p(monster_role_x,monster_role_y)) then 
        --    print("attack");
        --end
        --if role_x 
    end
end
function monster_manager:update_monster(rolex,roley)
     if #self.monster_list < 10 then --在地图上随机产生
        self:add_monster();
    end
    
    local currentRole_pos_X = rolex;--self.root_layer:getPositionX() +  self.root_width * 3 / 2 
    local currentRole_pos_Y =roley;--self.root_layer:getPositionY() +self.root_height *3 / 2;
    --print("current_pos:"..self.root_layer:getPositionX()..",:"..currentRole_pos_X..",Y"..currentRole_pos_Y);
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
        if des_x >=0 then 
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
        if math.abs(v:getPositionX()  - currentRole_pos_X) >= 10 or  math.abs(v:getPositionY()  - currentRole_pos_Y) >= 10  then 
            v:setPosition(v:getPositionX() + speedx,v:getPositionY() + speedy)
        end  

        --local ui_layer_posX = self.UILayer:getPositionX();
        --local ui_layer_posY = self.UILayer:getPositionY();
        --self.UILayer:setPosition(ui_layer_posX+speedx,ui_layer_posY+speedy);

    end
end
return monster_manager;
--endregion
