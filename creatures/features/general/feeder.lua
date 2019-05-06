--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2019 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

feeder.lua

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

creatures.feeder = {}

-- Update feeder
local update_feeder_node = function(pos)
	local nodename = minetest.get_node(pos).name
	
	local def = creatures.registered_feeder_nodes[nodename]
	if not def.node_steps then return end
	
	local meta = minetest.get_meta(pos)
	local food = meta:get_float("food") or 0
	
	
	local selected_node_step = def.node_steps[1]
	
	local i = table.maxn(def.node_steps)
	while i > 1 do
		local node_step = def.node_steps[i]
		-- Check node step
		if node_step.food <= food then
			selected_node_step = def.node_steps[i]
			break
		end
		i = i - 1
	end
	local node = minetest.get_node(pos)
	node.name = selected_node_step.name
	minetest.swap_node(pos, node)
end

-- Set supply level
creatures.set_feeder_level = function(pos, supply_or_itemstack)
	supply_or_itemstack = supply_or_itemstack or 0
	
	-- Definitions
	local nodename = minetest.get_node(pos).name
	local def = creatures.registered_feeder_nodes[nodename]
	
	-- Node Meta
	local meta = minetest.get_meta(pos)
	local food = meta:get_float("food") or 0
	local old_food = food + 0
	
	local supply = supply_or_itemstack
	local take = 0
	
	if type(supply_or_itemstack) ~= "number" then 
		
		local item_supply_def = def.supply[supply_or_itemstack:get_name()]
		
		local count = supply_or_itemstack:get_count()
		take = item_supply_def.count or 1
		
		if count < take then
			take = count
		end
		
		-- supply number
		supply = def.supply[supply_or_itemstack:get_name()].food or 1
		supply = supply * take
	end
	
	-- Save new food number at node
	food = food + supply
	if food > def.max_food then
		food = def.max_food
	elseif food < 0 then
		food = 0
	end
	meta:set_float("food", food)
	
	-- Rename infotext
	local percent = math.ceil((food/def.max_food)*100)
	meta:set_string("infotext", "Food: "..percent.."% ("..food..")")
	update_feeder_node(pos)
	
	return (old_food - food), take
end

-- Register node feeder
creatures.registered_feeder_nodes = {}
creatures.register_feeder_node = function(nodename, def, secondary)
	creatures.registered_feeder_nodes[nodename] = {}
	
	creatures.registered_feeder_nodes[nodename].supply = def.supply
	creatures.registered_feeder_nodes[nodename].max_food = def.max_food
	creatures.registered_feeder_nodes[nodename].node_steps = def.node_steps
	
	local groups = creatures.copy_tb(minetest.registered_items[nodename].groups)
	groups.mob_feeder = 1
	
	creatures.registered_feeder_nodes[nodename].old_on_rightclick = creatures.copy_tb(minetest.registered_items[nodename].on_rightclick)
	creatures.registered_feeder_nodes[nodename].old_on_place = creatures.copy_tb(minetest.registered_items[nodename].on_place)
	creatures.registered_feeder_nodes[nodename].old_on_dig = creatures.copy_tb(minetest.registered_items[nodename].on_dig)
	minetest.override_item(nodename, {
		stack_max = 1,
		groups = groups,
		
		on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			
			if itemstack and itemstack:get_name() and creatures.registered_feeder_nodes[nodename].supply[itemstack:get_name()] then
				
				local s, take = creatures.set_feeder_level(pos, itemstack)
				
				if s ~= 0 then
				
					itemstack:take_item(take)
					
				end
				
			end
			
			if creatures.registered_feeder_nodes[nodename].old_on_rightclick then
				return creatures.registered_feeder_nodes[nodename].old_on_rightclick(pos, node, player, itemstack, pointed_thing)
			end
			return itemstack
		end,
		
		on_place = function(itemstack, placer, pointed_thing)
			
			if not pointed_thing or not pointed_thing.above then return end
			
			local meta = itemstack:get_meta()
			local supply = meta:get_float("food")
			
			-- Verifica se esta acessando outro node
			local under = pointed_thing.under
			local node = minetest.get_node(under)
			local defnode = minetest.registered_nodes[node.name]
			if defnode and defnode.on_rightclick and
				((not placer) or (placer and not placer:get_player_control().sneak)) then
				return defnode.on_rightclick(under, node, placer, itemstack,
					pointed_thing) or itemstack
			end
			
			if not minetest.item_place(itemstack, placer, pointed_thing) then
				return itemstack
			end
			
			creatures.set_feeder_level(pointed_thing.above, supply)
			
			itemstack:take_item()
			if creatures.registered_feeder_nodes[nodename].old_on_place then
				return creatures.registered_feeder_nodes[nodename].old_on_place(itemstack, placer, pointed_thing)
			end
			return itemstack
			
		end,
		
		on_dig = function(pos, node, digger)
			local meta = minetest.get_meta(pos)
			local inv = digger:get_inventory()
			
			local nodename = minetest.get_node(pos).name
			local def = creatures.registered_feeder_nodes[nodename]
			local food = meta:get_float("food")
			local percent = math.ceil((food/def.max_food)*100)
			
			local itemstack = {name=nodename, count=1, meta={
				["food"] = food,
				["description"] = minetest.registered_items[nodename].description .. " ("..percent.."%)"
			}}
			
			if inv:room_for_item("main", itemstack) then
						
				-- Coloca no inventario
				inv:add_item("main", itemstack)
			else
				-- Dropa no local
				minetest.add_item(pos, itemstack)
			end
			
			minetest.remove_node(pos)
			
			if creatures.registered_feeder_nodes[nodename].old_on_dig then
				return creatures.registered_feeder_nodes[nodename].old_on_dig(pos, node, digger)
			end
		end,
	})
	
	-- Secondary registration
	if secondary ~= true then
		-- Register feeder steps
		for _,node_step in ipairs(def.node_steps or {}) do 
			if node_step.name ~= nodename then
				creatures.register_feeder_node(node_step.name, def, true)
			end
		end
	end
	
end
