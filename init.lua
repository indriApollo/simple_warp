
-- global mod namespace
simple_warp = {}

simple_warp.mod_name = minetest.get_current_modname()
simple_warp.mod_path = minetest.get_modpath(simple_warp.mod_name)

local mod_name = simple_warp.mod_name
local mod_path = simple_warp.mod_path

local loadmodule = function(path)
	local file = io.open(path)
	if not file then
		minetest.log("error","["..mod_name.."] Unable to load "..path)
		return false
	end
	file:close()
	return dofile(path)
end

loadmodule(mod_path .. "/functions.lua")
loadmodule(mod_path .. "/register.lua")

minetest.log("info","["..mod_name.."] Warps enabled")