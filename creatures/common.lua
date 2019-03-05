--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

common.lua

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


-- Get random index
creatures.get_random_index = function(tb)
	local index_table = {}
	for index,d in pairs(tb) do
		table.insert(index_table, index)
	end
	return index_table[math.random(1, table.maxn(index_table))]
end

-- Error msg
creatures.throw_error = function(msg)
	core.log("error", "[Creatures]: " .. msg)
end

-- Get distance p1 to p2
creatures.get_dist_p1top2 = function(p1, p2)
	if not p1 or not p2 then
		return
	end
	local dist = {
		x=p2.x-p1.x, 
		y=p2.y-p1.y, 
		z=p2.z-p1.z
	}
	local real_dist = math.hypot(math.hypot(math.abs(dist.x), math.abs(dist.z)), math.abs(dist.y))
	return real_dist, dist
end

-- Velocity add
creatures.velocity_add = function(self, v_add)
	local obj = self.object
	local v = obj:getvelocity()
	
	local new_v = vector.add(v, v_add)
	
	obj:setvelocity(new_v)
end
