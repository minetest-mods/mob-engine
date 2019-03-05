--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

panic.lua

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
	
	-- Insert special mode "panic" which is used when in panic
	if def.stats.can_panic and def.modes.walk then
		
		-- Mode
		local panic_mode = table.copy(def.modes["walk"])
		panic_mode.chance = 0
		panic_mode.duration = 3
		panic_mode.moving_speed = panic_mode.moving_speed * 2
		if def.modes.panic and def.modes.panic.moving_speed then
			panic_mode.moving_speed = def.modes.panic.moving_speed
		end
		panic_mode.update_yaw = 0.7
		def.modes["panic"] = panic_mode
		
		-- Animation 
		local panic_anim = def.model.animations.panic
		if not panic_anim then
			panic_anim = table.copy(def.model.animations.walk)
			panic_anim.speed = panic_anim.speed * 2
		end
		def.model.animations.panic = panic_anim
		
	end
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		self.can_panic = def.stats.can_panic == true and def.modes.walk ~= nil
	end)
	
end)


-- Panic mode ("panic")
creatures.register_mode("panic", {
	
	-- On start
	start = function(self)
		
		-- Reset timer
		self.timers.yaw = 0
		
		-- Random dir
		creatures.set_dir(self, creatures.get_random_dir())
		
		-- Update mode settings
		creatures.mode_velocity_update(self)
		creatures.mode_animation_update(self)
	end,
	
	-- On step
	on_step = function(self, dtime)
		
		local r = creatures.random_yaw_step(self, dtime)
		if r == true then
			creatures.mode_velocity_update(self)
		end
	end,
})


-- For when attacked
creatures.register_on_hitted(function(self, puncher, time_from_last_punch, tool_capabilities, dir)
	if self.hostile ~= true then
		-- change mode
		creatures.start_mode(self, "panic")
	end
end)

