--[[
= Chicken for Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

nest.lua

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

-- Nest node
minetest.register_node("chicken:nest", {
	description = "Nest",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{0.125, -0.5, -0.25, 0.3125, -0.3125, 0.25}, -- NodeBox1
			{-0.3125, -0.5, -0.25, -0.125, -0.3125, 0.25}, -- NodeBox2
			{-0.25, -0.5, 0.125, 0.25, -0.3125, 0.3125}, -- NodeBox3
			{-0.25, -0.5, -0.3125, 0.25, -0.3125, -0.125}, -- NodeBox4
			{-0.1875, -0.3125, -0.25, 0.1875, -0.25, -0.1875}, -- NodeBox5
			{-0.1875, -0.3125, 0.1875, 0.1875, -0.25, 0.25}, -- NodeBox6
			{0.1875, -0.3125, -0.1875, 0.25, -0.25, 0.1875}, -- NodeBox7
			{-0.25, -0.3125, -0.1875, -0.1875, -0.25, 0.1875}, -- NodeBox8
			{0.0625, -0.5, -0.3125, 0.3125, -0.4375, 0.3125}, -- NodeBox10
			{-0.3125, -0.5, -0.3125, -0.0625, -0.4375, 0.3125}, -- NodeBox11
			{-0.3125, -0.5, 0.0625, 0.3125, -0.4375, 0.3125}, -- NodeBox12
			{-0.3125, -0.5, -0.3125, 0.3125, -0.4375, -0.0625}, -- NodeBox13
			{0.25, -0.4375, -0.3125, 0.375, -0.375, 0.3125}, -- NodeBox14
			{-0.375, -0.4375, -0.3125, -0.25, -0.375, 0.3125}, -- NodeBox15
			{-0.3125, -0.4375, 0.25, 0.3125, -0.375, 0.375}, -- NodeBox16
			{-0.3125, -0.4375, -0.375, 0.3125, -0.375, -0.25}, -- NodeBox17
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -8 / 16, -6 / 16, 6 / 16, -5 /16, 6 / 16},
	},
	tiles = {"farming_straw.png^[transformR90"},
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Vacant")
	end,
})



creatures.register_mob_node("chicken:nest", {
	mob_name = "chicken:chicken",
	
	-- Search MOB
	search_mob = true,
	
	-- On set mob node
	on_set_mob_node = function(pos, ent)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Occupied")
	end,
	
	-- On reset mob node
	on_reset_mob_node = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Vacant")
	end,
})
