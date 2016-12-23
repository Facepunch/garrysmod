
ENT.Base = "base_entity"
ENT.Type = "trigger"

--[[---------------------------------------------------------
	Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()
	self:SetTrigger(true)
	self.Entities = {}
end

--[[---------------------------------------------------------
	Name: IsTouchedBy
-----------------------------------------------------------]]
function ENT:IsTouchedBy(ent)
	return table.HasValue(self.Entities, ent)
end

--[[---------------------------------------------------------
	Name: StartTouch
	Desc: Called when a entity starts touching us
-----------------------------------------------------------]]
function ENT:StartTouch(ent)
	if ( !self:PassesTriggerFilters(ent) ) then return end
	table.insert(self.Entities, ent)
	
	self:Input("OnStartTouch", self, ent)
end

--[[---------------------------------------------------------
	Name: EndTouch
	Desc: Called when a entity stops touching us
-----------------------------------------------------------]]
function ENT:EndTouch(ent)
	if ( !self:IsTouchedBy(ent) ) then return end
	table.RemoveByValue(self.Entities, ent)
	
	self:Input("OnEndTouch", self, ent)

	local bFoundOtherTouchee = false
	local iSize = #self.Entities
	for i=iSize, 0, -1 do 
		local hOther = self.Entities[i]
		if ( !IsValid(hOther) ) then
			table.RemoveByValue(self.Entities, hOther)
		else
			bFoundOtherTouchee = true
		end
	end

	if ( !bFoundOtherTouchee ) then
		self:Input("OnEndTouchAll", self, ent)
	end
end

--[[---------------------------------------------------------
	Name: Touch
	Desc: Called when a entity touches us
-----------------------------------------------------------]]
function ENT:Touch(ent)
	if ( !self:PassesTriggerFilters(ent) ) then return end
	if ( !table.HasValue(self.Entities, ent) ) then table.insert(self.Entities, ent) end
	
	self:Input("OnTouch", self, ent)
end

--[[---------------------------------------------------------
	Name: PassesTriggerFilters
	Desc: Return true if this object should trigger us
-----------------------------------------------------------]]
function ENT:PassesTriggerFilters( entity )
	return true
end

--[[---------------------------------------------------------
	Name: KeyValue
	Desc: Called when a keyvalue is added to us
-----------------------------------------------------------]]
function ENT:KeyValue( key, value )
end

--[[---------------------------------------------------------
	Name: Think
	Desc: Entity's think function.
-----------------------------------------------------------]]
function ENT:Think()
end

--[[---------------------------------------------------------
	Name: OnRemove
	Desc: Called just before entity is deleted
-----------------------------------------------------------]]
function ENT:OnRemove()
end