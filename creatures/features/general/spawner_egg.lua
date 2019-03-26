--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

spawner_egg.lua

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


-- Check if 'height' is free from 'pos'
local function checkSpace(pos, height)
	for i = 0, height do
		local n = core.get_node_or_nil({x = pos.x, y = pos.y + i, z = pos.z})
		if not n or n.name ~= "air" then
			return false
		end
	end
	return true
end


-- Spawn an egg
local function eggSpawn(itemstack, placer, pointed_thing, egg_def)
	if pointed_thing.type == "node" then
		local pos = pointed_thing.above
		pos.y = pos.y + 0.5
		local height = (egg_def.box[5] or 2) - (egg_def.box[2] or 0)
		if checkSpace(pos, height) == true then
			core.add_entity(pos, egg_def.mob_name)
			if minetest.settings:get_bool("creative_mode") ~= true then
				itemstack:take_item()
			end
		end
		return itemstack
	end
end


-- Register Spawn Egg
function creatures.register_egg(egg_def)
	if not egg_def or not egg_def.mob_name or not egg_def.box then
		creatures.throw_error("Can't register Spawn-Egg. Not enough parameters given.")
		return false
	end
	
	-- Register CraftItem
	core.register_craftitem(":" .. egg_def.mob_name .. "_spawn_egg", {
		description = egg_def.description or egg_def.mob_name .. " spawn egg",
		inventory_image = egg_def.texture or "creatures_spawn_egg.png",
		liquids_pointable = false,
		on_place = function(itemstack, placer, pointed_thing)
			return eggSpawn(itemstack, placer, pointed_thing, egg_def)
		end,
	})
	return true
end


-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Check hostile enabled
	if def.stats.hostile and creatures.params.disable_hostile == true then
		return
	end
	
	-- Register Spawn
	if def.spawning then
	
		local spawn_def = def.spawning
		spawn_def.mob_name = mob_name
		spawn_def.mob_size = def.ent_def.collisionbox
		
		-- Register Spawn Egg
		if spawn_def.spawn_egg then
			local egg_def = def.spawning.spawn_egg
			egg_def.mob_name = mob_name
			egg_def.box = def.ent_def.collisionbox
			creatures.register_egg(egg_def)
		end
		
	end
end)

