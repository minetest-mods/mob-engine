--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

random_sounds.lua

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
		
		-- Timers
		self.soundtimer = math.random()
	end)
	
	-- 'on_step' callback
	creatures.register_on_step(mob_name, function(self, dtime)
		
		local def = core.registered_entities[self.mob_name]
		
		-- Timer updates
		self.soundtimer = self.soundtimer + dtime
		
		-- localize some things
		local current_mode = self.mode
		if current_mode == "" then current_mode = "idle" end
		local me = self.object
		local current_pos = me:getpos()
		current_pos.y = current_pos.y + 0.5
		
		
		-- Random sounds
		if def.sounds and def.sounds.random[current_mode] then
			local rnd_sound = def.sounds.random[current_mode]
			if not self.snd_rnd_time then
				self.snd_rnd_time = math.random((rnd_sound.time_min or 5), (rnd_sound.time_max or 35))
			end
			if rnd_sound and self.soundtimer > self.snd_rnd_time + math.random() then
				self.soundtimer = 0
				self.snd_rnd_time = nil
				core.sound_play(rnd_sound.name, {pos = current_pos, gain = rnd_sound.gain or 1, max_hear_distance = rnd_sound.distance or 30})
			end
		end
	end)
	
	-- Register 'get_staticdata'
	creatures.register_get_staticdata(mob_name, function(self)
		return {
			soundtimer = self.soundtimer,
		}
	end)
end)
