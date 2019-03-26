--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

spawner.lua

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


-- Make entity of the spawner node
local function makeSpawnerEntiy(mob_name, model)
	core.register_entity(":" .. mob_name .. "_spawner_dummy", {
	hp_max = 1,
	physical = false,
	collide_with_objects = false,
	collisionbox = {0,0,0, 0,0,0},
	visual = "mesh",
	visual_size = {x = 0.42, y = 0.42},
	mesh = model.mesh,
	textures = model.textures,
	makes_footstep_sound = false,
	automatic_rotate = math.pi * -2.9,
	mob_name = "_" .. mob_name .. "_dummy",

	on_activate = function(self)
		self.timer = 0
		self.object:setvelocity(nullVec)
		self.object:setacceleration(nullVec)
		self.object:set_armor_groups({immortal = 1})
	end,

	on_step = function(self, dtime)
		self.timer = self.timer + dtime
		if self.timer > 30 then
			self.timer = 0
			local n = core.get_node_or_nil(self.object:getpos())
			if n and n.name and n.name ~= mob_name .. "_spawner" then
				self.object:remove()
			end
		end
	end,
	})
end


-- Spawn mobs of spawner node
local function spawnerSpawn(pos, spawner_def)
	local mates = creatures.findTarget(nil, pos, spawner_def.range, "mate", spawner_def.mob_name, true) or {}
	if #mates >= spawner_def.number then
		return false
	end
	local number_max = spawner_def.number - #mates

	local rh = math.floor(spawner_def.range/2)
	local area = {
		min = {x = pos.x - rh, y=pos.y - rh, z = pos.z - rh},
		max = {x = pos.x + rh, y=pos.y + rh - spawner_def.height - 1, z = pos.z + rh}
	}

	local height = area.max.y - area.min.y
	local cnt = 0
	for i = 0, height do
		if cnt >= number_max then
			break
		end
		local p = {x = math.random(area.min.x, area.max.x), y = area.min.y + i, z = math.random(area.min.z, area.max.z)}
		local n = core.get_node_or_nil(p)
		if n and n.name then
			local walkable = core.registered_nodes[n.name].walkable or false
			p.y = p.y + 1
			if walkable and checkSpace(p, spawner_def.height) == true then
				local llvl = core.get_node_light(p)
				if not spawner_def.light or (spawner_def.light and inRange(spawner_def.light, llvl)) then
					cnt = cnt + 1
					core.add_entity(p, spawner_def.mob_name)
				end
			end
		end
	end
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


-- Register Spawner node
local spawner_timers = {}
function creatures.register_spawner(spawner_def)
	if not spawner_def or not spawner_def.mob_name or not spawner_def.model then
		creatures.throw_error("Can't register Spawn-Egg. Not enough parameters given.")
		return false
	end

	makeSpawnerEntiy(spawner_def.mob_name, spawner_def.model)

	core.register_node(":" .. spawner_def.mob_name .. "_spawner", {
		description = spawner_def.description or spawner_def.mob_name .. " spawner",
		paramtype = "light",
		tiles = {"creatures_spawner.png"},
		is_ground_content = true,
		drawtype = "glasslike",
		groups = {cracky = 1, level = 1},
		drop = "",
		on_construct = function(pos)
			pos.y = pos.y - 0.3
			core.add_entity(pos, spawner_def.mob_name .. "_spawner_dummy")
		end,
		on_destruct = function(pos)
			for _,obj in ipairs(core.get_objects_inside_radius(pos, 1)) do
				local entity = obj:get_luaentity()
				if obj and entity and entity.mob_name == "_" .. spawner_def.mob_name .. "_dummy" then
					obj:remove()
				end
			end
		end
	})

	local box = spawner_def.model.collisionbox
	local height = (box[5] or 2) - (box[2] or 0)
	spawner_def.height = height

	if spawner_def.player_range and type(spawner_def.player_range) == "number" then
		core.register_abm({
			nodenames = {spawner_def.mob_name .. "_spawner"},
			interval = 2,
			chance = 1,
			catch_up = false,
			action = function(pos)
				local id = core.pos_to_string(pos)
				if not spawner_timers[id] then
					spawner_timers[id] = os.time()
				end
				local time_from_last_call = os.time() - spawner_timers[id]
				local mobs,player_near = creatures.findTarget(nil, pos, spawner_def.player_range, "player", nil, true, true)
				if player_near == true 
					and time_from_last_call > 10 
					and (math.random(1, 5) == 1 or (time_from_last_call ) > 27) 
				then
					spawner_timers[id] = os.time()

					spawnerSpawn(pos, spawner_def)
				end
			end,
		})
	else
		core.register_abm({
			nodenames = {spawner_def.mob_name .. "_spawner"},
			interval = 10,
			chance = 3,
			action = function(pos)
				spawnerSpawn(pos, spawner_def)
			end
		})
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
	if def.spawning then
	
		local spawn_def = def.spawning
		spawn_def.mob_name = def.name
		spawn_def.mob_size = def.model.collisionbox
		
		-- Register Spawner
		if spawn_def.spawner then
			local spawner_def = def.spawning.spawner
			spawner_def.mob_name = mob_name
			spawner_def.range = spawner_def.range or 4
			spawner_def.number = spawner_def.number or 6
			spawner_def.model = def.model
			creatures.register_spawner(spawner_def)
		end
		
	end
end)
