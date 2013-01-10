
DEFINE_BASECLASS( "base_gmodentity" )

ENT.Type 			= "anim"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function ENT:Initialize()

	if (SERVER) then
		self:PhysicsInitBox( Vector( -4, -4, -4 ), Vector( 4, 4, 4 ) )
	end
	
end


--[[---------------------------------------------------------
	Name: SetBonePosition (serverside)
-----------------------------------------------------------]]
function ENT:SetNetworkedBonePosition( i, Pos, Angle )

	self:SetNetworkedVector( "Vector" .. i, Pos )
	self:SetNetworkedAngle( "Angle" .. i, Angle )

end


--[[---------------------------------------------------------
	Name: Draw (clientside)
-----------------------------------------------------------]]
function ENT:Draw()

	-- Don't draw it if we're a ragdoll and haven't  
	-- received all of the bone positions yet.
	local NumModelPhysBones = self:GetModelPhysBoneCount()
	if (NumModelPhysBones > 1) then
	
		if ( !self:GetNetworkedVector( "Vector0", false ) ) then
			return
		end
		
	end

	BaseClass.Draw( self )
	
end
