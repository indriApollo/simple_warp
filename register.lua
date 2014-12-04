
-- register privileges

minetest.register_privilege("usewarp","Can warp to public/private locations")
minetest.register_privilege("warpall","Can set/del public locations")
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
		simple_warp.set_warp(name,pos,param,name)
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
		simple_warp.del_warp(name,param,name)
	end,
})

minetest.register_chatcommand("setwarpall", {
	params = "/setwarpall <name>",
	description = "Set a public location",
	privs = {warpall = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		local pos = vector.round(player:getpos())
		simple_warp.set_warp(name,pos,param,"warp_all")
	end,
})

minetest.register_chatcommand("delwarpall", {
	params = "/delwarpall <name>",
	description = "Delete a public location",
	privs = {warpall = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		simple_warp.del_warp(name,param,"warp_all")
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
		simple_warp.list_warps(name,index,name)
	end,
})

minetest.register_chatcommand("warpsall", {
	params = "/warpsall <index>",
	description = "List all the public locations",
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
		simple_warp.list_warps(name,index,"warp_all")
	end,
})

minetest.register_chatcommand("warp", {
	params = "/warp <location>",
	description = "Warp to a public/private location",
	privs = {usewarp = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		simple_warp.warp(name,param)
	end,
})
