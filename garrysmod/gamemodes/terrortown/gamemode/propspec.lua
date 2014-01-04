---- Spectator prop meddling

local string = string
local math = math

PROPSPEC = {}

local propspec_toggle = GetConVar("ttt_spec_prop_control")
local propspec_base = GetConVar("ttt_spec_prop_base")
local propspec_min = GetConVar("ttt_spec_prop_maxpenalty")
local propspec_max = GetConVar("ttt_spec_prop_maxbonus")

function PROPSPEC.Start(ply, ent)
   ply:Spectate(OBS_MODE_CHASE)
   ply:SpectateEntity(ent, true)

   local bonus = math.Clamp(math.ceil(ply:Frags() / 2), propspec_min:GetInt(), propspec_max:GetInt())

   ply.propspec = {ent=ent, t=0, retime=0, punches=0, max=propspec_base:GetInt() + bonus}

   ent:SetNWEntity("spec_owner", ply)
   ply:SetNWInt("bonuspunches", bonus)
end

local function IsWhitelistedClass(cls)
   return (string.match(cls, "prop_physics*") or
           string.match(cls, "func_physbox*"))
end

function PROPSPEC.Target(ply, ent)
   if not propspec_toggle:GetBool() then return end
   if (not IsValid(ply)) or (not ply:IsSpec()) or (not IsValid(ent)) then return end

   if IsValid(ent:GetNWEntity("spec_owner", nil)) then return end

   local phys = ent:GetPhysicsObject()

   if ent:GetName() != "" and (not GAMEMODE.propspec_allow_named) then return end
   if (not IsValid(phys)) or (not phys:IsMoveable()) then return end

   -- normally only specific whitelisted ent classes can be possessed, but
   -- custom ents can mark themselves possessable as well
   if (not ent.AllowPropspec) and (not IsWhitelistedClass(ent:GetClass())) then return end

   PROPSPEC.Start(ply, ent)
end

function PROPSPEC.End(ply)
   local ent = ply.propspec.ent or ply:GetObserverTarget()
   if IsValid(ent) then
      ent:SetNWEntity("spec_owner", nil)
   end

   ply.propspec = nil
   ply:SpectateEntity(nil)
   ply:Spectate(OBS_MODE_ROAMING)
   ply:ResetViewRoll()

   timer.Simple(0.1, function()
                        if IsValid(ply) then ply:ResetViewRoll() end
                     end)
end

local propspec_force = GetConVar("ttt_spec_prop_force")

function PROPSPEC.Key(ply, key)
   local ent = ply.propspec.ent
   local phys = IsValid(ent) and ent:GetPhysicsObject()
   if (not IsValid(ent)) or (not IsValid(phys)) then 
      PROPSPEC.End(ply)
      return false
   end

   if not phys:IsMoveable() then
      PROPSPEC.End(ply)
      return true
   elseif phys:HasGameFlag(FVPHYSICS_PLAYER_HELD) then
      -- we can stay with the prop while it's held, but not affect it
      if key == IN_DUCK then
         PROPSPEC.End(ply)
      end
      return true
   end

   -- always allow leaving
   if key == IN_DUCK then
      PROPSPEC.End(ply)
      return true
   end

   local pr = ply.propspec
   if pr.t > CurTime() then return true end

   if pr.punches < 1 then return true end

   local m = math.min(150, phys:GetMass())
   local force = propspec_force:GetInt()
   local aim = ply:GetAimVector()

   local mf = m * force

   pr.t = CurTime() + 0.15

   if key == IN_JUMP then
      -- upwards bump
      phys:ApplyForceCenter(Vector(0,0, mf))
      pr.t = CurTime() + 0.05
   elseif key == IN_FORWARD then
      -- bump away from player
      phys:ApplyForceCenter(aim * mf)
   elseif key == IN_BACK then
      phys:ApplyForceCenter(aim * (mf * -1))
   elseif key == IN_MOVELEFT then
      phys:AddAngleVelocity(Vector(0, 0, 200))
      phys:ApplyForceCenter(Vector(0,0, mf / 3))
   elseif key == IN_MOVERIGHT then
      phys:AddAngleVelocity(Vector(0, 0, -200))
      phys:ApplyForceCenter(Vector(0,0, mf / 3))
   else
      return true -- eat other keys, and do not decrement punches
   end

   pr.punches = math.max(pr.punches - 1, 0)
   ply:SetNWFloat("specpunches", pr.punches / pr.max)

   return true
end

local propspec_retime = GetConVar("ttt_spec_prop_rechargetime")
function PROPSPEC.Recharge(ply)
   local pr = ply.propspec
   if pr.retime < CurTime() then
      pr.punches = math.min(pr.punches + 1, pr.max)
      ply:SetNWFloat("specpunches", pr.punches / pr.max)

      pr.retime = CurTime() + propspec_retime:GetFloat()
   end
end

