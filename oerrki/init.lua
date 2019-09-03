--[[
= Oerrki for Creatures MOB-Engine (cme) =
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

-- Spawn chance
local spawn_chance = tonumber(minetest.settings:get("chicken_spawn_chance") or 1)

local def = {
	stats = {
		hp = 13,
		lifetime = 540, -- 9 Minutes
		can_jump = 1,
		can_swim = true,
		can_burn = true,
		burn_light = {min = 15, max = 15},
		burn_time_of_day = {min = 6000, max = 18000},
		can_panic = true,
		has_falldamage = true,
		has_kockback = true,
		sneaky = true,
		hostile = true,
	},
	
	modes = {
		idle = {chance = 0.59, duration = 3, update_yaw = 8},
		walk = {chance = 0.3, duration = 5.5, moving_speed = 1.5, search_radius = 5},
		walk_long = {chance = 0.11, duration = 8, moving_speed = 1.3, update_yaw = 5},

		-- special modes
		attack = {chance = 0, moving_speed = 2.9, duration = 20},
		panic = {duration = 4, moving_speed = 3.2},
	},
	
	sounds = {
		on_damage = {name = "oerrki_hit", gain = 1.0, distance = 10},
		on_death = {name = "oerrki_hit", gain = 1.0, distance = 10},
		swim = {name = "creatures_splash", gain = 1.0, distance = 10},
		random = {
			idle = {name = "oerrki_idle", gain = 1.0, distance = 25},
			attack = {name = "oerrki_attack", gain = 1.0, distance = 20},
		},
	},
	
	model = {
		mesh = "oerrki.b3d",
		textures = {"oerrki.png"},
		collisionbox_width = 0.6,
		collisionbox_height = 1.85,
		vision_height = 1.65,
		rotation = -90.0,
		animations = {
			idle = {start = 1, stop = 23, speed = 15},
			walk = {start = 24, stop = 31, speed = 8, loop = false},
			walk_long = {start = 24, stop = 31, speed = 8, loop = false},
			attack = {start = 37, stop = 49, speed = 18},
			death = {start = 50, stop = 76, speed = 32, loop = false, duration = 2.52},
		},
	},
	
	combat = {
		attack_damage = 2,
		attack_speed = 0.6,
		attack_radius = 1.5,

		search_enemy = true,
		search_timer = 1.6,
		search_radius = 12,
		search_type = "player",
	},

	spawning = {
		ambience = {
			-- Not too deep
			{ 
				spawn_type = "abm",
				
				max_number = 2*spawn_chance,
				number = 1*spawn_chance,
				light = {min = 0, max = 8},
				height_limit = {min = -300, max = 50},
				
				abm_nodes = {
					spawn_on = {"default:stone"},
				},
				abm_interval = 55,
				abm_chance = 7800/spawn_chance,
			},
			{ 
				spawn_type = "generated",
				
				max_number = 2*spawn_chance,
				number = 1*spawn_chance,
				light = {min = 0, max = 8},
				height_limit = {min = -300, max = 50},
				
				on_generated_chance = 70*spawn_chance,
				on_generated_nodes = { 
					spawn_on = {"default:stone"}, 
					get_under_air = true, 
				},
			},
			-- Deep
			{ 
				spawn_type = "abm",
				
				max_number = 3*spawn_chance,
				number = 1*spawn_chance,
				light = {min = 0, max = 8},
				height_limit = {min = -30000, max = -300},
				
				abm_nodes = {
					spawn_on = {"default:stone"},
				},
				abm_interval = 55,
				abm_chance = 5500/spawn_chance,
			},
			{ 
				spawn_type = "generated",
				
				max_number = 3*spawn_chance,
				number = {
					min = 1*spawn_chance, 
					max = 2*spawn_chance
					},
				light = {min = 0, max = 8},
				height_limit = {min = -30000, max = -300},
				
				on_generated_chance = 100,
				on_generated_nodes = { 
					spawn_on = {"default:stone"}, 
					get_under_air = true, 
				},
			},
		},
		
		spawn_egg = {
			description = "Oerrki Spawn-Egg",
			texture = "egg_oerrki.png",
		},

		spawner = {
			description = "Oerrki Spawner",
			range = 8,
			player_range = 20,
			number = 6,
			light = {min = 0, max = 8},
		}
	},
}

creatures.register_mob("oerrki:oerrki", def)
