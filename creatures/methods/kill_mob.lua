--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

kill_mob.lua

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

-- Update animation
local function update_animation(obj_ref, mode, anim_def)
	if anim_def and obj_ref then
		obj_ref:set_animation({x = anim_def.start, y = anim_def.stop}, anim_def.speed, 0, anim_def.loop)
	end
end


-- Kill a Mob
function creatures.kill_mob(self)
	if not self then return end
	
	local def = creatures.get_def(self)
	local me = self.object
	
	local pos = me:getpos()
	me:setvelocity({x=0,z=0,y=0})
	me:set_properties({collisionbox = nullVec})
	me:set_hp(0)

	if def.sounds and def.sounds.on_death then
		local death_snd = def.sounds.on_death
		core.sound_play(death_snd.name, {pos = pos, max_hear_distance = death_snd.distance or 5, gain = death_snd.gain or 1})
	end

	if def.model.animations.death then
		local dur = def.model.animations.death.duration or 0.5
		update_animation(me, "death", def.model.animations["death"])
		core.after(dur, function()
		me:remove()
		end)
	else
		me:remove()
	end
	if def.drops then
		if type(def.drops) == "function" then
			def.drops(me:get_luaentity())
		else
			creatures.drop_items(pos, def.drops)
		end
	end
	
	return true
end

