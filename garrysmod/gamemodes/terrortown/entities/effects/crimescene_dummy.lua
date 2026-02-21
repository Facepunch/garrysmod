
local backup_mdl = Model("models/player/phoenix.mdl")

function EFFECT:Init(data)
   self.Corpse = data:GetEntity()

   self:SetPos(data:GetOrigin())

   local ang = data:GetAngles()
   -- pitch is done via aim_pitch, and roll shouldn't happen
   ang.r = 0
   ang.p = 0
   self:SetAngles(ang)

   self:SetRenderBounds(Vector(-18, -18, 0), Vector(18, 18, 64))

   self.Sequence = data:GetColor()
   self.Cycle    = data:GetScale()
   self.Duration = data:GetRadius() or 0
   self.EndTime  = CurTime() + self.Duration

   self.FadeTime = 2

   self.FadeIn   = CurTime() + self.FadeTime
   self.FadeOut  = self.EndTime - self.FadeTime

   self.Alpha = 0

   if IsValid(self.Corpse) then
      local mdl = self.Corpse:GetModel()
      mdl = util.IsValidModel(mdl) and mdl or backup_mdl

      self.Dummy = ClientsideModel(mdl, RENDERGROUP_TRANSLUCENT)
      if not self.Dummy then return end
      self.Dummy:SetPos(data:GetOrigin())
      self.Dummy:SetAngles(ang)
      self.Dummy:AddEffects(EF_NODRAW)

      self.Dummy:SetSequence(self.Sequence)
      self.Dummy:SetCycle(self.Cycle)

      local pose = data:GetStart()
      self.Dummy:SetPoseParameter("aim_yaw", pose.x)
      self.Dummy:SetPoseParameter("aim_pitch", pose.y)
      self.Dummy:SetPoseParameter("move_yaw", pose.z)
   else
      self.Dummy = nil
   end
end

function EFFECT:Think()
   if self.EndTime < CurTime() then
      SafeRemoveEntity(self.Dummy)
      return false
   end

   if self.FadeIn > CurTime() then
      self.Alpha = 1 - ((self.FadeIn - CurTime()) / self.FadeTime)
   elseif self.FadeOut < CurTime() then
      self.Alpha = 1 - ((CurTime() - self.FadeOut) / self.FadeTime)
   end

   return IsValid(self.Dummy)
end

function EFFECT:Render()
   render.SuppressEngineLighting( true )
   render.SetColorModulation(0.4, 0.4, 1)
   render.SetBlend(0.8 * self.Alpha)

   if self.Dummy then
      --self.Dummy:ClearPoseParameters()
      self.Dummy:DrawModel()
   end

   render.SetBlend(1)
   render.SetColorModulation(1, 1, 1)
   render.SuppressEngineLighting(false)
end

