--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

eat.lua

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

-- Eat mode ("eat")
creatures.register_mode("eat", {
	
	-- On step
	on_step = function(self, dtime)
		
		-- localize some things
		local def = creatures.registered_mobs[self.mob_name]
		local modes = def.modes
		local current_mode = self.mode
		local me = self.object
		local current_pos = me:getpos()
		current_pos.y = current_pos.y + 0.5
		local moved = self.moved
		
		-- Check eat node
		if not self.eat_node then
			local nodes = modes["eat"].nodes
			local p = {x = current_pos.x, y = current_pos.y - 1, z = current_pos.z}
			local sn = core.get_node_or_nil(p)
			local eat_node -- eaten node
			for _,name in pairs(nodes) do
				if name == self.last_node.name then
					eat_node = current_pos
					break
				elseif sn and sn.name == name then
					eat_node = p
					break
				end
			end

			if not eat_node then
				self.mode = ""
				return
			else
				self.eat_node = eat_node
			end
		end
		
		local n = core.get_node_or_nil(self.eat_node)
		local nnn = n.name
		local node_def = core.registered_nodes[n.name]
		local sounds
		if node_def then
			if node_def.drop and type(node_def.drop) == "string" then
				nnn = node_def.drop
			elseif not node_def.walkable then
				nnn = "air"
			end
		end
		if nnn and nnn ~= n.name and core.registered_nodes[nnn] then
			core.set_node(self.eat_node, {name = nnn})
			if not sounds then
				sounds = def.sounds
			end
			if sounds and sounds.dug then
				core.sound_play(sounds.dug, {pos = self.eat_node, max_hear_distance = 5, gain = 1})
			end
		end
		self.eat_node = nil
		
		
	end,
})


