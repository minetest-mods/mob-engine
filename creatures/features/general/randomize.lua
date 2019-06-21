--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

randomize.lua

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


-- Set random values
creatures.set_random_values = function(self, forced)
	local def = creatures.mob_def(self)
	if def.randomize == nil then return end
	
	-- Randomize
	if self.randomized_value == nil then
		if forced == true then
			self.randomized_value = def.randomize.values[math.random(1, #def.randomize.values)]
		else
			return
		end
	end
	
	-- Random texture
	if self.randomized_value.textures then
		self.object:set_properties({textures = self.randomized_value.textures})
	end
	
	-- Random tags
	if self.randomized_value.tags then
		for index,v in pairs(self.randomized_value.tags) do
			self[index] = v
		end
	end
	
	if def.randomize.on_randomize then
		def.randomize.on_randomize(self, self.randomized_value)
	end
end


-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	if not def.randomize then return end
	
	-- Register 'get_staticdata'
	creatures.register_get_staticdata(mob_name, function(self)
		return {
			randomized_value = self.randomized_value,
		}
	end)
	
	-- Register 'on_activate'
	creatures.register_on_activate(mob_name, function(self, staticdata)
		creatures.set_random_values(self, true)
	end)
	
	-- If child
	if def.child then
		
		-- Register 'on_grow'
		creatures.register_on_grow(def.child.name, function(self, new_self) 
			new_self.randomized_value = self.randomized_value
			creatures.set_random_values(new_self)
			-- Adjust texture
			self.object:set_properties({textures = self.randomized_value.textures})
		end)
	end
	
end)

-- Inclute tag in mob node
table.insert(creatures.mob_node_save_tags, "randomized_value")
