--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
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


-- Check mob_node at pos
local check_node = function(pos)
	local node = creatures.get_far_node(pos)
	if not creatures.registered_mob_nodes[node.name] then
		return false
	end
	return true
end


-- Set mob in node
local set_mob_node = function(pos, ent)
	if check_node(pos) == false then 
		return 
	end
	
	local meta = minetest.get_meta(pos)
	
	-- Hash link of occupation
	local hashlink = tostring(ent.object)
	
	ent.mob_node.hashlink = hashlink
	ent.mob_node.pos = {
		x = creatures.int(pos.x),
		y = creatures.int(pos.y),
		z = creatures.int(pos.z)
	}
	
	meta:set_string("creatures:hashlink", hashlink)
	local def = creatures.get_mob_node_def(minetest.get_node(pos).name)
	if def.on_set_mob_node then
		def.on_set_mob_node(pos, ent)
	end
end


-- Reset mob node
local reset_mob_node = function(pos)
	if check_node(pos) == false then return end
	
	local meta = minetest.get_meta(pos)
	
	meta:set_string("creatures:hashlink", "")
	
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


-- Save MOB
local save_mob = function(self)
	
	-- Check mob node
	if self.mob_node.pos then
		
		-- Check way
		if node_way(self) == false then return end
		
		-- Check distance
		local d, v = creatures.get_dist_p1top2(self.object:get_pos(), self.mob_node.pos)
		if v.x < 5 or v.y < 5 or v.z < 5 then
			
			-- Save in the mob node
			local meta = minetest.get_meta(self.mob_node.pos)
			meta:set_string("creatures:saved_mob", "true")
			meta:set_string("creatures:saved_mob_pos", minetest.serialize(self.object:get_pos()))
			
			-- Mark to remove object when load
			self.remove = true
			self.object:remove()
		end
	end
	
end


-- Load MOB
local load_mob = function(pos)
	local meta = minetest.get_meta(pos)
	
	-- MOB node definitions
	local def = creatures.get_mob_node_def(minetest.get_node(pos).name)
	
	-- Spawn MOB
	local obj = core.add_entity(pos, def.mob_name)
	local ent = obj:get_luaentity()
	
	-- Move to last pos
	if meta:get_string("creatures:saved_mob_pos") ~= "" then
		local p = minetest.deserialize(meta:get_string("creatures:saved_mob_pos"))
		
		if node_way(ent, p) == true then
			obj:set_pos(p)
		end
	end
	
	-- Setup MOB
	ent.mob_node.pos = creatures.copy_tb(pos)
	ent.mob_node.hashlink = meta:get_string("creatures:hashlink")
	
	-- Clear node metadata
	meta:set_string("creatures:saved_mob_pos", "")
	meta:set_string("creatures:saved_mob", "")
	
	return
	
end

-- Checkk vacant mob node
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
check_mob_node = creatures.check_mob_node

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
			
			-- Search MOBs
			for _,obj in ipairs(creatures.find_target(
				pos, 
				4, 
				{
					search_type = "mate",
					mob_name = mob_name,
					xray = true,
				})
			) do
				-- Check if is the same hashlink
				if obj:get_luaentity().mob_node.hashlink == hashlink then
					return
				end
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
			
			-- If inside
			if meta:get_string("creatures:saved_mob") == "true" then
				load_mob(pos)
			end
		end,
	})
	
	
	-- Register 'get_staticdata'
	creatures.register_get_staticdata(mob_name, function(self)
		
		save_mob(self)
		
		return {
			mob_node = self.mob_node
		}
		
	end)
	
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		self.mob_node = self.mob_node or {}
		
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
				if creatures.check_mob_node(self) == true then
					
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
	
	-- Register 'on_clear_objects'
	creatures.register_on_clear_objects(mob_name, function(self) 
		if check_mob_node(self) == true then
			save_mob(self)
		end
	end)
	
	-- Registered mob nodes
	creatures.registered_mob_nodes[mob_node] = def
end

-- Get mob node definitions
creatures.get_mob_node_def = function(node_name)
	return creatures.registered_mob_nodes[node_name]
end




