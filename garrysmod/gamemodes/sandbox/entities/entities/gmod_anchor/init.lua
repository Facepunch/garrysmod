
ENT.Type = "anim"

function ENT:Initialize()

	self:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" ) 
	self:PhysicsInit( SOLID_VPHYSICS )
	
	self:SetNotSolid( true )
	self:SetNoDraw( true )
	self:DrawShadow( false )
	
	local Phys = self:GetPhysicsObject()
	if ( Phys ) then
	
		Phys:EnableMotion( false )
		Phys:EnableCollisions( false )
		
	end
	
	self:SetUnFreezable( true )
	
end
