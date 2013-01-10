
--[[---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
-----------------------------------------------------------]]
function EFFECT:Init( data )
	
	local vOffset = data:GetOrigin()
	
	local NumParticles = 16
	
	local emitter = ParticleEmitter( vOffset )
	
		for i=0, NumParticles do
		
			local particle = emitter:Add( "effects/spark", vOffset )
			if (particle) then
				
				particle:SetVelocity( VectorRand() * 50 )
				
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.5 )
				
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				
				particle:SetStartSize( 1 )
				particle:SetEndSize( 0 )
				
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-200, 200) )
				
				particle:SetAirResistance( 400 )
				
				particle:SetGravity( Vector( 0, 0, 100 ) )
			
			end
			
		end
		
	emitter:Finish()
	
end


--[[---------------------------------------------------------
   THINK
-----------------------------------------------------------]]
function EFFECT:Think( )
	return false
end

--[[---------------------------------------------------------
   Draw the effect
-----------------------------------------------------------]]
function EFFECT:Render()
end
