--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

random_yaw.lua

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

-- Check random yaw
creatures.random_yaw_step = function(self, dtime)
	
	-- MOB type settings
	local def = creatures.get_def(self)
	
	-- Timer updates
	self.timers.yaw = self.timers.yaw + dtime
		
	if self.timers.yaw >= def.modes[self.mode].update_yaw then
		local tl = def.modes[self.mode].update_yaw
		self.timers.yaw = math.random(tl/3, tl)
		
		-- Random dir
		creatures.set_dir(self, creatures.get_random_dir())
		return true
	end
	return false
end

-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		-- Timers
		self.timers.yaw = 0
		
	end)
	
end)
