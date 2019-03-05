--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

follow_search.lua

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

local hasMoved = creatures.compare_pos

-- Find Target
local findTarget = creatures.find_target

-- Check Wielded
local function checkWielded(wielded, itemList)
	for s,w in pairs(itemList) do
		if w == wielded then
			return true
		end
	end
	return false
end

-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		-- Timer
		self.followSearchTimer = 0
		
	end)
	
	-- Register 'on_step'
	creatures.register_on_step(mob_name, function(self, dtime)
		
		-- Timer update
		self.followSearchTimer = self.followSearchTimer + dtime
		local modes = def.modes
		
		-- localize some things
		local modes = def.modes
		local current_mode = self.mode
		local me = self.object
		local current_pos = me:getpos()
		current_pos.y = current_pos.y + 0.5
		local moved = self.moved
		
		-- Search a target (1-2ms)
		if 
			-- if not target yet
			not self.target 
			-- and is a follower
			and  modes["follow"]
			-- and not in "_run" mode
			and current_mode ~= "_run" 
		then
			
			-- get timer limit
			local timer = modes["follow"].timer
			
			-- if elapsed timer
			if self.followSearchTimer > (timer or 4) then
				
				-- reset timer
				self.followSearchTimer = 0
				
				-- targets list
				local targets = findTarget(me, current_pos, modes["follow"].radius or 5, "player")
				
				-- choose a random target
				if #targets > 1 then
					self.target = targets[rnd(1, #targets)]
				elseif #targets == 1 then
					self.target = targets[1]
				end
				
				-- if a target was found
				if self.target then
					
					-- change mode
					-- check target wielded item
					local name = self.target:get_wielded_item():get_name()
					if name and checkWielded(name, modes["follow"].items) == true then
						current_mode = "follow"
						self.modetimer = 0
					else
						self.target = nil
					end
				end
			end
		end
	end)
	
end)
