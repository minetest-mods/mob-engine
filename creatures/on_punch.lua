--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

on_punch.lua

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


-- Add Wear out
local tool_uses = {0, 30, 110, 150, 280, 300, 500, 1000}
local function addWearout(player, tool_def)
	if not minetest.settings:get_bool("creative_mode") then
		local item = player:get_wielded_item()
		if tool_def and tool_def.damage_groups and tool_def.damage_groups.fleshy then
			local uses = tool_uses[tool_def.damage_groups.fleshy] or 0
			if uses > 0 then
				local wear = 65535/uses
				item:add_wear(wear)
				player:set_wielded_item(item)
			end
		end
	end
end


-- Limit
local function limit(value, min, max)
	if value < min then
		return min
	end
	if value > max then
		return max
	end
	return value
end


-- Calcule Punch Damage
local function calcPunchDamage(obj, actual_interval, tool_caps)
	local damage = 0
	if not tool_caps or not actual_interval then
		return 0
	end
	local my_armor = obj:get_armor_groups() or {}
	for group,_ in pairs(tool_caps.damage_groups) do
		damage = damage + (tool_caps.damage_groups[group] or 0) * limit(actual_interval / tool_caps.full_punch_interval, 0.0, 1.0) * ((my_armor[group] or 0) / 100.0)
	end
	return damage or 0
end


-- On Punch
creatures.on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
	if self.stunned == true then
		return
	end

	local me = self.object
	local mypos = me:getpos()

	creatures.change_hp(self, calcPunchDamage(me, time_from_last_punch, tool_capabilities) * -1)
	if puncher then
		if self.hostile then
			self.mode = "attack"
			self.target = puncher
		end
		if time_from_last_punch >= 0.45 and self.stunned == false then
			if self.has_kockback == true then
				local v = me:getvelocity()
				v.y = 0
				if not self.can_fly then
				me:setacceleration({x = 0, y = -15, z = 0})
				end
				creatures.knockback(self, dir, v, 5)
				self.stunned = true
			end

			-- add wearout to weapons/tools
			addWearout(puncher, tool_capabilities)
		end
	end
end

