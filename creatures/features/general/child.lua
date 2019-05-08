--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

child.lua

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

-- Merge tables
local merge_tb = function(tb, new_tb)
	if not tb then return end
	for index,new_value in pairs(new_tb) do
		tb[index] = new_value
	end
	return tb
end


-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	if not def.child then return end
	
	local child_def = def.child
	creatures.register_mob(def.child.name, {
	
		stats = merge_tb(def.stats , child_def.stats or {}),
		hunger = merge_tb(def.hunger, child_def.hunger or {}),
		modes = merge_tb(def.modes, child_def.modes or {}),
		model = merge_tb(def.model, child_def.model or {}),
		sounds = merge_tb(def.sounds, child_def.sounds or {}),
		drops = child_def.drops or def.drops,
		
		-- Callbacks
		get_staticdata = child_def.get_staticdata or def.get_staticdata,
		on_activate = child_def.on_activate or def.on_activate,
		on_rightclick = child_def.on_rightclick or def.on_rightclick,
		on_step = child_def.on_step or def.on_step,
		on_punch = child_def.on_punch or def.on_punch,
		on_rightclick = child_def.on_rightclick or def.on_rightclick,
		randomize = child_def.randomize or def.randomize,
		
		-- Optional
		spawning = child_def.spawning,
	})
	
	-- Register 'on_activate'
	creatures.register_on_activate(def.child.name, function(self, staticdata)
		self.child_birth_day = self.child_birth_day or minetest.get_day_count()
		self.is_child = true
		self.timers.child_grow = 0
	end)
	
	-- Register 'get_staticdata'
	creatures.register_get_staticdata(def.child.name, function(self)
		return {
			is_child = self.is_child,
			child_birth_day = self.child_birth_day,
		}
	end)
	
	-- Register 'on_grow'
	if def.child.on_grow then
		creatures.register_on_grow(def.child.name, def.child.on_grow)
	end
	
	-- Register 'on_step'
	creatures.register_on_step(def.child.name, function(self, dtime)
		-- Timer update
		self.timers.child_grow = self.timers.child_grow + dtime
		
		if self.timers.child_grow >= 3 then
			self.timers.child_grow = 0
			
			if self.child_birth_day + def.child.days_to_grow >= minetest.get_day_count() then return end
			
			-- Spawn new MOB
			local p = self.object:get_pos()
			local new_obj = minetest.add_entity(p, mob_name)
			local new_self = new_obj:get_luaentity()
			creatures.set_dir(new_self, self.dir)
			new_self.is_child = true
			
			-- Run callback 'on_grow'
			creatures.on_grow(self.mob_name, self, new_self)
			
			-- Remove old MOB
			self.object:remove()
			
			return true
		end
	end)
	
end)

-- Register 'on_grow'
creatures.register_on_grow = function(mob_name, func)
	-- Check 'on_grow'
	if creatures.registered_mobs[mob_name].on_grow_table == nil then
		creatures.registered_mobs[mob_name].on_grow_table = {}
	end
	
	table.insert(creatures.registered_mobs[mob_name].on_grow_table, func)
end

-- Execute 'on_grow'
creatures.on_grow = function(mob_name, self, new_self)

	-- Check 'on_grow'
	if creatures.registered_mobs[mob_name].on_grow_table == nil then
		creatures.registered_mobs[mob_name].on_grow_table = {}
	end
	
	-- Run registered 'on_grow'
	for _,f in ipairs(creatures.registered_mobs[mob_name].on_grow_table) do
		local r = f(self, new_self)
		if r == true then
			return r
		end
	end
end
