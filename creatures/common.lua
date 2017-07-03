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




-- constants
nullVec = {x = 0, y = 0, z = 0}
DEGTORAD = math.pi / 180.0

-- common functions


-- Random
function creatures.rnd(table, errval)
	if not errval then
		errval = false
	end

	local res = 1000000000
	local rn = math.random(0, res - 1)
	local retval = nil

	local psum = 0
	for s,w in pairs(table) do
		psum = psum + ((tonumber(w) or w.chance or 0) * res)
		if psum > rn then
			retval = s
			break
		end
	end

	return retval
end


-- Error msg
function throw_error(msg)
	core.log("error", "#Creatures: ERROR: " .. msg)
end


-- Compare if 'pos1' is at 'pos2'
function creatures.compare_pos(pos1, pos2)
	if not pos1 or not pos2 then
		return
	end
	if pos1.x == pos2.x and pos1.y == pos2.y and pos1.z == pos2.z then
		return false
	end
	return true
end

