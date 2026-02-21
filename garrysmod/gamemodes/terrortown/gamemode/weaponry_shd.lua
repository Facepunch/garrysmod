
WEPS = {}

function WEPS.TypeForWeapon(class)
   local tbl = util.WeaponForClass(class)
   return tbl and tbl.Kind or WEAPON_NONE
end

-- You'd expect this to go on the weapon entity, but we need to be able to call
-- it on a swep table as well.
function WEPS.IsEquipment(wep)
   return wep.Kind and wep.Kind >= WEAPON_EQUIP
end

function WEPS.GetClass(wep)
   if istable(wep) then
      return wep.ClassName or wep.Classname
   elseif IsValid(wep) then
      return wep:GetClass()
   end
end

function WEPS.DisguiseToggle(ply)
   if IsValid(ply) and ply:IsActiveTraitor() then
      if not ply:GetNWBool("disguised", false) then
         RunConsoleCommand("ttt_set_disguise", "1")
      else
         RunConsoleCommand("ttt_set_disguise", "0")
      end
   end
end
