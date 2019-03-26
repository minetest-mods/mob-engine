--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

walk_around.lua

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


-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
	
		self.mdt.walk_around = 0
		self.walk_around_time = 0
	end)
	
end)


-- On finish path
local on_finish_path = function(self)
	-- Stop movement
	creatures.send_in_dir(self, 0, {x=0,z=0})
	-- Stop walk animation
	creatures.set_animation(self, "idle")
end


-- Walk Around mode ("walk_around")
creatures.register_mode("walk_around", {
	
	-- On start
	start = function(self)
		
		local mode_def = creatures.mode_def(self)
		
		self.mdt.walk_around = 0 
			
		local mob_def = creatures.mob_def(self)
		
		local me = self.object
		local current_pos = me:getpos()
		current_pos.y = current_pos.y + 0.5
		
		local nodes = creatures.get_under_walkable_nodes_in_area(
			{ -- min pos
				x = current_pos.x - 1,
				y = current_pos.y - math.floor(mob_def.stats.can_jump),
				z = current_pos.z - 1
			}, 
			{ -- max pos
				x = current_pos.x + 1,
				y = current_pos.y + math.floor(mob_def.stats.can_jump),
				z = current_pos.z + 1
			}
		)
		
		if table.maxn(nodes) > 1 then
			-- Walk 1 node in any direction
			local pos = creatures.get_random_from_table(nodes)
			local new_dir = creatures.get_dir_p1top2(current_pos, pos)
			
			if new_dir then
				creatures.set_dir(self, new_dir)
				
				self.walk_around_time = 1/mode_def.moving_speed
				
				-- Send
				creatures.send_in_dir(self, mode_def.moving_speed)
				creatures.set_animation(self, "walk")
				return
			end
		end
		
		-- Finish mode
		creatures.start_mode(self, "idle")
	end,
	
	-- On step
	on_step = function(self, dtime)
		
		self.mdt.walk_around = self.mdt.walk_around + dtime
		
		if self.mdt.walk_around > self.walk_around_time then
			self.mdt.walk_around = 0
			
			-- reset time
			self.walk_around_time = 0
			
			-- Finish mode
			creatures.start_mode(self, "idle")
		end
		
	end,
	
})


