--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

modes.lua

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

-- Modpath
local modpath = core.get_modpath("creatures")

-- Compare pos
local hasMoved = creatures.compare_pos

-- Update animation
creatures.mode_animation_update = function(self)
	local obj = self.object
	local mode = self.mode
	local def = creatures.get_def(self).model.animations[mode]
	
	-- Check animation
	if not def then return end
	
	obj:set_animation(
		{x = def.start, y = def.stop}, 
		def.speed, 
		0, 
		def.loop
	)
end

-- Update velocity
creatures.mode_velocity_update = function(self)
	local obj = self.object
	local dir = self.dir
	local mode = self.mode
	local def = creatures.get_def(self)
	if not def or not def.modes[mode] then return end
	local modes = def.modes
	local speed = def.modes[mode].moving_speed or 0
	
	local v = obj:getvelocity()
	
	if not dir.y then
		dir.y = v.y/speed
	end
	
	local new_v = {x = dir.x * speed, y = v.y , z = dir.z * speed}
	obj:setvelocity(new_v)
end

-- Get mode def
creatures.mode_def = function(self, mode)
	return creatures.registered_mobs[self.mob_name].modes[(mode or self.mode)]
end


-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Save settings for modes
	creatures.registered_mobs[mob_name].modes = def.modes
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		self.mode = "idle"
		
		-- Timers
		self.modetimer = math.random()
		
		-- Timers for modes
		self.mdt = {}
		
		-- Update mode settings
		creatures.mode_velocity_update(self)
		creatures.mode_animation_update(self)
	end)
	
	-- 'on_step' callback for modes control
	creatures.register_on_step(mob_name, function(self, dtime)
		
		local def = creatures.get_def(self)
		
		-- Timer updates
		self.modetimer = self.modetimer + dtime
		
		-- Localize some things
		local modes = def.modes
		local current_mode = self.mode
		local me = self.object
		local current_pos = me:getpos()
		local moved = self.moved
		
		-- Current pos adjustment
		current_pos.y = current_pos.y + 0.5
		
		-- Check modetimer
		if current_mode ~= "" and self.modetimer >= (def.modes[current_mode].duration or 0) then
			current_mode = ""
		end
		
		-- Select a mode
		if current_mode == "" then
			local new_mode = creatures.get_random_index(modes) or "idle"
			
			if new_mode == "panic" 
				or new_mode == "swin" 
				or new_mode == "attack"
			then
				new_mode = "idle"
			end
			
			-- Check "eat" mode
			if new_mode == "eat" and self.in_water == true then
				new_mode = "idle"
			end
			
			current_mode = new_mode
			
			-- Start
			creatures.start_mode(self, current_mode)
			
			-- Update current_mode if changed when start
			current_mode = self.mode
		end
		
		-- Execute step modes
		if creatures.registered_modes[current_mode] and creatures.registered_modes[current_mode].on_step then
			
			creatures.registered_modes[current_mode].on_step(self, dtime)
		end
	end)
	
	-- Register 'get_staticdata'
	creatures.register_get_staticdata(mob_name, function(self)
		return {
			mode = self.mode,
			modetimer = self.modetimer,
		}
	end)
end)

-- Start a mode
creatures.start_mode = function(self, mode)
	
	-- Debug tool
	--minetest.chat_send_all("Starting mode: "..mode)
	
	local mob_def = creatures.mob_def(self)
	
	-- Check mode
	if not mob_def.modes[mode] then
		creatures.throw_error("Mode "..dump(mode).." no registered in mob "..dump(self.mob_name))
		mode = "idle"
	end
	
	-- Update last mode
	self.last_mode = self.mode
	
	-- Update mode settings
	self.mode = mode
	self.modetimer = 0
	
	if creatures.registered_modes[mode] and creatures.registered_modes[mode].start then
		creatures.registered_modes[mode].start(self)
	end
end

-- Register a mode
creatures.registered_modes = {}
creatures.register_mode = function(modename, def)
	creatures.registered_modes[modename] = def
	return true
end

dofile(modpath .."/features/mode/modes/fly.lua")
dofile(modpath .."/features/mode/modes/walk.lua")
dofile(modpath .."/features/mode/modes/walk_around.lua")
dofile(modpath .."/features/mode/modes/panic.lua")
dofile(modpath .."/features/mode/modes/follow.lua")
dofile(modpath .."/features/mode/modes/attack.lua")
dofile(modpath .."/features/mode/modes/eat.lua")
dofile(modpath .."/features/mode/modes/idle.lua")
