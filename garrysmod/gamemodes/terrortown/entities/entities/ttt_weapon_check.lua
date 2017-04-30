
ENT.Type = "brush"
ENT.Base = "base_brush"

function ENT:KeyValue(key, value)
   if key == "WeaponsFound" then
      -- this is our output, so handle it as such
      self:StoreOutput(key, value)
   end
end

local function VectorInside(vec, mins, maxs)
   return (vec.x > mins.x and vec.x < maxs.x
           and vec.y > mins.y and vec.y < maxs.y
           and vec.z > mins.z and vec.z < maxs.z)
end

-- We use stuff from weaponry.lua here, like weapon types

local function HasWeaponType(ply, weptype)
   for _, wep in pairs(ply:GetWeapons()) do
      if IsValid(wep) and WEPS.TypeForWeapon(wep:GetClass()) == weptype then
         return true
      end
   end
   return false
end

local function HasPrimary(ply)
   return HasWeaponType(ply, WEAPON_HEAVY)
end

local function HasSecondary(ply)
   return HasWeaponType(ply, WEAPON_PISTOL)
end

local function HasEquipment(ply)
   return ply:HasEquipment()
end

local function HasNade(ply)
   return HasWeaponType(ply, WEAPON_NADE)
end

local function HasAny(ply)
   return HasPrimary(ply) or HasSecondary(ply) or HasEquipment(ply) or HasNade(ply)
end

local function HasNamed(name)
   return function(ply) 
             return ply:HasWeapon(name) 
          end
end

local checkers = {
   [1] = HasPrimary,
   [2] = HasSecondary,
   [3] = HasEquipment,
   [4] = HasNade,
   [5] = HasAny
};

function ENT:GetWeaponChecker(check)
   if type(check) == "string" then
      return HasNamed(check)
   else
      return checkers[check]
   end
end

function ENT:TestWeapons(weptype)
   local mins = self:LocalToWorld(self:OBBMins())
   local maxs = self:LocalToWorld(self:OBBMaxs())

   local check = self:GetWeaponChecker(weptype)
   
   if check == nil then
      ErrorNoHalt("ttt_weapon_check: invalid parameter\n")
      return 0
   end

   for _,ply in pairs(player.GetAll()) do
      if IsValid(ply) and ply:IsTerror() then
         local pos = ply:GetPos()
         local center = ply:LocalToWorld(ply:OBBCenter())
         if VectorInside(pos, mins, maxs) or VectorInside(center, mins, maxs) then
            if check(ply) then
               return 1
            end
         end
      end
   end

   return 0
end

function ENT:AcceptInput(name, activator, caller, data)
   if name == "CheckForType" or name == "CheckForClass" then
      local weptype = tonumber(data)
      local wepname = tostring(data)

      if not weptype and not wepname then
         ErrorNoHalt("ttt_weapon_check: Invalid parameter to CheckForWeapons input!\n")
         return false
      end

      local weapons = self:TestWeapons(weptype or wepname)

      self:TriggerOutput("WeaponsFound", activator, weapons)

      return true
   end
end


