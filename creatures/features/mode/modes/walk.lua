--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

walk.lua

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

-- Walk mode ("walk")
creatures.register_mode("walk", {
	
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
	end,
})


