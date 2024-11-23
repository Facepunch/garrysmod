
include( "shared.lua" )

--[[---------------------------------------------------------
	Name: Draw
	Desc: Draw it!
-----------------------------------------------------------]]
local Entity = FindMetaTable( "Entity" )

function ENT:Draw()
	Entity.DrawModel( self )
end

--[[---------------------------------------------------------
	Name: DrawTranslucent
	Desc: Draw translucent
-----------------------------------------------------------]]
function ENT:DrawTranslucent()

	-- This is here just to make it backwards compatible.
	-- You shouldn't really be drawing your model here unless it's translucent

	self:Draw()

end
