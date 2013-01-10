

EFFECT.Mat = Material( "effects/select_dot" )

--[[---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
-----------------------------------------------------------]]
function EFFECT:Init( data )
	
	for i=0, 5 do
	
		local effectdata = EffectData()
			effectdata:SetOrigin( data:GetOrigin() )
			effectdata:SetNormal( data:GetNormal() )
			effectdata:SetEntity( data:GetEntity() )
			effectdata:SetAttachment( data:GetAttachment() )
		util.Effect( "selection_ring", effectdata )
		
	end
	
	local Pos = data:GetOrigin()
	
	self:SetRenderBounds( Vector( -8, -8, -8 ), Vector( 8, 8, 8 ) )
	self:SetPos( Pos )
	
	-- This 0.01 is a hack.. to prevent the angle being weird and messing up when we change it back to a normal
	self:SetAngles( data:GetNormal():Angle() + Angle( 0.01, 0.01, 0.01 ) )
	
	if (data:GetEntity():IsValid()) then
		self:SetParentPhysNum( data:GetAttachment() )
		self:SetParent( data:GetEntity() )
	end
	
	self.Size = 4
	self.Alpha = 255
	
end


--[[---------------------------------------------------------
   THINK
-----------------------------------------------------------]]
function EFFECT:Think( )

	self.Alpha = self.Alpha - 255 * FrameTime()
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
						 Color( 255, 255, 255, self.Alpha ) )
						 
	
end
