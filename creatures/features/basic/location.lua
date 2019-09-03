--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

location.lua

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

-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		-- Timer
		self.timers.loc = 0
		
		self.last_node = {name="ignore"}
		self.current_node = {name="ignore"}
		self.last_pos = self.object:getpos()
		
		
	end)
	
	-- Register 'on_step'
	creatures.register_on_step(mob_name, function(self, dtime)
		
		-- Timer update
		self.timers.loc = self.timers.loc + dtime
		
		if self.timers.loc >= 0.2 then
			self.timers.loc = 0
			
			-- localize some things
			local me = self.object
			local current_pos = me:get_pos()
			self.moved = not vector.equals(current_pos, self.last_pos)
			
			-- Check 'current_node'
			if self.current_node == nil then self.current_node = core.get_node_or_nil(current_pos) end
			
			-- Update pos and current node if necessary
			if self.moved == true or self.last_node.name == "ignore" then
			
				-- Update last locate
				self.last_pos = current_pos
				self.last_node = self.current_node
				self.last_light = minetest.get_node_light(self.last_pos)
				
				self.current_node = core.get_node_or_nil(current_pos)
			end
			
		end
	end)
	
end)
