--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

mob_node.lua

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

local hash_tb = {}

-- Check mob_node at pos
local check_node = function(pos)
	local node = creatures.get_far_node(pos)
	if not creatures.registered_mob_nodes[node.name] then
		return false
	end
	return true
end

-- Save MOB
local save_mob = function(self)
	
	-- Save in the mob node
	local meta = minetest.get_meta(self.mob_node.pos)
	meta:set_string("creatures:saved_mob", "true")
	meta:set_float("creatures:last_cleaning_cycle", creatures.cleaning_cycle)
	
	-- Save tags
	for _,tag_name in ipairs(creatures.mob_node_save_tags) do
		meta:set_string("creatures:saved_mob_node_tag_"..tag_name, minetest.serialize(self[tag_name]))
	end
	
	-- Run callback
	local def = creatures.get_mob_node_def(minetest.get_node(self.mob_node.pos).name)
	if def.on_save_mob then
		def.on_save_mob(self.mob_node.pos, self)
	end
	
end

-- Set mob in node
local set_mob_node = function(pos, self)
	if check_node(pos) == false then 
		return 
	end
	
	local meta = minetest.get_meta(pos)
	
	-- Hash link of occupation
	local hashlink = tostring(self.object)
	
	self.mob_node.hashlink = hashlink
	self.mob_node.pos = {
		x = creatures.int(pos.x),
		y = creatures.int(pos.y),
		z = creatures.int(pos.z)
	}
	
	meta:set_string("creatures:hashlink", hashlink)
	
	save_mob(self)
	
	hash_tb[hashlink] = self.object
	
	-- Run callback
	local def = creatures.get_mob_node_def(minetest.get_node(pos).name)
	if def.on_set_mob_node then
		def.on_set_mob_node(pos, self)
	end
end


-- Reset mob node
local reset_mob_node = function(pos)
	if check_node(pos) == false then return end
	
	local meta = minetest.get_meta(pos)
	
	meta:set_string("creatures:hashlink", "")
	meta:set_string("creatures:saved_mob", "")
	
	-- Run callback
	local def = creatures.get_mob_node_def(minetest.get_node(pos).name)
	if def.on_reset_mob_node then
		def.on_reset_mob_node(pos)
	end
end


-- Check if can walk to mob_node
local node_way = function(self, pos, origin)
	if not pos then
		pos = self.mob_node.pos
	end
	
	if minetest.find_path(
		origin or self.object:get_pos(), 
		pos, 
		8, -- search distance
		1, -- max jump
		2, -- max drop
		"A*_noprefetch" -- algorithm
	) then
		return true
	end
	return false
end


-- Load MOB
local load_mob = function(pos)
	local meta = minetest.get_meta(pos)
	meta:set_float("creatures:last_cleaning_cycle", creatures.cleaning_cycle)
	
	-- MOB node definitions
	local def = creatures.get_mob_node_def(minetest.get_node(pos).name)
	
	-- Spawn MOB
	local obj = core.add_entity(pos, def.mob_name)
	local self = obj:get_luaentity()
	
	-- Setup MOB
	self.mob_node = {}
	self.mob_node.pos = creatures.copy_tb(pos)
	self.mob_node.hashlink = meta:get_string("creatures:hashlink")
	
	hash_tb[self.mob_node.hashlink] = self.object
	
	-- Load tags
	for _,tag_name in ipairs(creatures.mob_node_save_tags) do
		self[tag_name] = minetest.deserialize(meta:get_string("creatures:saved_mob_node_tag_"..tag_name))
	end
	
	-- Update randomized values
	creatures.set_random_values(self, true)
	
	-- Run callback
	local def = creatures.get_mob_node_def(minetest.get_node(pos).name)
	if def.on_load_mob then
		def.on_load_mob(pos, self)
	end
end

-- Check vacant mob node
local vacant_mob_node = function(pos)
	local meta = minetest.get_meta(pos)
	
	if meta:get_string("creatures:hashlink") == "" then
		
		return true
	end
	
	return false
end

-- Check mob node
creatures.check_mob_node = function(self)
	if not self.mob_node.hashlink or not self.mob_node.pos then 
		return false 
	end
	local meta = minetest.get_meta(self.mob_node.pos)
	
	if meta:get_string("creatures:hashlink") == self.mob_node.hashlink then
		return true
	end
	
	return false
end
local check_mob_node = creatures.check_mob_node

-- Check cleaning cycle
local check_cleaning_cycle = function(pos)
	local meta = minetest.get_meta(pos)
	local last_cycle = meta:get_float("creatures:last_cleaning_cycle") or 0
	
	if meta:get_string("creatures:saved_mob") == "true" 
		and last_cycle ~= creatures.cleaning_cycle 
	then
		load_mob(pos)
	end
end


-- Register mob node
creatures.registered_mob_nodes = {}
creatures.register_mob_node = function(mob_node, def)
	
	local mob_name = def.mob_name
	
	-- ABM
	minetest.register_abm{
		nodenames = {mob_node},
		interval = 5,
		chance = 1,
		action = function(pos)
		
			local meta = minetest.get_meta(pos)
			local hashlink = meta:get_string("creatures:hashlink")
			
			-- Check hash
			if hashlink == "" then return end
			
			-- If removed all objects
			check_cleaning_cycle(pos)
			
			-- Check
			if hash_tb[hashlink] 
				and hash_tb[hashlink]:get_pos()
				and creatures.get_dist_p1top2(pos, hash_tb[hashlink]:get_pos()) < 10 
				and node_way(self, pos, hash_tb[hashlink]:get_pos()) == true
			then
				return
			end
			
			-- Not found
			reset_mob_node(pos)
		end
	}
	
	
	-- LBM
	minetest.register_lbm({
		name = ":"..mob_node.."_load",
		nodenames = {mob_node},
		run_at_every_load = true,
		action = function(pos, node)
			
			local meta = minetest.get_meta(pos)
			local hashlink = meta:get_string("creatures:hashlink")
			
			-- Check hash
			if hashlink == "" then return end
			
			-- If removed all objects
			check_cleaning_cycle(pos)
		end,
	})
	
	
	-- Register 'on_die_mob' callback
	creatures.register_on_die_mob(mob_name, function(self, reason)
		if self.mob_node and self.mob_node.pos then
			reset_mob_node(self.mob_node.pos)
			self.mob_node = nil
		end
	end)
	
	
	-- Register 'get_staticdata'
	creatures.register_get_staticdata(mob_name, function(self)
		return {
			mob_node = self.mob_node
		}
		
	end)
	
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		self.mob_node = self.mob_node or {}
		
		if self.mob_node and self.mob_node.hashlink then
			hash_tb[self.mob_node.hashlink] = self.object
		end
		
		self.timers.mob_node = 0
		
	end)
	
	
	-- Register 'on_step'
	creatures.register_on_step(mob_name, function(self, dtime)
		
		-- Timer update
		self.timers.mob_node = self.timers.mob_node + dtime
		
		if self.timers.mob_node >= 5 then
			self.timers.mob_node = 0
			
			local me = self.object
			local my_pos = me:get_pos()
			
			
			-- If with mob node
			if self.mob_node.pos then
				
				-- Check mob node
				if check_mob_node(self) == true then
					
					-- Reset lifetime
					self.lifetimer = 0
					
					return
				
				-- Lose mob node
				else
					self.mob_node.pos = nil
					self.mob_node.hashlink = nil
				end
			
			
			-- If without mob node
			else
				-- Search MOB system
				if def.search_mob == true then
					-- Search a mob nodes
					for _,p in ipairs(minetest.find_nodes_in_area(vector.add(my_pos, 4), vector.subtract(my_pos, 4), {mob_node})) do
						if node_way(self, p) == true and vacant_mob_node(p) == true then
							-- Use this mob node
							set_mob_node(p, self)
							break
						end
					end
				end
			end 
			
		end
	end)
	
	-- Registered mob nodes
	creatures.registered_mob_nodes[mob_node] = def
end

-- Get mob node definitions
creatures.get_mob_node_def = function(node_name)
	return creatures.registered_mob_nodes[node_name]
end




