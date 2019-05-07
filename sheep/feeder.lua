--[[
= Sheep for Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

feeder.lua

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
minetest.register_node("sheep:sheep_feeder", {
	description = "Sheep Feeder",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = { -- Created with NodeBoxEditor
			{-0.5, -0.375, 0.4375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.0625, -0.3125}, 
			{0.4375, -0.375, -0.375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, -0.4375, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, 
			{0.4375, -0.5, -0.375, 0.5, -0.375, -0.3125}, 
			{0.4375, -0.5, 0.4375, 0.5, -0.375, 0.5}, 
			{-0.5, -0.5, 0.4375, -0.4375, -0.375, 0.5}, 
			{-0.5, -0.5, -0.375, -0.4375, -0.375, -0.3125} 
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.375, 0.5, 0.125, 0.5}, 
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.375, 0.5, 1, 0.5},
	},
	tiles = {
		"default_acacia_wood.png", -- Top
		"default_acacia_wood.png", -- Bottom
		"default_acacia_wood.png", -- Right 
		"default_acacia_wood.png", -- Left
		"default_acacia_wood.png", -- Back
		"default_acacia_wood.png" -- Front
	},
	sunlight_propagates = true,
	buildable_to = true,
	groups = {snappy = 3, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
})
core.register_craft({
	output = 'sheep:sheep_feeder',
	replacements = {{"sheep:shepherd_wooden_stick", "sheep:shepherd_wooden_stick"}},
	recipe = {
		{'group:stick', 'default:acacia_wood', 'group:stick'},
		{'default:acacia_wood', 'farming:wheat', 'default:acacia_wood'},
		{'group:stick', 'sheep:shepherd_wooden_stick', 'group:stick'},
	}
})

-- Feeder steps
for n,data in ipairs({
	{ -- 1
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.5, -0.375, 0.4375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.0625, -0.3125}, 
			{0.4375, -0.375, -0.375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, -0.4375, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, 
			{0.4375, -0.5, -0.375, 0.5, -0.375, -0.3125}, 
			{0.4375, -0.5, 0.4375, 0.5, -0.375, 0.5}, 
			{-0.5, -0.5, 0.4375, -0.4375, -0.375, 0.5}, 
			{-0.5, -0.5, -0.375, -0.4375, -0.375, -0.3125}, 
			{-0.4375, -0.3125, -0.3125, 0.4375, -0.25, 0.4375}, 
		},
		selection_box = {-0.5, -0.5, -0.375, 0.5, 0.125, 0.5},
		tiles = {
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_top.png^[makealpha:76,255,0))", -- Top
			"default_acacia_wood.png", -- Bottom
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Right 
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Left
			"default_acacia_wood.png", -- Back
			"default_acacia_wood.png" -- Front
		},
	},
	{ -- 2
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.5, -0.375, 0.4375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.0625, -0.3125}, 
			{0.4375, -0.375, -0.375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, -0.4375, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, 
			{0.4375, -0.5, -0.375, 0.5, -0.375, -0.3125}, 
			{0.4375, -0.5, 0.4375, 0.5, -0.375, 0.5}, 
			{-0.5, -0.5, 0.4375, -0.4375, -0.375, 0.5}, 
			{-0.5, -0.5, -0.375, -0.4375, -0.375, -0.3125}, 
			{-0.4375, -0.3125, -0.3125, 0.4375, -0.1875, 0.4375}, 
		},
		selection_box = {-0.5, -0.5, -0.375, 0.5, 0.125, 0.5},
		tiles = {
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_top.png^[makealpha:76,255,0))", -- Top
			"default_acacia_wood.png", -- Bottom
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Right 
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Left
			"default_acacia_wood.png", -- Back
			"default_acacia_wood.png" -- Front
		},
	},
	{ -- 3
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.5, -0.375, 0.4375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.0625, -0.3125}, 
			{0.4375, -0.375, -0.375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, -0.4375, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, 
			{0.4375, -0.5, -0.375, 0.5, -0.375, -0.3125}, 
			{0.4375, -0.5, 0.4375, 0.5, -0.375, 0.5}, 
			{-0.5, -0.5, 0.4375, -0.4375, -0.375, 0.5}, 
			{-0.5, -0.5, -0.375, -0.4375, -0.375, -0.3125}, 
			{-0.4375, -0.3125, -0.3125, 0.4375, -0.125, 0.4375}, 
		},
		selection_box = {-0.5, -0.5, -0.375, 0.5, 0.125, 0.5},
		tiles = {
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_top.png^[makealpha:76,255,0))", -- Top
			"default_acacia_wood.png", -- Bottom
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Right 
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Left
			"default_acacia_wood.png", -- Back
			"default_acacia_wood.png" -- Front
		},
	},
	{ -- 4
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.5, -0.375, 0.4375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.0625, -0.3125}, 
			{0.4375, -0.375, -0.375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, -0.4375, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, 
			{0.4375, -0.5, -0.375, 0.5, -0.375, -0.3125}, 
			{0.4375, -0.5, 0.4375, 0.5, -0.375, 0.5}, 
			{-0.5, -0.5, 0.4375, -0.4375, -0.375, 0.5}, 
			{-0.5, -0.5, -0.375, -0.4375, -0.375, -0.3125}, 
			{-0.4375, -0.3125, -0.3125, 0.4375, -0.0625, 0.4375}, 
		},
		selection_box = {-0.5, -0.5, -0.375, 0.5, 0.125, 0.5},
		tiles = {
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_top.png^[makealpha:76,255,0))", -- Top
			"default_acacia_wood.png", -- Bottom
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Right 
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Left
			"default_acacia_wood.png", -- Back
			"default_acacia_wood.png" -- Front
		},
	},
	{ -- 5
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.5, -0.375, 0.4375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.0625, -0.3125}, 
			{0.4375, -0.375, -0.375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, -0.4375, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, 
			{0.4375, -0.5, -0.375, 0.5, -0.375, -0.3125}, 
			{0.4375, -0.5, 0.4375, 0.5, -0.375, 0.5}, 
			{-0.5, -0.5, 0.4375, -0.4375, -0.375, 0.5}, 
			{-0.5, -0.5, -0.375, -0.4375, -0.375, -0.3125}, 
			{-0.4375, -0.3125, -0.3125, 0.4375, 0, 0.4375}, 
		},
		selection_box = {-0.5, -0.5, -0.375, 0.5, 0.125, 0.5},
		tiles = {
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_top.png^[makealpha:76,255,0))", -- Top
			"default_acacia_wood.png", -- Bottom
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Right 
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Left
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Back
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_front_5.png^[makealpha:76,255,0))" -- Front
		},
	},
	{ -- 6
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.5, -0.375, 0.4375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.0625, -0.3125}, 
			{0.4375, -0.375, -0.375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, -0.4375, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, 
			{0.4375, -0.5, -0.375, 0.5, -0.375, -0.3125}, 
			{0.4375, -0.5, 0.4375, 0.5, -0.375, 0.5}, 
			{-0.5, -0.5, 0.4375, -0.4375, -0.375, 0.5}, 
			{-0.5, -0.5, -0.375, -0.4375, -0.375, -0.3125}, 
			{-0.4375, -0.3125, -0.3125, 0.4375, 0.0625, 0.4375}, 
		},
		selection_box = {-0.5, -0.5, -0.375, 0.5, 0.125, 0.5},
		tiles = {
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_top.png^[makealpha:76,255,0))", -- Top
			"default_acacia_wood.png", -- Bottom
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Right 
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Left
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Back
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_front_6.png^[makealpha:76,255,0))" -- Front
		},
	},
	{ -- 7
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.5, -0.375, 0.4375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.0625, -0.3125}, 
			{0.4375, -0.375, -0.375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, -0.4375, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, 
			{0.4375, -0.5, -0.375, 0.5, -0.375, -0.3125}, 
			{0.4375, -0.5, 0.4375, 0.5, -0.375, 0.5}, 
			{-0.5, -0.5, 0.4375, -0.4375, -0.375, 0.5}, 
			{-0.5, -0.5, -0.375, -0.4375, -0.375, -0.3125}, 
			{-0.4375, -0.3125, -0.3125, 0.4375, 0.125, 0.4375}, 
		},
		selection_box = {-0.5, -0.5, -0.375, 0.5, 0.125, 0.5},
		tiles = {
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_top.png^[makealpha:76,255,0))", -- Top
			"default_acacia_wood.png", -- Bottom
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Right 
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Left
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Back
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_front.png^[makealpha:76,255,0))" -- Front
		},
	},
	{ -- 8
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.5, -0.375, 0.4375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.0625, -0.3125}, 
			{0.4375, -0.375, -0.375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, -0.4375, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, 
			{0.4375, -0.5, -0.375, 0.5, -0.375, -0.3125}, 
			{0.4375, -0.5, 0.4375, 0.5, -0.375, 0.5}, 
			{-0.5, -0.5, 0.4375, -0.4375, -0.375, 0.5}, 
			{-0.5, -0.5, -0.375, -0.4375, -0.375, -0.3125}, 
			{-0.4375, -0.3125, -0.3125, 0.4375, 0.1875, 0.4375}, 
		},
		selection_box = {-0.5, -0.5, -0.375, 0.5, 0.1875, 0.5}, 
		tiles = {
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_top.png^[makealpha:76,255,0))", -- Top
			"default_acacia_wood.png", -- Bottom
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Right 
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Left
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Back
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_front.png^[makealpha:76,255,0))" -- Front
		},
	},
	{ -- 9
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.5, -0.375, 0.4375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.0625, -0.3125}, 
			{0.4375, -0.375, -0.375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, -0.4375, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, 
			{0.4375, -0.5, -0.375, 0.5, -0.375, -0.3125}, 
			{0.4375, -0.5, 0.4375, 0.5, -0.375, 0.5}, 
			{-0.5, -0.5, 0.4375, -0.4375, -0.375, 0.5}, 
			{-0.5, -0.5, -0.375, -0.4375, -0.375, -0.3125}, 
			{-0.4375, -0.3125, -0.3125, 0.4375, 0.25, 0.4375}, 
		},
		selection_box = {-0.5, -0.5, -0.375, 0.5, 0.25, 0.5}, 
		tiles = {
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_top.png^[makealpha:76,255,0))", -- Top
			"default_acacia_wood.png", -- Bottom
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Right 
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Left
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Back
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_front.png^[makealpha:76,255,0))" -- Front
		},
	},
	{ -- 10
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.5, -0.375, 0.4375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.0625, -0.3125}, 
			{0.4375, -0.375, -0.375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, -0.4375, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, 
			{0.4375, -0.5, -0.375, 0.5, -0.375, -0.3125}, 
			{0.4375, -0.5, 0.4375, 0.5, -0.375, 0.5}, 
			{-0.5, -0.5, 0.4375, -0.4375, -0.375, 0.5}, 
			{-0.5, -0.5, -0.375, -0.4375, -0.375, -0.3125}, 
			{-0.4375, -0.3125, -0.3125, 0.4375, 0.25, 0.4375}, 
			{-0.3125, 0.3125, -0.1875, 0.3125, 0.375, 0.3125}, 
			{-0.375, 0.25, -0.25, 0.375, 0.3125, 0.375}, 
		},
		selection_box = {-0.5, -0.5, -0.375, 0.5, 0.375, 0.5}, 
		tiles = {
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_top.png^[makealpha:76,255,0))", -- Top
			"default_acacia_wood.png", -- Bottom
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Right 
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Left
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Back
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_front.png^[makealpha:76,255,0))" -- Front
		},
	},
	{ -- 11
		node_box_fixed = { -- Created with NodeBoxEditor
			{-0.5, -0.375, 0.4375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.0625, -0.3125}, 
			{0.4375, -0.375, -0.375, 0.5, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, -0.4375, 0.125, 0.5}, 
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, 
			{0.4375, -0.5, -0.375, 0.5, -0.375, -0.3125}, 
			{0.4375, -0.5, 0.4375, 0.5, -0.375, 0.5}, 
			{-0.5, -0.5, 0.4375, -0.4375, -0.375, 0.5}, 
			{-0.5, -0.5, -0.375, -0.4375, -0.375, -0.3125}, 
			{-0.4375, -0.3125, -0.3125, 0.4375, 0.3125, 0.4375}, 
			{-0.3125, 0.375, -0.1875, 0.3125, 0.4375, 0.3125}, 
			{-0.375, 0.3125, -0.25, 0.375, 0.375, 0.375}, 
		},
		selection_box = {-0.5, -0.5, -0.375, 0.5, 0.4375, 0.5}, 
		tiles = {
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_top.png^[makealpha:76,255,0))", -- Top
			"default_acacia_wood.png", -- Bottom
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Right 
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Left
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_side.png^[makealpha:76,255,0))", -- Back
			"(default_acacia_wood.png^(farming_straw.png^sheep_feeder_layer_front.png^[makealpha:76,255,0))" -- Front
		},
	},
}) do
	minetest.register_node("sheep:sheep_feeder_"..n, {
		description = "Sheep Feeder",
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		node_box = {
			type = "fixed",
			fixed = data.node_box_fixed,
		},
		selection_box = {
			type = "fixed",
			fixed = data.selection_box or {-0.5, -0.5, -0.375, 0.5, 0.125, 0.5},
		},
		collision_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.375, 0.5, 1, 0.5},
		},
		tiles = data.tiles or {"farming_straw.png^[transformR90"},
		sunlight_propagates = true,
		buildable_to = true,
		groups = {snappy = 3, attached_node = 1, flammable = 1, not_in_creative_inventory = 1},
		sounds = default.node_sound_wood_defaults()
	})
end

-- Register feeder
creatures.register_feeder_node("sheep:sheep_feeder", {
	supply = {
		["farming:straw"] = {
			food = 5,
		},
	},
	max_food = 100,
	node_steps = {
		{
			food = 0,
			name = "sheep:sheep_feeder",
		},
		{
			food = 1,
			name = "sheep:sheep_feeder_1",
		},
		{
			food = 10,
			name = "sheep:sheep_feeder_2",
		},
		{
			food = 20,
			name = "sheep:sheep_feeder_3",
		},
		{
			food = 30,
			name = "sheep:sheep_feeder_4",
		},
		{
			food = 40,
			name = "sheep:sheep_feeder_5",
		},
		{
			food = 50,
			name = "sheep:sheep_feeder_6",
		},
		{
			food = 60,
			name = "sheep:sheep_feeder_7",
		},
		{
			food = 70,
			name = "sheep:sheep_feeder_8",
		},
		{
			food = 80,
			name = "sheep:sheep_feeder_9",
		},
		{
			food = 90,
			name = "sheep:sheep_feeder_10",
		},
		{
			food = 100,
			name = "sheep:sheep_feeder_11",
		},
	},
})

-- Drinking Fountain node
minetest.register_node("sheep:drinking_fountain", {
	description = "Sheep Drinking Fountain",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = { -- Created with NodeBoxEditor
			{-0.4375, -0.5, 0.375, 0.4375, -0.125, 0.4375}, 
			{-0.4375, -0.5, -0.4375, 0.4375, -0.1875, 0.4375}, 
			{-0.4375, -0.5, -0.4375, 0.4375, -0.125, -0.375}, 
			{-0.4375, -0.5, -0.375, -0.375, -0.125, 0.375}, 
			{0.375, -0.5, -0.375, 0.4375, -0.125, 0.375}, 
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.4375, -0.5, -0.4375, 0.4375, -0.125, 0.4375}, 
	},
	tiles = {
		"(default_water.png^((default_acacia_wood.png)^sheep_drinking_fountain_layer_top.png^[makealpha:76,255,0))", -- Top
		"default_acacia_wood.png", -- Bottom
		"default_acacia_wood.png", -- Right 
		"default_acacia_wood.png", -- Left
		"default_acacia_wood.png", -- Back
		"default_acacia_wood.png" -- Front
	},
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, attached_node = 1, flammable = 1},
	sounds = default.node_sound_wood_defaults()
})
core.register_craft({
	output = 'sheep:drinking_fountain',
	replacements = {
		{"sheep:shepherd_wooden_stick", "sheep:shepherd_wooden_stick"},
		{"group:water_bucket", "bucket:bucket_empty"}
	},
	recipe = {
		{'group:stick', 'default:acacia_wood', 'group:stick'},
		{'default:acacia_wood', 'group:water_bucket', 'default:acacia_wood'},
		{'group:stick', 'sheep:shepherd_wooden_stick', 'group:stick'},
	}
})
