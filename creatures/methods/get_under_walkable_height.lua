--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

get_under_walkable_height.lua

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

-- Get under walkable height
creatures.get_under_walkable_height = function(pos, minh, maxh)
	
	local h = maxh
	
	-- Check first node
	if creatures.check_free_pos({x=pos.x,y=h,z=pos.z}) == false then
		return
	end
	
	h = h - 1
	
	while h >= (minh-1) do
		if creatures.check_free_pos({x=pos.x,y=h,z=pos.z}) == false then
			-- Check if is wall/fence
			if creatures.is_wall({x=pos.x,y=h,z=pos.z}) == true then
				return h + 2
			else
				return h + 1
			end
		end
		h = h - 1 -- Finish with minh-2
	end
	
	return 
end
