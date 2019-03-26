--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

path.lua

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

-- Finish path
local finish_path = function(self)
	-- Path status
	self.path.status = false
	self.path.time = 0 -- reset time limit
	
	-- Function when finish path
	if self.path.on_finish then
		self.path.on_finish(self)
	end
end

-- Interrupt path
local interrupt_path = function(self)
	-- Path status
	self.path.status = false
	self.path.time = 0 -- reset time limit
	
	-- Function when finish path
	if self.path.on_interrupt then
		self.path.on_interrupt(self)
	end
end

-- Find path
creatures.find_path = function(self, target_pos, search_def, search_distance, max_jump, max_drop)
	
	-- Minetest path finder
	if search_def.algorithm == "A*_noprefetch"
		or search_def.algorithm == "A*" 
		or search_def.algorithm == "Dijkstra" 
	then
		return minetest.find_path(
			self.object:getpos(), 
			target_pos, 
			search_def.search_distance, -- search distance
			search_def.max_jump, -- max jump
			search_def.max_drop, -- max drop
			search_def.algorithm -- algorithm
		)
	
	-- Creatures path finder
	else
		return creatures.path_finder(
			self,
			target_pos, 
			search_def -- search definitions
		)
	end
	
end

-- Find path
creatures.new_path = function(self, target_pos, speed, on_finish, on_interrupt, search_def)
	local my_pos = self.object:getpos()
	
	search_def = search_def or {}
	
	self.path.way = creatures.find_path(
		self, 
		target_pos, 
		{ 
			search_distance = search_def.search_distance or 15, 
			max_jump = search_def.max_jump or 1, 
			max_drop = search_def.max_drop or 2,
			algorithm = search_def.algorithm,
			target_dist = search_def.target_dist
		}
	)
	
	-- Check
	if not self.path.way then
		return false
	end
	
	-- Set params
	self.path.status = true
	self.path.speed = speed
	self.path.on_finish = on_finish
	self.path.on_interrupt = on_interrupt
	
	return true
end

-- Path step
creatures.path_step = function(self, dtime)
	
	-- Timer updates
	self.timers.path = self.timers.path + dtime
	
	if self.timers.path >= self.path.time and self.path.status == true then
		self.timers.path = 0
		
		-- Path params
		local way = self.path.way or {}
		
		-- Check path finish path
		if not way[1] then
			-- Finish path
			finish_path(self)
			return
		end
		
		-- MOB pos
		local mypos = self.object:getpos()
		
		-- Check path step
		do
			local dist = creatures.get_dist_p1top2(mypos, way[1])
			
			-- Arrived at the last point
			if dist < 1.1 then
			
				-- Remove this location path, go to the next
				table.remove(self.path.way, 1)
				
				-- Finish path
				if not way[1] then
					-- Finish path
					finish_path(self)
					return
				end
			
			-- Is too away 
			else
				-- Interrupt path
				interrupt_path(self)
				return
			end
		end
		
		-- Move to next location path
		
		-- Check objects obstruction
		local objects = creatures.find_target(way[1], 0.5, {
			xray = true,
			search_type = "all",
			ignore_obj = {self.object}		
		})
		if table.maxn(objects) > 0 then
			-- Interrupt path
			interrupt_path(self)
			return
		end
		
		-- Movement params
		local speed = self.path.speed 
		
		-- Time for movement interval
		self.path.time = 1/speed
		
		-- Rotate to next location path
		local new_dir = creatures.get_dir_p1top2(mypos, way[1])
		if new_dir then
			creatures.set_dir(self, new_dir)
		end
		
		-- Start movement
		creatures.send_in_dir(self, speed)
		
	end
end


-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		-- Timers
		self.timers.path = 0
		
		-- Path Params
		self.path = {
			time = 0,
			status = false,
			way = nil,
			speed = 0,
		}
		
	end)
	
end)
