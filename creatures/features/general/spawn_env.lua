--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

spawn_env.lua

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

local registered_emergent_nodes = {}

local nodes_count = 0

-- Try spawn env
local try_spawn = function(pos, label, spawn_on)
	-- Check Spawn env node
	if minetest.get_meta(pos):get_string("creatures:spawn_env") == "" then return end
	-- Check MOB
	local meta = minetest.get_meta(pos)
	local spawn_env = minetest.deserialize(meta:get_string("creatures:spawn_env"))
	
	-- Check clean cycle
	if spawn_env.clean_cycle == creatures.cleaning_cycle then return end
	-- Try spawn
	local self = creatures.spawn_at_ambience(pos, label, 
		{
			spawn_on = spawn_on,
			only_one = true,
			ignore_height_limits = true,
			ignore_time_range = true,
			ignore_light = true,
		}
	)
	if self then
		self.is_wild = true
		self.spawn_env = {
			node_pos = table.copy(pos),
			node_name = minetest.get_node(pos).name,
		}
		spawn_env.clean_cycle = creatures.cleaning_cycle
		meta:set_string("creatures:spawn_env", minetest.serialize(spawn_env))
	end
end

-- Register spawn env
creatures.register_spawn_env = function(label)
	
	nodes_count = nodes_count + 1
	
	local def = creatures.registered_spawn[label]
	
	local nodename = def.spawn_env_nodes.emergent
	registered_emergent_nodes[nodename] = {}
	registered_emergent_nodes[nodename].label = label
	registered_emergent_nodes[nodename].spawn_env_nodes = def.spawn_env_nodes
	registered_emergent_nodes[nodename].number = def.number
	registered_emergent_nodes[nodename].build = def.spawn_env_nodes.build
	
	minetest.register_node(nodename, {
		description = "Spawn Env Node",
		tiles = {"creatures_spawn_env.png"},
		paramtype = "light",
		drawtype = "glasslike_framed_optional",
		sunlight_propagates = true,
		groups = {spawn_env=1, not_in_creative_inventory = 1},
		drop = "",
	})
	
	minetest.register_decoration({
		name = "creatures:spawn_env_"..nodes_count,
		deco_type = "simple",
		place_on = def.spawn_env_nodes.place_on,
		--place_offset_y = -1,
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.0001,
			spread = {x = 200, y = 200, z = 200},
			seed = def.spawn_env_seed or 549,
			octaves = 3,
			persist = 0.6 * (def.spawn_env_chance or 1),
			lacunarity = 1,
		},
		biomes = def.spawn_env_biomes,
		y_max = def.height_limit.max or 200,
		y_min = def.height_limit.min or 0,
		decoration = nodename,
		param2 = 4,
	})
	
	minetest.register_abm{
		label = "set spawn env node "..nodes_count,
		nodenames = def.spawn_env_nodes.set_on,
		neighbors = def.spawn_env_nodes.neighbors,
		interval = 10,
		chance = 1,
		action = function(pos)
			try_spawn(pos, label, def.spawn_env_nodes.spawn_on)
		end,
	}
	
end

minetest.register_lbm({
	name = "creatures:set_spawn_env_node",
	run_at_every_load = true,
	nodenames = {"group:spawn_env"},
	action = function(pos)
		local nodename = minetest.get_node(pos).name
		local def = registered_emergent_nodes[minetest.get_node(pos).name]
		local number = 1
		if def.number then
			if type(def.number) == "number" then
				number = def.number
			else
				number = math.random(def.number.min, def.number.max)
			end
		end
		
		-- Builds
		if def.build then
			-- Place nodes
			if def.build.place then
				local nodes = minetest.find_nodes_in_area(
					{x=pos.x-6, y=pos.y-6, z=pos.z-6}, 
					{x=pos.x+6, y=pos.y+6, z=pos.z+6}, 
					def.build.place.nodes
				)
				local n = number
				while n > 0 and #nodes > 0 do
					local p = creatures.get_random_from_table(nodes, true)
					minetest.set_node(
						{x=p.x, y=p.y+(def.build.place.y_diff or 0), z=p.z},
						{name=def.build.place.nodename}
					)
					n = n - 1
				end
			end
		end
		
		local nodes = minetest.find_nodes_in_area(
			{x=pos.x-6, y=pos.y-6, z=pos.z-6}, 
			{x=pos.x+6, y=pos.y+6, z=pos.z+6}, 
			def.spawn_env_nodes.set_on
		)
		while number > 0 and #nodes > 0 do
			local p = creatures.get_random_from_table(nodes, true)
			local meta = minetest.get_meta(p)
			local spawn_env = {
				mob_name = def.mob_name,
				clean_cycle = nil, -- Try spawn first time
			}
			meta:set_string("creatures:spawn_env", minetest.serialize(spawn_env))
			number = number - 1
			try_spawn(p, registered_emergent_nodes[nodename].label, registered_emergent_nodes[nodename].spawn_env_nodes.spawn_on)
			
		end
		minetest.remove_node(pos)
	end,
})

-- Check env node
local check_env_node = function(self)
	local node = creatures.get_far_node(self.spawn_env.node_pos) -- force load node
	
	-- Check node
	if node.name ~= self.spawn_env.node_name then
		return false
	end
	
	-- Check metadata
	local meta = minetest.get_meta(self.spawn_env.node_pos)
	if meta:get_string("creatures:spawn_env") == "" then
		return false
	end
	
	return true
end

-- Clear spawn env node
local clear_env_node = function(self)
	if check_env_node(self) == false then return end
	
	-- Remove data from node
	local meta = minetest.get_meta(self.spawn_env.node_pos)
	meta:set_string("creatures:spawn_env", "")
	
	-- Remove data from lua entity
	self.spawn_env = nil
end

-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Register 'on_die_mob' callback
	creatures.register_on_die_mob(mob_name, function(self, reason)
		if self.spawn_env ~= nil then
			clear_env_node(self)
		end
	end)
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		self.is_wild = self.is_wild or false
	end)
	
	-- Register 'get_staticdata'
	creatures.register_get_staticdata(mob_name, function(self)
		if self.activated and self.spawn_env ~= nil and self.mob_node ~= nil and self.mob_node.pos ~= nil then
			clear_env_node(self)
			self.is_wild = false
			return
		end
		if self.spawn_env ~= nil then
			return {
				is_wild = self.is_wild,
				spawn_env = self.spawn_env,
			}
		end
	end)
	
end)
