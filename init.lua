
mod_name = minetest.get_current_modname()
mod_path = minetest.get_modpath(mod_name)

local function format_pos(pos)
	local x = pos.x
	local y = pos.y
	local z = pos.z
	return x..":"..y..":"..z -- x:y:z string
end

local function check_for_conflict(name,warp) -- check if the warp name already exists worldwide
	local warp_file = Settings(mod_path.."/warp_all.conf")
	if not warp_file then
		minetest.log("error","["..mod_name.."] Couldn't open file warp_all.conf !")
		minetest.chat_send_player(name,"["..mod_name.."] Couldn't open file warp_all.conf !")
		return false
	end
	if warp_file:get(warp) then
		minetest.chat_send_player(name,warp.." is already in use, try a different warp name !")
		return false
	else
		return true
	end
end

local function warp(name,warp)
	local warp_file = Settings(mod_path.."/warp_all.conf")
	if not warp_file then
		minetest.log("error","["..mod_name.."] Couldn't open file warp_all.conf !")
		minetest.chat_send_player(name,"["..mod_name.."] Couldn't open file warp_all.conf !")
		return false
	end
	local warp_pos = warp_file:get(warp) -- looking for the warp in the worldwide locations
	if not warp_pos then
		warp_file = Settings(mod_path.."/"..name..".conf")
		if not warp_file then
			minetest.log("error","["..mod_name.."] Couldn't open file "..name..".conf !")
			minetest.chat_send_player(name,"["..mod_name.."] Couldn't open file "..name..".conf !")
			return false
		end
		warp_pos = warp_file:get(warp) -- looking for the warp in the private locations
	end
	if not warp_pos then
		minetest.chat_send_player(name,"No such warp !") -- warp doesn't exist
	else
		warp_pos = string.split(warp_pos,":")
		player = minetest.get_player_by_name(name)
		player:setpos({x=warp_pos[1],y=warp_pos[2],z=warp_pos[3]})
		minetest.chat_send_player(name,"Warped to "..warp.." !")
	end
end

local function set_private_warp(name,pos,warp)
	local warp_file = Settings(mod_path.."/"..name..".conf")
	if not warp_file then
		minetest.log("error","["..mod_name.."] Couldn't open file "..name..".conf !")
		minetest.chat_send_player(name,"["..mod_name.."] Couldn't open file "..name..".conf !")
		return false
	end
	if check_for_conflict(name,warp) then
		warp_file:set(warp,format_pos(pos))
		warp_file:write()
		minetest.chat_send_player(name,"Warp "..warp.." successfully set !")
	else
		return false
	end
end

local function set_worldwide_warp(name,pos,warp)
	local warp_file = Settings(mod_path.."/warp_all.conf")
	if not warp_file then
		minetest.log("error","["..mod_name.."] Couldn't open file warp_all.conf !")
		minetest.chat_send_player(name,"["..mod_name.."] Couldn't open file warp_all.conf !")
		return false
	end
	if check_for_conflict(name,warp) then
		warp_file:set(warp,format_pos(pos))
		warp_file:write()
		minetest.chat_send_player(name,"Warp "..warp.." successfully set !")
	else
		return false
	end
end

local function del_private_warp(name,warp)
	local warp_file = Settings(mod_path.."/"..name..".conf")
	if not warp_file then
		minetest.log("error","["..mod_name.."] Couldn't open file "..name..".conf !")
		minetest.chat_send_player(name,"["..mod_name.."] Couldn't open file "..name..".conf !")
		return false
	end
	if not warp_file:remove(warp) then
		minetest.chat_send_player(name,"No such warp !")
	else
		warp_file:write()
		minetest.chat_send_player(name,"Warp "..warp.." successfully deleted !")
	end
end

local function del_worldwide_warp(name,warp)
	local warp_file = Settings(mod_path.."/warp_all.conf")
	if not warp_file then
		minetest.log("error","["..mod_name.."] Couldn't open file warp_all.conf !")
		minetest.chat_send_player(name,"["..mod_name.."] Couldn't open file warp_all.conf !")
		return false
	end
	if not warp_file:remove(warp) then
		minetest.chat_send_player(name,"No such warp !")
	else
		warp_file:write()
		minetest.chat_send_player(name,"Warp "..warp.." successfully deleted !")
	end
end

local function list_warps(name,index,list)
	local warp_file = io.open(mod_path.."/"..list..".conf")
	if not warp_file then
		minetest.log("error","["..mod_name.."] Couldn't open file "..list..".conf !")
		minetest.chat_send_player(name,"["..mod_name.."] Couldn't open file "..list..".conf !")
		return false
	end
	local warp_table_start = (index*10)-10
	if index == 1 then
		warp_table_start = 1
	end
	print(warp_table_start)
	local warp_table_stop = (index*10)-1
	local nlines = 0
	local warp_list = ""
	for line in warp_file:lines() do -- we show 9 elements of the table
		line = string.split(line,"=")
		if line[1] then -- avoid empty lines
			nlines = nlines + 1
			if nlines >= warp_table_start and nlines <= warp_table_stop then
				if warp_list then
					warp_list = warp_list..line[1]
				else
					warp_list = line[1]
				end
				if nlines%3 == 0 and nlines ~= warp_table_stop then -- newline after 3 entries
					warp_list = warp_list.."\n"
				end
			end
		end
	end
	warp_list = warp_list.."\n ---- page "..index.."/"..math.floor((nlines/9)+0.9).." ---- "
	minetest.chat_send_player(name,warp_list)
end

-- register privileges

minetest.register_privilege("usewarp","Can warp to worldwide/private locations")
minetest.register_privilege("warpall","Can set/del worldwide locations")
minetest.register_privilege("warpown","Can set/del private locations")

-- chatcommands

minetest.register_chatcommand("setwarp", {
	params = "/setwarp <name>",
	description = "Set a private location",
	privs = {warpown = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		local pos = vector.round(player:getpos())
		set_private_warp(name,pos,param)
	end,
})

minetest.register_chatcommand("delwarp", {
	params = "/delwarp <name>",
	description = "Delete a private location",
	privs = {warpown = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		del_private_warp(name,param)
	end,
})

minetest.register_chatcommand("setwarpall", {
	params = "/setwarpall <name>",
	description = "Set a worldwide location",
	privs = {warpall = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		local pos = vector.round(player:getpos())
		set_worldwide_warp(name,pos,param)
	end,
})

minetest.register_chatcommand("delwarpall", {
	params = "/delwarpall <name>",
	description = "Delete a worldwide location",
	privs = {warpall = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		del_worldwide_warp(name,param)
	end,
})

minetest.register_chatcommand("warps", {
	params = "/warps <index>",
	description = "List all your private locations",
	privs = {warpown = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		index = tonumber(param)
		if not index then
			index = 1
		elseif index <= 0 then
			return false, "Index must be a positive number !"
		end
		list_warps(name,index,name)
	end,
})

minetest.register_chatcommand("warpsall", {
	params = "/warpsall <index>",
	description = "List all the worldwide locations",
	privs = {usewarp = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		index = tonumber(param)
		if not index then
			index = 1
		elseif index <= 0 then
			return false, "Index must be a positive number !"
		end
		list_warps(name,index,"warp_all")
	end,
})

minetest.register_chatcommand("warp", {
	params = "/warp <location>",
	description = "Warp to a worldwide/private location",
	privs = {usewarp = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		warp(name,param)
	end,
})
