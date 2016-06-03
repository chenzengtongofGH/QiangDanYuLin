-- sg_log.lua

-- des      :日志接口
-- author   :wz
-- data     :2015年1月13日
sg_log = {}

function sg_log.info(msg)
    CBaseFun:CCLuaLog("[run-info]:" .. msg);
end

function sg_log.warning(msg)
    CBaseFun:CCLuaLog("[run-warning]:" .. msg);
end

function sg_log.errormsg(msg)
    CBaseFun:CCLuaLog("[run-error]:" .. msg);
end


-- 打印表 indent传0
function sg_log.tprint (tbl, indent)
	sg_log.info("------------ start -------------");
	sg_log.tprint_recurision(tbl, indent)
	sg_log.info("------------ end -------------");
end

function sg_log.tprint_recurision(tbl, indent)
	if not indent then indent = 0 end
  if tbl == nil then 
	sg_log.info("nil")
	return
  end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      sg_log.info(formatting)
      sg_log.tprint_recurision(v, indent+1)
    else
		if type(v) == "userdata" then 
			sg_log.info(formatting .. "userdata")
		else
		    sg_log.info(formatting .. v)
		end
    end
  end
end

-- local t = {};
-- table.insert(t, g_gettime()), --1
-- table.insert(t, g_gettime()), --2
-- sg_log.print_interval(t, t)
function sg_log.print_interval(t, title)
    local title = title or "start";
    print("--------------- " .. title .. " -----------------");
    for i=1, #t-1, 1 do
        local a = t[i];
        local b = t[i+1];
        print("interval " .. i .. ":" .. (b-a));
    end
    print("--------------- end -----------------");
end