---- Replace old and boring ents with new and shiny SENTs

ents.TTT = {}

local table = table
local math = math
local pairs = pairs

local function ReplaceSingle(ent, newname)

   -- Ammo that has been mapper-placed will not have a pos yet at this point for
   -- reasons that have to do with being really annoying. So don't touch those
   -- so we can replace them later. Grumble grumble.
   if ent:GetPos() == vector_origin then
      return
   end

   ent:SetSolid(SOLID_NONE)

   local rent = ents.Create(newname)
   rent:SetPos(ent:GetPos())
   rent:SetAngles(ent:GetAngles())
   rent:Spawn()

   rent:Activate()
   rent:PhysWake()

   ent:Remove()
end

local hl2_ammo_replace = {
   ["item_ammo_pistol"] = "item_ammo_pistol_ttt",
   ["item_box_buckshot"] = "item_box_buckshot_ttt",
   ["item_ammo_smg1"] = "item_ammo_smg1_ttt",
   ["item_ammo_357"] = "item_ammo_357_ttt",
   ["item_ammo_357_large"] = "item_ammo_357_ttt",
   ["item_ammo_revolver"] = "item_ammo_revolver_ttt", -- zm
   ["item_ammo_ar2"] = "item_ammo_pistol_ttt",
   ["item_ammo_ar2_large"] = "item_ammo_smg1_ttt",
   ["item_ammo_smg1_grenade"] = "weapon_zm_pistol",
   ["item_battery"] = "item_ammo_357_ttt",
   ["item_healthkit"] = "weapon_zm_shotgun",
   ["item_suitcharger"] = "weapon_zm_mac10",
   ["item_ammo_ar2_altfire"] = "weapon_zm_mac10",
   ["item_rpg_round"] = "item_ammo_357_ttt",
   ["item_ammo_crossbow"] = "item_box_buckshot_ttt",
   ["item_healthvial"] = "weapon_zm_molotov",
   ["item_healthcharger"] = "item_ammo_revolver_ttt",
   ["item_ammo_crate"] = "weapon_ttt_confgrenade",
   ["item_item_crate"] = "ttt_random_ammo"
};

-- Replace an ammo entity with the TTT version
-- Optional cls param is the classname, if the caller already has it handy
local function ReplaceAmmoSingle(ent, cls)
   if cls == nil then cls = ent:GetClass() end

   local rpl = hl2_ammo_replace[cls]
   if rpl then
      ReplaceSingle(ent, rpl)
   end
end

local function ReplaceAmmo()
   for _, ent in pairs(ents.FindByClass("item_*")) do
      ReplaceAmmoSingle(ent)
   end
end

local hl2_weapon_replace = {
   ["weapon_smg1"] = "weapon_zm_mac10",
   ["weapon_shotgun"] = "weapon_zm_shotgun",
   ["weapon_ar2"] = "weapon_ttt_m16",
   ["weapon_357"] = "weapon_zm_rifle",
   ["weapon_crossbow"] = "weapon_zm_pistol",
   ["weapon_rpg"] = "weapon_zm_sledge",
   ["weapon_slam"] = "item_ammo_pistol_ttt",
   ["weapon_frag"] = "weapon_zm_revolver",
   ["weapon_crowbar"] = "weapon_zm_molotov"
};

local function ReplaceWeaponSingle(ent, cls)
   -- Loadout weapons immune
   -- we use a SWEP-set property because at this state all SWEPs identify as weapon_swep
   if ent.AllowDelete == false then
      return
   else
      if cls == nil then cls = ent:GetClass() end

      local rpl = hl2_weapon_replace[cls]
      if rpl then
         ReplaceSingle(ent, rpl)
      end

   end
end


local function ReplaceWeapons()
   for _, ent in pairs(ents.FindByClass("weapon_*")) do
      ReplaceWeaponSingle(ent)
   end
end


-- Remove ZM ragdolls that don't work, AND old player ragdolls.
-- Exposed because it's also done at BeginRound
function ents.TTT.RemoveRagdolls(player_only)
   for k, ent in pairs(ents.FindByClass("prop_ragdoll")) do
      if IsValid(ent) then
         if not player_only and string.find(ent:GetModel(), "zm_", 6, true) then
            ent:Remove()
         elseif ent.player_ragdoll then
            -- cleanup ought to catch these but you know
            ent:Remove()
         end
      end
   end
end

-- People spawn with these, so remove any pickups (ZM maps have them)
local function RemoveCrowbars()
   for k, ent in pairs(ents.FindByClass("weapon_zm_improvised")) do
      ent:Remove()
   end
end

function ents.TTT.ReplaceEntities()
   ReplaceAmmo()
   ReplaceWeapons()
   RemoveCrowbars()
   ents.TTT.RemoveRagdolls()
end


local cls = "" -- avoid allocating
local sub = string.sub
local function ReplaceOnCreated(s, ent)
   -- Invalid ents are of no use anyway
   if not ent:IsValid() then return end

   cls = ent:GetClass()

   if sub(cls, 1, 4) == "item" then
      ReplaceAmmoSingle(ent, cls)
   elseif sub(cls, 1, 6) == "weapon" then
      ReplaceWeaponSingle(ent, cls)
   end
end

local noop = util.noop

GM.OnEntityCreated = ReplaceOnCreated

-- Helper so we can easily turn off replacement stuff when we don't need it
function ents.TTT.SetReplaceChecking(state)
   if state then
      GAMEMODE.OnEntityCreated = ReplaceOnCreated
   else
      GAMEMODE.OnEntityCreated = noop
   end
end

-- GMod's game.CleanUpMap destroys rope entities that are parented. This is an
-- experimental fix where the rope is unparented, the map cleaned, and then the
-- rope reparented.
-- Same happens for func_brush.
local broken_parenting_ents = {
   "move_rope",
   "keyframe_rope",
   "info_target",
   "func_brush"
}

function ents.TTT.FixParentedPreCleanup()
   for _, rcls in pairs(broken_parenting_ents) do
      for k,v in pairs(ents.FindByClass(rcls)) do
         if v.GetParent and IsValid(v:GetParent()) then
            v.CachedParentName = v:GetParent():GetName()
            v:SetParent(nil)

            if not v.OrigPos then
               v.OrigPos = v:GetPos()
            end
         end
      end
   end
end

function ents.TTT.FixParentedPostCleanup()
   for _, rcls in pairs(broken_parenting_ents) do
      for k,v in pairs(ents.FindByClass(rcls)) do
         if v.CachedParentName then
            if v.OrigPos then
               v:SetPos(v.OrigPos)
            end

            local parents = ents.FindByName(v.CachedParentName)
            if #parents == 1 then
               local parent = parents[1]
               v:SetParent(parent)
            end
         end
      end
   end
end

function ents.TTT.TriggerRoundStateOutputs(r, param)
   r = r or GetRoundState()

   for _, ent in pairs(ents.FindByClass("ttt_map_settings")) do
      if IsValid(ent) then
         ent:RoundStateTrigger(r, param)
      end
   end
end


-- CS:S and TF2 maps have a bunch of ents we'd like to abuse for weapon spawns,
-- but to do that we need to register a SENT with their class name, else they
-- will just error out and we can't do anything with them.
local dummify = {
   -- CS:S
   "hostage_entity",
   -- TF2
   "item_ammopack_full",
   "item_ammopack_medium",
   "item_ammopack_small",
   "item_healthkit_full",
   "item_healthkit_medium",
   "item_healthkit_small",
   "item_teamflag",
   "game_intro_viewpoint",
   "info_observer_point",
   "team_control_point",
   "team_control_point_master",
   "team_control_point_round",
   -- ZM
   "item_ammo_revolver"
};

for k, cls in pairs(dummify) do
   scripted_ents.Register({Type="point", IsWeaponDummy=true}, cls, false)
end

-- Cache this, every ttt_random_weapon uses it in its Init
local SpawnableSWEPs = nil
function ents.TTT.GetSpawnableSWEPs()
   if not SpawnableSWEPs then
      local tbl = {}
      for k,v in pairs(weapons.GetList()) do
         if v and v.AutoSpawnable and (not WEPS.IsEquipment(v)) then
            table.insert(tbl, v)
         end
      end

      SpawnableSWEPs = tbl
   end

   return SpawnableSWEPs
end

local SpawnableAmmoClasses = nil
function ents.TTT.GetSpawnableAmmo()
   if not SpawnableAmmoClasses then
      local tbl = {}
      for k,v in pairs(scripted_ents.GetList()) do
         if v and (v.AutoSpawnable or (v.t and v.t.AutoSpawnable)) then
            table.insert(tbl, k)
         end
      end

      SpawnableAmmoClasses = tbl
   end

   return SpawnableAmmoClasses
end

local function PlaceWeapon(swep, pos, ang)
   local cls = swep and WEPS.GetClass(swep)
   if not cls then return end

   -- Create the weapon, somewhat in the air in case the spot hugs the ground.
   local ent = ents.Create(cls)
   pos.z = pos.z + 3
   ent:SetPos(pos)
   ent:SetAngles(VectorRand():Angle())
   ent:Spawn()

   -- Create some associated ammo (if any)
   if ent.AmmoEnt then
      for i=1, math.random(0,3) do
         local ammo = ents.Create(ent.AmmoEnt)

         if IsValid(ammo) then
            pos.z = pos.z + 2
            ammo:SetPos(pos)
            ammo:SetAngles(VectorRand():Angle())
            ammo:Spawn()
            ammo:PhysWake()
         end
      end
   end

   return ent
end

-- Spawns a bunch of guns (scaling with maxplayers count or 
-- by ttt_weapon_spawn_max cvar) at randomly selected
-- entities of the classes given the table
local function PlaceWeaponsAtEnts(spots_classes)
   local spots = {}
   for _, s in pairs(spots_classes) do
      for _, e in pairs(ents.FindByClass(s)) do
         table.insert(spots, e)
      end
   end

   local spawnables = ents.TTT.GetSpawnableSWEPs()
   
   local max = GetConVar( "ttt_weapon_spawn_count" ):GetInt()
   if max == 0 then 
      max = game.MaxPlayers()
      max = max + math.max(3, 0.33 * max)
   end
   
   local num = 0
   local w = nil
   for k, v in RandomPairs(spots) do
      w = table.Random(spawnables)
      if w and IsValid(v) and util.IsInWorld(v:GetPos()) then
         local spawned = PlaceWeapon(w, v:GetPos(), v:GetAngles())

         num = num + 1

         -- People with only a grenade are sad pandas. To get IsGrenade here,
         -- we need the spawned ent that has inherited the goods from the
         -- basegrenade swep.
         if spawned and spawned.IsGrenade then
            w = table.Random(spawnables)
            if w then
               PlaceWeapon(w, v:GetPos(), v:GetAngles())
            end
         end
      end

      if num > max then
         return
      end
   end
end

local function PlaceExtraWeaponsForCSS()
   MsgN("Weaponless CS:S-like map detected. Placing extra guns.")

   local spots_classes = {
      "info_player_terrorist",
      "info_player_counterterrorist",
      "hostage_entity"
   };

   PlaceWeaponsAtEnts(spots_classes)
end

-- TF2 actually has ammo ents and such, but unlike HL2DM there are not enough
-- different entities to do replacement.
local function PlaceExtraWeaponsForTF2()
   MsgN("Weaponless TF2-like map detected. Placing extra guns.")

   local spots_classes = {
      "info_player_teamspawn",
      "team_control_point",
      "team_control_point_master",
      "team_control_point_round",
      "item_ammopack_full",
      "item_ammopack_medium",
      "item_ammopack_small",
      "item_healthkit_full",
      "item_healthkit_medium",
      "item_healthkit_small",
      "item_teamflag",
      "game_intro_viewpoint",
      "info_observer_point"
   };

   PlaceWeaponsAtEnts(spots_classes)
end

-- If there are no guns on the map, see if this looks like a TF2/CS:S map and
-- act appropriately
function ents.TTT.PlaceExtraWeapons()
   -- If ents.FindByClass is constructed lazily or is an iterator, doing a
   -- single loop should be faster than checking the table size.

   -- Get out of here if there exists any weapon at all
   for k,v in pairs(ents.FindByClass("weapon_*")) do
      -- See if it's the kind of thing we would spawn, to avoid the carry weapon
      -- and such. Owned weapons are leftovers on players that will go away.
      if IsValid(v) and v.AutoSpawnable and not IsValid(v:GetOwner()) then
         return
      end
   end

   -- All current TTT mappers use these, so if we find one we're good
   for k,v in pairs(ents.FindByClass("info_player_deathmatch")) do return end

   -- CT spawns on the other hand are unlikely to be seen outside CS:S maps
   for k,v in pairs(ents.FindByClass("info_player_counterterrorist")) do
      PlaceExtraWeaponsForCSS()
      return
   end

   -- And same for TF2 team spawns
   for k,v in pairs(ents.FindByClass("info_player_teamspawn")) do
      PlaceExtraWeaponsForTF2()
      return
   end
end

---- Weapon/ammo placement script importing

local function RemoveReplaceables()
   -- This could be transformed into lots of FindByClass searches, one for every
   -- key in the replace tables. Hopefully this is faster as more of the work is
   -- done on the C side. Hard to measure.
   for _, ent in pairs(ents.FindByClass("item_*")) do
      if hl2_ammo_replace[ent:GetClass()] then
         ent:Remove()
      end
   end

   for _, ent in pairs(ents.FindByClass("weapon_*")) do
      if hl2_weapon_replace[ent:GetClass()] then
         ent:Remove()
      end
   end
end

local function RemoveWeaponEntities()
   RemoveReplaceables()

   for _, cls in pairs(ents.TTT.GetSpawnableAmmo()) do
      for k, ent in pairs(ents.FindByClass(cls)) do
         ent:Remove()
      end
   end

   for _, sw in pairs(ents.TTT.GetSpawnableSWEPs()) do
      local cn = WEPS.GetClass(sw)
      for k, ent in pairs(ents.FindByClass(cn)) do
         ent:Remove()
      end
   end

   ents.TTT.RemoveRagdolls(false)
   RemoveCrowbars()
end

local function RemoveSpawnEntities()
   for k, ent in pairs(GetSpawnEnts(false, true)) do
      ent.BeingRemoved = true -- they're not gone til next tick
      ent:Remove()
   end
end

local function CreateImportedEnt(cls, pos, ang, kv)
   if not cls or not pos or not ang or not kv then return false end

   local ent = ents.Create(cls)
   if not IsValid(ent) then return false end
   ent:SetPos(pos)
   ent:SetAngles(ang)

   for k,v in pairs(kv) do
      ent:SetKeyValue(k, v)
   end

   ent:Spawn()

   ent:PhysWake()

   return true
end

function ents.TTT.CanImportEntities(map)
   if not tostring(map) then return false end
   if not GetConVar("ttt_use_weapon_spawn_scripts"):GetBool() then return false end

   local fname = "maps/" .. map .. "_ttt.txt"

   return file.Exists(fname, "GAME")
end

local function ImportSettings(map)
   if not ents.TTT.CanImportEntities(map) then return end

   local fname = "maps/" .. map .. "_ttt.txt"
   local buf = file.Read(fname, "GAME")

   local settings = {}

   local lines = string.Explode("\n", buf)
   for k, line in pairs(lines) do
      if string.match(line, "^setting") then
         local key, val = string.match(line, "^setting:\t(%w*) ([0-9]*)")
         val = tonumber(val)

         if key and val then
            settings[key] = val
         else
            ErrorNoHalt("Invalid setting line " .. k .. " in " .. fname .. "\n")
         end
      end
   end

   return settings
end

local classremap = {
   ttt_playerspawn = "info_player_deathmatch"
};

local function ImportEntities(map)
   if not ents.TTT.CanImportEntities(map) then return end

   local fname = "maps/" .. map .. "_ttt.txt"

   local buf = file.Read(fname, "GAME")
   local lines = string.Explode("\n", buf)
   local num = 0
   for k, line in ipairs(lines) do
      if (not string.match(line, "^#")) and (not string.match(line, "^setting")) and line != "" and string.byte(line) != 0 then
         local data = string.Explode("\t", line)

         local fail = true -- pessimism

         if data[2] and data[3] then
            local cls = data[1]
            local ang = nil
            local pos = nil

            local posraw = string.Explode(" ", data[2])
            pos = Vector(tonumber(posraw[1]), tonumber(posraw[2]), tonumber(posraw[3]))

            local angraw = string.Explode(" ", data[3])
            ang = Angle(tonumber(angraw[1]), tonumber(angraw[2]), tonumber(angraw[3]))

            -- Random weapons have a useful keyval
            local kv = {}
            if data[4] then
               local kvraw = string.Explode(" ", data[4])
               local key = kvraw[1]
               local val = tonumber(kvraw[2])

               if key and val then
                  kv[key] = val
               end
            end

            -- Some dummy ents remap to different, real entity names
            cls = classremap[cls] or cls

            fail = not CreateImportedEnt(cls, pos, ang, kv)
         end

         if fail then
            ErrorNoHalt("Invalid line " .. k .. " in " .. fname .. "\n")
         else
            num = num + 1
         end
      end
   end

   MsgN("Spawned " .. num .. " entities found in script.")

   return true
end


function ents.TTT.ProcessImportScript(map)
   MsgN("Weapon/ammo placement script found, attempting import...")

   MsgN("Reading settings from script...")
   local settings = ImportSettings(map)

   if tobool(settings.replacespawns) then
      MsgN("Removing existing player spawns")
      RemoveSpawnEntities()
   end

   MsgN("Removing existing weapons/ammo")
   RemoveWeaponEntities()

   MsgN("Importing entities...")
   local result = ImportEntities(map)
   if result then
      MsgN("Weapon placement script import successful!")
   else
      ErrorNoHalt("Weapon placement script import failed!\n")
   end
end
