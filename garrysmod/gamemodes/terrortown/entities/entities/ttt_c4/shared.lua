-- c4 explosive

local math = math

if SERVER then
   AddCSLuaFile("cl_init.lua")
   AddCSLuaFile("shared.lua")
end

if CLIENT then
   -- this entity can be DNA-sampled so we need some display info
   ENT.Icon = "VGUI/ttt/icon_c4"
   ENT.PrintName = "C4"

   local GetPTranslation = LANG.GetParamTranslation
   local hint_params = {usekey = Key("+use", "USE")}

   ENT.TargetIDHint = {
      name = "C4",
      hint = "c4_hint",
      fmt  = function(ent, txt) return GetPTranslation(txt, hint_params) end
   };
end

C4_WIRE_COUNT   = 6
C4_MINIMUM_TIME = 45
C4_MAXIMUM_TIME = 600

ENT.Type = "anim"
ENT.Model = Model("models/weapons/w_c4_planted.mdl")

ENT.CanHavePrints = true
ENT.CanUseKey = true

AccessorFunc( ENT, "thrower", "Thrower")

AccessorFunc( ENT, "radius", "Radius", FORCE_NUMBER )
AccessorFunc( ENT, "dmg", "Dmg", FORCE_NUMBER )

AccessorFunc( ENT, "arm_time", "ArmTime", FORCE_NUMBER)
AccessorFunc( ENT, "timer_length", "TimerLength", FORCE_NUMBER)

-- Generate accessors for DT vars. This way all consumer code can keep accessing
-- the vars as they always did, the only difference is that behind the scenes
-- they are set up as DT vars.
AccessorFuncDT(ENT, "explode_time", "ExplodeTime")
AccessorFuncDT(ENT, "armed", "Armed")

ENT.Beep = 0
ENT.DetectiveNearRadius = 300
ENT.SafeWires = nil

function ENT:SetupDataTables()
   self:DTVar("Int", 0, "explode_time")
   self:DTVar("Bool", 0, "armed")
end

function ENT:Initialize()
   self:SetModel(self.Model)

   if SERVER then
      self:PhysicsInit(SOLID_VPHYSICS)
   end
   self:SetMoveType(MOVETYPE_VPHYSICS)
   self:SetSolid(SOLID_BBOX)
   self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

   if SERVER then
      self:SetUseType(SIMPLE_USE)
   end

   self.SafeWires = nil
   self.Beep = 0
   self.DisarmCausedExplosion = false

   self:SetTimerLength(0)
   self:SetExplodeTime(0)
   self:SetArmed(false)
   if not self:GetThrower() then self:SetThrower(nil) end

   if not self:GetRadius() then self:SetRadius(1000) end
   if not self:GetDmg() then self:SetDmg(200) end

end

function ENT:SetDetonateTimer(length)
   self:SetTimerLength(length)
   self:SetExplodeTime( CurTime() + length )
end


function ENT:UseOverride(activator)
   if IsValid(activator) and activator:IsPlayer() then
      -- Traitors not allowed to disarm other traitor's C4 until he is dead
      local owner = self:GetOwner()
      if self:GetArmed() and owner != activator and activator:GetTraitor() and (IsValid(owner) and owner:Alive() and owner:GetTraitor()) then
         LANG.Msg(activator, "c4_no_disarm")
         return
      end

      self:ShowC4Config(activator)
   end
end

function ENT.SafeWiresForTime(t)
   local m = t / 60

   if m > 4 then     return 1
   elseif m > 3 then return 2
   elseif m > 2 then return 3
   elseif m > 1 then return 4
   else              return 5
   end
end

function ENT:WeldToGround(state)
   if self.IsOnWall then return end

   if state then
      -- getgroundentity does not work for non-players
      -- so sweep ent downward to find what we're lying on
      local ignore = player.GetAll()
      table.insert(ignore, self.Entity)

      local tr = util.TraceEntity({start=self:GetPos(), endpos=self:GetPos() - Vector(0,0,16), filter=ignore, mask=MASK_SOLID}, self.Entity)

      -- Start by increasing weight/making uncarryable
      local phys = self:GetPhysicsObject()
      if IsValid(phys) then
         -- Could just use a pickup flag for this. However, then it's easier to
         -- push it around.
         self.OrigMass = phys:GetMass()
         phys:SetMass(150)
      end

      if tr.Hit and (IsValid(tr.Entity) or tr.HitWorld) then
         -- "Attach" to a brush if possible
         if IsValid(phys) and tr.HitWorld then
            phys:EnableMotion(false)
         end

         -- Else weld to objects we cannot pick up
         local entphys = tr.Entity:GetPhysicsObject()
         if IsValid(entphys) and entphys:GetMass() > CARRY_WEIGHT_LIMIT then
            constraint.Weld(self, tr.Entity, 0, 0, 0, true)
         end

         -- Worst case, we are still uncarryable
      end
   else
      constraint.RemoveConstraints(self.Entity, "Weld")
      local phys = self:GetPhysicsObject()
      if IsValid(phys) then
         phys:EnableMotion(true)
         phys:SetMass(self.OrigMass or 10)
      end
   end
end

function ENT:SphereDamage(dmgowner, center, radius)
   -- It seems intuitive to use FindInSphere here, but that will find all ents
   -- in the radius, whereas there exist only ~16 players. Hence it is more
   -- efficient to cycle through all those players and do a Lua-side distance
   -- check.

   local r = radius ^ 2 -- square so we can compare with dotproduct directly


   -- pre-declare to avoid realloc
   local d = 0.0
   local diff = nil
   local dmg = 0
   for _, ent in pairs(player.GetAll()) do
      if IsValid(ent) and ent:Team() == TEAM_TERROR then

         -- dot of the difference with itself is distance squared
         diff = center - ent:GetPos()
         d = diff:DotProduct(diff)

         if d < r then
            -- deadly up to a certain range, then a quick falloff within 100 units
            d = math.max(0, math.sqrt(d) - 490)
            dmg = -0.01 * (d^2) + 125

            local dmginfo = DamageInfo()
            dmginfo:SetDamage(dmg)
            dmginfo:SetAttacker(dmgowner)
            dmginfo:SetInflictor(self.Entity)
            dmginfo:SetDamageType(DMG_BLAST)
            dmginfo:SetDamageForce(center - ent:GetPos())
            dmginfo:SetDamagePosition(ent:GetPos())

            ent:TakeDamageInfo(dmginfo)
         end
      end
   end
end

local c4boom = Sound("c4.explode")
function ENT:Explode(tr)
   if SERVER then
      self:SetNoDraw(true)
      self:SetSolid(SOLID_NONE)

      -- pull out of the surface
      if tr.Fraction != 1.0 then
         self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
      end

      local pos = self:GetPos()
      if util.PointContents(pos) == CONTENTS_WATER or GetRoundState() != ROUND_ACTIVE then
         self:Remove()
         self:SetExplodeTime(0)
         return
      end

      local dmgowner = self:GetThrower()
      dmgowner = IsValid(dmgowner) and dmgowner or self.Entity

      local r_inner = 750
      local r_outer = self:GetRadius()

      if self.DisarmCausedExplosion then
         r_inner = r_inner / 2.5
         r_outer = r_outer / 2.5
      end

      -- damage through walls
      self:SphereDamage(dmgowner, pos, r_inner)

      -- explosion damage
      util.BlastDamage(self, dmgowner, pos, r_outer, self:GetDmg())

      local effect = EffectData()
      effect:SetStart(pos)
      effect:SetOrigin(pos)
      -- these don't have much effect with the default Explosion
      effect:SetScale(r_outer)
      effect:SetRadius(r_outer)
      effect:SetMagnitude(self:GetDmg())

      if tr.Fraction != 1.0 then
         effect:SetNormal(tr.HitNormal)
      end

      effect:SetOrigin(pos)
      util.Effect("Explosion", effect, true, true)
      util.Effect("HelicopterMegaBomb", effect, true, true)

      timer.Simple(0.1, function() sound.Play(c4boom, pos, 100, 100) end)

      -- extra push
      local phexp = ents.Create("env_physexplosion")
      phexp:SetPos(pos)
      phexp:SetKeyValue("magnitude", self:GetDmg())
      phexp:SetKeyValue("radius", r_outer)
      phexp:SetKeyValue("spawnflags", "19")
      phexp:Spawn()
      phexp:Fire("Explode", "", 0)


      -- few fire bits to ignite things
      timer.Simple(0.2, function() StartFires(pos, tr, 4, 5, true, dmgowner) end)

      self:SetExplodeTime(0)

      SCORE:HandleC4Explosion(dmgowner, self:GetArmTime(), CurTime())

      self:Remove()
   else
      local spos = self:GetPos()
      local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
      util.Decal("Scorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)

      self:SetExplodeTime(0)
   end
end

function ENT:IsDetectiveNear()
   local center = self:GetPos()
   local r = self.DetectiveNearRadius ^ 2
   local d = 0.0
   local diff = nil
   for _, ent in pairs(player.GetAll()) do
      if IsValid(ent) and ent:IsActiveDetective() then
         -- dot of the difference with itself is distance squared
         diff = center - ent:GetPos()
         d = diff:DotProduct(diff)

         if d < r then
            if ent:HasWeapon("weapon_ttt_defuser") then
               return true
            end
         end
      end
   end

   return false
end

local beep = Sound("weapons/c4/c4_beep1.wav")
local MAX_MOVE_RANGE = 1000000 -- sq of 1000
function ENT:Think()
   if not self:GetArmed() then return end

   local curpos = self:GetPos()
   if self.LastPos and self.LastPos:DistToSqr(curpos) > MAX_MOVE_RANGE then
      self:Disarm(nil)
   end
   self.LastPos = curpos

   local etime = self:GetExplodeTime()
   if self:GetArmed() and etime != 0 and etime < CurTime() then
      -- find the ground if it's near and pass it to the explosion
      local spos = self:GetPos()
      local tr = util.TraceLine({start=spos, endpos=spos + Vector(0,0,-32), mask=MASK_SHOT_HULL, filter=self:GetThrower()})

      local success, err = pcall(self.Explode, self, tr)
      if not success then
         -- prevent effect spam on Lua error
         self:Remove()

         ErrorNoHalt("ERROR CAUGHT: ttt_c4: " .. err .. "\n")
      end
   elseif self:GetArmed() and CurTime() > self.Beep then
      local amp = 48

      if self:IsDetectiveNear() then
         amp = 65

         local dlight = CLIENT and DynamicLight(self:EntIndex())
         if dlight then
            dlight.Pos = self:GetPos()
            dlight.r = 255
            dlight.g = 0
            dlight.b = 0
            dlight.Brightness = 1
            dlight.Size = 128
            dlight.Decay = 500
            dlight.DieTime = CurTime() + 0.1
         end

      elseif SERVER then
         -- volume lower for long fuse times, bottoms at 50 at +5mins
         amp = amp + math.max(0, 12 - (0.03 * self:GetTimerLength()))
      end

      if SERVER then
         sound.Play(beep, self:GetPos(), amp, 100)
      end

      local btime = (etime - CurTime()) / 30
      self.Beep = CurTime() + btime
   end
end

-- Timer configuration handlign

if SERVER then
   -- Inform traitors about us
   function ENT:SendWarn(armed)
      umsg.Start("c4_warn", GetTraitorFilter(true))
      umsg.Short(self:EntIndex())
      umsg.Bool(armed)
      if armed then
         umsg.Vector(self:GetPos())
         umsg.Float(self:GetExplodeTime())
      end
      umsg.End()
   end

   function ENT:OnRemove()
      self:SendWarn(false)
   end

   function ENT:Disarm(ply)
      local owner = self:GetOwner()

      SCORE:HandleC4Disarm(ply, owner, true)

      if ply != owner and IsValid(owner) then
         LANG.Msg(owner, "c4_disarm_warn")
      end

      self:SetExplodeTime(0)
      self:SetArmed(false)
      self:WeldToGround(false)
      self:SendWarn(false)

      self.DisarmCausedExplosion = false
   end

   function ENT:FailedDisarm(ply)
      self.DisarmCausedExplosion = true

      SCORE:HandleC4Disarm(ply, self:GetOwner(), false)

      -- tiny moment of zen and realization before the bang
      self:SetExplodeTime(CurTime() + 0.1)
   end

   function ENT:Arm(ply, time)

      -- Initialize armed state
      self:SetDetonateTimer(time)
      self:SetArmTime(CurTime())

      self:SetArmed(true)
      self:WeldToGround(true)
      self.DisarmCausedExplosion = false

      -- ply may be a different player than he who dropped us.
      -- Arming player should be the damage owner = "thrower"
      self:SetThrower(ply)
      -- Owner determines who gets messages and can quick-disarm if traitor,
      -- make that the armer as well for now. Theoretically the dropping player
      -- should also be able to quick-disarm, but that's going to be rare.
      self:SetOwner(ply)

      -- Wire stuff:

      self.SafeWires = {}

      -- list of possible wires to make safe
      local choices = {}
      for i=1, C4_WIRE_COUNT do
         table.insert(choices, i)
      end

      -- random selection process, lot like traitor selection
      local safe_count = self.SafeWiresForTime(time)
      local safes = {}
      local picked = 0
      while picked < safe_count do
         local pick = math.random(1, #choices)
         local w = choices[pick]

         if not self.SafeWires[w] then
            self.SafeWires[w] = true
            table.remove(choices, pick)

            -- owner will end up having the last safe wire on his corpse
            ply.bomb_wire = w

            picked = picked + 1
         end
      end

      -- send indicator to traitors
      self:SendWarn(true)
   end

   function ENT:ShowC4Config(ply)
      -- show menu to player to configure or disarm us
      umsg.Start("c4_config", ply)
      umsg.Short(self:EntIndex())
      umsg.End()
   end

   local function ReceiveC4Config(ply, cmd, args)
      if (not IsValid(ply)) or (not ply:IsTerror()) or (not ply:Alive()) or #args != 2 then return end
      local idx = tonumber(args[1])
      local time = tonumber(args[2])

      if not idx or not time then return end

      local bomb = ents.GetByIndex(idx)
      if IsValid(bomb) and (not bomb:GetArmed()) then

         if bomb:GetPos():Distance(ply:GetPos()) > 256 then
            -- These cases should never arise in normal play, so no messages
            return
         elseif time < C4_MINIMUM_TIME or time > C4_MAXIMUM_TIME then
            return
         elseif IsValid(bomb:GetPhysicsObject()) and bomb:GetPhysicsObject():HasGameFlag(FVPHYSICS_PLAYER_HELD) then
            return
         else
            LANG.Msg(ply, "c4_armed")

            bomb:Arm(ply, time)
         end
      end

   end
   concommand.Add("ttt_c4_config", ReceiveC4Config)

   local function SendDisarmResult(ply, idx, result)
      umsg.Start("c4_disarm_result", ply)
      umsg.Short(idx)
      umsg.Bool(result)
      umsg.End()
   end

   local function ReceiveC4Disarm(ply, cmd, args)
      if (not IsValid(ply)) or (not ply:IsTerror()) or (not ply:Alive()) or #args != 2 then return end
      local idx = tonumber(args[1])
      local wire = tonumber(args[2])

      if not idx or not wire then return end

      local bomb = ents.GetByIndex(idx)
      if IsValid(bomb) and bomb:GetArmed() then
         if bomb:GetPos():Distance(ply:GetPos()) > 256 then
            return
         elseif bomb.SafeWires[wire] or ply:IsTraitor() or ply == bomb:GetOwner() then
            LANG.Msg(ply, "c4_disarmed")

            bomb:Disarm(ply)

            -- only case with success umsg
            SendDisarmResult(ply, idx, true)
         else
            SendDisarmResult(ply, idx, false)

            -- wrong wire = bomb goes boom
            bomb:FailedDisarm(ply)
         end
      end
   end
   concommand.Add("ttt_c4_disarm", ReceiveC4Disarm)


   local function ReceiveC4Pickup(ply, cmd, args)
      if (not IsValid(ply)) or (not ply:IsTerror()) or (not ply:Alive()) or #args != 1 then return end
      local idx = tonumber(args[1])

      if not idx then return end

      local bomb = ents.GetByIndex(idx)
      if IsValid(bomb) and bomb.GetArmed and (not bomb:GetArmed()) then
         if bomb:GetPos():Distance(ply:GetPos()) > 256 then return
         elseif not ply:CanCarryType(WEAPON_EQUIP1) then
            LANG.Msg(ply, "c4_no_room")
         else
            local prints = bomb.fingerprints or {}

            local wep = ply:Give("weapon_ttt_c4")
            if IsValid(wep) then
               wep.fingerprints = wep.fingerprints or {}
               table.Add(wep.fingerprints, prints)

               bomb:Remove()

            end
         end
      end
   end
   concommand.Add("ttt_c4_pickup", ReceiveC4Pickup)


   local function ReceiveC4Destroy(ply, cmd, args)
      if (not IsValid(ply)) or (not ply:IsTerror()) or (not ply:Alive()) or #args != 1 then return end
      local idx = tonumber(args[1])

      if not idx then return end

      local bomb = ents.GetByIndex(idx)
      if IsValid(bomb) and (not bomb:GetArmed()) then
         if bomb:GetPos():Distance(ply:GetPos()) > 256 then return
         else
            -- spark to show onlookers we destroyed this bomb
            util.EquipmentDestroyed(bomb:GetPos())

            bomb:Remove()
         end
      end
   end
   concommand.Add("ttt_c4_destroy", ReceiveC4Destroy)
end

if CLIENT then
   surface.CreateFont("C4ModelTimer", {
                         font = "Default",
                         size = 13,
                         weight = 0,
                         antialias = false
                      })

   local strtime = util.SimpleTime
   local max = math.max
   function ENT:Draw()
      self:DrawModel()

      if self:GetArmed() then
         local ang = self:GetAngles() ang:RotateAroundAxis(self:GetUp(),-90)
         local angpos_ur = self:GetAttachment(self:LookupAttachment("controlpanel0_ur")) or --Doesn't work, wrong attachment?
            {Pos=self:GetPos()+self:GetForward()*4.5+self:GetUp()*8.8+self:GetRight()*7.8,Ang=ang} --Relative position failsafe
         if angpos_ur then
            cam.Start3D2D(angpos_ur.Pos, angpos_ur.Ang, 0.2)
            draw.DrawText(strtime(max(0, self:GetExplodeTime() - CurTime()), "%02i:%02i"), "C4ModelTimer", -1, 1, COLOR_RED, TEXT_ALIGN_RIGHT)
            cam.End3D2D()
         end
      end
   end
end
