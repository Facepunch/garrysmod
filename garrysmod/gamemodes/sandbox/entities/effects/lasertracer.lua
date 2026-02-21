
EFFECT.Mat = Material( "effects/spark" )

function EFFECT:Init( data )

	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()

	local ent = data:GetEntity()
	local attid = data:GetAttachment()

	if ( IsValid( ent ) && attid > 0 ) then
		if ( ent.Owner == LocalPlayer() && LocalPlayer():GetViewModel() == LocalPlayer() ) then ent = ent.Owner:GetViewModel() end

		local att = ent:GetAttachment( attid )
		if ( att ) then
			self.StartPos = att.Pos
		end
	end

	self.Dir = self.EndPos - self.StartPos

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )

	self.TracerTime = math.min( 1, self.StartPos:Distance( self.EndPos ) / 10000 )
	self.Length = math.Rand( 0.1, 0.15 )

	-- Die when it reaches its target
	self.DieTime = CurTime() + self.TracerTime

end

function EFFECT:Think()

	if ( CurTime() > self.DieTime ) then

		-- Awesome End Sparks
		local effectdata = EffectData()
		effectdata:SetOrigin( self.EndPos + self.Dir:GetNormalized() * -2 )
		effectdata:SetNormal( self.Dir:GetNormalized() * -3 )
		effectdata:SetMagnitude( 1 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 6 )
		util.Effect( "Sparks", effectdata )

		return false
	end

	return true

end

function EFFECT:Render()

	local fDelta = ( self.DieTime - CurTime() ) / self.TracerTime
	fDelta = math.Clamp( fDelta, 0, 1 ) ^ 0.5

	render.SetMaterial( self.Mat )

	local sinWave = math.sin( fDelta * math.pi )

	render.DrawBeam( self.EndPos - self.Dir * ( fDelta - sinWave * self.Length ),
		self.EndPos - self.Dir * ( fDelta + sinWave * self.Length ),
		2 + sinWave * 16, 1, 0, Color( 0, 255, 0, 255 ) )

end
