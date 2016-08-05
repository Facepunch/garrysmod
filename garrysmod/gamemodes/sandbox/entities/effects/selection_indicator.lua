
EFFECT.Mat = Material( "effects/select_dot" )

function EFFECT:Init( data )

	local pos = data:GetOrigin()
	local att = data:GetAttachment()
	local ent = data:GetEntity()
	local nrml = data:GetNormal()

	self:SetRenderBounds( Vector( -8, -8, -8 ), Vector( 8, 8, 8 ) )
	self:SetPos( pos )

	-- This 0.01 is a hack.. to prevent the angle being weird and messing up when we change it back to a normal
	self:SetAngles( nrml:Angle() + Angle( 0.01, 0.01, 0.01 ) )

	if ( IsValid( ent ) ) then
		self:SetParentPhysNum( att )
		self:SetParent( ent )
	end

	self.Size = 4
	self.Alpha = 255

	local effectdata = EffectData()
	effectdata:SetOrigin( pos )
	effectdata:SetNormal( nrml )
	effectdata:SetEntity( ent )
	effectdata:SetAttachment( att )

	for i = 0, 5 do

		util.Effect( "selection_ring", effectdata )

	end

end

function EFFECT:Think()

	self.Alpha = self.Alpha - 255 * FrameTime()
	if ( self.Alpha < 0 ) then return false end
	return true

end

function EFFECT:Render()

	if ( self.Alpha < 1 ) then return end

	render.SetMaterial( self.Mat )

	render.DrawQuadEasy( self:GetPos(), self:GetAngles():Forward(), self.Size, self.Size, Color( 255, 255, 255, self.Alpha ) )

end
