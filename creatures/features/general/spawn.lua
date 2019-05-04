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

-- Add entity
local add_entity = function(p, mob_name)
	local obj = core.add_entity(p, mob_name)
	local self = obj:get_luaentity()
	creatures.set_dir(self, creatures.get_random_dir())
end

-- Spawn a mob group
local function groupSpawn(pos, mob, group, nodenames, range, max_loops)
	local cnt = 0
	local cnt2 = 0

	local nodes = core.find_nodes_in_area({x = pos.x - range, y = pos.y - range, z = pos.z - range},
	{x = pos.x + range, y = pos.y, z = pos.z + range}, nodenames)
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
			add_entity(p, mob.name)
		end
	end
	if cnt < group then
		return false
	end
end

-- Registered spawns
creatures.registered_spawn = {}

-- Spawn a MOB at ambience
local spawn_at_ambience = function(pos, label, nodes)
	local def = creatures.registered_spawn[label]
	
	-- Check Time of Day
	local tod = core.get_timeofday() * 24000
	if def.time_range then
		local wanted_res = false
		local range = table.copy(def.time_range)
		if range.min > range.max and range.min <= tod then
			wanted_res = true
		end
		if inRange(range, tod) == wanted_res then
			return
		end
	end
	
	-- Check height limits
	if def.height_limit and not inRange(def.height_limit, pos.y) then
		return
	end

	-- Check light
	pos.y = pos.y + 1
	local llvl = core.get_node_light(pos)
	if def.light and not inRange(def.light, llvl) then
		return
	end
	
	-- Check creature count 
	local max
	do
		local mates_num = #creatures.find_target(
			pos, 
			def.spawn_zone_width, 
			{
				search_type = "mate", 
				mob_name = def.mob_name, 
				xray = true
			}
		)
		if (mates_num or 0) >= def.max_number then
			return
		else
			max = def.max_number - mates_num
		end
	end
	
	-- ok everything seems fine, spawn creature
	local height_min = (def.mob_size[5] or 2) - (def.mob_size[2] or 0)
	height_min = math.ceil(height_min)

	local number = 0
	if type(def.number) == "table" then
		number = math.random(def.number.min, def.number.max)
	else
		number = def.number or 1
	end

	if max and number > max then
		number = max
	end
	
	if number > 1 then
		groupSpawn(pos, {name = def.mob_name, size = height_min}, number, nodes or def.spawn_on, 5)
	else
		-- space check
		if not checkSpace(pos, height_min) then
			return
		end
		add_entity(pos, def.mob_name)
	end
end

-- Register Spawn
function creatures.register_spawn(label, def)
	if not def or not def.abm_nodes then
		creatures.throw_error("No valid definition for given.")
		return false
	end
	
	-- ABM
	def.abm_interval = def.abm_interval or 44
	def.abm_chance = def.abm_chance or 7000
	def.abm_nodes.neighbors = def.abm_nodes.neighbors or {}
	table.insert(def.abm_nodes.neighbors, "air")
	
	-- On generated
	def.on_generated_chance = def.on_generated_chance or 100
	def.on_generated_nodes = def.on_generated_nodes or {"default:dirt_with_grass"}
	
	-- Ambience
	def.spawn_zone_width = def.spawn_zone_width or 16
	
	creatures.registered_spawn[label] = table.copy(def)
	
	-- Register ABM
	if def.abm_nodes then
		minetest.register_abm({
			nodenames = def.abm_nodes.spawn_on,
			neighbors = def.abm_nodes.neighbors,
			interval = def.abm_interval,
			chance = def.abm_chance,
			catch_up = false,
			action = function(pos, node, active_object_count, active_object_count_wider)
				
				-- prevent abm-"feature"
				if stopABMFlood() == true then
					return
				end
				
				spawn_at_ambience(pos, label, def.abm_nodes.spawn_on)
			end,
		})
	end
	
	-- On generated map
	if def.on_generated_nodes then
		minetest.register_on_generated(function(minp, maxp, blockseed)
			
			-- Check height limits
			if def.height_limit 
				and not inRange(def.height_limit, minp.y) 
				and not inRange(def.height_limit, maxp.y)
			then
				return
			end
			
			-- Search a node near center
			local random_pos = {
				x = math.random(minp.x, maxp.x),
				y = math.random(minp.y, maxp.y),
				z = math.random(minp.z, maxp.z)
			}
			local radius = (maxp.x - minp.x)
			local pos = minetest.find_node_near(random_pos, radius, def.spawn_on or def.on_generated_nodes.spawn_on)
			if pos 
				and math.random(1, 100) <= def.on_generated_chance -- Calcule chance
			then
				
				-- Adjusto to a node under air 
				local n = 0
				while n <= 5 and minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z}).name ~= "air" do
					pos.y = pos.y + 1
					n = n + 1
				end
				
				spawn_at_ambience(pos, label, def.spawn_on or def.on_generated_nodes.spawn_on)
			end
		end)
	end
	
	return true
end


-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Check hostile enabled
	if def.stats.hostile and creatures.params.disable_hostile == true then
		return
	end
	
	-- Register Spawn
	if def.spawning and def.spawning.ambience then
		
		if def.spawning.ambience[1] then
			for i,spawn_def in ipairs(def.spawning.ambience) do
				
				local label = mob_name .. ":" .. i
				spawn_def.mob_name = mob_name
				spawn_def.mob_size = def.model.collisionbox
				
				-- Register Spawn
				if creatures.register_spawn(label, spawn_def) ~= true then
					creatures.throw_error("Couldn't register spawning ambience for '" .. mob_name .. "'")
				end
			end
		else
			local spawn_def = def.spawning.ambience
			
			local label = mob_name .. ":1"
			spawn_def.mob_name = mob_name
			spawn_def.mob_size = def.model.collisionbox
			
			-- Register Spawn
			if creatures.register_spawn(label, spawn_def) ~= true then
				creatures.throw_error("Couldn't register spawning ambience for '" .. mob_name .. "'")
			end
		end
	end
end)
