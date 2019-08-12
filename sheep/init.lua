--[[
= Sheep for Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

init.lua

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

-- Global table
sheep = {}

sheep.spawn_env_chance = tonumber(minetest.settings:get("sheep_spawn_chance") or 2)

-- Craftitems
dofile(core.get_modpath("sheep") .. "/craftitems.lua")

-- Sheep
dofile(core.get_modpath("sheep") .. "/sheep.lua")

-- Bed
dofile(core.get_modpath("sheep") .. "/bed.lua")

-- Feeder
dofile(core.get_modpath("sheep") .. "/feeder.lua")




