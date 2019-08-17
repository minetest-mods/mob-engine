--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

params.lua

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

-- Engine params
creatures.params = {}

-- Allow hostile
creatures.params.disable_hostile = minetest.settings:get_bool("creatures_disable_hostile") or false

-- Allow hostile
creatures.params.disable_particles = minetest.settings:get_bool("creatures_disable_particles") or false

-- Spawn Control
creatures.params.spawn_flood_control = tonumber(minetest.settings:get("creatures_spawn_flood_control") or 5)

-- Default values
creatures.default_value = {}

-- HP
creatures.default_value.hp = 5

-- Breath
creatures.default_value.breath = 5

-- Collision Box
creatures.default_value.collisionbox_width = 0.9
creatures.default_value.collisionbox_height = 0.9

-- Weight
creatures.default_value.weight = 45

-- Save tags in mob node
creatures.mob_node_save_tags = {}

-- Distance for nodes near on spawning
creatures.default_value.nodes_near_radius = 8


