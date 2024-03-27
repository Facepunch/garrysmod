
local cl_showhints = CreateConVar( "cl_showhints", "1",
	bit.bor( FCVAR_ARCHIVE, FCVAR_USERINFO ), "Show hints called thru SANDBOX:AddHint", 0, 1 )

-- A list of hints we've already done so we don't repeat ourselves
GM.ProcessedHints = {}

local function ThrowHint( GM, name, length, sound )

	if ( !cl_showhints:GetBool() ) then return end

	local text = language.GetPhrase( "Hint_" .. name )
	local startpos, endpos, bind = text:find( "%%([^%%]+)%%" )

	if ( startpos ~= nil ) then
		local buffer = {}
		local bufferlen = 1
		local nextstartpos = 1
		
		repeat
			local key = input.LookupBinding( bind )

			if ( key ~= nil ) then
				key = key:upper()
			else
				key = bind .. " (command not bound to a key)"
			end

			-- Add the unaltered string + the translated key to the string buffer
			buffer[ bufferlen ] = text:sub( nextstartpos, startpos - 1 )
			buffer[ bufferlen + 1 ] = key
			bufferlen = bufferlen + 2

			nextstartpos = endpos + 1
			startpos, endpos, bind = text:find( "%%([^%%]+)%%", nextstartpos )
		until ( startpos == nil )
		
		text = table.concat( buffer, "", 1, bufferlen - 1 )
	end

	if ( length == nil ) then length = 20 end
	GM:AddNotify( text, NOTIFY_HINT, length )

	if ( sound == nil ) then sound = "ambient/water/drip" .. math.random( 1, 4 ) .. ".wav" end
	surface.PlaySound( sound )

end

function GM:AddHint( name, delay, length, sound )

	if ( self.ProcessedHints[ name ] ) then return end

	if ( !engine.IsPlayingDemo() ) then
		timer.Create( "GMOD_HintSystem_" .. name, delay, 1, function()
			ThrowHint( self, name, length, sound )
		end )
	end

	self.ProcessedHints[ name ] = true

end

function GM:SuppressHint( name )

	timer.Remove( "GMOD_HintSystem_" .. name )

end

function GM:UnprocessHint( name )

	self.ProcessedHints[ name ] = nil

end

-- Show opening menu hint if they haven't opened the menu within 30 seconds
GM:AddHint( "OpeningMenu", 30 )

-- Tell them that they can turn off hints as they fully load in
GM:AddHint( "Annoy1", 10 )
GM:AddHint( "Annoy2", 13 )
