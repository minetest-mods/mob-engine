--[[
= Chicken for Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

egg.lua

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



local function timer(step, entity)
	if not entity then
		return
	end

	if entity.physical_state == false then
		if entity.ref then
			if math.random(1, 20) == 5 then
				core.add_entity(entity.ref:getpos(), "chicken:chicken")
			end
			entity.ref:remove()
		end
	else
		core.after(step, timer, step, entity)
	end
end

function throw_egg(player, strength)
	local pos = player:getpos()
	pos.y = pos.y + 1.5
	local dir = player:get_look_dir()
	pos.x = pos.x + dir.x
	pos.z = pos.z + dir.z
	local obj = minetest.add_item(pos, "chicken:egg")
	if obj then
		local entity = obj:get_luaentity()
		entity.ref = obj
		entity.mergeable = false
		obj:setvelocity({x = dir.x * strength, y = -3, z = dir.z * strength})
		obj:setacceleration({x = dir.x * -5 + dir.y, y = -13, z = dir.z * -5 + dir.y})
		timer(0.1, entity)
		return true
	end
	return false
end

core.register_craftitem("chicken:egg", {
	description = "Egg",
	inventory_image = "chicken_egg.png",
	on_use = function(itemstack, user, pointed_thing)
		if throw_egg(user, 12) then
			itemstack:take_item()
		end
		return itemstack
	end,
})

core.register_craftitem("chicken:fried_egg", {
	description = "Fried Egg",
	inventory_image = "chicken_fried_egg.png",
	on_use = core.item_eat(2)
})

core.register_craft({
	type = "cooking",
	output = "chicken:fried_egg",
	recipe = "chicken:egg",
})


local on_finish_path = function(self)
	-- Stop movement
	creatures.send_in_dir(self, 0, {x=0,z=0})
	-- Stop walk animation
	creatures.set_animation(self, "idle")
	
	-- Restart mode
	creatures.start_mode(self, "chicken:dropegg")
end

local on_interrupt_path = function(self)
	-- Stop movement
	creatures.send_in_dir(self, 0, {x=0,z=0})
	-- Stop walk animation
	creatures.set_animation(self, "idle")
	
	-- Finish mode
	creatures.start_mode(self, "idle")
end

-- Drop Egg mode ("dropegg")
creatures.register_mode("chicken:dropegg", {
	
	-- On step
	start = function(self, dtime)
		
		-- Last day when dropped egg
		self["chicken:last_dropday"] = self["chicken:last_dropday"] or 0
		
		-- Today
		local today = core.get_day_count()
		
		-- Check if drop egg today
		if self["chicken:last_dropday"] ~= today and creatures.check_mob_node(self) == true then
			
			local walk_mode = creatures.mode_def(self, "walk")
			local current_pos = self.object:get_pos()
			
			local pmn = creatures.copy_tb(self.mob_node.pos)
			pmn.y = pmn.y - 0.4
			
			-- Check if is in the nest
			local d, vd = creatures.get_dist_p1top2(current_pos, pmn)
			if math.abs(vd.x) < 0.25 and math.abs(vd.z) < 0.25 then
				
				-- Drop Egg
				local ps = creatures.copy_tb(self.mob_node.pos)
				ps.y = ps.y - 0.3
				core.add_item(ps, "chicken:egg")
				self["chicken:last_dropday"] = today
				
				-- Move chicken to nest center
				ps.y = ps.y - 0.18
				self.object:set_pos(ps)
				
				-- Finish mode
				creatures.start_mode(self, "idle")
				
			-- Go to nest
			else
			
				-- Walk to nest
				if creatures.new_path( -- Try find path
					self, 
					self.mob_node.pos, 
					walk_mode.moving_speed,
					on_finish_path,
					on_interrupt_path,
					{
						target_dist = 0.2,
					}
				) == true then
					
					-- Start walk animation
					creatures.set_animation(self, "walk")
				else
				
					-- Finish mode
					creatures.start_mode(self, "idle")
				end
				
			end
		end
	end,
	
	-- On step
	on_step = function(self, dtime)
	
		creatures.path_step(self, dtime)
		
	end,
})

