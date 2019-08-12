--[[
= Chicken for Creatures MOB-Engine (cme) =
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
chicken = {}

-- Params

-- Time for AMB interval at nest node
chicken.nest_update_time = 30

chicken.chicken_timer = 10

chicken.spawn_env_chance = tonumber(minetest.settings:get("chicken_spawn_chance") or 2)

-- Egg
dofile(core.get_modpath("chicken") .. "/egg.lua")

-- Craftitems
dofile(core.get_modpath("chicken") .. "/craftitems.lua")

-- Chicken
dofile(core.get_modpath("chicken") .. "/chicken.lua")

-- Nest
dofile(core.get_modpath("chicken") .. "/nest.lua")

-- Feeder
dofile(core.get_modpath("chicken") .. "/feeder.lua")
