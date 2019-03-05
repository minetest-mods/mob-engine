--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

swim.lua

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

local changeHP = creatures.change_hp

-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		self.can_swim = def.stats.can_swim
		
		-- Timers
		self.timers.swim = 0
		self.timers.drown = 0
	end)
	
	-- Register 'on_step'
	creatures.register_on_step(mob_name, function(self, dtime)
		
		local me = self.object
		
		-- Remove gravity when in water
		if self.in_water then
			
			self.physic.gravity = false
			-- Update physic
			creatures.update_physic(self)
			-- Update acceleration in water
			me:setacceleration({x = 0, y = -1.2, z = 0})
		end
		
		-- Timer updates
		self.timers.swim = self.timers.swim + dtime
		self.timers.drown = self.timers.drown + dtime
		
		-- Check swim
		if self.timers.swim > 0.4 then
		
			self.timers.swim = 0
			
			-- Check if in water
			if self.last_node.name == "default:water_source" then
				self.in_water = true
			else
				self.in_water = false
			end
			
			
			-- In water
			if self.in_water == true then
				
				-- Reduce breath
				self.breath = self.breath - 1
				if self.breath < 0 then
					self.breath = 0
				end
				
				-- Swin
				local vel = me:getvelocity()
				creatures.velocity_add(self, {x = 0, y = 0.6, z = 0})
				
				-- play swimming sounds
				if def.sounds and def.sounds.swim then
					local swim_snd = def.sounds.swim
					core.sound_play(swim_snd.name, {pos = current_pos, gain = swim_snd.gain or 1, max_hear_distance = swim_snd.distance or 10})
				end
				creatures.spawn_particles(current_pos, vel, "bubble.png")
			
			-- Out of water
			else
				
				-- Reestore breath
				self.breath = self.breath + 3
				local max_breath = creatures.max_breath(self)
				if self.breath > max_breath then
					self.breath = max_breath
				end
			end
		end
		
		-- Add damage when drowning
		if self.env_damage and self.timers.drown > 1 and self.last_node then
			self.timers.drown = 0
			
			if self.breath <= 0 then
				changeHP(self, -1)
			end
		end
	end)
	
end)
