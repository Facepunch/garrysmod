
local gmod			= gmod
local table 		= table
local pairs			= pairs
local isfunction	= isfunction
local isstring		= isstring
local IsValid		= IsValid

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

	if ( !isstring( name ) && IsValid( name ) ) then
		Hooks[ event_name ][ name ] = Hooks[ event_name ][ name ] or {}
		return table.insert( Hooks[ event_name ][ name ], func )
	else
		Hooks[ event_name ][ name ] = func
	end

end


--
-- Remove a hook
--
function Remove( event_name, name, ent_id )

	if ( !isstring( event_name ) ) then return end
	if ( !Hooks[ event_name ] ) then return end

	if ( ent_id && Hooks[ event_name ][ name ] ) then
		Hooks[ event_name ][ name ][ ent_id ] = nil
	else
		Hooks[ event_name ][ name ] = nil
	end

end

--
-- Run a hook (this replaces Call)
--
function Run( name, ... )
	return Call( name, nil, ... )
end

--
-- Called by the engine
--
function Call( name, gm, ... )

	local ret

	--
	-- If called from hook.Run then gm will be nil.
	--
	if ( gm == nil && gmod != nil ) then
		gm = gmod.GetGamemode()
	end

	--
	-- Run hooks
	--
	local HookTable = Hooks[ name ]
	if ( HookTable != nil ) then
	
		local a, b, c, d, e, f;

		for k, v in pairs( HookTable ) do 
			
			if ( isstring( k ) ) then
				
				--
				-- If it's a string, it's cool
				--
				a, b, c, d, e, f = v( ... )

			else

				--
				-- If the key isn't a string - we assume it to be an entity
				-- Or panel, or something else that IsValid works on.
				--
				if ( IsValid( k ) ) then
					for HookID, func in pairs( v ) do
						--
						-- If the object is valid - pass it as the first argument (self)
						--
						a, b, c, d, e, f = func( k, ... )
					end
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
			if ( a != nil ) then
				return a, b, c, d, e, f
			end
			
		end
	end
	
	--
	-- Call the gamemode function
	--
	if ( !gm ) then return end
	
	local GamemodeFunction = gm[ name ]
	if ( GamemodeFunction == nil ) then return end
		
	return GamemodeFunction( gm, ... )	
	
end
