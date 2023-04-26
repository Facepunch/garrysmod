
local cl_showhints = CreateClientConVar( "cl_showhints", "1", true, false )

-- A list of hints we've already done so we don't repeat ourselves`
local ProcessedHints = {}

--
-- Throw's a Hint to the screen
--
local function ThrowHint( GM, name, force, length )

	if ( !cl_showhints:GetBool() ) then return end

	local text = language.GetPhrase( "Hint_" .. name )

	local s, e, group = string.find( text, "%%([^%%]+)%%" )
	while ( s ) do
		local key = input.LookupBinding( group )
		if ( !key ) then
			if ( !force ) then return end
			key = "<NOT BOUND>"
		end

		text = string.gsub( text, "%%([^%%]+)%%", "'" .. key:upper() .. "'" )
		s, e, group = string.find( text, "%%([^%%]+)%%" )
	end

	if ( length == nil ) then length = 20 end
	GM:AddNotify( text, NOTIFY_HINT, length )

	surface.PlaySound( "ambient/water/drip" .. math.random( 1, 4 ) .. ".wav" )

end


--
-- Adds a hint to the queue
--
function GM:AddHint( name, delay, force, length )

	if ( ProcessedHints[ name ] ) then return end

	if ( !engine.IsPlayingDemo() ) then
		timer.Create( "HintSystem_" .. name, delay, 1, function()
			ThrowHint( self, name, force, length )
		end )
	end

	ProcessedHints[ name ] = true

end

--
-- Removes a hint from the queue
--
function GM:SuppressHint( name )

	timer.Remove( "HintSystem_" .. name )

end

function GM:UnprocessHint( name )

	ProcessedHints[ name ] = nil

end

-- Show opening menu hint if they haven't opened the menu within 30 seconds
GM:AddHint( "OpeningMenu", 30 )

-- Tell them that they can turn off hints as they load in
GM:AddHint( "Annoy1", 10 )
GM:AddHint( "Annoy2", 12 )
