--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

get_under_walkable_nodes_in_area.lua

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

-- Get under walkable nodes in area
creatures.get_under_walkable_nodes_in_area = function(minp, maxp)
	-- Nodes found
	local f = {}
	local i = 0
	local x, z = minp.x, minp.z
	while x <= maxp.x do
		while z <= maxp.z do
			local h = creatures.get_under_walkable_height({x=x, z=z}, minp.y, maxp.y)
			i = i + 1
			if h then
				table.insert(f, {x=x, y=h, z=z})
			end
			z = z + 1
		end
		z = minp.z
		x = x + 1
	end
	
	return f
end

