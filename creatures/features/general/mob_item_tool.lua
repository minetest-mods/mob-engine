--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

mob_item_tool.lua

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


-- Register 'on_register_mob'
creatures.register_on_register_mob(function(mob_name, def)
	
	if not def.mob_item_tool then return end
	
	-- Register 'on_activate'
	creatures.register_on_rightclick(mob_name, function(self, clicker)
		
		local itemstack = clicker:get_wielded_item()
		
		if not def.mob_item_tool[itemstack:get_name()] then return end
		
		local item_def = def.mob_item_tool[itemstack:get_name()]
		
		-- Check if disabled in child MOBs
		if item_def.disabled_in_child == true and self.is_child then return end
		
		-- Run callback
		local r
		if item_def.on_use then
			local new_itemstack
			r, new_itemstack = item_def.on_use(self, clicker, itemstack)
			itemstack = new_itemstack or itemstack
		end
		
		-- Add wear
		if item_def.wear and r == true then
			itemstack:add_wear(item_def.wear)
		end
		
		-- Update item
		clicker:set_wielded_item(itemstack)
		
	end)
	
	
end)
