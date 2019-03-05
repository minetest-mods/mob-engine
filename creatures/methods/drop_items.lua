--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

drop_items.lua

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


-- Drop Itens
function creatures.drop_items(pos, drops)
	if not pos or not drops then
		return
	end

	-- convert drops table
	local tab = {}
	for _,elem in pairs(drops) do
		local name = tostring(elem[1])
		local v = elem[2]
		local chance = elem.chance
		local amount = ""
		-- check if drops depending on defined chance
		if name and chance then
			local ct = {}
			ct[name] = chance
			ct["_fake"] = 1 - chance
			local res = ct[creatures.get_random_index(ct)]
			if res == "_fake" then
				name = nil
			end
		end
		
		-- get amount
		if name and v then
			if type(v) == "table" then
				amount = math.random(v.min or 1, v.max or 1) or 1
			elseif type(v) == "number" then
				amount = v
			end
			if amount > 0 then
				amount = " " .. amount
			end
		end
		if name then
			local obj = core.add_item(pos, name .. amount)
			if not obj then
				throw_error("Could not drop item '" .. name .. amount .. "'")
			end
		end
	end
end

-- Alias
creatures.dropItems = creatures.drop_items
