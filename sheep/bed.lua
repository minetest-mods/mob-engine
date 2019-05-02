--[[
= Sheep for Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

bed.lua

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

-- Bed node
minetest.register_node("sheep:bed", {
	description = "Sheep Bed",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.46875, -0.5, -0.46875, 0.46875, -0.4375, 0.46875}, 
			{-0.4375, -0.5, -0.4375, 0.4375, -0.375, 0.4375}, 
		}
	},
	tiles = {"farming_straw.png^[transformR90"},
	sunlight_propagates = true,
	buildable_to = true,
	walkable = false,
	groups = {snappy = 3, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
})
core.register_craft({
	output = 'sheep:bed',
	replacements = {
		{"sheep:shepherd_wooden_stick", "sheep:shepherd_wooden_stick"}
	},
	recipe = {
		{'farming:straw', '', 'farming:straw'},
		{'', 'sheep:shepherd_wooden_stick', ''},
		{'farming:straw', '', 'farming:straw'},
	}
})

-- Sheep Bed
creatures.register_mob_node("sheep:bed", {
	mob_name = "sheep:sheep",
	
	-- Search MOB
	search_mob = true,
	
	-- On load MOB
	on_save_mob = function(pos, self)
		local meta = minetest.get_meta(pos)
		
		meta:set_string("wool_color", self.wool_color)
		meta:set_string("has_wool", minetest.serialize(self.has_wool))
	end,
	
	-- On load MOB
	on_load_mob = function(pos, self)
		local meta = minetest.get_meta(pos)
		
		self.wool_color = meta:get_string("wool_color")
		self.has_wool = minetest.deserialize(meta:get_string("has_wool"))
		sheep.set_color(self)
	end,
	
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
