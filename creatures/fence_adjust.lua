--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

fence_adjust.lua

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

-- Adjust fence
for _,nodename in ipairs({
	"default:fence_wood",
	"default:fence_acacia_wood",
	"default:fence_junglewood",
	"default:fence_pine_wood",
	"default:fence_aspen_wood"
}) do

	minetest.override_item(nodename, {
		collision_box = {
			type = "connected",
			fixed = {{-1/8, -1/2, -1/8, 1/8, 3/2, 1/8}},
			connect_front = {{-1/16,3/16,-1/2,1/16,24/16,-1/8},
				{-1/16,-5/16,-1/2,1/16,-3/16,-1/8}},
			connect_left = {{-1/2,3/16,-1/16,-1/8,24/16,1/16},
				{-1/2,-5/16,-1/16,-1/8,-3/16,1/16}},
			connect_back = {{-1/16,3/16,1/8,1/16,24/16,1/2},
				{-1/16,-5/16,1/8,1/16,-3/16,1/2}},
			connect_right = {{1/8,3/16,-1/16,1/2,24/16,1/16},
				{1/8,-5/16,-1/16,1/2,-3/16,1/16}},
		}
	})

end

-- Adjust fence reail
for _,nodename in ipairs({
	"default:fence_rail_wood",
	"default:fence_rail_acacia_wood",
	"default:fence_rail_junglewood",
	"default:fence_rail_pine_wood",
	"default:fence_rail_aspen_wood"
}) do

	minetest.override_item(nodename, {
		collision_box = {
			type = "connected",
			fixed = {
				{-1/16,  3/16, -1/16, 1/16,  24/16, 1/16},
				{-1/16, -3/16, -1/16, 1/16, -5/16, 1/16}
			},
			connect_front = {
				{-1/16,  3/16, -1/2, 1/16,  24/16, -1/16},
				{-1/16, -5/16, -1/2, 1/16, -3/16, -1/16}},
			connect_left = {
				{-1/2,  3/16, -1/16, -1/16,  24/16, 1/16},
				{-1/2, -5/16, -1/16, -1/16, -3/16, 1/16}},
			connect_back = {
				{-1/16,  3/16, 1/16, 1/16,  24/16, 1/2},
				{-1/16, -5/16, 1/16, 1/16, -3/16, 1/2}},
			connect_right = {
				{1/16,  3/16, -1/16, 1/2,  24/16, 1/16},
				{1/16, -5/16, -1/16, 1/2, -3/16, 1/16}},
		}
	})

end

-- Adjust fence closed gate
for _,nodename in ipairs({
	"doors:gate_wood_closed",
	"doors:gate_acacia_wood_closed",
	"doors:gate_junglewood_closed",
	"doors:gate_pine_wood_closed",
	"doors:gate_aspen_wood_closed"
}) do

	minetest.override_item(nodename, {
		collision_box = {
			type = "fixed",
			fixed = {-1/2, -1/2, -1/4, 1/2, 3/2, 1/4}
		}
	})

end

-- Adjust fence opened gate
for _,nodename in ipairs({
	"doors:gate_wood_open",
	"doors:gate_acacia_wood_open",
	"doors:gate_junglewood_open",
	"doors:gate_pine_wood_open",
	"doors:gate_aspen_wood_open"
}) do

	minetest.override_item(nodename, {
		collision_box = {
			type = "fixed",
			fixed = {{-1/2, -1/2, -1/8, -3/8, 3/2, 1/8},
				{-1/2, -3/8, -1/2, -3/8, 12/8, 0}},
		}
	})

end

-- Adjust walls
for _,nodename in ipairs({
	"walls:cobble",
	"walls:mossycobble",
	"walls:desertcobble"
}) do

	minetest.override_item(nodename, {
		collision_box = {
			type = "connected",
			fixed = {{-1/4, -1/2, -1/4, 1/4, 3/2, 1/4}},
			-- connect_bottom =
			connect_front = {{-3/16, -1/2, -1/2,  3/16, 12/8, -1/4}},
			connect_left = {{-1/2, -1/2, -3/16, -1/4, 16/8,  3/16}},
			connect_back = {{-3/16, -1/2,  1/4,  3/16, 12/8,  1/2}},
			connect_right = {{ 1/4, -1/2, -3/16,  1/2, 12/8,  3/16}},
		}
	})

end
