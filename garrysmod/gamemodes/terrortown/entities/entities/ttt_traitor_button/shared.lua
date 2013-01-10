--- Special button only for traitors and usable from range

ENT.Type = "anim"
ENT.Base = "base_anim"

AccessorFuncDT(ENT, "description", "Description")
AccessorFuncDT(ENT, "delay", "Delay")
AccessorFuncDT(ENT, "locked", "Locked")
AccessorFuncDT(ENT, "nextuse", "NextUseTime")

function ENT:SetupDataTables()
   self:DTVar("Float", 0, "delay")
   self:DTVar("Float", 1, "nextuse")
   self:DTVar("Bool", 0, "locked")
   self:DTVar("String", 0, "description")
end

function ENT:IsUsable()
   return (not self:GetLocked()) and self:GetNextUseTime() < CurTime()
end
