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
			if selfOrObject.can_panic == true then
				selfOrObject.target = nil
				selfOrObject.mode = "_run"
				selfOrObject.modetimer = 0
			end
		end
	end)
end

