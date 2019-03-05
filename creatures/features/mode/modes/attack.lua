--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

attack.lua

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

-- Get discance
local function getDistance(vec, fly_offset)
	if not vec then
		return -1
	end
	if fly_offset then
		vec.y = vec.y + fly_offset
	end
	return math.sqrt((vec.x)^2 + (vec.y)^2 + (vec.z)^2)
end

-- Attack mode ("attack")
creatures.register_mode("attack", {
	
	-- On start
	start = function(self)
		
		-- Random dir
		creatures.set_dir(self, creatures.get_random_dir())
		
		-- Update mode settings
		creatures.mode_velocity_update(self)
		creatures.mode_animation_update(self)
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
		
		-- Timer updates
		self.mdt.follow = (self.mdt.follow or 0) + dtime
		self.mdt.attack = (self.mdt.attack or 0) + dtime
		
		-- Check target
		if not self.target then
			self.mode = ""
			return
		end
		
		if self.mdt.follow > 0.6 then
			self.mdt.follow = 0
			
			-- Target values
			local p2 = self.target:getpos()
			
			local offset
			if self.can_fly then
				offset = modes["fly"].target_offset
			end
			
			local dist = creatures.get_dist_p1top2(current_pos, p2)
			
			-- Max distance radius for have a target
			local radius = def.combat.search_radius
			
			-- Check if target is too far
			if dist == -1 or dist > (radius or 5) then
				self.target = nil
				current_mode = ""
			
			-- Check if can punch the target
			elseif dist > -1
				and dist < def.combat.attack_radius -- minimun distance to attack
				and self.mdt.attack > def.combat.attack_speed -- check attack time
			then 
				self.mdt.attack = 0
					
				-- Check if target is in line of sight
				if core.line_of_sight(current_pos, p2) == true then
					self.target:punch(me, 1.0,  {
						full_punch_interval = def.combat.attack_speed,
						damage_groups = {fleshy = def.combat.attack_damage}
					})
				end
			end
			
			-- Direction adjustment
			creatures.set_dir(self, creatures.get_dir_p1top2(current_pos, p2))
			-- Update velocity
			creatures.mode_velocity_update(self)
			
		end
		
		self.mode = current_mode
	end,
})

creatures.register_on_hitted(function(self, puncher, time_from_last_punch, tool_capabilities, dir)
	if self.hostile == true then
		-- change mode
		self.target = puncher
		creatures.start_mode(self, "attack")
	end
end)


