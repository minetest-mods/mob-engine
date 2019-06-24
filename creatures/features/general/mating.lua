--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

mating.lua

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

-- Check if is fertile
local is_fertile = function(self)
	local def = creatures.mob_def(self)
	
	-- Check fertile
	if (not def.mating) or self.mating_last_day + def.mating.interval > minetest.get_day_count()  then return false end
	
	-- Check spawn for child
	-- Spawn type : "mob_node"
	if def.mating.spawn_type == "mob_node" then
		-- Has a mob node
		if creatures.check_mob_node(self) == false then
			return false
		end
		-- Spawn pos is empty
		if creatures.check_mob_in_pos(self, self.mob_node.pos) ~= true then
			return false
		end
	end
	
	return true
end


-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	if not def.mating then return end
	
	-- Check MOB child name
	if def.mating.child_mob == nil then
		def.mating.child_mob = def.child.name
	end
	
	-- Register 'get_staticdata'
	creatures.register_get_staticdata(mob_name, function(self)
		
		return {
			mating_last_day = self.mating_last_day,
		}
		
	end)
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		self.mating_last_day = self.mating_last_day or minetest.get_day_count()
		
		self.timers.mating = 0
		
	end)
	
	-- Register 'on_step'
	creatures.register_on_step(mob_name, function(self, dtime)
		
		-- Timer update
		self.timers.mating = self.timers.mating + dtime
		
		if self.timers.mating >= 25 then
			self.timers.mating = 0
			
			local me = self.object
			local my_pos = me:get_pos()
			
			-- Check if interval is elapsed
			if is_fertile(self) == false then 
				return 
			end
			
			-- Search another MOB to mating
			local mobs = creatures.find_target(self.object:get_pos(), 6, 
				{
					xray = false, 
					no_count = false, 
					search_type = "mate", 
					mob_name = mob_name, 
				}
			)
			
			-- Check MOBs
			local fertile_mobs = {}
			for _,obj in ipairs(mobs) do
				if is_fertile(obj:get_luaentity()) then
					table.insert(fertile_mobs, obj:get_luaentity())
				end
			end
			
			if table.maxn(fertile_mobs) > 2 then
				-- Random number of childs for spawn
				local c = math.ceil((table.maxn(fertile_mobs)/2)*0.3)
				while c > 0 do
					-- Spawn
					minetest.add_entity(fertile_mobs[c].mob_node.pos, def.mating.child_mob)
					c = c - 1
				end
				for _,entity in ipairs(fertile_mobs) do
					entity.mating_last_day = minetest.get_day_count()
				end
			end
			
		end
	end)
	
end)
