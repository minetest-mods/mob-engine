--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

death_effects.lua

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
	
	-- Register 'on_die_mob'
	creatures.register_on_die_mob(mob_name, function(self, reason)
		
		local mob_def = creatures.mob_def(self)
		
		-- Mark died MOB
		self.is_died = true
		
		-- Mark to remove
		self.remove = true
		
		-- Physic
		self.object:set_properties({collisionbox = {0,0,0, 0,0,0}})
		
		-- Sound
		if mob_def.sounds and mob_def.sounds.on_death then
			local death_snd = mob_def.sounds.on_death
			core.sound_play(death_snd.name, {
				pos = self.object:getpos(), 
				max_hear_distance = death_snd.distance or 5, 
				gain = death_snd.gain or 1
			})
		end
		
		-- Animation
		if mob_def.model.animations.death then
		
			creatures.set_animation(self, "death")
			
			local duration = mob_def.model.animations.death.duration or 0.5
			core.after(duration, function()
				self.object:remove()
			end)
			
		else
			self.object:remove()
		end
	end)
	
	-- 'on_step' callback
	creatures.register_on_step(mob_name, function(self, dtime)
		-- Check if is alive
		if self.is_died == true then
			return true
		end
	end)
	
	-- 'on_rightclick' callback
	creatures.register_on_rightclick(mob_name, function(self, clicker)
		-- Check if is alive
		if self.is_died == true then
			return true
		end
	end)
	
	-- 'on_punch' callback
	creatures.register_on_punch(mob_name, function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		-- Check if is alive
		if self.is_died == true then
			return true
		end
	end)
end)
