--[[
= Chicken for Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
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

-- Feeder node
minetest.register_node("chicken:chicken_feeder", {
	description = "Chicken Feeder",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = { -- Created with NodeBoxEditor
			{-0.25, -0.375, -0.1875, -0.1875, 0.25, 0.1875}, 
			{0.1875, -0.375, -0.1875, 0.25, 0.25, 0.1875}, 
			{-0.1875, -0.375, 0.1875, 0.1875, 0.25, 0.25}, 
			{-0.1875, -0.375, -0.25, 0.1875, 0.25, -0.1875}, 
			{0.1875, -0.5, -0.25, 0.25, 0.25, -0.1875}, 
			{0.1875, -0.5, 0.1875, 0.25, 0.25, 0.25}, 
			{-0.25, -0.5, 0.1875, -0.1875, 0.25, 0.25}, 
			{-0.25, -0.5, -0.25, -0.1875, 0.25, -0.1875}, 
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.25, 0.25}, 
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
	},
	tiles = {
		"(chicken_feeder_seeds.png^(default_junglewood.png^chicken_feeder_layer_top.png^[makealpha:76,255,0))", -- Top
		"(chicken_feeder_seeds.png^(default_junglewood.png^chicken_feeder_layer_top.png^[makealpha:76,255,0))", -- Bottom
		"(chicken_feeder_seeds.png^(default_junglewood.png^chicken_feeder_layer_side.png^[makealpha:76,255,0))", -- Right 
		"(chicken_feeder_seeds.png^(default_junglewood.png^chicken_feeder_layer_side.png^[makealpha:76,255,0))", -- Left
		"(chicken_feeder_seeds.png^(default_junglewood.png^chicken_feeder_layer_side.png^[makealpha:76,255,0))", -- Back
		"(chicken_feeder_seeds.png^(default_junglewood.png^chicken_feeder_layer_side.png^[makealpha:76,255,0))" -- Front
	},
	sunlight_propagates = true,
	groups = {snappy = 3, attached_node = 1, flammable = 1},
	sounds = default.node_sound_wood_defaults()
})
core.register_craft({
	output = 'chicken:chicken_feeder',
	recipe = {
		{'group:stick', '', 'group:stick'},
		{'group:wood', 'farming:seed_wheat', 'group:wood'},
		{'group:stick', '', 'group:stick'},
	}
})

-- Feeder steps
for n,data in ipairs({
	{ -- 1
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.25, -0.375, -0.1875, -0.1875, 0.25, 0.1875}, 
			{0.1875, -0.375, -0.1875, 0.25, 0.25, 0.1875}, 
			{-0.1875, -0.375, 0.1875, 0.1875, 0.25, 0.25}, 
			{-0.1875, -0.375, -0.25, 0.1875, 0.25, -0.1875}, 
			{0.1875, -0.5, -0.25, 0.25, 0.25, -0.1875}, 
			{0.1875, -0.5, 0.1875, 0.25, 0.25, 0.25}, 
			{-0.25, -0.5, 0.1875, -0.1875, 0.25, 0.25}, 
			{-0.25, -0.5, -0.25, -0.1875, 0.25, -0.1875}, 
			{-0.1875, -0.5, -0.3125, 0.1875, -0.375, 0.3125}, 
			{-0.3125, -0.5, -0.1875, 0.3125, -0.375, 0.1875}, 
			{-0.375, -0.5, -0.125, 0.375, -0.4375, 0.125}, 
			{-0.125, -0.5, -0.375, 0.125, -0.4375, 0.375}, 
		},
	},
	{ -- 2
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.25, -0.375, -0.1875, -0.1875, 0.25, 0.1875}, 
			{0.1875, -0.375, -0.1875, 0.25, 0.25, 0.1875}, 
			{-0.1875, -0.375, 0.1875, 0.1875, 0.25, 0.25}, 
			{-0.1875, -0.375, -0.25, 0.1875, 0.25, -0.1875}, 
			{0.1875, -0.5, -0.25, 0.25, 0.25, -0.1875}, 
			{0.1875, -0.5, 0.1875, 0.25, 0.25, 0.25}, 
			{-0.25, -0.5, 0.1875, -0.1875, 0.25, 0.25}, 
			{-0.25, -0.5, -0.25, -0.1875, 0.25, -0.1875}, 
			{-0.1875, -0.5, -0.3125, 0.1875, -0.375, 0.3125}, 
			{-0.3125, -0.5, -0.1875, 0.3125, -0.375, 0.1875}, 
			{-0.375, -0.5, -0.125, 0.375, -0.4375, 0.125}, 
			{-0.125, -0.5, -0.375, 0.125, -0.4375, 0.375}, 
			{-0.125, -0.5, -0.375, 0.125, -0.4375, 0.375}, 
			{-0.0625, -0.5, -0.375, 0.0625, -0.375, 0.375}, 
			{-0.0625, -0.5, -0.4375, 0.0625, -0.4375, 0.4375}, 
			{-0.375, -0.5, -0.125, 0.375, -0.4375, 0.125}, 
			{-0.375, -0.5, -0.0625, 0.375, -0.375, 0.0625}, 
			{-0.4375, -0.5, -0.0625, 0.4375, -0.4375, 0.0625}, 
			{-0.4375, -0.5, -0.375, -0.375, -0.4375, -0.3125}, 
			{-0.1875, -0.5, -0.1875, 0.1875, -0.3125, 0.1875}, 
		},
	},
	{ -- 3
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.25, -0.375, -0.1875, -0.1875, 0.25, 0.1875},
			{0.1875, -0.375, -0.1875, 0.25, 0.25, 0.1875}, 
			{-0.1875, -0.375, 0.1875, 0.1875, 0.25, 0.25}, 
			{-0.1875, -0.375, -0.25, 0.1875, 0.25, -0.1875}, 
			{0.1875, -0.5, -0.25, 0.25, 0.25, -0.1875}, 
			{0.1875, -0.5, 0.1875, 0.25, 0.25, 0.25}, 
			{-0.25, -0.5, 0.1875, -0.1875, 0.25, 0.25}, 
			{-0.25, -0.5, -0.25, -0.1875, 0.25, -0.1875}, 
			{-0.1875, -0.5, -0.3125, 0.1875, -0.375, 0.3125}, 
			{-0.3125, -0.5, -0.1875, 0.3125, -0.375, 0.1875}, 
			{-0.375, -0.5, -0.125, 0.375, -0.4375, 0.125}, 
			{-0.125, -0.5, -0.375, 0.125, -0.4375, 0.375}, 
			{-0.125, -0.5, -0.375, 0.125, -0.4375, 0.375}, 
			{-0.0625, -0.5, -0.375, 0.0625, -0.375, 0.375}, 
			{-0.0625, -0.5, -0.4375, 0.0625, -0.4375, 0.4375}, 
			{-0.375, -0.5, -0.125, 0.375, -0.4375, 0.125}, 
			{-0.375, -0.5, -0.0625, 0.375, -0.375, 0.0625}, 
			{-0.4375, -0.5, -0.0625, 0.4375, -0.4375, 0.0625}, 
			{0.375, -0.5, 0.25, 0.4375, -0.4375, 0.3125}, 
			{-0.4375, -0.5, -0.375, -0.375, -0.4375, -0.3125}, 
			{-0.1875, -0.5, -0.1875, 0.1875, -0.25, 0.1875}, 
			{0.125, -0.5, 0.375, 0.1875, -0.4375, 0.4375}, 
			{-0.3125, -0.5, 0.3125, -0.25, -0.4375, 0.375}, 
			{0.375, -0.5, -0.375, 0.4375, -0.4375, -0.3125}, 
		},
	},
	{ -- 4
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.25, -0.375, -0.1875, -0.1875, 0.25, 0.1875}, 
			{0.1875, -0.375, -0.1875, 0.25, 0.25, 0.1875}, 
			{-0.1875, -0.375, 0.1875, 0.1875, 0.25, 0.25}, 
			{-0.1875, -0.375, -0.25, 0.1875, 0.25, -0.1875}, 
			{0.1875, -0.5, -0.25, 0.25, 0.25, -0.1875}, 
			{0.1875, -0.5, 0.1875, 0.25, 0.25, 0.25}, 
			{-0.25, -0.5, 0.1875, -0.1875, 0.25, 0.25}, 
			{-0.25, -0.5, -0.25, -0.1875, 0.25, -0.1875}, 
			{-0.1875, -0.5, -0.3125, 0.1875, -0.375, 0.3125}, 
			{-0.3125, -0.5, -0.1875, 0.3125, -0.375, 0.1875}, 
			{-0.375, -0.5, -0.125, 0.375, -0.4375, 0.125}, 
			{-0.125, -0.5, -0.375, 0.125, -0.4375, 0.375}, 
			{-0.125, -0.5, -0.375, 0.125, -0.4375, 0.375}, 
			{-0.0625, -0.5, -0.375, 0.0625, -0.375, 0.375}, 
			{-0.0625, -0.5, -0.4375, 0.0625, -0.4375, 0.4375}, 
			{-0.375, -0.5, -0.125, 0.375, -0.4375, 0.125}, 
			{-0.375, -0.5, -0.0625, 0.375, -0.375, 0.0625}, 
			{-0.4375, -0.5, -0.0625, 0.4375, -0.4375, 0.0625}, 
			{0.375, -0.5, 0.25, 0.4375, -0.4375, 0.3125}, 
			{-0.4375, -0.5, -0.375, -0.375, -0.4375, -0.3125}, 
			{-0.1875, -0.5, -0.1875, 0.1875, 0, 0.1875}, 
			{0.125, -0.5, 0.375, 0.1875, -0.4375, 0.4375}, 
			{-0.3125, -0.5, 0.3125, -0.25, -0.4375, 0.375}, 
			{0.375, -0.5, -0.375, 0.4375, -0.4375, -0.3125}, 
			{-0.375, -0.5, 0.375, -0.3125, -0.4375, 0.4375}, 
			{0.25, -0.5, 0.3125, 0.3125, -0.4375, 0.375}, 
			{0.25, -0.5, -0.3125, 0.3125, -0.4375, -0.25}, 
			{-0.375, -0.5, -0.3125, -0.3125, -0.4375, -0.25}, 
		},
	},
	{ -- 5
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.25, -0.375, -0.1875, -0.1875, 0.25, 0.1875}, 
			{0.1875, -0.375, -0.1875, 0.25, 0.25, 0.1875}, 
			{-0.1875, -0.375, 0.1875, 0.1875, 0.25, 0.25}, 
			{-0.1875, -0.375, -0.25, 0.1875, 0.25, -0.1875}, 
			{0.1875, -0.5, -0.25, 0.25, 0.25, -0.1875},
			{0.1875, -0.5, 0.1875, 0.25, 0.25, 0.25}, 
			{-0.25, -0.5, 0.1875, -0.1875, 0.25, 0.25}, 
			{-0.25, -0.5, -0.25, -0.1875, 0.25, -0.1875}, 
			{-0.1875, -0.5, -0.3125, 0.1875, -0.375, 0.3125}, 
			{-0.3125, -0.5, -0.1875, 0.3125, -0.375, 0.1875}, 
			{-0.375, -0.5, -0.125, 0.375, -0.4375, 0.125}, 
			{-0.125, -0.5, -0.375, 0.125, -0.4375, 0.375}, 
			{-0.125, -0.5, -0.375, 0.125, -0.4375, 0.375}, 
			{-0.0625, -0.5, -0.375, 0.0625, -0.375, 0.375}, 
			{-0.0625, -0.5, -0.4375, 0.0625, -0.4375, 0.4375}, 
			{-0.375, -0.5, -0.125, 0.375, -0.4375, 0.125}, 
			{-0.375, -0.5, -0.0625, 0.375, -0.375, 0.0625}, 
			{-0.4375, -0.5, -0.0625, 0.4375, -0.4375, 0.0625}, 
			{0.375, -0.5, 0.25, 0.4375, -0.4375, 0.3125}, 
			{-0.4375, -0.5, -0.375, -0.375, -0.4375, -0.3125}, 
			{-0.1875, -0.5, -0.1875, 0.1875, 0.125, 0.1875}, 
			{0.125, -0.5, 0.375, 0.1875, -0.4375, 0.4375}, 
			{-0.3125, -0.5, 0.3125, -0.25, -0.4375, 0.375}, 
			{0.375, -0.5, -0.375, 0.4375, -0.4375, -0.3125}, 
			{-0.375, -0.5, 0.375, -0.3125, -0.4375, 0.4375}, 
			{0.25, -0.5, 0.3125, 0.3125, -0.4375, 0.375}, 
			{0.25, -0.5, -0.3125, 0.3125, -0.4375, -0.25}, 
			{-0.375, -0.5, -0.3125, -0.3125, -0.4375, -0.25}, 
			{-0.3125, -0.5, -0.4375, -0.25, -0.4375, -0.375}, 
			{-0.4375, -0.5, 0.25, -0.375, -0.4375, 0.3125}, 
		},
		selection_box = {-0.5, -0.5, -0.375, 0.5, 0.125, 0.5},
	},
	{ -- 6
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.25, -0.375, -0.1875, -0.1875, 0.25, 0.1875}, 
			{0.1875, -0.375, -0.1875, 0.25, 0.25, 0.1875}, 
			{-0.1875, -0.375, 0.1875, 0.1875, 0.25, 0.25}, 
			{-0.1875, -0.375, -0.25, 0.1875, 0.25, -0.1875}, 
			{0.1875, -0.5, -0.25, 0.25, 0.25, -0.1875}, 
			{0.1875, -0.5, 0.1875, 0.25, 0.25, 0.25}, 
			{-0.25, -0.5, 0.1875, -0.1875, 0.25, 0.25}, 
			{-0.25, -0.5, -0.25, -0.1875, 0.25, -0.1875}, 
			{-0.1875, -0.5, -0.3125, 0.1875, -0.375, 0.3125}, 
			{-0.3125, -0.5, -0.1875, 0.3125, -0.375, 0.1875}, 
			{-0.375, -0.5, -0.125, 0.375, -0.4375, 0.125}, 
			{-0.125, -0.5, -0.375, 0.125, -0.4375, 0.375}, 
			{-0.125, -0.5, -0.375, 0.125, -0.4375, 0.375}, 
			{-0.0625, -0.5, -0.375, 0.0625, -0.375, 0.375}, 
			{-0.0625, -0.5, -0.4375, 0.0625, -0.4375, 0.4375}, 
			{-0.375, -0.5, -0.125, 0.375, -0.4375, 0.125}, 
			{-0.375, -0.5, -0.0625, 0.375, -0.375, 0.0625}, 
			{-0.4375, -0.5, -0.0625, 0.4375, -0.4375, 0.0625}, 
			{0.375, -0.5, 0.25, 0.4375, -0.4375, 0.3125}, 
			{-0.4375, -0.5, -0.375, -0.375, -0.4375, -0.3125}, 
			{-0.1875, -0.5, -0.1875, 0.1875, 0.25, 0.1875}, 
			{0.125, -0.5, 0.375, 0.1875, -0.4375, 0.4375}, 
			{-0.3125, -0.5, 0.3125, -0.25, -0.4375, 0.375}, 
			{0.375, -0.5, -0.375, 0.4375, -0.4375, -0.3125}, 
			{-0.375, -0.5, 0.375, -0.3125, -0.4375, 0.4375}, 
			{0.25, -0.5, 0.3125, 0.3125, -0.4375, 0.375}, 
			{0.25, -0.5, -0.3125, 0.3125, -0.4375, -0.25}, 
			{-0.375, -0.5, -0.3125, -0.3125, -0.4375, -0.25}, 
			{-0.3125, -0.5, -0.4375, -0.25, -0.4375, -0.375}, 
			{-0.4375, -0.5, 0.25, -0.375, -0.4375, 0.3125}, 
			{-0.4375, -0.5, 0.125, -0.375, -0.4375, 0.1875}, 
			{0.375, -0.5, 0.125, 0.4375, -0.4375, 0.1875}, 
			{0.3125, -0.5, -0.3125, 0.375, -0.4375, -0.25}, 
		},
	},
	{ -- 7
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.25, -0.375, -0.1875, -0.1875, 0.25, 0.1875}, 
			{0.1875, -0.375, -0.1875, 0.25, 0.25, 0.1875}, 
			{-0.1875, -0.375, 0.1875, 0.1875, 0.25, 0.25}, 
			{-0.1875, -0.375, -0.25, 0.1875, 0.25, -0.1875}, 
			{0.1875, -0.5, -0.25, 0.25, 0.25, -0.1875}, 
			{0.1875, -0.5, 0.1875, 0.25, 0.25, 0.25}, 
			{-0.25, -0.5, 0.1875, -0.1875, 0.25, 0.25}, 
			{-0.25, -0.5, -0.25, -0.1875, 0.25, -0.1875}, 
			{-0.1875, -0.5, -0.3125, 0.1875, -0.375, 0.3125}, 
			{-0.3125, -0.5, -0.1875, 0.3125, -0.375, 0.1875}, 
			{-0.375, -0.5, -0.125, 0.375, -0.4375, 0.125}, 
			{-0.125, -0.5, -0.375, 0.125, -0.4375, 0.375}, 
			{-0.125, -0.5, -0.375, 0.125, -0.4375, 0.375}, 
			{-0.0625, -0.5, -0.375, 0.0625, -0.375, 0.375}, 
			{-0.0625, -0.5, -0.4375, 0.0625, -0.4375, 0.4375}, 
			{-0.375, -0.5, -0.125, 0.375, -0.4375, 0.125}, 
			{-0.375, -0.5, -0.0625, 0.375, -0.375, 0.0625}, 
			{-0.4375, -0.5, -0.0625, 0.4375, -0.4375, 0.0625}, 
			{0.375, -0.5, 0.25, 0.4375, -0.4375, 0.3125}, 
			{-0.4375, -0.5, -0.375, -0.375, -0.4375, -0.3125}, 
			{-0.1875, -0.5, -0.1875, 0.1875, 0.3125, 0.1875}, 
			{0.125, -0.5, 0.375, 0.1875, -0.4375, 0.4375}, 
			{-0.3125, -0.5, 0.3125, -0.25, -0.4375, 0.375}, 
			{0.375, -0.5, -0.375, 0.4375, -0.4375, -0.3125}, 
			{-0.375, -0.5, 0.375, -0.3125, -0.4375, 0.4375}, 
			{0.25, -0.5, 0.3125, 0.3125, -0.4375, 0.375}, 
			{0.25, -0.5, -0.3125, 0.3125, -0.4375, -0.25}, 
			{-0.375, -0.5, -0.3125, -0.3125, -0.4375, -0.25}, 
			{-0.3125, -0.5, -0.4375, -0.25, -0.4375, -0.375}, 
			{-0.4375, -0.5, 0.25, -0.375, -0.4375, 0.3125}, 
			{-0.4375, -0.5, 0.125, -0.375, -0.4375, 0.1875}, 
			{0.375, -0.5, 0.125, 0.4375, -0.4375, 0.1875}, 
			{0.3125, -0.5, -0.3125, 0.375, -0.4375, -0.25}, 
			{-0.125, 0.3125, -0.125, 0.125, 0.375, 0.125}, 
			{0.125, -0.5, -0.5, 0.1875, -0.4375, -0.4375}, 
		},
	},
	{ -- 8
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.25, -0.375, -0.1875, -0.1875, 0.25, 0.1875}, 
			{0.1875, -0.375, -0.1875, 0.25, 0.25, 0.1875}, 
			{-0.1875, -0.375, 0.1875, 0.1875, 0.25, 0.25},  
			{-0.1875, -0.375, -0.25, 0.1875, 0.25, -0.1875},  
			{0.1875, -0.5, -0.25, 0.25, 0.25, -0.1875}, 
			{0.1875, -0.5, 0.1875, 0.25, 0.25, 0.25}, 
			{-0.25, -0.5, 0.1875, -0.1875, 0.25, 0.25}, 
			{-0.25, -0.5, -0.25, -0.1875, 0.25, -0.1875}, 
			{-0.1875, -0.5, -0.3125, 0.1875, -0.375, 0.3125}, 
			{-0.3125, -0.5, -0.1875, 0.3125, -0.375, 0.1875},
			{-0.375, -0.5, -0.125, 0.375, -0.4375, 0.125}, 
			{-0.125, -0.5, -0.375, 0.125, -0.4375, 0.375}, 
			{-0.125, -0.5, -0.375, 0.125, -0.4375, 0.375}, 
			{-0.0625, -0.5, -0.375, 0.0625, -0.375, 0.375}, 
			{-0.0625, -0.5, -0.4375, 0.0625, -0.4375, 0.4375}, 
			{-0.375, -0.5, -0.125, 0.375, -0.4375, 0.125}, 
			{-0.375, -0.5, -0.0625, 0.375, -0.375, 0.0625}, 
			{-0.4375, -0.5, -0.0625, 0.4375, -0.4375, 0.0625}, 
			{0.375, -0.5, 0.25, 0.4375, -0.4375, 0.3125}, 
			{-0.4375, -0.5, -0.375, -0.375, -0.4375, -0.3125}, 
			{-0.1875, -0.5, -0.1875, 0.1875, 0.4375, 0.1875}, 
			{0.125, -0.5, 0.375, 0.1875, -0.4375, 0.4375}, 
			{-0.3125, -0.5, 0.3125, -0.25, -0.4375, 0.375}, 
			{0.375, -0.5, -0.375, 0.4375, -0.4375, -0.3125}, 
			{-0.375, -0.5, 0.375, -0.3125, -0.4375, 0.4375}, 
			{0.25, -0.5, 0.3125, 0.3125, -0.4375, 0.375}, 
			{0.25, -0.5, -0.3125, 0.3125, -0.4375, -0.25}, 
			{-0.375, -0.5, -0.3125, -0.3125, -0.4375, -0.25}, 
			{-0.3125, -0.5, -0.4375, -0.25, -0.4375, -0.375}, 
			{-0.4375, -0.5, 0.25, -0.375, -0.4375, 0.3125}, 
			{-0.4375, -0.5, 0.125, -0.375, -0.4375, 0.1875}, 
			{0.375, -0.5, 0.125, 0.4375, -0.4375, 0.1875}, 
			{0.3125, -0.5, -0.3125, 0.375, -0.4375, -0.25}, 
			{-0.125, 0.4375, -0.125, 0.125, 0.5, 0.125}, 
			{0.125, -0.5, -0.5, 0.1875, -0.4375, -0.4375}, 
		},
	},
}) do
	minetest.register_node("chicken:chicken_feeder_"..n, {
		description = "Chicken Feeder",
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		node_box = {
			type = "fixed",
			fixed = data.node_box_fixed,
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.25, -0.5, -0.25, 0.25, 0.25, 0.25}, 
		},
		collision_box = {
			type = "fixed",
			fixed = {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
		},
		tiles = {
			"(chicken_feeder_seeds.png^(default_junglewood.png^chicken_feeder_layer_top.png^[makealpha:76,255,0))", -- Top
			"(chicken_feeder_seeds.png^(default_junglewood.png^chicken_feeder_layer_top.png^[makealpha:76,255,0))", -- Bottom
			"(chicken_feeder_seeds.png^(default_junglewood.png^chicken_feeder_layer_side.png^[makealpha:76,255,0))", -- Right 
			"(chicken_feeder_seeds.png^(default_junglewood.png^chicken_feeder_layer_side.png^[makealpha:76,255,0))", -- Left
			"(chicken_feeder_seeds.png^(default_junglewood.png^chicken_feeder_layer_side.png^[makealpha:76,255,0))", -- Back
			"(chicken_feeder_seeds.png^(default_junglewood.png^chicken_feeder_layer_side.png^[makealpha:76,255,0))" -- Front
		},
		sunlight_propagates = true,
		buildable_to = true,
		groups = {snappy = 3, attached_node = 1, flammable = 1, not_in_creative_inventory = 1},
		sounds = default.node_sound_wood_defaults()
	})
end

-- Register feeder
creatures.register_feeder_node("chicken:chicken_feeder", {
	supply = {
		["farming:seed_wheat"] = {
			count = 5,
		},
	},
	max_food = 70,
	node_steps = {
		{
			food = 0,
			name = "chicken:chicken_feeder",
		},
		{
			food = 1,
			name = "chicken:chicken_feeder_1",
		},
		{
			food = 10,
			name = "chicken:chicken_feeder_2",
		},
		{
			food = 20,
			name = "chicken:chicken_feeder_3",
		},
		{
			food = 30,
			name = "chicken:chicken_feeder_4",
		},
		{
			food = 40,
			name = "chicken:chicken_feeder_5",
		},
		{
			food = 50,
			name = "chicken:chicken_feeder_6",
		},
		{
			food = 60,
			name = "chicken:chicken_feeder_7",
		},
		{
			food = 70,
			name = "chicken:chicken_feeder_8",
		},
	},
})
