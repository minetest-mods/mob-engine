--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
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


-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Check 'makes_footstep_sound' param
	if def.stats.can_fly ~= true then
		def.ent_def.makes_footstep_sound = true
	end
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		local def = creatures.registered_mobs[self.mob_name]
		
		-- Settings
		self.can_fly = def.stats.can_fly
		
		-- Check gravity
		if self.can_fly then
			self.physic.gravity = false
		end
		
		-- Update physic
		creatures.update_physic(self)
	end)
end)


