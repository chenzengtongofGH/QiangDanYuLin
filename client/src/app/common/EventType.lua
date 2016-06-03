--事件定义列表
local eventsystem = {
	DelayEvent = {}, 
	TempDelayEvent = {},
	DelayEvent0= {},
	TempDelayEvent0= {},
	EventList = {},
	timeevent = nil,
};

local gScheduler = require("app/common/scheduler")
--注册消息响应函数
function eventsystem:registEventHanlder(name, handler)
	if(not handler) then	
		--debug code release version delete
		local Info = debug.getinfo(2, "Sl")
		--log.Error("[ERROR: Handle=nil]:"..string.format("%s: %d",Info.short_src, Info.currentline))
		return
	end
	if( self.EventList[name] == nil ) then
	    self.EventList[name] = {};
	    table.insert(self.EventList[name], handler);
	else
		for k,v in pairs(self.EventList[name]) do
			if v == handler then
				local Info = debug.getinfo(2, "Sl")
				--log.Error("[ERROR: Handle Repeat]:"..string.format("%s: line at %d",Info.short_src, Info.currentline))
				return
			end
		end
	    table.insert(self.EventList[name], handler);
	end		
end
--触发消息
function eventsystem:pushEvent(name,...)
	self:processEvent(name,...)
end
--延迟处理事件
function eventsystem:pushNormalEvent(event,...)
	local arg = {...}
	local eventInfo = {event,arg}
	self.TempDelayEvent0[#self.TempDelayEvent0+1]=eventInfo	
	if(not self.eventScheduler) then	
		self:registScheduler()
	end
end

--执行处理
function eventsystem:processEvent(event,...)	
	if(self.EventList[event]) then
		local handlerList = self.EventList[event];
		for k, handle in pairs(handlerList) do
			handle(event,...)
		end
	else
		sg_log.info("[EventSystem]:"..event.." is not regist.")
	end
end
function eventsystem:excuteEngineEvent(event)
	if(self.EventList[event] == nil) then
		sg_log.info("event "..event.." is not regist")
		return
	end
	local handlerList = self.EventList[event]
	for index,handler in pairs(handlerList) do
		handler(event);
	end
end
function eventsystem:processNormalEvent()
	if not next(self.TempDelayEvent0) then
		return
	end
	--合并表
	for i=1, #self.TempDelayEvent0 do
		self.DelayEvent0[#self.DelayEvent0+1]=self.TempDelayEvent0[i]
	end
	self.TempDelayEvent0 = {}	
		
	for i = 1, #self.DelayEvent0 do
		local event = self.DelayEvent0[i][1]
		local args = self.DelayEvent0[i][2]		
		if(self.EventList[event]) then
			local handlerList = self.EventList[event];
			for k, handle in pairs(handlerList) do
				if next(args) then
					handle(event,unpack(args))
				else
					handle(event)
				end
				
			end
		else
			--print ("event "..event.." is not regist.")
		end
	end
	self.DelayEvent0 = {}
end

--触发延时消息(延时类消息会保证一段时间内只能同时存在一个消息)
--(因为会删除其他消息，所以仅用于无参数消息，主要用于刷新界面等流程)
function eventsystem:pushDelayEvent(name,delaytime)
	if not delaytime or type(delaytime) ~= "number" then
		delaytime = 100
	end
	--全部都只塞进临时表，process时做表合并处理
	self.TempDelayEvent[name] = {delaytime,sBaseFun:getTime()};
	if self.timeevent == nil then
		self:RegScheduler();
	end
end

function eventsystem_delayprocess()
	local time = sBaseFun:getTime()	

	--合并表
	for i,k in pairs(eventsystem.TempDelayEvent) do
		eventsystem.DelayEvent[i] = k
	end
	eventsystem.TempDelayEvent = {}
	
	local empty = true
	local removeEvent = {}
	for i,k in pairs(eventsystem.DelayEvent) do
		if time > k[1]+k[2] then		
			eventsystem:excuteEngineEvent(i);
			--EventSystem.DelayEvent[i] = nil
			removeEvent[#removeEvent+1] = i			
		end				
		empty = false
	end		
	--清理已经执行过的事件
	for i=1,#removeEvent do	
		eventsystem.DelayEvent[removeEvent[i]] = nil		
	end
	
	--清空表，清除定时器
	if empty then 
		eventsystem.DelayEvent = {};
		gScheduler.unscheduleGlobal(eventsystem.timeevent);
		eventsystem.timeevent = nil;
	end
end

--注册消息函数
function eventsystem:RegScheduler()
	self.timeevent = gScheduler.scheduleGlobal(eventsystem_delayprocess,0.1,false);
end	
function eventsystem:removeAllScheduler()
	if self.timeevent then
		gScheduler:unscheduleGlobal(self.timeevent)
		self.timeevent = nil
	end
	if self.eventScheduler then
		gScheduler.unscheduleGlobal(self.eventScheduler)
		self.eventScheduler = nil
	end
end
function eventsystem:registScheduler()
	self.eventScheduler = gScheduler.scheduleGlobal(ES_ProcessEvent,0.05,false);
end

--移除消息响应函数
function eventsystem:removeEventHandler(name, handler)
	if( self.EventList[name] == nil ) then
		return;
	else
		--先记录下来，再移出，防止出错
		local indextable = {}
		for index,value in pairs(self.EventList[name]) do
			if(handler == value) or handler == nil then
				table.insert(indextable,index)
				--table.remove(self.EventList[name], index);
			end
		end
		
		if #indextable > 0 then		
			--倒序移除
			for i = #indextable, 1, -1 do
				table.remove(self.EventList[name], indextable[i]);
			end				
		end
	end

end
function eventsystem:release()
	self:removeAllScheduler()
	
	self.DelayEvent = {}
	self.TempDelayEvent = {}
	self.DelayEvent0= {}
	self.TempDelayEvent0= {}
	self.EventList = {}
	self.timeevent = nil
    eventsystem:registEventHanlder("DO_FUNCTION", doFunction)
end
function doFunction(...)
	 local arg = {...}
	if arg[2] then
		if arg[2] then
			arg[2]()
		end
	end
end
eventsystem:registEventHanlder("DO_FUNCTION", doFunction)

--[[if EventSystem and EventSystem.release then
	EventSystem:release()
end--]]

function ES_ProcessEvent()
	eventsystem:processNormalEvent()
end
function eventsystem:registEvent(handle,...)
	if type(handle) == "function" then
		local events={...}
		for k,v in ipairs(events) do		
			self:registEventHanlder(v,handle)
		end
	end
end

return eventsystem;