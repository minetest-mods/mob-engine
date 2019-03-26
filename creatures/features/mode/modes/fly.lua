--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

fly.lua

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

-- Fly mode ("fly")
creatures.register_mode("fly", {
	
	-- On start
	start = function(self)
		
		self.mdt.fly = 0
		self.fly_time = 0
		
		local mode_def = creatures.mode_def(self)
		local mob_def = creatures.get_def(self)
		
		local me = self.object
		local current_pos = me:getpos()
		
		local nodes = core.find_nodes_in_area(
			vector.add(current_pos, 1), 
			vector.subtract(current_pos, 1),
			{"air"}
		)
		
		-- Select a random dir
		if table.maxn(nodes) > 1 then
			-- Fly 1 node in any direction
			local pos = creatures.get_random_from_table(nodes)
			local new_dir = creatures.get_dir_p1top2(current_pos, pos, true)
			
			if new_dir then
				creatures.set_dir(self, new_dir)
				
				self.fly_time = 1/mode_def.moving_speed
				
				-- Send
				creatures.send_in_dir(self, mode_def.moving_speed, self.dir, true)
				creatures.set_animation(self, "fly")
				return
			end
		end
		
	end,
	
	-- On step
	on_step = function(self, dtime)
		
		self.mdt.fly = self.mdt.fly + dtime
		
		if self.mdt.fly > self.fly_time then
			-- Stop movement
			creatures.send_in_dir(self, 0, {x=0,y=0,z=0}, true)
			-- Stop fly animation
			creatures.set_animation(self, "idle")
		end
		
	end,
})


