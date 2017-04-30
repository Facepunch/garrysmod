
ENT.Base = "base_entity"
ENT.Type = "brush"

--[[---------------------------------------------------------
	Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()
end

--[[---------------------------------------------------------
	Name: StartTouch
-----------------------------------------------------------]]
function ENT:StartTouch( entity )
end

--[[---------------------------------------------------------
	Name: EndTouch
-----------------------------------------------------------]]
function ENT:EndTouch( entity )
end

--[[---------------------------------------------------------
	Name: Touch
-----------------------------------------------------------]]
function ENT:Touch( entity )
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
