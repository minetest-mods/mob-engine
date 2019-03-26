--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

follow_search.lua

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

local hasMoved = creatures.compare_pos

-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		-- Timer
		self.timers.follow_search = 0
		
	end)
	
	-- Register 'on_step'
	creatures.register_on_step(mob_name, function(self, dtime)
		
		-- Timer update
		self.timers.follow_search = self.timers.follow_search + dtime
		local modes = def.modes
		
		-- localize some things
		local modes = def.modes
		local current_mode = self.mode
		local me = self.object
		local current_pos = me:getpos()
		current_pos.y = current_pos.y + 0.5
		local moved = self.moved
		
		-- Search a target (1-2ms)
		if 
			-- if not target yet
			not self.target 
			-- and is a follower
			and modes.follow
			-- and not in "idle" mode
			and current_mode == "idle" 
		then
			
			-- if elapsed timer
			if self.timers.follow_search > (modes.follow.search_timer or 4) then
				self.timers.follow_search = 0
				
				-- if a target was found
				for _,target in ipairs(creatures.find_target(creatures.get_vision_pos(self), modes.follow.radius or 5, {
					search_type = "player",
					ignore_obj = {me}
				})) do
					
					-- change mode
					-- check target wielded item
					local name = target:get_wielded_item():get_name()
					if name and modes.follow.items[name] == true then
						self.target = target
						creatures.start_mode(self, "follow")
					end
				end
			end
		end
	end)
	
end)
