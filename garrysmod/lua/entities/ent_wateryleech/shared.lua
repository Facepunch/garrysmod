ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName		= "Carnivorous Leeches"
ENT.Author			= "Andreas 'Nekres' G."
ENT.Category 		= "Half-Life 2"
ENT.Contact    		= "N/A"
ENT.Purpose 		= "Stable remake of source engines 'ent_watery_leech' spawned by source engines 'trigger_waterydeath'."
ENT.Instructions 	= "If owner enters any waters, he will get damage over time by a swarm of leeches." 
ENT.AutomaticFrameAdvance = true

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:Initialize()
	util.PrecacheSound( Sound("coast.leech_bites_loop") )
	util.PrecacheSound( Sound("coast.leech_water_churn_loop") )
	self.leech_bites_loop = CreateSound(self.Entity, Sound("coast.leech_bites_loop"))
	self.leech_water_churn_loop = CreateSound(self.Entity, Sound("coast.leech_water_churn_loop"))
end
function ENT:Think()
	if (!self:GetNWEntity("target")) then return end

	local target = self:GetNWEntity("target")

	if (target:IsPlayer()) then
		if (target:WaterLevel() == 3) then

			self.leech_bites_loop:Play()
			self.leech_water_churn_loop:Play()

			// Majority of body in water: Play sounds.
		elseif (target:WaterLevel() == 2) then

			self.leech_bites_loop:Play()
			self.leech_water_churn_loop:Play()

			// Not or just feet in water: Stop sounds.
		elseif (target:WaterLevel() <= 1) then

			self.leech_bites_loop:Stop()
			self.leech_water_churn_loop:Stop()

		end
	end

	self:NextThink( CurTime() )
	return true
end
function ENT:OnRemove()
	if (self.leech_bites_loop && self.leech_water_churn_loop) then
		self.leech_bites_loop:Stop()
		self.leech_water_churn_loop:Stop()
	end
end