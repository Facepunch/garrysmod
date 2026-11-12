
function EFFECT:GetParticlePosition( i )
	if ( self.BoneStartPos and self.BoneEndPos and i != 0 ) then
		return LerpVector( math.random(), self.BoneStartPos, self.BoneEndPos )
	end

	return self.DefaultPosition
end

function EFFECT:Init( data )

	if ( GetConVarNumber( "gmod_drawtooleffects" ) == 0 ) then return end

	local vOffset = data:GetOrigin()
	local boneId = data:GetAttachment()
	local ent = data:GetEntity()
	local scaleDir = data:GetScale()
	self.DefaultPosition = vOffset

	local boneScale = Vector( 1, 1, 1 )
	if ( IsValid( ent ) and boneId > 0 ) then

		boneScale = ent:GetManipulateBoneScale( boneId )
		local pos, _ = ent:GetBonePosition( boneId )
		if ( pos ) then
			self.BoneStartPos = pos
			self.BoneEndPos = pos
		end

		for i = 1, ent:GetBoneCount() do
			if ( ent:GetBoneMatrix( i ) and ent:GetBoneParent( i ) == boneId and ent:GetBoneMatrix( boneId ) ) then
				local posNext, _ = ent:GetBonePosition( i )
				if ( posNext and posNext == ent:GetPos() and ent:GetBoneMatrix( i ) ) then
					posNext = ent:GetBoneMatrix( i ):GetTranslation()
				end
				if ( posNext ) then
					self.BoneEndPos = posNext
					break
				end
			end
		end
	end

	local emitter = ParticleEmitter( vOffset )

	local NumParticles = 16
	for i = 0, NumParticles do

		local vel = VectorRand() * 50 * boneScale
		local velOffset = Vector()
		if ( scaleDir > 0 ) then
			velOffset = vel / 7
			vel = vel * -1
		end

		local particle = emitter:Add( "effects/spark_inflator", self:GetParticlePosition( i ) + velOffset )
		if ( particle ) then

			particle:SetDieTime( 0.5 )

			particle:SetStartAlpha( 170 )
			particle:SetEndAlpha( 0 )

			particle:SetStartSize( 1 )
			particle:SetEndSize( 0 )

			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetRollDelta( math.Rand( -200, 200 ) )

			particle:SetAirResistance( 400 )

			particle:SetVelocity( vel )
			if ( scaleDir < 0 ) then
				particle:SetGravity( Vector( 0, 0, 100 ) )
			end

		end

	end

	emitter:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
