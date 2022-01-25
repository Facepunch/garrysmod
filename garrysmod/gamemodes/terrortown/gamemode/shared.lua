GM.Name = "Trouble in Terrorist Town"
GM.Author = "Bad King Urgrain"
GM.Website = "ttt.badking.net"
GM.Version = "shrug emoji"


GM.Customized = false

-- Round status consts
ROUND_WAIT   = 1
ROUND_PREP   = 2
ROUND_ACTIVE = 3
ROUND_POST   = 4

-- Player roles
ROLE_INNOCENT  = 0
ROLE_TRAITOR   = 1
ROLE_DETECTIVE = 2
ROLE_NONE = ROLE_INNOCENT

-- Game event log defs
EVENT_KILL        = 1
EVENT_SPAWN       = 2
EVENT_GAME        = 3
EVENT_FINISH      = 4
EVENT_SELECTED    = 5
EVENT_BODYFOUND   = 6
EVENT_C4PLANT     = 7
EVENT_C4EXPLODE   = 8
EVENT_CREDITFOUND = 9
EVENT_C4DISARM    = 10

WIN_NONE      = 1
WIN_TRAITOR   = 2
WIN_INNOCENT  = 3
WIN_TIMELIMIT = 4

-- Weapon categories, you can only carry one of each
WEAPON_NONE   = 0
WEAPON_MELEE  = 1
WEAPON_PISTOL = 2
WEAPON_HEAVY  = 3
WEAPON_NADE   = 4
WEAPON_CARRY  = 5
WEAPON_EQUIP1 = 6
WEAPON_EQUIP2 = 7
WEAPON_ROLE   = 8

WEAPON_EQUIP = WEAPON_EQUIP1
WEAPON_UNARMED = -1

-- Kill types discerned by last words
KILL_NORMAL  = 0
KILL_SUICIDE = 1
KILL_FALL    = 2
KILL_BURN    = 3

-- Entity types a crowbar might open
OPEN_NO   = 0
OPEN_DOOR = 1
OPEN_ROT  = 2
OPEN_BUT  = 3
OPEN_NOTOGGLE = 4 --movelinear

-- Mute types
MUTE_NONE = 0
MUTE_TERROR = 1
MUTE_ALL = 2
MUTE_SPEC = 1002

COLOR_WHITE  = Color(255, 255, 255, 255)
COLOR_BLACK  = Color(0, 0, 0, 255)
COLOR_GREEN  = Color(0, 255, 0, 255)
COLOR_DGREEN = Color(0, 100, 0, 255)
COLOR_RED    = Color(255, 0, 0, 255)
COLOR_YELLOW = Color(200, 200, 0, 255)
COLOR_LGRAY  = Color(200, 200, 200, 255)
COLOR_BLUE   = Color(0, 0, 255, 255)
COLOR_NAVY   = Color(0, 0, 100, 255)
COLOR_PINK   = Color(255,0,255, 255)
COLOR_ORANGE = Color(250, 100, 0, 255)
COLOR_OLIVE  = Color(100, 100, 0, 255)

include("util.lua")
include("lang_shd.lua") -- uses some of util
include("equip_items_shd.lua")

function DetectiveMode() return GetGlobalBool("ttt_detective", false) end
function HasteMode() return GetGlobalBool("ttt_haste", false) end

-- Create teams
TEAM_TERROR = 1
TEAM_SPEC = TEAM_SPECTATOR

function GM:CreateTeams()
   team.SetUp(TEAM_TERROR, "Terrorists", Color(0, 200, 0, 255), false)
   team.SetUp(TEAM_SPEC, "Spectators", Color(200, 200, 0, 255), true)

   -- Not that we use this, but feels good
   team.SetSpawnPoint(TEAM_TERROR, "info_player_deathmatch")
   team.SetSpawnPoint(TEAM_SPEC, "info_player_deathmatch")
end

-- Everyone's model
local ttt_playermodels = {
   Model("models/player/phoenix.mdl"),
   Model("models/player/arctic.mdl"),
   Model("models/player/guerilla.mdl"),
   Model("models/player/leet.mdl")
};

function GetRandomPlayerModel()
   return table.Random(ttt_playermodels)
end

local ttt_playercolors = {
   all = {
      COLOR_WHITE,
      COLOR_BLACK,
      COLOR_GREEN,
      COLOR_DGREEN,
      COLOR_RED,
      COLOR_YELLOW,
      COLOR_LGRAY,
      COLOR_BLUE,
      COLOR_NAVY,
      COLOR_PINK,
      COLOR_OLIVE,
      COLOR_ORANGE
   },

   serious = {
      COLOR_WHITE,
      COLOR_BLACK,
      COLOR_NAVY,
      COLOR_LGRAY,
      COLOR_DGREEN,
      COLOR_OLIVE
   }
};

CreateConVar("ttt_playercolor_mode", "1")
function GM:TTTPlayerColor(model)
   local mode = GetConVarNumber("ttt_playercolor_mode") or 0
   if mode == 1 then
      return table.Random(ttt_playercolors.serious)
   elseif mode == 2 then
      return table.Random(ttt_playercolors.all)
   elseif mode == 3 then
      -- Full randomness
      return Color(math.random(0, 255), math.random(0, 255), math.random(0, 255))
   end
   -- No coloring
   return COLOR_WHITE
end

-- Kill footsteps on player and client
function GM:PlayerFootstep(ply, pos, foot, sound, volume, rf)
   if IsValid(ply) and (ply:Crouching() or ply:GetMaxSpeed() < 150 or ply:IsSpec()) then
      -- do not play anything, just prevent normal sounds from playing
      return true
   end
end

-- Predicted move speed changes
function GM:Move(ply, mv)
   if ply:IsTerror() then
      local basemul = 1
      local slowed = false
      -- Slow down ironsighters
      local wep = ply:GetActiveWeapon()
      if IsValid(wep) and wep.GetIronsights and wep:GetIronsights() then
         basemul = 120 / 220
         slowed = true
      end
      local mul = hook.Call("TTTPlayerSpeedModifier", GAMEMODE, ply, slowed, mv) or 1
      mul = basemul * mul
      mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * mul)
      mv:SetMaxSpeed(mv:GetMaxSpeed() * mul)
   end
end


-- Weapons and items that come with TTT. Weapons that are not in this list will
-- get a little marker on their icon if they're buyable, showing they are custom
-- and unique to the server.
DefaultEquipment = {
   -- traitor-buyable by default
   [ROLE_TRAITOR] = {
      "weapon_ttt_c4",
      "weapon_ttt_flaregun",
      "weapon_ttt_knife",
      "weapon_ttt_phammer",
      "weapon_ttt_push",
      "weapon_ttt_radio",
      "weapon_ttt_sipistol",
      "weapon_ttt_teleport",
      "weapon_ttt_decoy",
      EQUIP_ARMOR,
      EQUIP_RADAR,
      EQUIP_DISGUISE
   },

   -- detective-buyable by default
   [ROLE_DETECTIVE] = {
      "weapon_ttt_binoculars",
      "weapon_ttt_defuser",
      "weapon_ttt_health_station",
      "weapon_ttt_stungun",
      "weapon_ttt_cse",
      "weapon_ttt_teleport",
      EQUIP_ARMOR,
      EQUIP_RADAR
   },

   -- non-buyable
   [ROLE_NONE] = {
      "weapon_ttt_confgrenade",
      "weapon_ttt_m16",
      "weapon_ttt_smokegrenade",
      "weapon_ttt_unarmed",
      "weapon_ttt_wtester",
      "weapon_tttbase",
      "weapon_tttbasegrenade",
      "weapon_zm_carry",
      "weapon_zm_improvised",
      "weapon_zm_mac10",
      "weapon_zm_molotov",
      "weapon_zm_pistol",
      "weapon_zm_revolver",
      "weapon_zm_rifle",
      "weapon_zm_shotgun",
      "weapon_zm_sledge",
      "weapon_ttt_glock"
   }
};
