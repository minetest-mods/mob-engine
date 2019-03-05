--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

spawn.lua

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


-- Checks if a number is within range
local function inRange(range, value)
	if not value or not range or not range.min or not range.max then
		return false
	end
	if (value >= range.min and value <= range.max) then
		return true
	end
	return false
end


-- Check if 'height' is free from 'pos'
local function checkSpace(pos, height)
	for i = 0, height do
		local n = core.get_node_or_nil({x = pos.x, y = pos.y + i, z = pos.z})
		if not n or n.name ~= "air" then
			return false
		end
	end
	return true
end


-- Local timer 'time_taker'
local time_taker = 0
local function step(tick)
	core.after(tick, step, tick)
	time_taker = time_taker + tick
end
step(0.5) -- start timer

-- Stop ABM Flood
local function stopABMFlood()
	if time_taker == 0 then
		return true
	end
	time_taker = 0
end


-- Spawn a mob group
local function groupSpawn(pos, mob, group, nodes, range, max_loops)
	local cnt = 0
	local cnt2 = 0

	local nodes = core.find_nodes_in_area({x = pos.x - range, y = pos.y - range, z = pos.z - range},
	{x = pos.x + range, y = pos.y, z = pos.z + range}, nodes)
	local number = #nodes - 1
	if max_loops and type(max_loops) == "number" then
		number = max_loops
	end
	while cnt < group and cnt2 < number do
		cnt2 = cnt2 + 1
		local p = nodes[math.random(1, number)]
		p.y = p.y + 1
		if checkSpace(p, mob.size) == true then
			cnt = cnt + 1
			core.add_entity(p, mob.name)
		end
	end
	if cnt < group then
		return false
	end
end


-- Register Spawn
function creatures.register_spawn(spawn_def)
	if not spawn_def or not spawn_def.abm_nodes then
		creatures.throw_error("No valid definition for given.")
		return false
	end
	
	
	-- Neighbors adjustment
	if not spawn_def.abm_nodes.neighbors then
		spawn_def.abm_nodes.neighbors = {}
	end
	table.insert(spawn_def.abm_nodes.neighbors, "air")
	
	
	-- Register ABM
	core.register_abm({
		nodenames = spawn_def.abm_nodes.spawn_on,
		neighbors = spawn_def.abm_nodes.neighbors,
		interval = spawn_def.abm_interval or 44,
		chance = spawn_def.abm_chance or 7000,
		catch_up = false,
		action = function(pos, node, active_object_count, active_object_count_wider)
			
			-- prevent abm-"feature"
			if stopABMFlood() == true then
				return
			end
	
			-- time check
			local tod = core.get_timeofday() * 24000
			if spawn_def.time_range then
				local wanted_res = false
				local range = table.copy(spawn_def.time_range)
				if range.min > range.max and range.min <= tod then
					wanted_res = true
				end
				if inRange(range, tod) == wanted_res then
					return
				end
			end
	
			-- position check
			if spawn_def.height_limit and not inRange(spawn_def.height_limit, pos.y) then
				return
			end

			-- light check
			pos.y = pos.y + 1
			local llvl = core.get_node_light(pos)
			if spawn_def.light and not inRange(spawn_def.light, llvl) then
				return
			end
			
			-- creature count check
			local max
			if active_object_count_wider > (spawn_def.max_number or 1) then
				local mates_num = #creatures.findTarget(nil, pos, 16, "mate", spawn_def.mob_name, true)
				if (mates_num or 0) >= spawn_def.max_number then
					return
				else
					max = spawn_def.max_number - mates_num
				end
			end

			-- ok everything seems fine, spawn creature
			local height_min = (spawn_def.mob_size[5] or 2) - (spawn_def.mob_size[2] or 0)
			height_min = math.ceil(height_min)

			local number = 0
			if type(spawn_def.number) == "table" then
				number = math.random(spawn_def.number.min, spawn_def.number.max)
			else
				number = spawn_def.number or 1
			end

			if max and number > max then
				number = max
			end

			if number > 1 then
				groupSpawn(pos, {name = spawn_def.mob_name, size = height_min}, number, spawn_def.abm_nodes.spawn_on, 5)
			else
				-- space check
				if not checkSpace(pos, height_min) then
					return
				end
				core.add_entity(pos, spawn_def.mob_name)
			end
		end,
	})

	return true
end


-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Check hostile enabled
	if def.stats.hostile and creatures.params.disable_hostile == true then
		return
	end
	
	-- Register Spawn
	if def.spawning then
	
		local spawn_def = def.spawning
		spawn_def.mob_name = mob_name
		spawn_def.mob_size = def.model.collisionbox
		
		-- Register Spawn
		if creatures.register_spawn(spawn_def) ~= true then
			throw_error("Couldn't register spawning for '" .. mob_name .. "'")
		end
		
	end
end)
