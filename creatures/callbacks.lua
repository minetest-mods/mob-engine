--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

callbacks.lua

This software is provided 'as-is', without any express or implied warranty. In no
event will the authors be held liable for any damages arising from the use of
this software.

Permission is granted to anyone to use this software for any purpose, including
commercial applications, and to alter it and redistribute it freely, subject to the
following restrictions:

1. The origin of this software must not be misrepresented; you must not
claim that you wrote the original software. If you use this software in a
product, an acknowledgment in the product documentation is required.
2. Altered source versions must be plainly marked as such, and must not
be misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
]]


-- Register 'on_step'
creatures.register_on_step = function(mob_name, func)
	-- Check 'on_step'
	if creatures.registered_mobs[mob_name].on_step_table == nil then
		creatures.registered_mobs[mob_name].on_step_table = {}
	end
	
	table.insert(creatures.registered_mobs[mob_name].on_step_table, func)
end

-- Execute 'on_step'
creatures.on_step = function(mob_name, self, dtime)
	
	-- first get the relevant specs; exit if we don't know anything (1-3ms)
	local def = core.registered_entities[self.mob_name]
	if not def then
		throw_error("Can't load creature-definition")
		return
	end
	
	-- Check 'on_step'
	if creatures.registered_mobs[mob_name].on_step_table == nil then
		creatures.registered_mobs[mob_name].on_step_table = {}
	end
	
	-- Run registered 'on_step'
	for _,f in ipairs(creatures.registered_mobs[mob_name].on_step_table) do
		local r = f(self, dtime)
		if r == true then
			return r
		end
	end
end


-- Register 'on_punch'
creatures.register_on_punch = function(mob_name, func)
	-- Check 'on_punch'
	if creatures.registered_mobs[mob_name].on_punch_table == nil then
		creatures.registered_mobs[mob_name].on_punch_table = {}
	end
	
	table.insert(creatures.registered_mobs[mob_name].on_punch_table, func)
end

-- Execute 'on_punch'
creatures.on_punch = function(mob_name, self, puncher, time_from_last_punch, tool_capabilities, dir)

	-- Check 'on_punch'
	if creatures.registered_mobs[mob_name].on_punch_table == nil then
		creatures.registered_mobs[mob_name].on_punch_table = {}
	end
	
	-- Run registered 'on_punch'
	for _,f in ipairs(creatures.registered_mobs[mob_name].on_punch_table) do
		local r = f(self, puncher, time_from_last_punch, tool_capabilities, dir)
		if r == true then
			return r
		end
	end
end


-- Register 'on_rightclick'
creatures.register_on_rightclick = function(mob_name, func)
	-- Check 'on_rightclick'
	if creatures.registered_mobs[mob_name].on_rightclick_table == nil then
		creatures.registered_mobs[mob_name].on_rightclick_table = {}
	end
	
	table.insert(creatures.registered_mobs[mob_name].on_rightclick_table, func)
end

-- Execute 'on_rightclick'
creatures.on_rightclick = function(mob_name, self, clicker)

	-- Check 'on_rightclick'
	if creatures.registered_mobs[mob_name].on_rightclick_table == nil then
		creatures.registered_mobs[mob_name].on_rightclick_table = {}
	end
	
	-- Run registered 'on_rightclick'
	for _,f in ipairs(creatures.registered_mobs[mob_name].on_rightclick_table) do
		local r = f(self, clicker)
		if r == true then
			return r
		end
	end
end


-- Register 'get_staticdata'
creatures.register_get_staticdata = function(mob_name, func)
	-- Check 'get_staticdata'
	if creatures.registered_mobs[mob_name].get_staticdata_table == nil then
		creatures.registered_mobs[mob_name].get_staticdata_table = {}
	end
	
	table.insert(creatures.registered_mobs[mob_name].get_staticdata_table, func)
end

-- Execute 'get_staticdata'
creatures.get_staticdata = function(mob_name, self)

	-- Check 'get_staticdata'
	if creatures.registered_mobs[mob_name].get_staticdata_table == nil then
		creatures.registered_mobs[mob_name].get_staticdata_table = {}
	end
	
	-- Run registered 'get_staticdata'
	local data = {}
	
	for _,f in ipairs(creatures.registered_mobs[mob_name].get_staticdata_table) do
		local other_data = f(self)
		
		-- Merge results
		if other_data and type(other_data) == "table" then
			for s,w in pairs(other_data) do
				data[s] = w
			end
		end
	end
	
	return minetest.serialize(data)
end


-- Register 'on_activate'
creatures.register_on_activate = function(mob_name, func)
	-- Check 'on_activate'
	if creatures.registered_mobs[mob_name].on_activate_table == nil then
		creatures.registered_mobs[mob_name].on_activate_table = {}
	end
	
	table.insert(creatures.registered_mobs[mob_name].on_activate_table, func)
end

-- Execute 'on_activate'
creatures.on_activate = function(mob_name, self, staticdata)
	
	-- Restore Staticdata for entity
	if staticdata then
		local tab = core.deserialize(staticdata)
		if tab and type(tab) == "table" then
			for s,w in pairs(tab) do
				self[tostring(s)] = w
			end
		end
	end
	
	-- Check 'on_activate'
	if creatures.registered_mobs[mob_name].on_activate_table == nil then
		creatures.registered_mobs[mob_name].on_activate_table = {}
	end
	
	-- Run registered 'on_activate'
	for _,f in ipairs(creatures.registered_mobs[mob_name].on_activate_table) do
		local r = f(self, staticdata)
		if r == true then
			return r
		end
	end
end

