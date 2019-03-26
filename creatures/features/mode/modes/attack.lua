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

-- Follow path timer
local follow_path_time = 2.5

-- Follow time
local follow_time = 0.5


-- On finish path
local on_finish_path = function(self)
	self.mdt.follow_path = follow_path_time
	
	-- Stop movement
	creatures.send_in_dir(self, 0, {x=0,y=0,z=0}, self.can_fly)
	creatures.set_animation(self, "idle")
end


-- Rotate to target
local rotate_to_target = function(self, current_pos, target_pos)
	-- Rotate
	local new_dir = creatures.get_dir_p1top2(current_pos, target_pos, self.can_fly)
	if new_dir then
		creatures.set_dir(self, new_dir)
	end
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
		
		-- Ready for start a path
		self.mdt.follow_path = follow_path_time
	end,
	
	-- On step
	on_step = function(self, dtime)
		
		creatures.path_step(self, dtime)
		
		-- localize some things
		local def = creatures.registered_mobs[self.mob_name]
		local modes = def.modes
		local current_mode = self.mode
		local me = self.object
		local current_pos = me:get_pos()
		current_pos.y = current_pos.y + 0.5
		local moved = self.moved
		
		-- Timer updates
		self.mdt.follow = (self.mdt.follow or 0) + dtime
		self.mdt.attack = (self.mdt.attack or 0) + dtime
		self.mdt.follow_path = (self.mdt.follow_path or 0) + dtime
		
		-- Check target
		if not self.target then
			creatures.start_mode(self, "idle")
			return
		end
		
		-- Check if can punch now
		if self.mdt.attack > def.combat.attack_speed then
			
			-- Target values
			local target_pos = self.target:get_pos()
			local dist = creatures.get_dist_p1top2(current_pos, target_pos)
			
			if dist < def.combat.attack_radius -- Check attack distance
				and core.line_of_sight(current_pos, target_pos) == true -- Check line of sight
			then
				-- Stop movement
				creatures.send_in_dir(self, 0, {x=0,y=0,z=0}, self.can_fly)
				creatures.set_animation(self, "attack")
				
				-- Rotate
				rotate_to_target(self, current_pos, target_pos)
				
				-- Delay for follow
				self.mdt.follow = follow_time - def.combat.attack_speed
				
				-- Attack
				self.mdt.attack = 0
				self.target:punch(me, 1.0,  {
					full_punch_interval = def.combat.attack_speed,
					damage_groups = {fleshy = def.combat.attack_damage}
				})
			end
			
		end
		
		-- Follow target
		if self.mdt.follow > follow_time then
			self.mdt.follow = 0
			
			-- Target values
			local target_pos = self.target:getpos()
			local dist = creatures.get_dist_p1top2(current_pos, target_pos)
			
			local def_mode = creatures.mode_def(self)
			
			-- Check if target is too far
			if dist > def.combat.search_radius then
				creatures.start_mode(self, "idle")
				return
				
			else
				
				if self.can_fly ~= true then
					
					if self.mdt.follow_path > follow_path_time then
						self.mdt.follow_path = 0
						
						-- New path
						if creatures.new_path(
							self, 
							creatures.get_node_pos_object(self.target), 
							def_mode.moving_speed,
							on_finish_path,
							on_finish_path
						) == true then
							
							-- Start attack/walk animation
							creatures.mode_animation_update(self)
						else
							-- Wait
							creatures.send_in_dir(self, 0, {x=0,y=0,z=0}, self.can_fly)
							creatures.set_animation(self, "idle")
						end
					end
				
				-- Flying
				else
					
					-- Rotate
					rotate_to_target(self, current_pos, target_pos)
					creatures.send_in_dir(self, def_mode.moving_speed, self.dir, self.can_fly)
					
				end
			end
			
		end
	end,
})

creatures.register_on_hitted(function(self, puncher, time_from_last_punch, tool_capabilities, dir)

	if self.hostile == true then
		
		-- change mode
		self.target = puncher
		creatures.start_mode(self, "attack")
	end
end)


