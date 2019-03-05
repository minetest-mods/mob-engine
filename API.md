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
  
##### General
* `mode`: current mode
* `last_mode`: last mode
* `last_pos`: last pos
* `current_node`: current node
* `last_node`: last node
* `dir`: luaentity direction (in cartesian coordinates of trigonometric axis)
* `drops`: table used for drops
* `stats`: table for MOB stats
* `model`: table for model settings
* `sounds`: table for sound settings
* `combat`: table for combat settings

Registering a mob
-----------------
When you register a MOB, the engine register and manage an entity in Minetest through internal features.

Features
--------
Features run many engine features. Some features depend on others.

### Modes
Modes are usefull for controlling MOB behaviors and they are the main feature of engine. 
Modes can be started randomly by the engine.

### Default modes
* `idle`
* `walk`
* `attack`
* `follow`
* `eat`
* `panic`

#### Methods
* `creatures.register_mode(mode_name, {mode definition})`: Register a mode
  * `mode_name` is a string of mode ID
  * Returns `true` when sucessfull
* `creatures.start_mode(luaentity, mode_name)`: Start a mode in a MOB
* `creatures.mode_animation_update(luaentity)`: Apply animation of current mode
* `creatures.mode_velocity_update(luaentity)`: Apply velocity of current mode
* `creatures.random_yaw_step(luaentity, dtime)`: luaentity step callback for change yaw randomly
  * Uses `update_yaw` from current mode for maximum elapsed time between changes
  * Minimun elapsed time between changes is 33% of `update_yaw`
  * Return `true` when direction is changed

### Rotation
This methods can be used for get and manipulate different direction formats.
It is important to remember that currently the direction works only around the 
vertical axis of the MOB, which allows to define only to which side you want to point.
Exists basically two formats for get or manipulate directions wich this feature:
* *yaw*: vertical y axis rotation defined in radian 
* *dir*: cartesian coordinates of trigonometric axis (y is ever returned 0)

#### Methods
* `creatures.dir_to_yaw(dir)`: Convert cartesian coordinates to axis rotation 
* `creatures.yaw_to_dir(yaw)`: Convert axis rotation for cartesian coordinates
* `creatures.get_dir_p1top2(pos, target_pos)`: Get direction in dir type of position to target pos
* `creatures.get_yaw_p1top2(pos, target_pos)`: Get direction in yaw type of position to target pos
* `creatures.get_random_dir()`: Get random direction in dir type
* `creatures.get_random_yaw()`: Get random direction in yaw type

Methods
-------
Methods are useful for different purposes of the engine.

### Methods
* `creatures.change_hp(self, value)`: Change MOB health points
* `creatures.spawn_particles(pos, velocity, texture_str)`: Spawn particles
* `creatures.kill_mob(luaentity)`: Kill a MOB
* `creatures.drop_items(pos, {drop definition})`: Drops items at position
    * `pos` where to drop Items
* `creatures.find_target(search_obj, pos, radius, search_type, mob_name, xray, no_count)`: Find targets near
  * Returns (#1) table of found objects (as ObjectRef) and (#2) boolean if player near
  * `search_obj` is searching object; can be nil
  * `pos` is starting position for search radius
  * `radius` for searching in blocks/node
  * `search_type` that specifies returned object requirements
    * `"all"` -- returns every object except dropped Items
    * `"hostile"` -- returns every object(creature) that has hostile setting or is player
      * ignores `"mob_type"` if specified
    * `"nonhostile"` -- returns every object that is not hostile or player
    * `"player"` -- returns all players
    * `"mate"` -- returns all objects(creatures) that are of same kind
      * requires `"mob_type"` specifies
  * `mob_type` specifies creature that is ignored or searched, depending on search_type
  * `xray` allows searching through blocks/nodes (default == false)
  * `no_count` skips collecting loop and returns just the boolean player_near
    * table is empty

### Commons
Common methods when working with mob-engine

#### Methods
* `creatures.get_random_index(tb)`: Get a random index from indexed table
* `creatures.throw_error(msg)`: Send debug error menssage
* `creatures.get_dist_p1top2(p1, p2)`: Get distance between two coordinates
  * Return (#1) absolute distance and (#2) distance in vectors xyz
* `creatures.velocity_add(self, v_add)`: Increase object velocity
  * `v_add` in vectors xyz

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
            has_falldamage = false, 	-- deals damage if falling more than 3 blocks <optional>
            has_kockback = false,    	-- get knocked back when hit <optional>
            sneaky = false, 		-- disables step sounds <optional>
            light = {min, max},      	-- which light level will burn creature (requires can_burn = true) <optional>
            
            can_jump = 1, 		-- height in nodes <optional> [NOT WORK]
            dies_when_tamed = false, 	-- stop despawn when tamed <optional> [NOT WORK]
            
        }
        
        modes = {
            idle = {
                chance = 0.5, 		-- number between 0.0 and 1.0 (!!NOTE: sum of all modes MUST be 1.0!!)
                                            -- if chance is 0 then mode is not chosen automatically
                duration = 10, 		-- time in seconds until the next mode is chosen (depending on chance)
                moving_speed = 1, 	-- moving speed(flying/walking) <optional>
                update_yaw = 1 		-- timer in seconds until the looking dir is changed <optional>
                                            -- if moving_speed > 0 then the moving direction is also changed
            },

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
        
        model = {
            mesh = "creatures_sheep.x", 		-- mesh name; see Minetest Documentation for supported filetypes
            textures = {"creatures_sheep.png"}, 	-- table of textures; see Minetest Documentation
            collisionbox = <NodeBox>, 			-- defines mesh collision box; see Minetest Documentation
            rotation = 0.0, 				-- sets rotation offset when moving
            backface_culling = false, 			-- set true to enable backface culling
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


### Sounds definition (`register_mob`)
    {
        name = <name>,        -- sound name as string; see Minetest documentation
        gain = 1.0,           -- sound gain; see Minetest documentation
        distance = <number>,  -- hear distance in blocks/nodes <optional>
        time_min = <time>     -- minimum time in seconds between sounds (random only) <optional>
        time_max = <time>     -- maximum time in seconds between sounds (random only) <optional>
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
