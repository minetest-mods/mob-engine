--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

hit_bottom.lua

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

-- Default collision box
local default_collisionbox = {
	-0.45, -0.01, -0.45,
	0.45, 0.8, 0.45
}

-- Params
local max_w = 1.2
local max_h = 2

-- Time for check hit bottom
local check_hit_bottom_time = 3

-- Tool capabilities
local tool_capabilities = {
	full_punch_interval = 0.9,
	max_drop_level = 0,
	groupcaps = {
		crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
		snappy = {times={[3]=0.40}, uses=0, maxlevel=1},
		oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=0}
	},
	damage_groups = {fleshy=1},
}

-- Check collision
local check_collision = function(obj1, obj2)
	
	-- Positions
	local pos1 = obj1:get_pos()
	local pos2 = obj2:get_pos()
	
	-- Collision Box
	local box1 = creatures.get_collisionbox(obj1)
	local box2 = creatures.get_collisionbox(obj2)
	
	-- Calcule real box positions
	local b1 = {
		pos1.x + box1[1] - 0.1, -- Min X
		pos1.y + box1[2] - 0.1, -- Min Y
		pos1.z + box1[3] - 0.1, -- Min Z
		pos1.x + box1[4] + 0.3, -- Max X
		pos1.y + box1[5] + 0.3, -- Max Y
		pos1.z + box1[6] + 0.3  -- Max Z
	}
	local b2 = {
		pos2.x + box2[1], -- Min X
		pos2.y + box2[2], -- Min Y
		pos2.z + box2[3], -- Min Z
		pos2.x + box2[4], -- Max X
		pos2.y + box2[5], -- Max Y
		pos2.z + box2[6]  -- Max Z
	}
	
	-- Check collision
	if (b1[1] >= b2[4] or b1[4] <= b2[1]) 
		or (b1[2] >= b2[5] or b1[5] <= b2[2]) 
		or (b1[3] >= b2[6] or b1[6] <= b2[3]) 
	then
		return false
	end
	return true
end

-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		
		self.timers.hit_bottom = 0
		
	end)
	
	-- Register 'on_step'
	creatures.register_on_step(mob_name, function(self, dtime)
		
		-- Timer update
		self.timers.hit_bottom = self.timers.hit_bottom + dtime
		
		if self.timers.hit_bottom >= check_hit_bottom_time then
			self.timers.hit_bottom = 0
			
			local def = creatures.get_def(self)
			
			local me = self.object
			local current_pos = me:getpos()
			
			-- Search objects in the bottom
			for _,obj in ipairs(
				creatures.find_target(
					{ -- pos
						x = current_pos.x,
						y = current_pos.y - max_h - 0.01,
						z = current_pos.z,
					}, 
					max_h, -- radius
					{
						xray = true,
						search_type = "all",
						ignore_obj = {me}
					}
				)
			) do
				if obj:get_luaentity() and check_collision(me, obj) == true then
					obj:punch(me, check_hit_bottom_time, tool_capabilities, {x=0,y=-1,z=0})
				end
			end
		end
	end)
	
end)


-- Check player hit bottom
creatures.check_player_hit_bottom = function(player, loop)
	if not player then return end
	
	local me = player
	local current_pos = me:getpos()
	
	-- Search objects in the bottom
	for _,obj in ipairs(
		creatures.find_target(
			{ -- pos
				x = current_pos.x,
				y = current_pos.y - max_h - 0.01,
				z = current_pos.z,
			}, 
			max_h, -- radius
			{
				xray = true,
				search_type = "all",
				ignore_obj = {me}
			}
		)
	) do
		if check_collision(me, obj) == true then
			obj:punch(me, 3, tool_capabilities, {x=0,y=-1,z=0})
		end
	end
	
	-- Mantain loop
	if loop == true then
		minetest.after(check_hit_bottom_time, creatures.check_player_hit_bottom, player, loop)
	end
end

minetest.register_on_joinplayer(function(player)
	-- Start loop
	minetest.after(check_hit_bottom_time, creatures.check_player_hit_bottom, player, true)
end)

