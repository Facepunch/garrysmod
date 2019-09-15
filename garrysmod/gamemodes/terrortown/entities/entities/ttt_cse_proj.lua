
AddCSLuaFile()

if CLIENT then
   local GetPTranslation = LANG.GetParamTranslation
   local hint_params = {usekey = Key("+use", "USE")}

   ENT.TargetIDHint = {
      name = "vis_name",
      hint = "vis_hint",
      fmt  = function(ent, txt) return GetPTranslation(txt, hint_params) end
   };

end

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/Items/battery.mdl")

ENT.RenderGroup = RENDERGROUP_BOTH

ENT.Range = 128
ENT.MaxScenesPerPulse = 3
ENT.SceneDuration = 10
ENT.PulseDelay    = 10

ENT.CanUseKey = true

function ENT:Initialize()
   self.BaseClass.Initialize(self)

   self:SetSolid(SOLID_VPHYSICS)

   if SERVER then
      self:SetMaxHealth(50)
      self:SetExplodeTime(CurTime() + 1)
   end

   self:SetHealth(50)
end

function ENT:GetNearbyCorpses()
   local pos = self:GetPos()

   local near = ents.FindInSphere(pos, self.Range)
   if not near then return end

   local near_corpses = {}

   local n = #near
   local ent = nil
   for i=1, n do
      ent = near[i]
      if IsValid(ent) and ent.player_ragdoll and ent.scene then
         table.insert(near_corpses, {ent=ent, dist=pos:LengthSqr()})
      end
   end

   return near_corpses
end

local zapsound = Sound("npc/assassin/ball_zap1.wav")
function ENT:OnTakeDamage(dmginfo)
   self:TakePhysicsDamage(dmginfo)

   self:SetHealth(self:Health() - dmginfo:GetDamage())
   if self:Health() < 0 then
      self:Remove()

      local effect = EffectData()
      effect:SetOrigin(self:GetPos())
      util.Effect("cball_explode", effect)
      sound.Play(zapsound, self:GetPos())
   end
end

function ENT:ShowSceneForCorpse(corpse)
   local scene = corpse.scene
   local hit = scene.hit_trace
   local dur = self.SceneDuration

   if hit then
      -- line showing bullet trajectory
      local e = EffectData()
      e:SetEntity(corpse)
      e:SetStart(hit.StartPos)
      e:SetOrigin(hit.HitPos)
      e:SetMagnitude(hit.HitBox)
      e:SetScale(dur)

      util.Effect("crimescene_shot", e)
   end

   if not scene then return end

   for _, dummy_key in pairs({"victim", "killer"}) do
      local dummy = scene[dummy_key]

      if dummy then
         -- Horrible sins committed here to get all the data we need over the
         -- wire, the pose parameters are going to be truncated etc. but
         -- everything sort of works out. If you know a better way to get this
         -- much data to an effect, let me know.
         local e = EffectData()
         e:SetEntity(corpse)
         e:SetOrigin(dummy.pos)
         e:SetAngles(dummy.ang)
         e:SetColor(dummy.sequence)
         e:SetScale(dummy.cycle)
         e:SetStart(Vector(dummy.aim_yaw, dummy.aim_pitch, dummy.move_yaw))
         e:SetRadius(dur)

         util.Effect("crimescene_dummy", e)
      end
   end
end

local scanloop = Sound("weapons/gauss/chargeloop.wav")
function ENT:StartScanSound()
   if not self.ScanSound then
      self.ScanSound = CreateSound(self, scanloop)
   end

   if not self.ScanSound:IsPlaying() then
      self.ScanSound:PlayEx(0.5, 100)
   end
end

function ENT:StopScanSound(force)
   if self.ScanSound and self.ScanSound:IsPlaying() then
      self.ScanSound:FadeOut(0.5)
   end

   if self.ScanSound and force then
      self.ScanSound:Stop()
   end
end


if CLIENT then
   local glow = Material("sprites/blueglow2")
   function ENT:DrawTranslucent()
      render.SetMaterial(glow)

      render.DrawSprite(self:LocalToWorld(self:OBBCenter()), 32, 32, COLOR_WHITE)
   end
end

function ENT:UseOverride(activator)
   if IsValid(activator) and activator:IsPlayer() then
      if activator:IsActiveDetective() and activator:CanCarryType(WEAPON_EQUIP) then
         self:StopScanSound(true)
         self:Remove()

         activator:Give("weapon_ttt_cse")
      else
         self:EmitSound("HL2Player.UseDeny")
      end
   end
end


function ENT:OnRemove()
   self:StopScanSound(true)
end

function ENT:Explode(tr)
   if SERVER then

      -- prevent starting effects when round is about to restart
      if GetRoundState() == ROUND_POST then return end

      self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

      local corpses = self:GetNearbyCorpses()
      if #corpses > self.MaxScenesPerPulse then
         table.SortByMember(corpses, "dist", function(a, b) return a > b end)
      end

      local e = EffectData()
      e:SetOrigin(self:GetPos())
      e:SetRadius(128)
      e:SetMagnitude(0.5)
      e:SetScale(4)
      util.Effect("pulse_sphere", e)

      -- show scenes for nearest corpses
      for i=1, self.MaxScenesPerPulse do
         local corpse = corpses[i]
         if corpse and IsValid(corpse.ent) then
            self:ShowSceneForCorpse(corpse.ent)
         end
      end

      if #corpses > 0 then
         self:StartScanSound()
      else
         self:StopScanSound()
      end

      -- "schedule" next show pulse
      self:SetDetonateTimer(self.PulseDelay)

   end
end


