

--[[---------------------------------------------------------
   If the entity is colliding with something this function
   will make it non solid and call a timer to itself.
   
   If it isn't colliding with anything it will make it solid
   and the timer will end.
-----------------------------------------------------------]]
function CheckPropSolid( e, solidtype, nonsolidtype, SolidCallback )

	if ( !IsValid( e ) ) then return end

	-- Trace our entity to check for collisions
	local trace = { start = e:GetPos(), endpos = e:GetPos(), filter = e }
	local tr = util.TraceEntity( trace, e ) 
	
	-- If it collides mark it non solid and test again in 0.5 seconds
	if ( tr.Hit ) then
	
		e:SetCollisionGroup( nonsolidtype )
		
		-- Check later and later every time.
		--timerlast = timerlast + 0.1
		timer.Simple( 0.5, CheckPropSolid, e, solidtype, nonsolidtype, SolidCallback )
		
	else
	
		e:SetCollisionGroup( solidtype )
		
		-- If we have a solid callback function call it
		if ( SolidCallback ) then
			SolidCallback( e )
		end
	
	end

end


function DoPropSpawnedEffect( e )

	if ( DisablePropCreateEffect ) then return end

	e:SetSpawnEffect( true );

end
