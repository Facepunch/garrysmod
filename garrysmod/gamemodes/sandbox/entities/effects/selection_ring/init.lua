

EFFECT.Mat = Material( "effects/select_ring" )

--[[---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
-----------------------------------------------------------]]
function EFFECT:Init( data )
	
	local size = 8
	self:SetCollisionBounds( Vector( -size,-size,-size ), Vector( size,size,size ) )
	
	local Pos = data:GetOrigin() + data:GetNormal() * 2
		
	self:SetPos( Pos )
	
	-- This 0.01 is a hack.. to prevent the angle being weird and messing up when we change it back to a normal
	self:SetAngles( data:GetNormal():Angle() + Angle( 0.01, 0.01, 0.01 ) )
	
	self:SetParentPhysNum( data:GetAttachment() )
	
	if (data:GetEntity():IsValid()) then
		self:SetParent( data:GetEntity() )
	end
	
	self.Pos = data:GetOrigin()
	self.Normal = data:GetNormal()
	
	self.Speed = math.Rand( 0.5, 1.5 )
	self.Size = 4
	self.Alpha = 255
	
	self.Life = 0.5
	
end


--[[---------------------------------------------------------
   THINK
-----------------------------------------------------------]]
function EFFECT:Think( )

	self.Alpha = self.Alpha - FrameTime() * 255 * 5 * self.Speed
	self.Size = self.Size + FrameTime() * 256 * self.Speed
	
	if (self.Alpha < 0 ) then return false end
	return true
	
end

--[[---------------------------------------------------------
   Draw the effect
-----------------------------------------------------------]]
function EFFECT:Render( )

	if (self.Alpha < 1 ) then return end

	render.SetMaterial( self.Mat )
	
	render.DrawQuadEasy( self:GetPos(),
						 self:GetAngles():Forward(),
						 self.Size, self.Size,
						 Color( math.Rand( 10, 150), math.Rand( 170, 220), math.Rand( 240, 255), self.Alpha ) )
						 
						

end
