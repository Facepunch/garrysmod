
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_fraggrenade_thrown.mdl")

local ttt_allow_jump = CreateConVar("ttt_allow_discomb_jump", "0")

local function PushPullRadius(pos, pusher)
   local radius = 400
   local phys_force = 1500
   local push_force = 256

   -- pull physics objects and push players
   for k, target in pairs(ents.FindInSphere(pos, radius)) do
      if IsValid(target) then
         local tpos = target:LocalToWorld(target:OBBCenter())
         local dir = (tpos - pos):GetNormal()
         local phys = target:GetPhysicsObject()

         if target:IsPlayer() and (not target:IsFrozen()) and ((not target.was_pushed) or target.was_pushed.t != CurTime()) then

            -- always need an upwards push to prevent the ground's friction from
            -- stopping nearly all movement
            dir.z = math.abs(dir.z) + 1

            local push = dir * push_force

            -- try to prevent excessive upwards force
            local vel = target:GetVelocity() + push
            vel.z = math.min(vel.z, push_force)

            -- mess with discomb jumps
            if pusher == target and (not ttt_allow_jump:GetBool()) then
               vel = VectorRand() * vel:Length()
               vel.z = math.abs(vel.z)
            end

            target:SetVelocity(vel)

            target.was_pushed = {att=pusher, t=CurTime(), wep="weapon_ttt_confgrenade"}

         elseif IsValid(phys) then
            phys:ApplyForceCenter(dir * -1 * phys_force)
         end
      end
   end

   local phexp = ents.Create("env_physexplosion")
   if IsValid(phexp) then
      phexp:SetPos(pos)
      phexp:SetKeyValue("magnitude", 100) --max
      phexp:SetKeyValue("radius", radius)
      -- 1 = no dmg, 2 = push ply, 4 = push radial, 8 = los, 16 = viewpunch
      phexp:SetKeyValue("spawnflags", 1 + 2 + 16)
      phexp:Spawn()
      phexp:Fire("Explode", "", 0.2)
   end
end

local zapsound = Sound("npc/assassin/ball_zap1.wav")
function ENT:Explode(tr)
   if SERVER then
      self:SetNoDraw(true)
      self:SetSolid(SOLID_NONE)

      -- pull out of the surface
      if tr.Fraction != 1.0 then
         self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
      end

      local pos = self:GetPos()

      -- make sure we are removed, even if errors occur later
      self:Remove()

      PushPullRadius(pos, self:GetThrower())

      local effect = EffectData()
      effect:SetStart(pos)
      effect:SetOrigin(pos)

      if tr.Fraction != 1.0 then
         effect:SetNormal(tr.HitNormal)
      end
      
      util.Effect("Explosion", effect, true, true)
      util.Effect("cball_explode", effect, true, true)

      sound.Play(zapsound, pos, 100, 100)
   else
      local spos = self:GetPos()
      local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
      util.Decal("SmallScorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)      

      self:SetDetonateExact(0)
   end
end
