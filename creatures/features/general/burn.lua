--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

burn.lua

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

-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		-- Settings
		self.can_burn = def.stats.can_burn
		
		-- Timer
		self.timers.burn = 0
		
	end)
	
	-- Register 'on_step'
	creatures.register_on_step(mob_name, function(self, dtime)
		
		-- Timer update
		self.timers.burn = self.timers.burn + dtime
		
		-- Add damage when in lava
		if self.timers.burn > 1 and self.last_node then
			self.timers.burn = 0
			local name = self.last_node.name
			if self.can_burn then
				if name == "fire:basic_flame" or name == "default:lava_source" then
					changeHP(self, -4)
				end
			end

			-- Add damage when light is too bright
			if self.can_burn then
				local light_damage, time_damage
				
				-- Check light
				if def.stats.burn_light then
					light_damage = false
					if self.last_light and creatures.in_range(def.stats.burn_light, self.last_light) == true then
						light_damage = true
					end
				end
				
				-- Check time of day
				if def.stats.burn_time_of_day then
					time_damage = false
					if creatures.in_range(def.stats.burn_time_of_day, (core.get_timeofday()*24000), 24000) == true then
						time_damage = true
					end
				end
				
				minetest.chat_send_all("light_damage = "..dump(light_damage))
				minetest.chat_send_all("time_damage = "..dump(time_damage))
				-- Take damage
				if light_damage ~= nil or time_damage ~= nil then
					
					if light_damage == nil then light_damage = true end
					if time_damage == nil then time_damage = true end
					
					if light_damage == true and time_damage == true then
						changeHP(self, -1)
					end
				end
			end
		end
	end)
	
end)
