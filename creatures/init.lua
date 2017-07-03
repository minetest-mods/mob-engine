--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
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


creatures = {}

local modpath = core.get_modpath("creatures")


-- API features

-- Basic Methods
dofile(modpath .."/common.lua")
dofile(modpath .."/drop_items.lua")
dofile(modpath .."/find_target.lua")
dofile(modpath .."/kill_mob.lua")
dofile(modpath .."/knockback.lua")
dofile(modpath .."/change_hp.lua")
-- Mod Functions
dofile(modpath .."/get_staticdata.lua")
dofile(modpath .."/on_rightclick.lua")
dofile(modpath .."/on_punch.lua")
dofile(modpath .."/on_step.lua")
-- Register Methods
dofile(modpath .."/register_mob.lua")
dofile(modpath .."/register_spawn.lua")
dofile(modpath .."/register_spawner.lua")
dofile(modpath .."/register_spawner_egg.lua")

-- Common items
dofile(modpath .."/items.lua")
