
ENT.Base = "base_entity"
ENT.Type = "point"

--[[---------------------------------------------------------
	Name: Initialize
	Desc: First function called. Use to set up your entity
-----------------------------------------------------------]]
function ENT:Initialize()
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

--
--	Name: OnRemove
--	Desc: Called just before entity is deleted
--
function ENT:OnRemove()
end

--
--	UpdateTransmitState
--
function ENT:UpdateTransmitState()

	--
	-- The default behaviour for point entities is to not be networked.
	-- If you're deriving an entity and want it to appear clientside, override this
	-- TRANSMIT_ALWAYS = always send, TRANSMIT_PVS = send if in PVS
	--
	return TRANSMIT_NEVER

end
