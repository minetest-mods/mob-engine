--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

hp.lua

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

-- Get max hp
creatures.max_hp = function(self)
	return (self.stats.hp or creatures.default_value.hp)
end

-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		-- Add everything we need as basis for the engine
		self.hp = self.hp or creatures.max_hp(self)
		
		-- Check Object hp
		self.object:set_hp(self.hp)
		
	end)
	
	
	-- Register 'get_staticdata'
	creatures.register_get_staticdata(mob_name, function(self)
		return {
			hp = self.object:get_hp(),
		}
	end)
end)

local function on_hit(me)
  core.after(0.1, function()
    me:settexturemod("^[colorize:#c4000099")
  end)
  core.after(0.5, function()
		me:settexturemod("")
	end)
end

-- On Damage
local function onDamage(self, hp)
	local me = self.object
	local def = core.registered_entities[self.mob_name]
	hp = hp or me:get_hp()

	if hp <= 0 then
		self.stunned = true
		creatures.kill_mob(self)
	else
		on_hit(me) -- red flashing
		if def.sounds and def.sounds.on_damage then
			local dmg_snd = def.sounds.on_damage
			core.sound_play(dmg_snd.name, {pos = me:getpos(), max_hear_distance = dmg_snd.distance or 5, gain = dmg_snd.gain or 1})
		end
	end
end


-- Change hp
function creatures.change_hp(self, value)
	local me = self.object
	local hp = me:get_hp()
	hp = hp + math.floor(value)
	me:set_hp(hp)
	if value < 0 then
		onDamage(self, hp)
	end
end

