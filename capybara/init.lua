--= Capybara for Creatures MOB-Engine (cme) =--
-- Copyright (c) 2015-2016 BlockMen <blockmen2015@gmail.com>
-- Copyright (c) 2025 Stardust-fr
--
-- init.lua
--
-- SPDX-License-Identifier: Zlib

-- Main capybara mob definition
local def = {

	-- Basic stats
	name = "creatures:capybara",
	stats = {
		hp = 8,
		lifetime = 450,
		can_jump = 1,
		can_swim = true,
		can_burn = true,
		can_panic = true,
		has_falldamage = true,
		has_kockback = true,
	},

	-- Model & animation setup
	model = {
		mesh = "capybara.b3d",
		textures = {"capybara.png"},
		collisionbox = {-0.3, -0.55, -0.2, 0.3, 0.3, 0.2}, 
		rotation = 90.0,
		animations = {
			idle = {start = 21, stop = 21, speed = 1},
			walk = {start = 1, stop = 20, speed = 15},
			walk_long = {start = 1, stop = 20, speed = 15},
		},
	},

	-- Sound definitions
	sounds = {
		on_damage = {name = "creatures_capybara_hit", gain = 1.0, distance = 10},
		on_death = {name = "creatures_capybara_death", gain = 1.0, distance = 10},
		swim = {name = "creatures_splash", gain = 1.0, distance = 10},
		random = {
			idle = {name = "creatures_capybara", gain = 0.6, distance = 10, time_min = 23},
		},
	},

	-- Behavior modes
	modes = {
		idle = {chance = 0.5, duration = 10, update_yaw = 8},
		walk = {chance = 0.2, duration = 4.5, moving_speed = 1.3},
		walk_long = {chance = 0.15, duration = 8, moving_speed = 1.3, update_yaw = 5},

		-- Follow behavior
		follow = {
			chance = 0,
			duration = 20,
			radius = 4,
			timer = 5,
			moving_speed = 1,
			items = {"default:apple", "farming:melon_slice"}
		},

		-- Eating behavior
		eat = {
			chance = 0.15,
			duration = 4,
			nodes = {
				"default:grass_1", "default:grass_2", "default:grass_3",
				"default:grass_4", "default:grass_5", "default:dirt_with_grass"
			}
		},
	},

	-- Drops on death
	drops = function(self)
		if not self then
			return
		end
		local pos = self.object:get_pos()
		if pos then
			creatures.dropItems(pos, {{"creatures:flesh"}})
		end
	end,

	-- Spawning settings
	spawning = {
		abm_nodes = {
			spawn_on = {
				"default:dirt_with_grass",
				"default:dirt",
			},
		},
		abm_interval = 55,
		abm_chance = 7800,
		max_number = 2,
		number = {min = 2, max = 4},
		time_range = {min = 5100, max = 18300},
		light = {min = 10, max = 15},
		height_limit = {min = 0, max = 10},

		spawn_egg = {
			description = "Capybara Spawn-Egg",
			texture = "capybara_egg.png",
		},
	},


-- Right-click interactions (feeding, taming)
	on_rightclick = function(self, clicker)
		local item = clicker:get_wielded_item()
		if not item then
			return true
		end
		local name = item:get_name()

		if name == "default:apple" then
			self.target = clicker
			self.mode = "follow"
			self.modetimer = 0

			if not self.tamed then
					self.fed_cnt = (self.fed_cnt or 0) + 1
			end


			local hp = self.object:get_hp()
			local max_hp = self.hp or 8 
			if hp < max_hp then
				self.object:set_hp(math.min(hp + 2, max_hp))
			end

			item:take_item()

			if not core.setting_getbool("creative_mode") then
				clicker:set_wielded_item(item)
			end
		end
		return true
	end,

	-- Per-step logic (taming counter)
	on_step = function(self, dtime)
		if not self or not self.object or not self.object:get_pos() then
			return
		end

		if self.fed_cnt and self.fed_cnt > 4 then
			self.tamed = true
			self.fed_cnt = nil
		end
	end,
}

-- Register the mob
creatures.register_mob(def)
