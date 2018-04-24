--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

find_target.lua

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


-- Find Target
function creatures.find_target(search_obj, pos, radius, search_type, ignore_mob, xray, no_count)
	local player_near = false
	local mobs = {}
	for  _,obj in ipairs(core.get_objects_inside_radius(pos, radius)) do
		if obj ~= search_obj then
			if xray or core.line_of_sight(pos, obj:getpos()) == true then
				local is_player = obj:is_player()
				if is_player then
					player_near = true
					if no_count == true then
						return {}, true
					end
				end
				local entity = obj:get_luaentity()
				local isItem = (entity and entity.name == "__builtin:item") or false
				local ignore = (entity and entity.mob_name == ignore_mob and search_type ~= "mates") or false

				if search_type == "all" then
					if not isItem and not ignore then
						table.insert(mobs, obj)
					end
					
				elseif search_type == "hostile" then
					if not ignore and (entity and entity.hostile == true) or is_player then
					table.insert(mobs, obj)
					end
					
				elseif search_type == "nonhostile" then
					if entity and not entity.hostile and not isItem and not ignore then
						table.insert(mobs, obj)
					end
					
				elseif search_type == "player" then
					if is_player then
						table.insert(mobs, obj)
					end
					
				elseif search_type == "mate" then
					if not isItem and (entity and entity.mob_name == ignore_mob) then
					table.insert(mobs, obj)
					end
				end
			end
		end
	end

	return mobs,player_near
end

