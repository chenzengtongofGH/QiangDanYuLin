--cocos2dx.scheduler
local scheduler = {}
local schedulerHandles={}
local sharedScheduler = cc.Director:getInstance():getScheduler()

function scheduler.scheduleUpdateGlobal(listener, isPaused)
    if type(isPaused) ~= "boolean" then isPaused = false end	
	local handle = sharedScheduler:scheduleScriptFunc(listener, 0, isPaused)
	schedulerHandles[#schedulerHandles+1]=handle
    return handle
end

function scheduler.scheduleGlobal(listener, interval, isPaused)
    if type(isPaused) ~= "boolean" then isPaused = false end	
	local handle = sharedScheduler:scheduleScriptFunc(listener, interval, isPaused)
	schedulerHandles[#schedulerHandles+1]=handle
	--log.Info("[SCHEDULER]:schedule handle="..handle.." count="..#schedulerHandles)
    return handle
end

function scheduler.unscheduleGlobal(handle)
	for k,v in ipairs(schedulerHandles) do
		if v == handle then
			table.remove(schedulerHandles,k)
		end
	end
	--log.Info("[SCHEDULER]:unschedule handle="..handle.." count="..#schedulerHandles)
    if type(handle) == "number" then
        sharedScheduler:unscheduleScriptEntry(handle)
    end
end

function scheduler.performWithDelayGlobal(listener, time)
    local handle
    handle = sharedScheduler:scheduleScriptFunc(function()
        scheduler.unscheduleGlobal(handle)
        listener()
    end, time, false)
    return handle
end
function scheduler.unscheduleAllGlobal()
	for k,v in ipairs(schedulerHandles) do
		sharedScheduler:unscheduleScriptEntry(v)
		--log.Info("[SCHEDULER]:unschedule all handle="..v.." count="..#schedulerHandles)
	end
	schedulerHandles={}
end
function scheduler.scheduleAmount()
	return #schedulerHandles
end

return scheduler
