--�¼������б�
local eventsystem = {
	DelayEvent = {}, 
	TempDelayEvent = {},
	DelayEvent0= {},
	TempDelayEvent0= {},
	EventList = {},
	timeevent = nil,
};

local gScheduler = require("app/common/scheduler")
--ע����Ϣ��Ӧ����
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
--������Ϣ
function eventsystem:pushEvent(name,...)
	self:processEvent(name,...)
end
--�ӳٴ����¼�
function eventsystem:pushNormalEvent(event,...)
	local arg = {...}
	local eventInfo = {event,arg}
	self.TempDelayEvent0[#self.TempDelayEvent0+1]=eventInfo	
	if(not self.eventScheduler) then	
		self:registScheduler()
	end
end

--ִ�д���
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
	--�ϲ���
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

--������ʱ��Ϣ(��ʱ����Ϣ�ᱣ֤һ��ʱ����ֻ��ͬʱ����һ����Ϣ)
--(��Ϊ��ɾ��������Ϣ�����Խ������޲�����Ϣ����Ҫ����ˢ�½��������)
function eventsystem:pushDelayEvent(name,delaytime)
	if not delaytime or type(delaytime) ~= "number" then
		delaytime = 100
	end
	--ȫ����ֻ������ʱ��processʱ����ϲ�����
	self.TempDelayEvent[name] = {delaytime,sBaseFun:getTime()};
	if self.timeevent == nil then
		self:RegScheduler();
	end
end

function eventsystem_delayprocess()
	local time = sBaseFun:getTime()	

	--�ϲ���
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
	--�����Ѿ�ִ�й����¼�
	for i=1,#removeEvent do	
		eventsystem.DelayEvent[removeEvent[i]] = nil		
	end
	
	--��ձ������ʱ��
	if empty then 
		eventsystem.DelayEvent = {};
		gScheduler.unscheduleGlobal(eventsystem.timeevent);
		eventsystem.timeevent = nil;
	end
end

--ע����Ϣ����
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

--�Ƴ���Ϣ��Ӧ����
function eventsystem:removeEventHandler(name, handler)
	if( self.EventList[name] == nil ) then
		return;
	else
		--�ȼ�¼���������Ƴ�����ֹ����
		local indextable = {}
		for index,value in pairs(self.EventList[name]) do
			if(handler == value) or handler == nil then
				table.insert(indextable,index)
				--table.remove(self.EventList[name], index);
			end
		end
		
		if #indextable > 0 then		
			--�����Ƴ�
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