-- sg_ui.lua
-- des      :一些封装过的UI接口
-- author   :wz
-- data     :2015年1月12日
sg_ui = {}
sg_ui.lastTouchTime = 0;
function sg_ui.LabelTTF(str, font, Fontsize,Textsize,ALIGNMENTType,isenableGlow)
    if not font then
        font = "Arial"
    end
    if not Fontsize then
        Fontsize = 24;
    end

    if not str then
        str = "";
    end
    local l;
    l = LabelEx:createWithSystemFont(str, font, Fontsize);
    --if not Textsize and not ALIGNMENTType then
    --         if not isenableGlow then 
    --         l = cc.Label:create();
    --         l:setString(str)
    --         l = cc.Label:createWithTTF(str, font, Fontsize)
    --        else
    --         l =cc.Label:createWithSystemFont(str, font, Fontsize)
    --        end
    --else    
    --    if not Textsize then 
    --        Textsize = cc.size(100,100);
    --    end
    --    if not ALIGNMENTType then 
    --        ALIGNMENTType = cc.TEXT_ALIGNMENT_LEFT
    --    end
    --    l =cc.Label:createWithTTF(str,font,Fontsize,Textsize,ALIGNMENTType)
    --end
   
    return l;
end
function sg_ui.LabelMapFont(pngfile,width,height,beginId)
    if not pngfile then 
        print("not have png map");
        return;
    end

    if not width  then 
        width = 0;
    end
    if not height then 
        height = 0;
    end
    if not beginId then 
        beginId = 48
    end
    --默认图片从0开始
    local l  = cc.Label:createWithCharMap(pngfile,width,height,beginId);
    return l;
end
function sg_ui.LabelBMFont(str, font)
    if not str then
        str = "";
    end
    if not font then
        return sg_ui.LabelTTF(str);
    end 
    local l = cc.Label:createWithBMFont(font, str)
    return l;
end
--[[
des     : 创建一个按钮
input   : onclick   点击响应函数
          texs      图片(普通，按下，不可用）
          str       文字
          event     响应消息
          ccui.TouchEventType.began
          ccui.TouchEventType.ended
return  : 按钮控件
autor   : 
date    : 2015年1月12日
--]] 
function sg_ui.create_button(onclick, texs, str, event)
    if not event then
        event = ccui.TouchEventType.ended
    end
    local function touchEvent(sender,eventType)
        if eventType == event  then           
            if onclick then
                sg_play_sound(MUSIC_BUTTON_NAME);
                onclick();
            end
        end
    end    

    local btn = ccui.Button:create()
    btn:setTouchEnabled(true)
    -- 资源处理
    local restype = ccui.TextureResType.localType;
    for i=1, 3 do
        if texs[i] then
            local reskey = nil;
            texs[i], restype = sg_loadResources(texs[i])
        else
            texs[i] = "";
        end
    end
    btn:loadTextures(texs[1], texs[2], texs[3], restype);
    btn:addTouchEventListener(touchEvent)
    if str then
        btn:setTitleText(str);
        btn:setTitleFontSize(22);
    end
    return btn
end
function sg_ui.addTouchEventListener_music_table(btn,onclick)
    sg_ui.addTouchEventListener_music(btn,onclick,TABS_MUSIC_CLICK);
end
function sg_ui.addTouchEventListener_music(btn,onclick,special_music,event)
    if not event then
        event = ccui.TouchEventType.ended
    end
    local function touchEvent(sender,eventType)
        if eventType == event then 
            if not special_music then 
                sg_play_sound(MUSIC_BUTTON_NAME);
            else
                sg_play_sound(special_music);
            end
            
            onclick(sender,eventType);
        end
    end
    btn:addTouchEventListener(touchEvent);
end
function sg_ui.set_button_DisablePic(btn,str)
    if not btn then 
        return ; 
    end
    local pic = sg_loadResources(str);
    btn:loadTextureDisabled(pic)
end
--[[
des     : 创建一个Layercolor
input   : size 为页面大小
return  : 一个layercolor
autor   : 
date    : 2015年1月19日
--]] 
function sg_ui.create_LayerColor(size,color)
    if not size then 
        size.width = 0;
        size.height = 0;
    end
    if not color then 
        color = cc.c4b(255,255,255,0)
    end
    local Layer = cc.LayerColor:create(color,size.width,size.height);
    return Layer;
end
function sg_ui.create_Scale9Sprite(filename,size1,capinset)
    if not filename then 
        print("create_Scale9Sprite not have filename");
        return;
    end    
    if not size1 then 
        size1 = cc.size(0,0);
    end
    if not capinset then 
        capinset = RECT_ZERO;
    end
    local m  = {scale9 = true ,size = size1 , capInsets = capinset }
    local mScale9Sprite = display.newSprite(filename, x, y, m);
 
    return mScale9Sprite;
end

function sg_ui.register_event_listener(ret, onbegan, onmove, onend,name)
    local function onTouchBegan(touch, event)
        
        local target = event:getCurrentTarget()     
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        local s = target:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)      
        if cc.rectContainsPoint(rect, locationInNode) then
            --print("~~~~~~~~~~~~~~name"..name);
            if onbegan then
                onbegan();
            end
            return true
        end
        return false
    end

    local function onTouchMoved(touch, event)
        local target = event:getCurrentTarget()
        if target == ret then
            if onmove then
                onmove();
            end
        end
    end

    local function onTouchEnded(touch, event)
        local target = event:getCurrentTarget()
        if target == ret then
            if onend then
                onend();
            end
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = ret:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, ret)    
end

--[[
des     : 创建一个吞噬所有消息的监听
input   : ret cc.node
         callfun TOUCH_BEGIN回调函数
return  : 监听对象
autor   : 
date    : 2015年1月22
--]] 
function sg_ui.swallow_touches(ret,callfun)
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)
	listener:registerScriptHandler(function() return true; end,cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(function() return true; end,cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(function() if callfun then callfun() end return true; end,cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = ret:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, ret)
	return listener
end	
--[[
des     : 创建一个进度条
input   : filename 进度条的名字
              duration减少的方向
return  : ProgressTimer
autor   : 
date    : 2015年2月7日
--]] 
function sg_ui.ProgressTimer(Sp,duration)
    if not Sp then
        print("The ProgressTimer Spirte Name is not exist");
    end
    if not  duration then
        duration=cc.PROGRESS_TIMER_TYPE_BAR;
    end
   
    local left = cc.ProgressTimer:create(Sp);
    left:setType(duration)--//设置进程条的类型
    left:setMidpoint(cc.p(-1, 0))--设置进度的运动方向
    left:setBarChangeRate(cc.p(1, 0)) --置进程条的变化速率
    left:setPercentage(100)
    return left;
end	
function sg_ui.setuibuttonEnabled(paramButton,paramEnabled)
        if not G_isUserDataValid(paramButton) then 
            return ;
        end
        if paramEnabled then 
            paramButton:setBright(true);
			paramButton:setEnabled(true);
			paramButton:setTouchEnabled(true);
        else
            paramButton:setBright(false);
			paramButton:setEnabled(false);
			paramButton:setTouchEnabled(false);
        end
end
function sg_ui.GetCsbForButtonForTab (tab,tag)
     for k,v in pairs (tab) do 
        if k == tag then
            sg_ui.setuibuttonEnabled(v,false)
        else
            sg_ui.setuibuttonEnabled(v,true)    
        end
    end
end

function sg_ui.create_checkbox(csb, name, selcb, unselcb)
    if not csb then 
        print("not find csb ");
        return ;
    end
    local checkbox = sg_get_child_by_name(csb, name);
    if G_isUserDataValid(checkbox) then 
        local function ontouch(sender, eventType)
            if eventType == ccui.CheckBoxEventType.selected then
                if selcb then
                    selcb();
                end
            elseif eventType == ccui.CheckBoxEventType.unselected then
                if unselcb then
                    unselcb();
                end
            end
        end
        checkbox:addEventListener(ontouch);
    else
        print("checkbox obj is error")    ;
        return;
    end
    return checkbox;
end

function sg_ui.set_btn_onclick(csb,btname,cb)
    if not csb then 
        print("not find csb ");
        return ;
    end
    local btn = sg_get_child_by_name(csb, btname);
    if G_isUserDataValid(btn) then 
        if cb then
            local function ontouch(sender, eventType)
                if eventType == ccui.TouchEventType.ended then
                    if cb then
                        cb();
                    end
                end
            end
            btn:addTouchEventListener(ontouch);
        else 
            print("callback fun is not exist");
            return;
        end
    else
        print("btn obj is error")    ;
        return;
    end
    return btn;    
end

function sg_ui.GetCsbForButton(csb,btname,cb)
    if not csb then 
        print("not find csb ");
        return ;
    end
    local btn = sg_get_child_by_name(csb, btname);
    if G_isUserDataValid(btn) then 
        if cb then
            sg_ui.addTouchEventListener_music(btn,cb)
        else 
            print("callback fun is not exist");
            return;
        end
    else
        print("btn obj is error")    ;
        return;
    end
    return btn;
end
--[[
des     : 创建粒子特效
input   : key对应的素材标签
return  : 粒子对象
autor   : 
date    : 2015年3.12
--]] 
function sg_ui.createParticle(key)
    local info  = sg_getresinfo(key);
    if not info then return end
    local p = cc.ParticleSystemQuad:create(info[1])
	p:setAutoRemoveOnFinish(true)
    return p ;
end

--[[
des     : 创建描边的字体
input   : ttfConfig 默认
              borderSize描边大小 
              TextPosType字体对齐方式
              maxWidth最大宽度
              FixWidth 固定宽度
return  : 字体对象
autor   : 
date    : 2015年2月4
--]] 
function sg_ui.LabelTTFOutline(str, fontPath,size,borderSize,TextPosType,maxWidth,FixWidth)--,ttfConfig)
   if not str then
        str = "";
    end
    if not TextPosType then 
        TextPosType = cc.TEXT_ALIGNMENT_LEFT
    end

    if not Fontsize then 
        Fontsize = 20;
    end

    local label1 = nil;
    if is_win32() then
        if not ttfConfig then 
                ttfConfig = {};
                if not fontPath then
                    --DroidSansFallback_0
                    ttfConfig.fontFilePath = "csb/ui/DroidSansFallback_0.ttf"
                else
                    ttfConfig.fontFilePath = fontPath
                end

                if not size then
                     ttfConfig.fontSize = 20 ; 
                else
                     ttfConfig.fontSize = size;
                end
                ttfConfig.glyphs   = cc.GLYPHCOLLECTION_DYNAMIC
                ttfConfig.customGlyphs = nil
                ttfConfig.distanceFieldEnabled = true
                if  not borderSize then
                    ttfConfig.outlineSize = 1
                else
                    ttfConfig.outlineSize = borderSize;
                end
        end
        if not maxWidth then
            maxWidth = cc.Director:getInstance():getWinSize().width;
        end
        label1 = LabelEx:createWithTTF(ttfConfig, str, TextPosType, maxWidth)
        if FixWidth then
            if label1:getContentSize().width > FixWidth then
                label1:setScaleX(FixWidth / label1:getContentSize().width);
            end
        end
    else  
        label1 = LabelEx:createWithSystemFont(str, font, Fontsize)
        if maxWidth then 
            label1:setWidth(maxWidth)
        end
        if FixWidth then 
            if label1:getContentSize().width >FixWidth then 
                label1:setScaleX(FixWidth/label1:getContentSize().width);
            end
        end
        label1:setAlignment(TextPosType);
        if borderSize and borderSize > 0 then
            label1:enableOutline(cc.c4b(0, 0, 0, 255), borderSize);
        end
    end
    return label1;
end
function sg_ui.createMenuFontLabel(str,cfun,font, Fontsize)
    if not str  then 
        str = "None string";
    end
    local label = sg_ui.LabelTTF(str,font,Fontsize);

    --
    local l = cc.MenuItemLabel:create(label);
    return l;
end

function sg_ui.create_lightline(tab)
	--创建出闪光链
	local pic = display.newSprite(tab.sprite)
    local pic_size = pic:getContentSize();
	local _lighting = LightLineRender:create(pic:getTexture());
	
	--设置线条位置
	for i=1,#tab.pos do
		_lighting:setLines(unpack(tab.pos[i]))
	end
	
	--设置不需要强制纹理循环
	if not tab.loop then
		_lighting:setForceTexLoop( false );
	end
	--设置宽
	_lighting:setWidth( tab.width or 80 );
	--设置 单张纹理长度，调整这个数值可以避免纹理过度拉伸或挤压
	_lighting:setTextueLength( tab.length or pic_size.width );
	--设置单个面片网格长，越小曲线越平滑，数值过于小可能带来效率问题
	_lighting:setStep( tab.step or 20);
	--设置振幅1
	_lighting:setAmplitude0( tab.amp0 or 4 );
	--设置频率1
	_lighting:setFrequency0( tab.fre0 or 500 );
	--设置振幅2
	_lighting:setAmplitude1( tab.amp1 or 1 );
	--设置频率2
	_lighting:setFrequency1( tab.fre1 or 400 );
	--设置
	_lighting:setTimeFactor( tab.time or 0.5 );

	--使用柏林噪音算法
	_lighting:setLineType( tab.linetype or 2 );
	
	--设置每帧强制更新重建模型
	if tab.update then
		_lighting:setForceUpdate(true);
	end
	
	_lighting:setGlobalZOrder(1);
	
	return _lighting
end
--创建滑动层
--大小
function sg_ui.createScrollView(ViewSizeX,ViewSizeY)
    local scrollView1 = cc.ScrollView :create()
    scrollView1:setViewSize(cc.size(ViewSizeX,ViewSizeY))
    scrollView1:setPosition(cc.p(0,0))
    scrollView1:ignoreAnchorPointForPosition( true)
    scrollView1:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL )
    scrollView1:setClippingToBounds( true) --设置剪切
    scrollView1:setBounceable( true) ---- 設置彈性效果设置回弹
    scrollView1:setDelegate() --自身注册
    return scrollView1;
end
--创建裁剪层
--裁剪的区域大小，裁剪层放的位置
function sg_ui.createClipLayer(clipeSizeX,clipeSizeY,BPosX,BPosY)
     --当前对象。
    local clipSizeX =  clipeSizeX * display.screen_design.w;
    local clipSizeY = clipeSizeY * display.screen_design.h
    local b = cc.RenderTexture:create(clipSizeX,clipSizeY, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888);
    b:beginWithClear(1.0,1.0,0,1);
    b:endToLua();
    if not BPosX then 
        b:setPosition(display.design_to_screen(152,165));
    else
        b:setPosition(cc.p(clipSizeX/2,clipSizeY/2));
    end
    zhezhaoLayer = display.newLayer(cc.c4b(255,0,255,0),cc.size(clipSizeX,clipSizeY))
    zhezhaoLayer:setPosition(cc.p(0,0))
   
    local mapclipper = cc.ClippingNode:create()
    mapclipper:setAlphaThreshold(0.5);
    mapclipper:setStencil(b);
    return mapclipper,zhezhaoLayer;
end


function sg_ui.swallow_now_layer(layer)
    local scene  = cc.Director:getInstance():getRunningScene() ;
     scene:addChild(layer,GAME_LAYER_Z.Pop);
     sg_ui.swallow_touches(layer)
end
require("app.views.common.commonui")
function sg_ui.createCommonUi(maincsb,ismain)
     local Node_menu = sg_get_child_by_name(maincsb, "Node_menu");
     local Posx,Posy = Node_menu:getPosition();
     G_Scale_BtnPos(Posx,Posy,ismain);
end

--createcommonShade创建遮罩过滤阴影
--阴影的宽度x
--阴影的高度y 
--阴影是否垂直翻转  默认为是
function sg_ui.createcommonShade(Sx,Sy,Fixclip)
    local sprite;
    --上面恒面的 -1，下面小的圆 ，大的 - 2
    if Sy == -1 then 
        sprite = sg_ui.create_Scale9Sprite("res#normal#ui#common#mash_smallbg1",cc.size(Sx,51));
    elseif Sy == -2 then 
        sprite = sg_ui.create_Scale9Sprite("res#normal#ui#common#mash_bigbg",cc.size(Sx,96));
    elseif Sy == -3 then
        sprite = sg_ui.create_Scale9Sprite("res#normal#ui#common#mask_smallup",cc.size(Sx,18));
    elseif Sy == -4 then 
        sprite = sg_ui.create_Scale9Sprite("res#normal#ui#common#mask_smalldown",cc.size(Sx,18));
    else
        sprite = sg_ui.create_Scale9Sprite("res#normal#ui#common#mash_smallbg2",cc.size(Sx,58));
    end
    sprite:setAnchorPoint(0.5,0);
    if not Fixclip then 
        sprite:setScaleY(-1);
    else
        sprite:setScaleY(1);
    end
    return sprite;
end
--创建打折ui接口
--打折量
function sg_ui.DiscountSp(Nums)
     local discountSp  = display.newSprite("res#csb#ui#shop#discount");
     --discountSp:addTo(rootLayer);
     local discountNums = sg_ui.LabelBMFont(Nums,DISCOUNTNUMBER_FONT);
     discountNums:addTo(discountSp);
     discountNums:setPosition(10,5);
     discountNums:setRotation(15);
     return discountSp;
end
--创建道具的统一接口
function sg_ui.createItemIcon(str)
    local  sp  = display.newSprite(str);
    if not sp then 
        sp = display.newSprite("wuqi");
        return sp;
    else
        return sp;
    end
end
function sg_ui.createShadeLayerC4b(color)
    if not color then 
        color  = cc.c4b(0,0,0,0.6);
    end
        local layer = display.newLayer(color);
        if display.screen_design.h > 1 then 
            layer:setContentSize(display.size)
            layer:setPosition(0,display.screen_des_size.h / 2);
        end
        return layer;
end


-- edit box
-- size 尺寸
-- holder 默认文字
function sg_ui.create_editbox(size, holder, fontsize, fontcolor)
    local editbox = ccui.EditBox:create(size, display.newSprite("res#normal#ui#common#alpha", 0, 0, {scale9 = true}));
    editbox:setPlaceHolder(holder)
    fontsize = fontsize or 30;
    editbox:setFontSize(fontsize);
    fontcolor = fontcolor or cc.c3b(0,0,0)
    editbox:setFontColor(fontcolor);
    editbox:setFontName("Droid Sans Fallback");
    editbox:setPlaceholderFontColor(cc.c3b(180,180,180))
    return editbox;
end

function sg_ui.create_exit_dlg()
    local csb = sg_load_csb("res#csb#ui#hint");
    csb:addTo(display.getRunningScene(), 10000);

    local function ok()
        cc.Director:getInstance():endToLua();
    end
    local okbtn = sg_ui.set_btn_onclick(csb, "Button_confirm1", ok)

    local function cancel()
        csb:removeFromParent(true);
    end
    local cancelbtn = sg_ui.set_btn_onclick(csb, "Button_cancel1", cancel)

    local str_node = sg_get_child_by_name(csb, "Node_hintdetails1");
    local label = sg_ui.LabelTTF(G_GetString("exit_dlg_str"), nil, 24);
    label:setColor(cc.c3b(242, 98, 255));
    str_node:addChild(label);
end

function sg_ui.reg_keybroad_listener(obj)
    local function on_key_release(keyCode, event)
        sg_log.info("key " .. keyCode .. " release");
        if keyCode == cc.KeyCode.KEY_BACK then
            sg_ui.create_exit_dlg();
        elseif keyCode == cc.KeyCode.KEY_MENU then
        end
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(on_key_release, cc.Handler.EVENT_KEYBOARD_RELEASED )

    local eventDispatcher = obj:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, obj);
end

function sg_ui.createTip(str,sp)
    local s9SizeSp = {x = 330,y = 150};
    local Tanchu9S = sg_ui.create_Scale9Sprite("res#csb#ui#formation#Sp9tan",cc.size(57,74));
     Tanchu9S:setContentSize(cc.size(s9SizeSp.x,s9SizeSp.y));
    local Tab = sp:convertToWorldSpace(cc.p(0.5,0.5));
    local X,Y = Tab.x,Tab.y;
    Tanchu9S:setPosition(X,Y+15);
    Tanchu9S:setAnchorPoint(cc.p(1,0.5));
    
    local jianjiao = display.newSprite("res#csb#ui#formation#Sp9tan1");
    jianjiao:addTo(Tanchu9S);
    jianjiao:setPosition(Tanchu9S:getContentSize().width+jianjiao:getContentSize().width/2-2,Tanchu9S:getContentSize().height/2);

    local DetailTTF = sg_ui.LabelTTF(str);
    DetailTTF:addTo(Tanchu9S);
    DetailTTF:setPosition(s9SizeSp.x/2,s9SizeSp.y/2);
    return Tanchu9S;
end


function sg_ui.create_touch_eff_layer()

    if G_isUserDataValid(sg_ui.touch_eff_layer) then
        sg_ui.touch_eff_layer:removeFromParent(true)
    end
    sg_ui.touch_eff_layer = display.newLayer(cc.c4b(255,0,0,0));
    listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(false)
	listener:registerScriptHandler(function() 
--                                        if not G_isUserDataValid(sg_ui.touch_eff_layer) then
--                                            return
--                                        end
                                        local curTime = g_gettime();
                                        if sg_ui.lastTouchTime + 100 < curTime then
                                            sg_ui.lastTouchTime = curTime;
                                            sg_ui.touch_eff_layer_listener:setSwallowTouches(false);
                                        else
                                            sg_ui.touch_eff_layer_listener:setSwallowTouches(true);
                                        end
                                        return true;
                                    end,cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(function() return true; end,cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(function() return true; end,cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = sg_ui.touch_eff_layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, sg_ui.touch_eff_layer)
    sg_ui.touch_eff_layer_listener = listener;

    sg_ui.touch_eff_layer:setTouchEnabled(true);
    sg_ui.touch_eff_layer:setAccelerometerEnabled(true);
    return sg_ui.touch_eff_layer
end

function sg_ui.new_tableview_n_layer(createHandler,dir,dimension,normalcell,selectcell,cellCount,selectHandler)
	local tablelayer = TableViewNLayer:create();
	tablelayer:setNumberOfCell(cellCount);
	tablelayer:registScriptHandler(regFunction(selectHandler));
	tablelayer:registScriptCellCreateHandler(regFunction(createHandler))
	tablelayer:setCellSize(normalcell,selectcell)
	tablelayer:createTableView(dir,dimension)
	return tablelayer
end