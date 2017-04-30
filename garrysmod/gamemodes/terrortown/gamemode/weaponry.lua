
include("weaponry_shd.lua") -- inits WEPS tbl

---- Weapon system, pickup limits, etc

local IsEquipment = WEPS.IsEquipment

-- Prevent players from picking up multiple weapons of the same type etc
function GM:PlayerCanPickupWeapon(ply, wep)
   if not IsValid(wep) or not IsValid(ply) then return end
   if ply:IsSpec() then return false end

   -- Disallow picking up for ammo
   if ply:HasWeapon(wep:GetClass()) then
      return false
   elseif not ply:CanCarryWeapon(wep) then
      return false
   elseif IsEquipment(wep) and wep.IsDropped and (not ply:KeyDown(IN_USE)) then
      return false
   end

   local tr = util.TraceEntity({start=wep:GetPos(), endpos=ply:GetShootPos(), mask=MASK_SOLID}, wep)
   if tr.Fraction == 1.0 or tr.Entity == ply then
      wep:SetPos(ply:GetShootPos())
   end

   return true
end

-- Cache role -> default-weapons table
local loadout_weapons = nil
local function GetLoadoutWeapons(r)
   if not loadout_weapons then
      local tbl = {
         [ROLE_INNOCENT] = {},
         [ROLE_TRAITOR]  = {},
         [ROLE_DETECTIVE]= {}
      };

      for k, w in pairs(weapons.GetList()) do
         if w and type(w.InLoadoutFor) == "table" then
            for _, wrole in pairs(w.InLoadoutFor) do
               table.insert(tbl[wrole], WEPS.GetClass(w))
            end
         end
      end

      loadout_weapons = tbl
   end

   return loadout_weapons[r]
end

-- Give player loadout weapons he should have for his role that he does not have
-- yet
local function GiveLoadoutWeapons(ply)
   local r = GetRoundState() == ROUND_PREP and ROLE_INNOCENT or ply:GetRole()
   local weps = GetLoadoutWeapons(r)
   if not weps then return end

   for _, cls in pairs(weps) do
      if not ply:HasWeapon(cls) and ply:CanCarryType(WEPS.TypeForWeapon(cls)) then
         ply:Give(cls)
      end
   end
end

local function HasLoadoutWeapons(ply)
   if ply:IsSpec() then return true end

   local r = GetRoundState() == ROUND_PREP and ROLE_INNOCENT or ply:GetRole()
   local weps = GetLoadoutWeapons(r)
   if not weps then return true end


   for _, cls in pairs(weps) do
      if not ply:HasWeapon(cls) and ply:CanCarryType(WEPS.TypeForWeapon(cls)) then
         return false
      end
   end

   return true
end

-- Give loadout items.
local function GiveLoadoutItems(ply)
   local items = EquipmentItems[ply:GetRole()]
   if items then
      for _, item in pairs(items) do
         if item.loadout and item.id then
            ply:GiveEquipmentItem(item.id)
         end
      end
   end
end

-- Quick hack to limit hats to models that fit them well
local Hattables = { "phoenix.mdl", "arctic.mdl", "Group01", "monk.mdl" }
local function CanWearHat(ply)
   local path = string.Explode("/", ply:GetModel())
   if #path == 1 then path = string.Explode("\\", path) end

   return table.HasValue(Hattables, path[3])
end

CreateConVar("ttt_detective_hats", "0")
-- Just hats right now
local function GiveLoadoutSpecial(ply)
   if ply:IsActiveDetective() and GetConVar("ttt_detective_hats"):GetBool() and CanWearHat(ply) then

      if not IsValid(ply.hat) then
         local hat = ents.Create("ttt_hat_deerstalker")
         if not IsValid(hat) then return end

         hat:SetPos(ply:GetPos() + Vector(0,0,70))
         hat:SetAngles(ply:GetAngles())

         hat:SetParent(ply)

         ply.hat = hat

         hat:Spawn()
      end
   else
      SafeRemoveEntity(ply.hat)

      ply.hat = nil
   end
end

-- Sometimes, in cramped map locations, giving players weapons fails. A timer
-- calling this function is used to get them the weapons anyway as soon as
-- possible.
local function LateLoadout(id)
   local ply = player.GetByID(id)
   if not IsValid(ply) then
      timer.Remove("lateloadout" .. id)
      return
   end

   if not HasLoadoutWeapons(ply) then
      GiveLoadoutWeapons(ply)

      if HasLoadoutWeapons(ply) then
         timer.Remove("lateloadout" .. id)
      end
   end
end

-- Note that this is called both when a player spawns and when a round starts
function GM:PlayerLoadout( ply )
   if IsValid(ply) and (not ply:IsSpec()) then
      -- clear out equipment flags
      ply:ResetEquipment()

      -- give default items
      GiveLoadoutItems(ply)

      -- hand out weaponry
      GiveLoadoutWeapons(ply)

      GiveLoadoutSpecial(ply)

      if not HasLoadoutWeapons(ply) then
         MsgN("Could not spawn all loadout weapons for " .. ply:Nick() .. ", will retry.")
         timer.Create("lateloadout" .. ply:EntIndex(), 1, 0,
                      function() LateLoadout(ply:EntIndex()) end)
      end
   end
end

function GM:UpdatePlayerLoadouts()
   for _, ply in ipairs(player.GetAll()) do
      hook.Call("PlayerLoadout", GAMEMODE, ply)
   end
end

---- Weapon switching
local function ForceWeaponSwitch(ply, cmd, args)
   if not ply:IsPlayer() or not args[1] then return end
   -- Turns out even SelectWeapon refuses to switch to empty guns, gah.
   -- Worked around it by giving every weapon a single Clip2 round.
   -- Works because no weapon uses those.
   local wepname = args[1]
   local wep = ply:GetWeapon(wepname)
   if IsValid(wep) then
      -- Weapons apparently not guaranteed to have this
      if wep.SetClip2 then
         wep:SetClip2(1)
      end
      ply:SelectWeapon(wepname)
   end
end
concommand.Add("wepswitch", ForceWeaponSwitch)

---- Weapon dropping

function WEPS.DropNotifiedWeapon(ply, wep, death_drop)
   if IsValid(ply) and IsValid(wep) then
      -- Hack to tell the weapon it's about to be dropped and should do what it
      -- must right now
      if wep.PreDrop then
         wep:PreDrop(death_drop)
      end

      -- PreDrop might destroy weapon
      if not IsValid(wep) then return end

      -- Tag this weapon as dropped, so that if it's a special weapon we do not
      -- auto-pickup when nearby.
      wep.IsDropped = true

      ply:DropWeapon(wep)

      wep:PhysWake()

      -- After dropping a weapon, always switch to holstered, so that traitors
      -- will never accidentally pull out a traitor weapon
      ply:SelectWeapon("weapon_ttt_unarmed")
   end
end

local function DropActiveWeapon(ply)
   if not IsValid(ply) then return end

   local wep = ply:GetActiveWeapon()

   if not IsValid(wep) then return end

   if wep.AllowDrop == false then
      return
   end

   local tr = util.QuickTrace(ply:GetShootPos(), ply:GetAimVector() * 32, ply)

   if tr.HitWorld then
      LANG.Msg(ply, "drop_no_room")
      return
   end

   ply:AnimPerformGesture(ACT_ITEM_PLACE)

   WEPS.DropNotifiedWeapon(ply, wep)
end
concommand.Add("ttt_dropweapon", DropActiveWeapon)

local function DropActiveAmmo(ply)
   if not IsValid(ply) then return end

   local wep = ply:GetActiveWeapon()
   if not IsValid(wep) then return end

   if not wep.AmmoEnt then return end

   local amt = wep:Clip1()
   if amt < 1 or amt <= (wep.Primary.ClipSize * 0.25) then
      LANG.Msg(ply, "drop_no_ammo")
      return
   end

   local pos, ang = ply:GetShootPos(), ply:EyeAngles()
   local dir = (ang:Forward() * 32) + (ang:Right() * 6) + (ang:Up() * -5)

   local tr = util.QuickTrace(pos, dir, ply)
   if tr.HitWorld then return end

   wep:SetClip1(0)

   ply:AnimPerformGesture(ACT_ITEM_GIVE)

   local box = ents.Create(wep.AmmoEnt)
   if not IsValid(box) then return end

   box:SetPos(pos + dir)
   box:SetOwner(ply)
   box:Spawn()

   box:PhysWake()

   local phys = box:GetPhysicsObject()
   if IsValid(phys) then
      phys:ApplyForceCenter(ang:Forward() * 1000)
      phys:ApplyForceOffset(VectorRand(), vector_origin)
   end

   box.AmmoAmount = amt

   timer.Simple(2, function()
                      if IsValid(box) then
                         box:SetOwner(nil)
                      end
                   end)
end
concommand.Add("ttt_dropammo", DropActiveAmmo)


-- Give a weapon to a player. If the initial attempt fails due to heisenbugs in
-- the map, keep trying until the player has moved to a better spot where it
-- does work.
local function GiveEquipmentWeapon(sid, cls)
   -- Referring to players by SteamID because a player may disconnect while his
   -- unique timer still runs, in which case we want to be able to stop it. For
   -- that we need its name, and hence his SteamID.
   local ply = player.GetBySteamID(sid)
   local tmr = "give_equipment" .. sid

   if (not IsValid(ply)) or (not ply:IsActiveSpecial()) then
      timer.Remove(tmr)
      return
   end

   -- giving attempt, will fail if we're in a crazy spot in the map or perhaps
   -- other glitchy cases
   local w = ply:Give(cls)

   if (not IsValid(w)) or (not ply:HasWeapon(cls)) then
      if not timer.Exists(tmr) then
         timer.Create(tmr, 1, 0, function() GiveEquipmentWeapon(sid, cls) end)
      end

      -- we will be retrying
   else
      -- can stop retrying, if we were
      timer.Remove(tmr)

      if w.WasBought then
         -- some weapons give extra ammo after being bought, etc
         w:WasBought(ply)
      end
   end
end

local function HasPendingOrder(ply)
   return timer.Exists("give_equipment" .. tostring(ply:SteamID()))
end

function GM:TTTCanOrderEquipment(ply, id, is_item)
   --- return true to allow buying of an equipment item, false to disallow
   return true
end

-- Equipment buying
local function OrderEquipment(ply, cmd, args)
   if not IsValid(ply) or #args != 1 then return end

   if not (ply:IsActiveTraitor() or ply:IsActiveDetective()) then return end

   -- no credits, can't happen when buying through menu as button will be off
   if ply:GetCredits() < 1 then return end

   -- it's an item if the arg is an id instead of an ent name
   local id = args[1]
   local is_item = tonumber(id)
   
   if not hook.Run("TTTCanOrderEquipment", ply, id, is_item) then return end

   -- we use weapons.GetStored to save time on an unnecessary copy, we will not
   -- be modifying it
   local swep_table = (not is_item) and weapons.GetStored(id) or nil

   -- some weapons can only be bought once per player per round, this used to be
   -- defined in a table here, but is now in the SWEP's table
   if swep_table and swep_table.LimitedStock and ply:HasBought(id) then
      LANG.Msg(ply, "buy_no_stock")
      return
   end

   local received = false

   if is_item then
      id = tonumber(id)

      -- item whitelist check
      local allowed = GetEquipmentItem(ply:GetRole(), id)

      if not allowed then
         print(ply, "tried to buy item not buyable for his class:", id)
         return
      end

      -- ownership check and finalise
      if id and EQUIP_NONE < id then
         if not ply:HasEquipmentItem(id) then
            ply:GiveEquipmentItem(id)
            received = true
         end
      end
   elseif swep_table then
      -- weapon whitelist check
      if not table.HasValue(swep_table.CanBuy, ply:GetRole()) then
         print(ply, "tried to buy weapon his role is not permitted to buy")
         return
      end

      -- if we have a pending order because we are in a confined space, don't
      -- start a new one
      if HasPendingOrder(ply) then
         LANG.Msg(ply, "buy_pending")
         return
      end

      -- no longer restricted to only WEAPON_EQUIP weapons, just anything that
      -- is whitelisted and carryable
      if ply:CanCarryWeapon(swep_table) then
         GiveEquipmentWeapon(ply:SteamID(), id)

         received = true
      end
   end

   if received then
      ply:SubtractCredits(1)
      LANG.Msg(ply, "buy_received")

      ply:AddBought(id)

      timer.Simple(0.5,
                   function()
                      if not IsValid(ply) then return end
                      net.Start("TTT_BoughtItem")
                      net.WriteBit(is_item)
                      if is_item then
                         net.WriteUInt(id, 16)
                      else
                         net.WriteString(id)
                      end
                      net.Send(ply)
                   end)

      hook.Call("TTTOrderedEquipment", GAMEMODE, ply, id, is_item)
   end
end
concommand.Add("ttt_order_equipment", OrderEquipment)

function GM:TTTToggleDisguiser(ply, state)
   -- Can be used to prevent players from using this button.
   -- return true to prevent it.
end

local function SetDisguise(ply, cmd, args)
   if not IsValid(ply) or not ply:IsActiveTraitor() then return end

   if ply:HasEquipmentItem(EQUIP_DISGUISE) then
      local state = #args == 1 and tobool(args[1])
      if hook.Run("TTTToggleDisguiser", ply, state) then return end

      ply:SetNWBool("disguised", state)
      LANG.Msg(ply, state and "disg_turned_on" or "disg_turned_off")
   end
end
concommand.Add("ttt_set_disguise", SetDisguise)

local function CheatCredits(ply)
   if IsValid(ply) then
      ply:AddCredits(10)
   end
end
concommand.Add("ttt_cheat_credits", CheatCredits, nil, nil, FCVAR_CHEAT)

local function TransferCredits(ply, cmd, args)
   if (not IsValid(ply)) or (not ply:IsActiveSpecial()) then return end
   if #args != 2 then return end

   local sid = tostring(args[1])
   local credits = tonumber(args[2])
   if sid and credits then
      local target = player.GetBySteamID(sid)
      if (not IsValid(target)) or (not target:IsActiveSpecial()) or (target:GetRole() ~= ply:GetRole()) or (target == ply) then
         LANG.Msg(ply, "xfer_no_recip")
         return
      end

      if ply:GetCredits() < credits then
         LANG.Msg(ply, "xfer_no_credits")
         return
      end

      credits = math.Clamp(credits, 0, ply:GetCredits())
      if credits == 0 then return end

      ply:SubtractCredits(credits)
      target:AddCredits(credits)

      LANG.Msg(ply, "xfer_success", {player=target:Nick()})
      LANG.Msg(target, "xfer_received", {player = ply:Nick(), num = credits})
   end
end
concommand.Add("ttt_transfer_credits", TransferCredits)

-- Protect against non-TTT weapons that may break the HUD
function GM:WeaponEquip(wep)
   if IsValid(wep) then
      -- only remove if they lack critical stuff
      if not wep.Kind then
         wep:Remove()
         ErrorNoHalt("Equipped weapon " .. wep:GetClass() .. " is not compatible with TTT\n")
      end
   end
end

-- non-cheat developer commands can reveal precaching the first time equipment
-- is bought, so trigger it at the start of a round instead
function WEPS.ForcePrecache()
   for k, w in ipairs(weapons.GetList()) do
      if w.WorldModel then
         util.PrecacheModel(w.WorldModel)
      end
      if w.ViewModel then
         util.PrecacheModel(w.ViewModel)
      end
   end
end
