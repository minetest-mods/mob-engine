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
local spawn_number = 0
local spawn_number_limit = creatures.params.spawn_flood_control
local function step(tick)
	core.after(tick, step, tick)
	spawn_number = 0
end
step(0.5) -- start timer

-- Stop ABM Flood
local function stopABMFlood()
	if spawn_number > spawn_number_limit then
		return true
	end
	spawn_number = spawn_number + 1
end

-- Add entity
local add_entity = function(p, mob_name)
	local obj = core.add_entity(p, mob_name)
	local self = obj:get_luaentity()
	creatures.set_dir(self, creatures.get_random_dir())
	
	return self
end

-- Force add entity
local force_add_entity = function(p, mob_name)
	--minetest.forceload_block(pos)
	local obj = core.add_entity(p, mob_name)
	local self = obj:get_luaentity()
	creatures.set_dir(self, creatures.get_random_dir())
end

-- Spawn a mob group
local function group_spawn(pos, mob, params)
	-- Params
	local group = params.group
	local nodenames = params.nodenames
	local range = params.range or 5
	local max_loops = params.max_loops or 6
	local delay = params.delay
	
	local cnt = 0
	local cnt2 = 0

	local nodes = core.find_nodes_in_area({x = pos.x - range, y = pos.y - range, z = pos.z - range},
	{x = pos.x + range, y = pos.y, z = pos.z + range}, nodenames)
	local number = table.maxn(nodes) - 1
	if max_loops and type(max_loops) == "number" then
		number = max_loops
	end
	
	while table.maxn(nodes) > 2 and cnt < group and cnt2 < number do
		cnt2 = cnt2 + 1
		local p = nodes[math.random(1, number)]
		if p then
			p.y = p.y + 1
			if checkSpace(p, mob.size) == true then
				cnt = cnt + 1
				if delay then
					minetest.after(delay, add_entity, p, mob.name)
				else
					add_entity(p, mob.name)
				end
			end
		end
	end
	if cnt < group then
		return false
	end
end

-- Registered spawns
creatures.registered_spawn = {}

-- Spawn a MOB at ambience
creatures.spawn_at_ambience = function(pos, label, params)
	local def = creatures.registered_spawn[label]
	params = params or {}
	
	-- Check Time of Day
	local tod = core.get_timeofday() * 24000
	if params.ignore_time_range ~= true and def.time_range then
		local range = table.copy(def.time_range)
		if range.min > range.max then
			if tod < range.max then
				tod = tod + 24000
			end
			range.max = range.max + 24000
		end
		if inRange(range, tod) == false then
			return
		end
	end
	
	-- Check height limits
	if params.ignore_height_limits ~= true and def.height_limit and not inRange(def.height_limit, pos.y) then
		return
	end
	
	-- Check creature count in zone
	local max
	if def.max_number and def.spawn_zone_width then
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
	if params.only_one == true then
		number = 1
	elseif type(def.number) == "table" then
		number = math.random(def.number.min, def.number.max)
	else
		number = def.number or 1
	end

	if max and number > max then
		number = max
	end
	
	if number > 1 then
		group_spawn(pos, {name = def.mob_name, size = height_min}, 
			{
				group = number, 
				nodenames = params.spawn_on or def.spawn_on, 
				range = 5, 
				delay = params.delay, 
			}
		)
	else
		
		local spawn_pos = table.copy(pos)
		
		if params.spawn_on then
			spawn_pos = nil
			local nds = minetest.find_nodes_in_area(
				{x = pos.x - 5, y = pos.y - 5, z = pos.z - 5},
				{x = pos.x + 5, y = pos.y + 5, z = pos.z + 5}, 
				params.spawn_on or def.spawn_on
			)
			while #nds > 0 do
				local p = creatures.get_random_from_table(nds, true)
				p.y = p.y + 1
				-- space check
				if checkSpace(p, height_min) then
					-- Check light
					local llvl = core.get_node_light(p)
					if def.light and not inRange(def.light, llvl) then
						p = nil
					else
						spawn_pos = table.copy(p)
						break
					end
				else
					p = nil
				end
			end
			if spawn_pos == nil then
				return
			end 
		else
			spawn_pos.y = spawn_pos.y + 1
			-- Check light
			local llvl = core.get_node_light(spawn_pos)
			if params.ignore_light ~= true and def.light and not inRange(def.light, llvl) then
				return
			end
			-- space check
			if not checkSpace(spawn_pos, height_min) then
				return
			end
		end
		
		if params.delay then
			minetest.after(params.delay, add_entity, spawn_pos, def.mob_name)
		else
			return add_entity(spawn_pos, def.mob_name)
		end
	end
end
local spawn_at_ambience = creatures.spawn_at_ambience

-- Register Spawn
function creatures.register_spawn(label, def)
	if not def then
		creatures.throw_error("No valid definition for given.")
		return false
	end
	
	-- On generated
	if def.on_generated_nodes then
		def.on_generated_chance = def.on_generated_chance or 100
		def.on_generated_nodes = def.on_generated_nodes or {"default:dirt_with_grass"}
	end
	
	-- Ambience
	def.spawn_zone_width = def.spawn_zone_width or 16
	
	creatures.registered_spawn[label] = table.copy(def)
	
	-- 'ABM' spawn type
	if def.spawn_type == "abm" then
	
		def.abm_interval = def.abm_interval or 44
		def.abm_chance = def.abm_chance or 7000
		
		-- Register ABM
		minetest.register_abm({
			nodenames = def.abm_nodes.spawn_on,
			neighbors = def.abm_nodes.neighbors,
			interval = def.abm_interval,
			chance = def.abm_chance,
			catch_up = false,
			action = function(pos, node, active_object_count, active_object_count_wider)
				
				-- prevent abm-"feature"
				if creatures.params.spawn_flood_control > 0 and stopABMFlood() == true then
					return
				end
				
				-- Check node near
				if def.abm_nodes.near 
				and minetest.find_node_near(
					pos, 
					def.abm_nodes.near_radius or creatures.default_value.nodes_near_radius, 
					def.abm_nodes.near
				) == nil then
					return
				end
				
				spawn_at_ambience(pos, label, 
					{
						spawn_on = def.abm_nodes.spawn_on,
					}
				)
			end,
		})
	
	-- 'Environment' spawn type
	elseif def.spawn_type == "environment" then
		creatures.register_spawn_env(label)
		
	-- 'On generated map' spawn type
	elseif def.spawn_type == "generated" then
	
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
			local pos 
			if def.on_generated_nodes.get_under_air == true then
				local nds = minetest.find_nodes_in_area_under_air(minp, maxp, def.spawn_on or def.on_generated_nodes.spawn_on)
				if table.maxn(nds) > 0 then
					pos = nds[math.random(1, table.maxn(nds))]
				end
			else
				pos = minetest.find_node_near(random_pos, radius, def.spawn_on or def.on_generated_nodes.spawn_on)
			end
			if pos 
				and math.random(1, 100) <= def.on_generated_chance -- Calcule chance
			then
				-- Adjust to a node under air 
				local n = 0
				while n <= 5 and minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z}).name ~= "air" do
					pos.y = pos.y + 1
					n = n + 1
				end
				
				-- Check node near
				if def.on_generated_nodes.near 
				and minetest.find_node_near(
					pos, 
					def.on_generated_nodes.near_radius or creatures.default_value.nodes_near_radius, 
					def.on_generated_nodes.near
				) == nil then
					return
				end
				
				spawn_at_ambience(pos, label, 
					{
						spawn_on = def.spawn_on or def.on_generated_nodes.spawn_on,
					}
				)
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
