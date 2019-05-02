Creatures MOB-Engine API Reference no-version (DEV)
===================================================

IMPORTANT: This WIP & unfinished file contains the definitions of current mob-engine functions
(Some documentation is lacking, so please bear in mind that this WIP file is just to enhance it)


Summary
-------
* Introduction
* General operation
* Registering a mob
* Features
* Methods
* Global Tables
* Definition tables


Introduction
------------
The main purpose of this MOB-Engine is to simplify and organize the creation and interaction of MOBs 
in Minetest. For this, several functionalities and standard operating models are available for encode.


General operation
-----------------
The entire engine operation is based on a set of methods used to organize luaentity callbacks. 
In this way, the features are directed to fulfill specific purposes that the MOB is subject ingame.

#### Luaentity variables
These values are reserved for the engine resources operation.

##### Aspects
* `hp`: health points
* `breath`: breath points
* `stunned`: boolean for if is stunned 
* `physic`: indexed table for internal physic params of engine

##### Timers
* `lifetimer`: timer elapsed while luaentity is active
* `modetimer`: timer elapsed in the current mode
* `mdt`: table for internal timers for modes
* `timers`: table for internal timers of engine
  * `burn`: for burn feature
  * `swim`: for swim feature
  * `drown`: for swim feature
  * `yaw`: for random yaw feature
  * `loc`: for location feature
  * `path`: for MOB path feature
  * `hit_bottom`: for hit bottom feature
  * `mob_node`: for MOB path feature
  * `attack`: for attack interval
  * `follow_search`: for follow search sistem
  * `hunger`: for nutrition feature
  * `mating`: for mating feature
  * `child_grow`: for grow child feature
  
##### General
* `mode`: current mode
* `last_mode`: last mode
* `last_pos`: last pos
* `can_fly`: is true if MOB can fly
* `can_jump`: block height MOB can jump
* `remove`: mark to remove MOB
* `current_node`: current node
* `last_node`: last node
* `dir`: luaentity direction (in cartesian coordinates of trigonometric axis)
* `drops`: table used for drops
* `stats`: table for MOB stats
* `model`: table for model settings
* `sounds`: table for sound settings
* `combat`: table for combat settings
* `path`: table for path params
* `mob_node`: table for mob node params
* `walk_around_time`: time of walk around mode
* `fly_time`: time limit of fly
* `is_died`: true if died
* `satiated`: boolean for if MOB is nourished
* `last_satiated_day`: last satiated day
* `weight`: MOB weight in kilograms
* `is_child`: is true when MOB is a child



Registering a mob
-----------------
When you register a MOB, the engine register and manage an entity in Minetest through internal features.

#### Methods
* `creatures.register_mob(mob_name, {mob definition})`: Register a MOB
  * `mob_name` is a string of MOB ID
  * Returns `true` when sucessfull
* `creatures.mob_def(luaentity)`: Get MOB definitions

Features
--------
Features run many engine features. Some features depend on others.

### Callbacks
The callbacks allow to systematize the operation of the engine and registered MOBs.
For default, when a registered callback return (#1) `true` then prevent run next registered callbacks

#### Methods
* `creatures.register_on_register_mob(func)`: Register callback for when MOB is registered
  * `func` is a function `function(mob_name, mob_def) end`
* `creatures.register_on_step(mob_name, func)`: Register callback for when run default on_step callback
  * `func` is a function `function(self, dtime) end`
* `creatures.register_on_punch(mob_name, func)`: Register callback for when run default on_step callback
  * `func` is a function `function(self, puncher, time_from_last_punch, tool_capabilities, dir) end`
* `creatures.register_on_rightclick(mob_name, func)`: Register callback for when run default on_rightclick callback
  * `func` is a function `function(self, clicker) end`
* `creatures.register_get_staticdata(mob_name, func)`: Register callback for when run default get_staticdata callback
  * `func` is a function `function(self) end`
    * This function need return staticdata in a table
* `creatures.register_on_activate(mob_name, func)`: Register callback for when run default on_activate callback
  * `func` is a function `function(self, staticdata) end`
* `creatures.register_on_clear_objects(mob_name, func)`: Register callback for when run minetest.clear_objects
  * `func` is a function `function(self) end`
* `creatures.register_on_hitted(func)`: Register callback for when MOB is hitted
  * `func` is a function `function(self, puncher, time_from_last_punch, tool_capabilities, dir) end`
* `creatures.register_on_clear_objects(mob_name, func)`: Register callback for when run minetest.clear_objects
  * `func` is a function `function(self) end`
* `creatures.register_on_change_hp(mob_name, func)`: Register callback for when run minetest.on_change_hp
  * `func` is a function `function(self, hp) end`
* `creatures.register_on_die_mob(mob_name, func)`: Register callback for when run minetest.on_die_mob
  * `func` is a function `function(self, reason) end`
* `creatures.on_step(mob_name, self, dtime)`: Run default on_step callback
* `creatures.on_punch(mob_name, self, puncher, time_from_last_punch, tool_capabilities, dir)`: Register callback for when run default on_punch callback
* `creatures.on_rightclick(mob_name, self, clicker)`: Run default on_rightclick callback
* `creatures.get_staticdata(mob_name, self)`: Run default get_staticdata callback
* `creatures.on_activate(mob_name, self, staticdata)`: Run default on_activate callback
* `creatures.on_clear_objects(mob_name, self)`: Run on_clear_objects callback
* `creatures.on_hitted(self, puncher, time_from_last_punch, tool_capabilities, dir)`: Run on_hitted callback
* `creatures.on_change_hp(self, hp)`: Run on_change_hp callback
  * Return (#1) `true` and (#2) HP changed
* `creatures.on_die_mob(self, [reason])`: Run on_die_mob callback

### Modes
Modes are usefull for controlling MOB behaviors and they are the main feature of engine. 
Modes can be started randomly by the engine.

### Default modes
* `idle`
* `walk`
* `fly`
* `attack`
* `follow`
* `eat`
* `panic`

#### Methods
* `creatures.register_mode(mode_name, {mode definition})`: Register a mode
  * `mode_name` is a string of mode ID
  * Returns `true` when sucessfull
* `creatures.register_idle_mode(mode_name)`: Register a custom idle mode
* `creatures.mode_def(luaentity, [mode_name])`: Get mode definitions
  * If `mode_name` is nil, current mode is used
* `creatures.start_mode(luaentity, mode_name)`: Start a mode in a MOB
* `creatures.mode_animation_update(luaentity)`: Apply animation of current mode
* `creatures.mode_velocity_update(luaentity)`: Apply velocity of current mode
* `creatures.random_yaw_step(luaentity, dtime)`: luaentity step callback for change yaw randomly
  * Uses `update_yaw` from current mode for maximum elapsed time between changes
  * Minimun elapsed time between changes is 33% of `update_yaw`
  * Return `true` when direction is changed

### MOB Node

#### MOB Node control
MOB is controlled by stored variables in the entity table named `mob_node`.
Table values:
* `pos`: MOB node coordinates
* `hashlink`: Hash of link between MOB node and MOB
* `on_set_mob_node`: Function runned when a new MOB is setted in MOB node
* `on_reset_mob_node`: Function runned when a new MOB is resetted in MOB node
MOB node is controlled by stored strings in node metadata
* `"creatures:hashlink"`: Hash of link between MOB node and MOB
* `"creatures:saved_mob"`: To check if MOB is saved
* `"creatures:saved_mob_pos"`: To save serialized pos of MOB

#### Methods
* `creatures.register_mob_node(node_name, {mob node definition})`: Register a MOB node
  * `node_name` is a itemstring of registered node
* `creatures.check_mob_node(self)`: Check if a MOB has a node

### MOB Path
This functionality is used to plan and execute intelligent movement through a path.

#### Path control
The movement execution is controlled by stored variables in the entity table named `path`.
Table values:
* `status`: Bool value for if moving in a path
* `time`: For check next location of path (internal use)
* `speed`: Speed moviment
* `on_finish`: Function runned when finish path
* `on_interrupt`: Function runned when interrupt path

#### Methods
* `creatures.path_step(luaentity, dtime)`: Run step for path feature
* `creatures.new_path(self, target_pos, speed, [on_finish], [on_interrupt], {path finder definition})`: Make a new path to MOB
  * Return `true` if sucess or `false` if there is no path
  * `speed` is the movement velocity
  * `on_finish` is a function `function(luaentity) ... end` for when finish path
  * `on_interrupt` is a function `function(luaentity) ... end` for when interrupt path

### Rotation
This methods can be used for get and manipulate different direction formats.
It is important to remember that currently the direction works only around the 
vertical axis of the MOB, which allows to define only to which side you want to point.
Exists basically two formats for get or manipulate directions wich this feature:
* *yaw*: vertical y axis rotation defined in radian 
* *dir*: cartesian coordinates of trigonometric axis (y is returned 0 ir `include_y` is `nil`)

#### Methods
* `creatures.dir_to_yaw(dir)`: Convert cartesian coordinates to axis rotation 
* `creatures.yaw_to_dir(yaw)`: Convert axis rotation for cartesian coordinates
* `creatures.get_dir_p1top2(pos, target_pos, [include_y])`: Get direction in dir type of position to target pos
* `creatures.get_yaw_p1top2(pos, target_pos)`: Get direction in yaw type of position to target pos
* `creatures.get_random_dir()`: Get random direction in dir type
* `creatures.get_random_yaw()`: Get random direction in yaw type
* `creatures.set_dir(luaentity, dir)`: Set a rotation in dir for the MOB
* `creatures.set_yaw(luaentity, yaw)`: Set a rotation in yaw for the MOB
* `creatures.send_in_dir(luaentity, speed, [dir], [include_y])`: Start MOB moviment in a dir
  * if `include_y` is true then start moviment in y direction
  * if `dir` is nil uses `luaentity.dir` direction
* `creatures.send_in_yaw(luaentity, speed, [yaw])`: Start MOB moviment in a yaw
  * if `yaw` is nil uses `luaentity.dir` direction

### Feeder

#### Methods
* `creatures.register_feeder_node(node_name, {feeder node definition}, [secondary])`: Register feeder node
* `creatures.set_feeder_level(pos, supply_or_item)`: Set feeder level
  * `supply_or_item` can be a itemname for resupply feeder or a number to change feeder level
  * Returns the number of how many levels have changed
  * `secondary` to execute this method like secondary mode (for internal use) 

Methods
-------
Methods are useful for different purposes of the engine.

### Methods
* `creatures.change_hp(self, value, [reason])`: Change MOB health points
  * `reason` is atring of reason TAG (eg. `"modname:reason_tag"`)
* `creatures.spawn_particles(pos, velocity, texture_str)`: Spawn particles
* `creatures.kill_mob(luaentity, [reason])`: Kill a MOB
* `creatures.drop_items(pos, {drop definition})`: Drops items at position
    * `pos` where to drop Items
* `creatures.find_target(pos, radius, {find target definition})`: Find targets near
  * Returns (#1) table of found objects (as ObjectRef) and (#2) boolean if player near
  * `pos` is starting position for search radius
  * `radius` for searching in blocks/node
* `creatures.set_animation(luaentity, anim_name)`: Set an animation
  * `anim_name` is an animation defined in the MOB
* `creatures.path_finder(luaentity, target_pos, {path finder definition})`: Path finder
* `creatures.int(n)`: Convert float to interger number
* `creatures.get_node_pos_object(object)`: Get node coordinate of central base object
* `creatures.check_free_pos(pos)`: Check free pos
* `creatures.get_under_walkable_height(pos, min_y, max_y)`: Get under walkable node pos
  * Return a pos for between `min_y` and `max_y` or `nil`
* `creatures.get_under_walkable_nodes_in_area(minp, maxp)`: Get under walkable node pos in area
  * Return a table with all found node pos

### Commons
Common methods when working with mob-engine

#### Methods
* `creatures.throw_error(msg)`: Send debug error menssage
* `creatures.int(float_number)`: Round numeric value to integer
  * If >.5 apply `math.ceil` else apply `math.floor`
* `creatures.copy_tb(table)`: Copy a dinamic table
* `creatures.get_random_index(tb)`: Get a random index from indexed table
* `creatures.get_random_from_table(table, [remove_value])`: Get and value from table
  * Return (#1) value and (#2) table
  * If `remove_value` is `true`, remove selected value from table
* `creatures.get_dist_p1top2(p1, p2)`: Get distance between two coordinates
  * Return (#1) absolute distance and (#2) distance in vectors xyz
* `creatures.velocity_add(self, v_add)`: Increase object velocity
  * `v_add` in vectors xyz
* `creatures.make_collisionbox(width, height)`: Make a collision box
* `creatures.get_collisionbox(ObjectRef)`: Get a collision box from object
* `creatures.check_mob_in_pos(luaentity, pos)`: Check MOB collision with nodes
  * Return `true` if no collide
* `creatures.get_far_node(pos)`: Get a node
* `creatures.check_free_pos(pos)`: Check if is walkable for a MOB

Global tables
-------------
* `creatures.registered_mobs`: Registered mob definitions, indexed by mob name
* `creatures.registered_modes`: Registered mode definitions, indexed by mode name
* `creatures.registered_mob_nodes`: Registered mob mode definitions, indexed by node name
* `creatures.registered_feeder_nodes`: Registered feeder node definitions, indexed by node name

Definition tables
-----------------

### MOB definition (`register_mob`)

    {
        
        stats = {
            hp = 5, 			-- 1 HP = "1/2 player heart"
            breath = 5,			-- 1 = "1/2 player bubble"
            hostile = false, 		-- is mob hostile (required for mode "attack") <optional>
            lifetime = 300, 		-- after which time mob despawns, in seconds <optional>
            can_swim = false, 		-- can mob swim or will it drown <optional>
            can_fly = false, 		-- allows to fly (requires mode "fly") and disable step sounds <optional>
            can_panic = false, 		-- runs fast around when hit (requires mode "walk") <optional>
            has_kockback = false,    	-- get knocked back when hit <optional>
            sneaky = false, 		-- disables step sounds <optional>
            light = {min, max},      	-- which light level will burn creature (requires can_burn = true) <optional>
            
            max_drop = 2, 		-- height in nodes <optional> (Default is 2)
            has_falldamage = false, 	-- deals damage if falling more than max_drop blocks <optional>
            
            can_jump = 1, 		-- height in nodes <optional> (Default is 1)
            
            dies_when_tamed = false, 	-- stop despawn when tamed <optional> [NOT WORK]
            
        }
        
        hunger = { -- MOB hunger (this ignore lifetime) <optional>
            days_interval = 5, -- Interval to eat each node
            water = true, -- true if need drik water <optional>
            water_nodes = {"modname:node"}, -- Table of nodes for drink <optional> (default is {"group:water"})
            food = { -- params for eat foods <optional>
                nodes = {"modname:node"} -- Table of nodes for eat
            },
        },
        
        modes = {
            idle = {
                chance = 0.5, 		--[[ number between 0.0 and 1.0 (!!NOTE: sum of all modes MUST be 1.0!!)
                                             if chance is 0 then mode is not chosen automatically]]
                duration = 10, 		-- time in seconds until the next mode is chosen (depending on chance)
                moving_speed = 1, 	-- moving speed(flying/walking) <optional>
                update_yaw = 1 		--[[ timer in seconds until the looking dir is changed <optional>
                                             if moving_speed > 0 then the moving direction is also changed ]]
            },
            walk = {
                <same as above>, 	-- all possible values like specified above
                search_radius = 5, 	-- Radius for search a node for walk <optional>
            }
            -- special modes
            attack = {<same as above>}
            follow = {
                <same as above>, 	-- all possible values like specified above
                radius = <number>, 	-- search distance in blocks/nodes for player
                timer = <time>, 	-- time in seconds between each check for player
                items = <table> 	-- table of items to make mob follow in format {<Itemname>, <Itemname>}; e.g. {"farming:wheat"}
            },
            eat = {
                <same as above>, 	-- all possible values like specified above
                nodes = <table> 	-- eatable nodes in format {<Itemname>, <Itemname>}; e.g. {"default:dirt_with_grass"}
            },
        },
        
        child = {
            name = "mod:mobname", 	-- MOB name
            days_to_grow = 5, 		-- Days to grow
            on_grow = func,             -- Function `function(old_luaentity, new_luaentity) end`
        }
        
        mating = {
            child_mob = "modname:mob", 	-- Name of child MOB
            interval = 2, 		-- Interval (in days) between mating
            spawn_type = "mob_node", 	--[[ Type for spawn child MOB
                                                 "mob_node" spawn child in MOB node]]
        },
        
        model = {
            mesh = "creatures_sheep.x", 		-- mesh name; see Minetest Documentation for supported filetypes
            textures = {"creatures_sheep.png"}, 	-- table of textures; see Minetest Documentation
            collisionbox_width = 0.9, 			-- defines mesh width collision box;
            collisionbox_height = 0.9, 			-- defines mesh height collision box;
            rotation = 0.0, 				-- sets rotation offset when moving
            backface_culling = false, 			-- set true to enable backface culling
            vision_height = 0,                          -- MOB viewing height <optional> (default is 0)
            weight = 45, 				-- Weight (in kilograms) used to calculate some physical aspects <optional> (default is 45)
            animations = { 				-- animation used if defined <optional>
            idle = {animation definition}, 		-- see #AnimationDef
            ... -- depends on modes (must correspond to be used);
            ^ supported "special modes": eat, follow, attack, death, swim, panic
        },
        
        sounds = {
            on_damage = {sounds definition},            -- see #SoundDef <optional>
            on_death = {sounds definition},             -- see #SoundDef <optional>
            swim = {sounds definition},                 -- see #SoundDef <optional>
            random = {                          	-- depends on mode <optional>
                idle = {sounds definition}, 		-- <optional>
                ... -- depends on modes (must correspond to be used); supports "special modes": eat, follow, attack
            },
        },
        
        drops = {#ItemDrops},     -- see #ItemDrops definition <optional>
            ^ can also be a function; receives "self" reference
        
        combat = { 			-- specifies behavior of hostile mobs in "attack" mode
            attack_damage = 1, 		-- how much damage deals each hit
            attack_speed = 0.6, 	-- time in seconds between hits
            attack_radius = 1.1, 	-- distance in blocks mob can reach to hit
            
            search_enemy = true, 	-- true to search enemies to attack
            search_timer = 2, 		-- time in seconds to search an enemy (only if none found yet)
            search_radius = 12, 	-- radius in blocks within enemies are searched
            search_type = "player", 	-- what enemy is being searched (see types at creatures.findTarget())
        }
        
        spawning = {                  -- defines spawning in world <optional>
            
            abm_nodes = {
                spawn_on = {<table>}, 	-- on what nodes mob can spawn <optional>
                    ^ table  -- nodes and groups in table format; e.g. {"group:stone", "default:stone"}
                neighbors = {}, 	-- what node should be neighbors to spawnnode <optional>
                    ^ can be nil or table as above; "air" is forced always as neighbor
            },
            abm_interval = <interval>, 	-- time in seconds until Minetest tries to find a node with set specs
            abm_chance = <chance>, 	-- chance is 1/<chance>
            
            max_number = <number>, 	-- maximum mobs of this kind per mapblock(16x16x16)
            
            number = <amount>,          -- how many mobs are spawned if found suitable spawn position
                ^ amount  -- number or table {min = <value>, max = <value>}
                
            time_range = <range>, 	-- time range in time of day format (0-24000) <optional>
                ^ range  -- table {min = <value>, max = <value>}
                
            light = <range>, 		-- min and max lightvalue at spawn position <optional>
                ^ range  -- table {min = <value>, max = <value>}
                
            height_limit = <range>, 	-- min and max height (world Y coordinate) <optional>
                ^ range  -- table {min = <value>, max = <value>}

            spawn_egg = { 		-- is set a spawn_egg is added to creative inventory <optional>
                description = <desc>, 	-- Item description as string
                texture = <name>, 	-- texture name as string
            },

            spawner = { -- is set a spawner_node is added to creative inventory <optional>
                range = <number>, 	-- defines an area (in blocks/nodes) within mobs are spawned
                number = <number>, 	-- maxmimum number of mobs spawned in area defined via range
                description = <desc>, 	-- Item description as string <optional>
                light = <range>, 	-- min and max lightvalue at spawn position <optional>
                    ^ range  -- table {min = <value>, max = <value>}
            }
        },
        
        on_rightclick = func(self, clicker) -- called when mob is rightclicked
            ^ prevents default action when returns boolean true

        on_punch = func(self, puncher) -- called when mob is punched (puncher can be nil)
            ^ prevents default action when returns boolean true

        on_step = func(self, dtime) -- called each server step
            ^ prevents default action when returns boolean true

        on_activate = func(self, staticdata) -- called when mob (re-)actived
            ^ Note: staticdata is deserialized by MOB-Engine (including costum values)

        get_staticdata = func(self) -- called when mob is punched (puncher can be nil)
            ^ must return a table to save mob data (serialization is done by MOB-Engine)
            ^ e.g: return {costum_mob_data = self.my_value}
        
    }


### Animation definition (`register_mob`)
    {
        start = 0,    -- animation start frame
        stop = 80,    -- animation end frame
        speed = 15,   -- animation speed
        loop = true,  -- if false, animation if just played once <optional>
        duration = 1  -- only supported in "death"-Animation, sets time the animation needs until mob is removed <optional>
    }


### Feeder node definition (`register_feeder_node`)
    {
        supply = {
            ["farming:straw"] = 5,
        },
        max_food = 100,
        node_steps = {
            {
                food = 0,
                name = "sheep:sheep_feeder",
            },
            {
                food = 1,
                name = "sheep:sheep_feeder_1",
            },
        },
    }

### Sounds definition (`register_mob`)
    {
        name = <name>,        -- sound name as string; see Minetest documentation
        gain = 1.0,           -- sound gain; see Minetest documentation
        distance = <number>,  -- hear distance in blocks/nodes <optional>
        time_min = <time>     -- minimum time in seconds between sounds (random only) <optional>
        time_max = <time>     -- maximum time in seconds between sounds (random only) <optional>
    }


### Path finder definition (`path_finder`)
    {
        search_radius = 10,   -- search radius for search <optional> (default is 10)
        perssist = 5,         -- max steps for a path <optional> (default is search_radius + 5)
        max_jump = 1,         -- max number of nodes for climb on a node in the path <optional> (default is 1)
        max_drop = 2,         -- max number of nodes for fallen in the path <optional> (default is 2)
        target_dist = 1,      -- target distance to reach between MOB and target_pos <optional> (default is 1)
    }


### Find target definition (`find_target`)
    {
        xray = false,              -- allows searching through blocks/nodes (default == false)
        no_count = false,          -- skips collecting loop and returns just the boolean player_near
                                          table is empty
        search_type = "type_name", --[[ that specifies returned object requirements
                                            "all" returns every object except dropped Items
                                            "hostile" returns every object(creature) that has hostile setting or is player
                                                ignores "mob_type" if specified
                                            "nonhostile" returns every object that is not hostile or player
                                            "player" returns all players
                                            "mate" returns all objects(creatures) that are of same kind
                                                requires "mob_type" specifies]]
        mob_name = "mob_name" ,    -- specifies creature that is ignored or searched, depending on search_type
        ignore_obj = {obj1, ...},  -- is searching object; can be nil
    }


### MOB Node definition (`register_mob_node`)
    {
        mob_name = "creatures:sheep",    -- MOB name
        search_mob = true,               -- search a MOB to the node
        on_set_mob_node = <function>,    --[[ callback for on set MOB node
                                              <function> is 'function(pos, luaentity) end'
        on_reset_mob_node = <function>,  --[[ callback for on reset MOB node
                                              <function> is 'function(pos) end'
        on_save_mob = <function>,        --[[ callback for on save MOB
                                              <function> is 'function(pos, luaentity) end'
        on_load_mob = <function>,        --[[ callback for on load MOB
                                              <function> is 'function(pos, luaentity) end'
    }


### Drop definition
    {
        {
            <Itemname>, -- e.g. "default:wood"
            <amount>,   -- either a <number> or table in format {min = <number>, max = <number>}; optional
            <rarity>    -- "chance = <value>": <value> between 0.0 and 1.0
        },
    }

Example 
Will drop with a chance of 30%  1 to 3 items of type "default:wood"
and with a chance of 100% 2 items of type "default:stone"

    {
        {
            "default:wood", 
            {min = 1, max = 3}, 
            chance = 0.3
        },
        {
            "default:stone", 
            2,
            nil,
        }
    }
