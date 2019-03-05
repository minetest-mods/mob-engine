--[[
= Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

spawnParticles.lua

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

-- Spawn particles
creatures.spawn_particles = function(...) end
if creatures.params.disable_particles ~= true then
	creatures.spawn_particles = function(pos, velocity, texture_str)
		local vel = vector.multiply(velocity, 0.5)
		vel.y = 0
		core.add_particlespawner({
			amount = 8,
			time = 1,
			minpos = vector.add(pos, -0.7),
			maxpos = vector.add(pos, 0.7),
			minvel = vector.add(vel, {x = -0.1, y = -0.01, z = -0.1}),
			maxvel = vector.add(vel, {x = 0.1,  y = 0,  z = 0.1}),
			minacc = vector.new(),
			maxacc = vector.new(),
			minexptime = 0.8,
			maxexptime = 1,
			minsize = 1,
			maxsize = 2.5,
			texture = texture_str,
		})
	end
end
