local meta = FindMetaTable( "Entity" )

if not meta then return end

function meta:SetDamageOwner(ply)
   self.dmg_owner = {ply = ply, t = CurTime()}
end

function meta:GetDamageOwner()
   if self.dmg_owner then
      return self.dmg_owner.ply, self.dmg_owner.t
   end
end

function meta:IsExplosive()
   local kv = self:GetKeyValues()["ExplodeDamage"]
   return self:Health() > 0 and kv and kv > 0
end

-- Some sounds are important enough that they shouldn't be affected by CPASAttenuationFilter
function meta:BroadcastSound(snd, lvl, pitch, vol, channel, flags, dsp)
   lvl = lvl or 75

   local rf = RecipientFilter()

   if lvl == 0 then
      rf:AddAllPlayers()
   else
      -- Overriding the PAS filter means this will no longer check if players
      -- are within audible range before sending them the sound message.
      -- Instead, we reimplement this check in lua.
      local pos = self:GetPos()

      local attenuation = lvl > 50 and 20.0 / (lvl - 50) or 4.0
      local maxAudible = math.min(2500, 2000 / attenuation)

      for _, ply in player.Iterator() do
         if (ply:EyePos() - pos):Length() > maxAudible then continue end

         rf:AddPlayer(ply)
      end
   end

   self:EmitSound(snd, lvl, pitch, vol, channel, flags, dsp, rf)
end