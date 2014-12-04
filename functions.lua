
-- simple_warp functions

simple_warp.format_pos = function(pos)
	local x = pos.x
	local y = pos.y
	local z = pos.z
	return x..":"..y..":"..z -- x:y:z string
end

simple_warp.check_for_conflict = function(name,warp) -- check if the warp name already exists public
	local warp_file = Settings(simple_warp.mod_path.."/warp_all.conf")
	if warp_file:get(warp) then
		minetest.chat_send_player(name,warp.." is already in use, try a different warp name !")
		return false
	else
		return true
	end
end

simple_warp.warp = function(name,warp)
	local warp_file = Settings(simple_warp.mod_path.."/warp_all.conf")
	local warp_pos = warp_file:get(warp) -- looking for the warp in the public locations
	if not warp_pos then
		warp_file = Settings(simple_warp.mod_path.."/"..name..".conf")
		if not warp_file then
			minetest.log("error","["..simple_warp.mod_name.."] Couldn't open file "..name..".conf !")
			minetest.chat_send_player(name,"["..simple_warp.mod_name.."] Couldn't open file "..name..".conf !")
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

simple_warp.set_warp = function(name,pos,warp,filename)
	local warp_file = Settings(simple_warp.mod_path.."/"..filename..".conf")
	if simple_warp.check_for_conflict(name,warp) then
		warp_file:set(warp,simple_warp.format_pos(pos))
		warp_file:write()
		minetest.chat_send_player(name,"Warp "..warp.." successfully set !")
	else
		return false
	end
end

simple_warp.del_warp = function(name,warp,filename)
	local warp_file = Settings(simple_warp.mod_path.."/"..filename..".conf")
	if not warp_file:remove(warp) then
		minetest.chat_send_player(name,"No such warp !")
	else
		warp_file:write()
		minetest.chat_send_player(name,"Warp "..warp.." successfully deleted !")
	end
end

simple_warp.list_warps = function(name,index,filename)
	local warp_file = io.open(simple_warp.mod_path.."/"..filename..".conf")
	if not warp_file then
		minetest.log("error","["..simple_warp.mod_name.."] Couldn't open file "..filename..".conf !")
		minetest.chat_send_player(name,"["..simple_warp.mod_name.."] Couldn't open file "..filename..".conf !")
		return false
	end
	local warp_table_start = (index*10)-10
	if index == 1 then
		warp_table_start = 1
	end
	local warp_table_stop = (index*10)-1
	local nlines = 0
	local warps_list = ""
	for line in warp_file:lines() do -- we show 9 elements of the table
		line = string.split(line,"=")
		if line[1] then -- avoid empty lines
			nlines = nlines + 1
			if nlines >= warp_table_start and nlines <= warp_table_stop then
				if warps_list then
					warps_list = warps_list..line[1]
				else
					warps_list = line[1]
				end
				if nlines%3 == 0 and nlines ~= warp_table_stop then -- newline after 3 entries
					warps_list = warps_list.."\n"
				end
			end
		end
	end
	warps_list = warps_list.."\n ---- page "..index.."/"..math.floor((nlines/9)+0.9).." ---- "
	minetest.chat_send_player(name,warps_list)
end
