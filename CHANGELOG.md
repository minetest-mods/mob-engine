# Change Log
All the remarkable changes of this project will be documented in this file.

This project adhere to [Semantic Versioning](http://semver.org/).


---
## [2.3.2][2.3.2] - 2017-04-10
### Changed
- Update general information

### Fixed
- Fix Minetest Bower integration


---
## [2.3.1][2.3.1] - 2016-02-16
### Added
- Add colored sheep

### Fixed
- Fix Oerrki spawning times (spawns on night as intended)


---
## [2.3.0][2.3.0] - 2016-02-11
### Added
- Add Oerrki
- Add fried eggs

### Fixed
- Fix moveing facement being reset
- Fix chicken model
- Fix sneaky variable not working
- Fix feathers being eatable


---
## [2.2.2][2.2.2] - 2016-02-03
### Added
- Add feature: Eggs can be thrown to spawn chicken (rare)
- Add feature: Chicken drop chicken meat and feather(s) on death

### Fixed
- Fix crash caused by not existing node
- Fix spawn eggs being endless in singleplayer
- Fix searching for target if in panic mode


---
## [2.2.0][2.2.0] - 2015-11-09
### Added
- Add chicken
- Add again sheep spawner (by LNJ)
- Add descriptions to spawners
- Add option to set custom panic and swim animations

### Fixed
- Fix possible crash (reported by bbaez)


---
## [2.1.0][2.1.0] - 2015-10-25
### Added
- Re-add zombies, ghosts and sheep
- Add feature "Feed sheep 5 times with wheat to tame"
- Add death animations
- Add missing documentation of combat values

### Changed
- Change license to modified zlib-License
- Complete rewrite and rename to Creatures MOB-Engine
- Clean up code
- Zombie spawners are now generated in dungeons (if they have more than 4 rooms)
- Reduce sheep model size
- Tweak codestyle a bit

### Fixed
- Fix bug that hostile mobs did sometimes not attack


---
## [1.1.5][1.1.5] - 2015-08-14
### Added
- Add description and screenshot files

### Changed
- Use [colorize instead of textures

### Fixed
- Fix "undeclared global variable" error
- Make sounds mono (fixes loud zombies, sheep)
- Fix sheep states


---
## [1.1.4][1.1.4] - 2014-08-05
### Added
- Add feature: Sheep drop meat when killed

### Changed
- Improve jump, decrease herd radius

### Removed
- Remove double-check

### Fixed
- Fix spawning


---
## [1.1.3][1.1.3] - 2014-05-25

### Changed
- Increase sheep detection radius

### Fixed
- Fix panic of sheep
- Fix crash caused by spawn control
- Fix mobs flood


---
## [1.1.2][1.1.2] - 2014-05-10
### Added
- Add shears
- Add recipe for shears
- Add feature: sheep follows player with wheat

### Fixed
- Fix the flood of the world with items


---
## [1.1.1][1.1.1] - 2014-04-27
### Added
- Add minetest.line_of_sight()
- Add experimental spawning control

### Changed
- Cleanup code
- Max lifetime for zombies

### Fixed
- Fix crashes


---
## [1.1.0][1.1.0] - 2014-03-13
### Added
- Add sheeps

### Changed
- Restructure code

### Fixed
- Fix issues


---
## [1.0.1][1.0.1] - 2014-03-13





---
[2.3.2]: https://github.com/minetest-mods/mob-engine/compare/2.3.1...2.3.2
[2.3.1]: https://github.com/minetest-mods/mob-engine/compare/2.3.0...2.3.1
[2.3.0]: https://github.com/minetest-mods/mob-engine/compare/2.2.2...2.3.0
[2.2.2]: https://github.com/minetest-mods/mob-engine/compare/2.2.0...2.2.2
[2.2.0]: https://github.com/minetest-mods/mob-engine/compare/2.1.0...2.2.0
[2.1.0]: https://github.com/minetest-mods/mob-engine/compare/1.1.5...2.1.0
[1.1.5]: https://github.com/minetest-mods/mob-engine/compare/1.1.4...1.1.5
[1.1.4]: https://github.com/minetest-mods/mob-engine/compare/1.1.3...1.1.4
[1.1.3]: https://github.com/minetest-mods/mob-engine/compare/1.1.2...1.1.3
[1.1.2]: https://github.com/minetest-mods/mob-engine/compare/1.1.1...1.1.2
[1.1.1]: https://github.com/minetest-mods/mob-engine/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/minetest-mods/mob-engine/compare/1.0.1...1.1.0
[1.0.1]: https://github.com/minetest-mods/mob-engine/commit/d5db6af4deb62ac5aa09f221361854378596e5cc
