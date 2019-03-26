--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

path_finder.lua

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

-- Int
local int = function(n)
	if (n - math.floor(n)) > 0.5 then
		return math.ceil(n)
	else
		return math.floor(n)
	end
end

-- Copy table
local cp = creatures.copy_tb

-- Serialize pos
local spos = function(pos)
	return pos.x.." "..pos.y.." "..pos.z
end

-- Add point
local add_point = function(w, new_p)
	table.insert(w.pts, new_p)
	return w
end

-- New way
local new_way = function(new_p, old_way)
	if not old_way then
		old_way = {
			pts = {},
		}
	end
	old_way = add_point(old_way, new_p)
	return cp(old_way)
end

-- Get node def
local get_node_def = function(nn)
	return minetest.registered_nodes[nn]
end


-- Check new point
local check_new_p = function(self, w, new_p, max_jump, max_drop)
	
	-- Get height
	local maxh = new_p.y + max_jump
	local minh = new_p.y - max_drop
	local h = creatures.get_under_walkable_height(new_p, minh, maxh)
	
	if not h then return end
	
	-- Check height limits
	if h > maxh or h < minh then
		
		-- Remove way
		return
	end
	
	-- Check free pos
	if creatures.check_mob_in_pos(self, {x=new_p.x,y=h,z=new_p.z}) == false then
		-- Remove way
		return
	end
	
	-- Insert new point
	w = add_point(w, {x=new_p.x,y=h,z=new_p.z})
	
	-- New way
	return w
end

-- Find a path
creatures.path_finder = function(self, target_pos, search_def)
	local pos1 = creatures.get_node_pos_object(self.object)
	local pos2 = target_pos
	
	local mob_def = creatures.get_def(self)
	
	search_def.search_radius = search_def.search_radius or 10
	local search_radius = search_def.search_radius
	search_def.perssist = search_def.perssist or (search_def.search_radius + 5)
	
	-- Max jump
	search_def.max_jump = math.floor(search_def.max_jump or self.stepheight)
	
	-- Max drop
	search_def.max_drop = math.floor(search_def.max_drop or mob_def.stats.max_drop)
	
	-- Get int
	pos1 = {
		x = int(pos1.x),
		y = int(pos1.y),
		z = int(pos1.z)
	}
	pos2 = {
		x = int(pos2.x),
		y = int(pos2.y),
		z = int(pos2.z)
	}
	
	-- Step
	local s = 0
	
	-- Steps limit
	local sl = search_def.perssist
	
	-- Ways
	local ways = {}
	local new_ways = {}
	
	local ptss = {}
	
	-- Initial way
	table.insert(ways, new_way(pos1))
	
	-- Minimum distance
	local dist = creatures.get_dist_p1top2(pos1, pos2)
	
	-- Maximum distance
	local max_dist = search_radius + 5
	
	while (s <= sl) and (table.maxn(ways) > 0) do
		s = s + 1
		
		for i,w in ipairs(ways) do
			
			local last_pos = w.pts[table.maxn(w.pts)]
			
			-- Current distance
			local d = creatures.get_dist_p1top2(last_pos, pos2)
			
			-- Check if finished 
			--[[
				Uses 1 to consider arriving at the top block to the nodebox block
			]]
			if d <= (search_def.target_dist or 1) then
				return cp(w.pts)
			end
			
			-- Check max target distance
			if d < max_dist then
				
				-- Start 4 new ways and discard old way
				for _,new_p in ipairs({
					{x=last_pos.x+1, y=last_pos.y, z=last_pos.z},
					{x=last_pos.x-1, y=last_pos.y, z=last_pos.z},
					{x=last_pos.x, y=last_pos.y, z=last_pos.z+1},
					{x=last_pos.x, y=last_pos.y, z=last_pos.z-1}
				}) do
					-- Check if is already used
					if ptss[spos(new_p)] == nil then
						ptss[spos(new_p)] = true
						local new_w = check_new_p(self, cp(w), new_p, search_def.max_jump, search_def.max_drop)
						if new_w then
							table.insert(new_ways, new_w)
						end
					end
				end
				
			end
			
		end
		
		-- Update ways for a new loop
		ways = cp(new_ways)
		new_ways = {}
		
	end
	
	return 
end
