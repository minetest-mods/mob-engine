--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

knockback.lua

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


-- Localizations
local rnd = math.random


-- Knockback
function creatures.knockback(selfOrObject, dir, old_dir, strengh)
	local object = selfOrObject
	if selfOrObject.mob_name then
		object = selfOrObject.object
	end
	local current_fmd = object:get_properties().automatic_face_movement_dir or 0
	object:set_properties({automatic_face_movement_dir = false})
	object:setvelocity(vector.add(old_dir, {x = dir.x * strengh, y = 3.5, z = dir.z * strengh}))
	old_dir.y = 0
	core.after(0.4, function()
		object:set_properties({automatic_face_movement_dir = current_fmd})
		object:setvelocity(old_dir)
		selfOrObject.falltimer = nil
		if selfOrObject.stunned == true then
			selfOrObject.stunned = false
		end
	end)
end

creatures.register_on_hitted(function(self, puncher, time_from_last_punch, tool_capabilities, dir)

	if self.has_kockback == true then
	
		local v = self.object:getvelocity()
		v.y = 0
		if not self.can_fly then
			self.object:setacceleration({x = 0, y = -15, z = 0})
		end
		creatures.knockback(self, dir, v, 5)
		self.stunned = true
	end
end)

-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
	
		self.has_kockback = def.stats.has_kockback
		self.stunned = false -- if knocked back or hit do nothing else
		
	end)
	
end)

