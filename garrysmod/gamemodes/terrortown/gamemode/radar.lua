-- Traitor radar functionality


-- should mirror client
local chargetime = 30

local math = math

local function RadarScan(ply, cmd, args)
   if not IsValid(ply) or not ply:IsTerror() then return end

   if not ply:HasEquipmentItem(EQUIP_RADAR) then
      LANG.Msg(ply, "radar_not_owned")
      return
   end

   if ply.radar_charge > CurTime() then
      LANG.Msg(ply, "radar_charging")
      return
   end

   ply.radar_charge = CurTime() + chargetime

   local targets = {}
   for k, p in player.Iterator() do
      if ply == p or (not IsValid(p)) or not p:IsTerror() then continue end

      if p:GetNWBool("disguised", false) and (not ply:IsTraitor()) then continue end

      local pos = p:LocalToWorld(p:OBBCenter())

      local role = p:GetRole()
      if role != ROLE_INNOCENT and role != ply:GetRole() then
         -- Detectives/Traitors can see who has their role, but not who
         -- has the opposite role.
         role = ROLE_INNOCENT
      end

      table.insert(targets, {role=role, pos=pos, ent=p})
   end

   hook.Run("TTTRadarScan", ply, targets)

   net.Start("TTT_Radar")
      net.WriteUInt(#targets, 8)
      for k, tgt in ipairs(targets) do
         net.WriteUInt(tgt.role, 2)

         -- Round off, easier to send and inaccuracy does not matter
         net.WriteInt(math.Round(tgt.pos.x), 15)
         net.WriteInt(math.Round(tgt.pos.y), 15)
         net.WriteInt(math.Round(tgt.pos.z), 15)
      end
   net.Send(ply)
end
concommand.Add("ttt_radar_scan", RadarScan)
