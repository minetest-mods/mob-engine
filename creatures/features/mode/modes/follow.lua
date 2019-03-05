--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

follow.lua

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


-- Follow mode ("follow")
creatures.register_mode("follow", {

	-- On start
	start = function(self)
		
		-- Timer
		self.mdt.follow = 0
		
	end,
	
	-- On step
	on_step = function(self, dtime)
		
		-- localize some things
		local def = creatures.registered_mobs[self.mob_name]
		local modes = def.modes
		local current_mode = self.mode
		local me = self.object
		local current_pos = me:getpos()
		current_pos.y = current_pos.y + 0.5
		local moved = self.moved
		
		-- Timer update
		self.mdt.follow = self.mdt.follow + dtime
		
		-- Check target
		if not self.target then
			self.mode = ""
			return
		end
		
		if self.followtimer > 0.6 then
			self.mdt.follow = 0
			
			-- Target values
			local p2 = self.target:getpos()
			local dir = creatures.get_dir_p1top2(current_pos, p2)
			
			local offset
			if self.can_fly then
				offset = modes["fly"].target_offset
			end
			
			local dist = getDistance(dir, offset)
			
			-- Max distance radius for have a target
			local radius = modes["follow"].radius
			
			-- Check if target is too far
			if dist == -1 or dist > (radius or 5) then
				self.target = nil
				current_mode = ""
				return
			end
			
			-- Walk or run to the target
				
			-- vector adjustment
			self.dir = vector.normalize(dir)
			creatures.set_dir(self, self.dir)
			if self.in_water then
				self.dir.y = me:getvelocity().y
			end
		end
		
		self.mode = current_mode
	end,
})


