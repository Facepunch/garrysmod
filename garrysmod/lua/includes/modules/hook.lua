
local gmod			= gmod
local pairs			= pairs
local isfunction	= isfunction
local isstring		= isstring
local IsValid		= IsValid
local unpack = unpack

module( "hook" )

Hooks = {}

--
-- For access to the Hooks table.. for some reason.
--
function GetTable() return Hooks end

--
-- Add a hook
--
function Add( event_name, name, func )

	if ( !isfunction( func ) ) then return end
	if ( !isstring( event_name ) ) then return end

	if (Hooks[ event_name ] == nil) then
		Hooks[ event_name ] = {}
	end

	Hooks[ event_name ][ name ] = func

end


--
-- Remove a hook
--
function Remove( event_name, name )

	if ( !isstring( event_name ) ) then return end
	if ( !Hooks[ event_name ] ) then return end

	Hooks[ event_name ][ name ] = nil

end

--
-- Run a hook (this replaces Call)
--
function Run( name, ... )
	return Call( name, nil, ... )
end



--
-- Called by the engine
-- Call( name, gamemode, ... )
--
Call = (function()
	local ret
	local function setRet(first, ...)
		if(first == nil)then
			return
		end
		ret = { first, ... }
	end
	return function( name, gm, ... )
		--
		-- Run hooks
		--
		local HookTable = Hooks[ name ]
		if ( HookTable != nil ) then
			ret = nil

			for k, v in pairs( HookTable ) do 
				
				if ( isstring( k ) ) then
					
					--
					-- If it's a string, it's cool
					--
					setRet( v( ... ) )

				else

					--
					-- If the key isn't a string - we assume it to be an entity
					-- Or panel, or something else that IsValid works on.
					--
					if ( IsValid( k ) ) then
						--
						-- If the object is valid - pass it as the first argument (self)
						--
						setRet( v( k, ... ) )
					else
						--
						-- If the object has become invalid - remove it
						--
						HookTable[ k ] = nil
					end
				end

				--
				-- Hook returned a value - it overrides the gamemode function
				--
				if ( ret ) then
					return unpack( ret )
				end
				
			end
		end

		--
		-- If called from hook.Run then gm will be nil.
		--
		if ( gm == nil && gmod != nil ) then
			gm = gmod.GetGamemode()
		end
		
		--
		-- Call the gamemode function
		--
		if ( !gm ) then return end
		
		local GamemodeFunction = gm[ name ]
		if ( GamemodeFunction == nil ) then return end
			
		return GamemodeFunction( gm, ... )	
		
	end
end)()
