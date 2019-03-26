--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

enemy_search.lua

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
		
		-- Timer
		self.timers.search_enemy = 0
		
	end)
	
	-- Register 'on_step'
	creatures.register_on_step(mob_name, function(self, dtime)
		
		-- Timer update
		self.timers.search_enemy = self.timers.search_enemy + dtime
		
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
			-- and is a hostile
			and (self.hostile and def.combat.search_enemy)
			-- and not in "panic" mode
			and current_mode ~= "panic" 
		then
			
			-- if elapsed timer
			if self.timers.search_enemy > (def.combat.search_timer or 2) then
				
				-- reset timer
				self.timers.search_enemy = 0
				
				-- targets list
				local targets = creatures.find_target(creatures.get_vision_pos(self), def.combat.search_radius, {
					search_type = def.combat.search_type, 
					mob_name = def.combat.search_name, 
					xray = def.combat.search_xray,
					ignore_obj = {me},
				})
				
				-- choose a random target
				if #targets > 1 then
					self.target = targets[rnd(1, #targets)]
				elseif #targets == 1 then
					self.target = targets[1]
				end
				
				-- if a target was found
				if self.target then
					
					-- change mode
					creatures.start_mode(self, "attack")
				end
			end
		end
	end)
	
end)
