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
   local rf = RecipientFilter()
   rf:AddAllPlayers()

   self:EmitSound(snd, lvl, pitch, vol, channel, flags, dsp, rf)
end