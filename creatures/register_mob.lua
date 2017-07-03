--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

register_mob.lua

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


local allow_hostile = minetest.settings:get_bool("only_peaceful_mobs") ~= true


-- Organize a entity table for registration
local function entity_table(def)
	
	
	-- Basic Attributes
	local ent_def = {
		physical = true,
		visual = "mesh",
		stepheight = 0.6, -- ensure we get over slabs/stairs
		automatic_face_movement_dir = def.model.rotation or 0.0,

		mesh = def.model.mesh,
		textures = def.model.textures,
		collisionbox = def.model.collisionbox or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		visual_size = def.model.scale or {x = 1, y = 1},
		backface_culling = def.model.backface_culling or false,
		collide_with_objects = def.model.collide_with_objects or true,
		makes_footstep_sound = true,

		stats = def.stats,
		model = def.model,
		sounds = def.sounds,
		combat = def.combat,
		modes = {},
		drops = def.drops,
	}
	
	
	-- Tanslate modes to better accessable format
	for mode_name,mode_def in pairs(def.modes) do
		local name = tostring(mode_name)
		if name ~= "update_time" then
			ent_def.modes[name] = mode_def
		end
	end
	
	
	-- Insert special mode "_run" which is used when in panic
	if def.stats.can_panic and def.modes.walk then
		
		-- Mode
		local run_mode = table.copy(ent_def.modes["walk"])
		run_mode.chance = 0
		run_mode.duration = 3
		run_mode.moving_speed = run_mode.moving_speed * 2
		if def.modes.panic and def.modes.panic.moving_speed then
			run_mode.moving_speed = def.modes.panic.moving_speed
		end
		run_mode.update_yaw = 0.7
		ent_def.modes["_run"] = run_mode
		
		-- Animation 
		local run_anim = def.model.animations.panic
		if not run_anim then
			run_anim = table.copy(def.model.animations.walk)
			run_anim.speed = run_anim.speed * 2
		end
		ent_def.model.animations._run = run_anim
		
	end
	
	
	-- Jump
	if def.stats.can_jump 
		and type(def.stats.can_jump) == "number" 
		and def.stats.can_jump > 0
	then
		ent_def.stepheight = def.stats.can_jump + 0.1
	end
	
	
	-- Fly
	if def.stats.sneaky or def.stats.can_fly then
		ent_def.makes_footstep_sound = false
	end
	
	
	-- Staticdata
	ent_def.get_staticdata = function(self)
		local data = creatures.get_staticdata(self) -- standard method
		
		-- if call custo is defined, merge results
		if def.get_staticdata then
			local other_data = def.get_staticdata(self)
			if other_data and type(other_data) == "table" then
				for s,w in pairs(other_data) do
					data[s] = w
				end
			end
		end

		-- return data serialized
		return core.serialize(data)
	end
	
	
	-- On Active
	ent_def.on_activate = function(self, staticdata)

		-- Add everything we need as basis for the engine
		self.mob_name = def.name
		self.hp = def.stats.hp
		self.hostile = def.stats.hostile
		self.mode = ""
		self.stunned = false -- if knocked back or hit do nothing else

		self.has_kockback = def.stats.has_kockback
		self.has_falldamage = def.stats.has_falldamage
		self.can_swim = def.stats.can_swim
		self.can_fly = def.stats.can_fly
		self.can_burn = def.stats.can_burn
		self.can_panic = def.stats.can_panic == true and def.modes.walk ~= nil
		self.dir = {x = 0, z = 0}

		self.fall_dist = 0
		self.air_cnt = 0


		-- Timers
		self.lifetimer = 0
		self.modetimer = math.random()
		self.soundtimer = math.random()
		self.nodetimer = 2 -- ensure we get the first step
		self.yawtimer = math.random() * 2
		self.followtimer = 0
		
		if self.can_swim then
			self.swimtimer = 2 -- ensure we get the first step
		end
		if self.hostile then
			self.attacktimer = 0
		end
		if self.hostile or def.modes.follow then
			self.searchtimer = 0
		end
		if self.can_burn or not def.stats.can_swim or self.has_falldamage then
			self.env_damage = true
			self.envtimer = 0
		end
		
		
		-- Restore Staticdata
		if staticdata then
			local tab = core.deserialize(staticdata)
			if tab and type(tab) == "table" then
				for s,w in pairs(tab) do
					self[tostring(s)] = w
				end
			end
		end
		
		
		-- Check we got a valid mode
		if not ent_def.modes[self.mode] 
			or (ent_def.modes[self.mode].chance or 0) <= 0 
		then
			self.mode = "idle"
		end
		
		
		-- Falling
		if not self.can_fly and not self.in_water then
			self.object:setacceleration({x = 0, y = -15, z = 0})
		end
		
		-- check if falling and set velocity only 0 when not falling
		if self.fall_dist == 0 then
			self.object:setvelocity(nullVec)
		end
		
		
		-- Check Object hp
		self.object:set_hp(self.hp)
		
		
		-- Check hostility
		if not minetest.settings:get_bool("enable_damage") then
			self.hostile = false
		end
		
		
		-- immortal is needed to disable clientside smokepuff shit 
		self.object:set_armor_groups({fleshy = 100, immortal = 1})
		
		
		-- Call custom
		if def.on_activate then
			def.on_activate(self, staticdata)
		end
	end
	
	
	-- On Punch
	ent_def.on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		
		-- Call custom
		if def.on_punch and def.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir) == true then
			return
		end
		
		-- Call standard
		creatures.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir)
	end
	
	
	-- On Rightclick
	ent_def.on_rightclick = function(self, clicker)
		
		-- Call custom
		if def.on_rightclick and def.on_rightclick(self, clicker) == true then
			return
		end
		
		-- Call standard
		creatures.on_rightclick(self, clicker)
	end
	
	
	-- On Step
	ent_def.on_step = function(self, dtime)
		
		-- Call custom
		if def.on_step and def.on_step(self, dtime) == true then
			return
		end
		
		-- Call standard
		creatures.on_step(self, dtime)
	end

	return ent_def
end


-- Register a Mob
function creatures.register_mob(def) -- returns true if sucessfull
	if not def or not def.name then
		throw_error("Can't register mob. No name or Definition given.")
		return false
	end
	
	-- Organize entity table
	local ent_def = entity_table(def)
	
	-- Register Entity
	core.register_entity(":" .. def.name, ent_def)
	
	-- Register Spawn
	if def.spawning and not (def.stats.hostile and not allow_hostile) then
	
		local spawn_def = def.spawning
		spawn_def.mob_name = def.name
		spawn_def.mob_size = def.model.collisionbox
		
		-- Register Spawn
		if creatures.register_spawn(spawn_def) ~= true then
			throw_error("Couldn't register spawning for '" .. def.name .. "'")
		end
		
		-- Register Spawn Egg
		if spawn_def.spawn_egg then
			local egg_def = def.spawning.spawn_egg
			egg_def.mob_name = def.name
			egg_def.box = def.model.collisionbox
			creatures.register_egg(egg_def)
		end
		
		-- Register Spawner
		if spawn_def.spawner then
			local spawner_def = def.spawning.spawner
			spawner_def.mob_name = def.name
			spawner_def.range = spawner_def.range or 4
			spawner_def.number = spawner_def.number or 6
			spawner_def.model = def.model
			creatures.register_spawner(spawner_def)
		end
		
	end

	return true
end


