--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

fallen.lua

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

local hasMoved = creatures.compare_pos

-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		-- Params
		def.stats.has_falldamage = def.stats.has_falldamage
		def.stats.max_drop = def.stats.max_drop or 2
		
	end)
	
	-- Register 'on_step'
	creatures.register_on_step(mob_name, function(self, dtime)
		
		-- Timer update
		self.falltimer = (self.falltimer or 0) + dtime
		
		if self.falltimer >= 0.1 then
			self.falltimer = 0
			
			local def = creatures.get_def(self)
			
			if def.stats.has_falldamage ~= true then return end
			
			self.falling_timer = self.falltimer + 0.1
			local me = self.object
			local current_pos = me:getpos()
			
			if self.falling_y == nil then self.falling_y = current_pos.y end
			if self.last_fall_y == nil then self.last_fall_y = current_pos.y end
			
			-- Stationary
			if current_pos.y == self.last_fall_y then
			
				-- If falling
				if current_pos.y < self.falling_y then
					local falltime = tonumber(self.falling_timer) or 0
					local dist = math.abs(self.last_fall_y - self.falling_y)
					
					local damage = 0
					if dist > 3 and not self.in_water and falltime/dist < 0.2 then
						damage = dist - 3
					end

					-- damage by calced value
					if damage > 0 then
						changeHP(self, damage * -1)
					end
				end
				
				-- Reset fall
				self.falling_y = current_pos.y
				self.falling_timer = 0
			end
			
			-- Update last y
			self.last_fall_y = current_pos.y
		end
	end)
	
end)
