--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

physic.lua

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

-- Update physic
creatures.update_physic = function(self)
	
	-- Gravity
	if self.physic.gravity == true then
		self.object:setacceleration({x = 0, y = -15, z = 0})
	else
		self.object:setacceleration({x = 0, y = 0, z = 0})
	end
end


-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Entity definitions
	def.ent_def.stepheight = 0.6 -- ensure we get over slabs/stairs
	def.ent_def.collisionbox = def.model.collisionbox or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	def.ent_def.collide_with_objects = def.model.collide_with_objects or true
	def.ent_def.physical = true
	
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		-- Physic parameters
		self.physic = {}
		self.physic.gravity = true
		
		creatures.update_physic(self)
	end)
end)


