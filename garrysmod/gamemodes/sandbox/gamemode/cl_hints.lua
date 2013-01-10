

CreateClientConVar( "cl_showhints", "1", true, false )

-- A list of hints we've already done so we don't repeat ourselves`
local ProcessedHints = {}

--
-- Throw's a Hint to the screen
--
local function ThrowHint( name )

	local show = GetConVarNumber( "cl_showhints" )
	if ( show == 0 ) then return end

	if ( engine.IsPlayingDemo() ) then return end

	GAMEMODE:AddNotify( "#Hint_"..name, NOTIFY_HINT, 20 )
	
	surface.PlaySound( "ambient/water/drip"..math.random(1, 4)..".wav" )

end


--
-- Adds a hint to the queue
--
function GM:AddHint( name, delay )

	if (ProcessedHints[ name ]) then return end

	timer.Create( "HintSystem_"..name, delay, 1, function() ThrowHint( name ) end )
	ProcessedHints[ name ] = true
	
end

--
-- Removes a hint from the queue
--
function GM:SuppressHint( name )

	timer.Destroy( "HintSystem_"..name )
	
end

-- Show opening menu hint if they haven't opened the menu within 30 seconds
GM:AddHint( "OpeningMenu", 30 )

-- Tell them how to turn the hints off after 1 minute
GM:AddHint( "Annoy1", 5 )
GM:AddHint( "Annoy2", 7 )
