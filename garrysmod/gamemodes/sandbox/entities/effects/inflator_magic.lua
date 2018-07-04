
function EFFECT:Init( data )

	if ( GetConVarNumber( "gmod_drawtooleffects" ) == 0 ) then return end

	local vOffset = data:GetOrigin()

	local NumParticles = 16

	local emitter = ParticleEmitter( vOffset )

	for i = 0, NumParticles do

		local particle = emitter:Add( "effects/spark", vOffset )
		if ( particle ) then

			particle:SetDieTime( 0.5 )

			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )

			particle:SetStartSize( 1 )
			particle:SetEndSize( 0 )

			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetRollDelta( math.Rand( -200, 200 ) )

			particle:SetAirResistance( 400 )

			particle:SetVelocity( VectorRand() * 50 )
			particle:SetGravity( Vector( 0, 0, 100 ) )

		end

	end

	emitter:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
