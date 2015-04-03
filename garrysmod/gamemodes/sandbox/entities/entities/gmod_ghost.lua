
DEFINE_BASECLASS( "base_gmodentity" )

ENT.Type 			= "anim"

ENT.Spawnable			= false

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
function ENT:SetNWBonePosition( i, Pos, Angle )

	self:SetNWVector( "Vector" .. i, Pos )
	self:SetNWAngle( "Angle" .. i, Angle )

end

ENT.SetNetworkedBonePosition = meta.SetNWBonePosition


--[[---------------------------------------------------------
	Name: Draw (clientside)
-----------------------------------------------------------]]
function ENT:Draw()

	-- Don't draw it if we're a ragdoll and haven't  
	-- received all of the bone positions yet.
	local NumModelPhysBones = self:GetModelPhysBoneCount()
	if (NumModelPhysBones > 1) then
	
		if ( !self:GetNWVector( "Vector0", false ) ) then
			return
		end
		
	end

	BaseClass.Draw( self )
	
end
