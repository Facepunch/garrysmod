# Nick Cagematch TTT
This repo includes configuration changes made to [Trouble in Terrorist Town](https://ttt.badking.net/). Oh, and all of the rest of [Garry's Mod](https://github.com/Facepunch/garrysmod) because TTT isn't a separate repo.

Nick Cagematch contains balance changes to make more equipment and playstyles viable, while not diverging too far from vanilla TTT's gameplay. You can [compare this repo to upstream](https://github.com/Facepunch/garrysmod/compare/master...dennisstewart:nickcagematch-ttt:master) for a list of changes.

## Installation
While it used to be possible to copy the entire `garrysmod` directory from nickcagematch-ttt into GarrysModDS, as of 5/20/2024 this is causing errors. As I don't have time to fix it, here are the steps to convert a normal Garry's Mod installation into Cagematch TTT:

- Copy the following the following files and directories and overwriting any collisions:
  - `garrysmod/cfg/autoexec.cfg`
  - `garrysmod/cfg/server.cfg`
  - `garrysmod/gamemodes/terrortown/entities` (and all subdirectories)
  - `garrysmod/gamemodes/terrortown/lang/gamemode/english.lua`
  - `garrysmod/lua/autorun/server/workshop.lua`
- Update `sv_password` and `sv_region` in `autoexec.cfg` and `server.cfg`
- Ensure `cstrike` in `mount.cfg` is pointed at the right directory for your system