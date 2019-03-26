--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

items.lua

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


core.register_craftitem("creatures:flesh", {
	description = "Flesh",
	inventory_image = "creatures_flesh.png",
	on_use = core.item_eat(2),
})

core.register_craftitem("creatures:meat", {
	description = "Cooked Meat",
	inventory_image = "creatures_meat.png",
	on_use = core.item_eat(4),
})

core.register_craft({
	type = "cooking",
	output = "creatures:meat",
	recipe = "creatures:flesh",
})

core.register_craftitem("creatures:rotten_flesh", {
	description = "Rotten Flesh",
	inventory_image = "creatures_rotten_flesh.png",
	on_use = core.item_eat(1),
})

core.register_tool("creatures:shears", {
	description = "Shears",
	inventory_image = "creatures_shears.png",
})

core.register_craft({
	output = 'creatures:shears',
	recipe = {
		{'', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:stick'},
	}
})
