# Nick Cagematch TTT
This repo includes configuration changes made to [Trouble in Terrorist Town](https://github.com/Facepunch/garrysmod/tree/master/garrysmod/gamemodes/terrortown). Oh, and all of the rest of [Garry's Mod](https://github.com/Facepunch/garrysmod) because TTT isn't a separate repo.

Nick Cagematch contains balance changes to make more equipment and playstyles viable, while not diverging too far from vanilla TTT's gameplay. You can [compare this repo to upstream](https://github.com/Facepunch/garrysmod/compare/master...dennisstewart:nickcagematch-ttt:master) for a list of changes.

## Setup
### SteamCMD
- Install [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD)
- Run the following commands to install / update Counter-Strike Source and Garry's Mod Dedicated Server:
  - `steamcmd`
  - `login anonymous`
  - `app_update 232330 validate` (Counter-Strike Source Dedicated Server)
  - `app_update 4020 validate` (GarrysModDS)
  - `exit`

### Configuring Garry's Mod
- Copy the entire `garrysmod` directory from `nickcagematch-ttt` into the `GarrysModDS` folder created by SteamCMD, overwriting files.
- Update `sv_password` and `sv_region` in `autoexec.cfg` and `server.cfg`
- Ensure `cstrike` in `mount.cfg` is pointed at the right directory for your system

### Starting the server
- Create a bash script to launch `srcds_run` or batch file to launch `srcds` with the following arguments:
  - `-console` - Run in console mode rather than GUI (Windows only)
  - `-condebug` - Writes console output to file
  - `-ip [ip address]` - Specifies which address to listen on, if your device has multiple. Unrelated to your external IP
  - `-game garrysmod` - Specifies the game to play
  - `+gamemode terrortown` - Specifies the gamemode
  - `+map [ttt_mapname]` - Specifies which map to start on
  - `+maxplayers 24` - Sets the max player count
  - `+sv_setsteamaccount [your key]` - This logs you into Steam. You can generate a key [here](https://steamcommunity.com/dev/managegameservers).
  - `+host_workshop_collection [collection id]`  - This installs / updates all the addons in your Steam Workshop collection. Read documentation [here](https://wiki.facepunch.com/gmod/Workshop_for_Dedicated_Servers).

- Putting it all together:
`srcds_run -condebug -ip [ip address] -game garrysmod +gamemode terrortown +map ttt_clue_se_2017 +maxplayers 24 +sv_setsteamaccount [your key] +host_workshop_collection [collection id]`
or
`srcds.exe -console -ip [ip address] -game garrysmod +gamemode terrortown +map ttt_clue_se_2017 +maxplayers 24 +sv_setsteamaccount [your key] +host_workshop_collection [collection id]`
- SRCDS flags and console variables are documented [here](https://developer.valvesoftware.com/wiki/Command_line_options#Source_Dedicated_Server).
- The [FacePunch wiki](https://wiki.facepunch.com/gmod/Downloading_a_Dedicated_Server) wiki has additional details about server hosting.