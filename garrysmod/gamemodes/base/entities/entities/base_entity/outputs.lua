
-- This is called from ENT:KeyValue(key,value) to store the output from
-- the map, it could also be called from ENT:AcceptInput I think, so if
-- ent_fire addoutput is used, we can store that too (that hasn't been
-- tested though).
-- Usage: self:StoreOutput("<name of output>","<entities to fire>,<input name>,<param>,<delay>,<times to be used>")
-- If called from ENT:KeyValue, then the first parameter is the key, and
-- the second is value.
function ENT:StoreOutput( name, info )

	-- Newer Source Engine games use this symbol as a delimiter
	local rawData = string.Explode( "\x1B", info )
	if ( #rawData < 2 ) then
		rawData = string.Explode( ",", info )
	end

	local Output = {}
	Output.entities = rawData[1] or ""
	Output.input = rawData[2] or ""
	Output.param = rawData[3] or ""
	Output.delay = tonumber( rawData[4] ) or 0
	Output.times = tonumber( rawData[5] ) or -1

	self.m_tOutputs = self.m_tOutputs or {}
	self.m_tOutputs[ name ] = self.m_tOutputs[ name ] or {}

	table.insert( self.m_tOutputs[ name ], Output )

end

-- This works like SetNetworkKeyValue, call it from ENT:KeyValue and it'll
-- return true if it successfully added an output from the passed KV pair.
function ENT:AddOutputFromKeyValue( key, value )

	if ( key:sub( 1, 2 ) == "On" ) then

		self:StoreOutput( key, value )
		return true

	end

	return false

end

-- Call from ENT:AcceptInput and it'll return true if the input was AddOutput
-- and if it successfully added an output.
-- Note that to be strictly compatible with Source entities, AddOutput should
-- allow setting arbitrary keyvalues, but this implementation does not.
function ENT:AddOutputFromAcceptInput( name, value )

	if ( name ~= "AddOutput" ) then

		return false

	end

	local pos = string.find( value, " ", 1, true )
	if ( pos == nil ) then

		return false

	end

	name, value = value:sub( 1, pos - 1 ), value:sub( pos + 1 )

	-- This is literally KeyValue but as an input and with ,s as :s.
	value = value:gsub( ":", "," )

	return self:AddOutputFromKeyValue( name, value )

end

-- Nice helper function, this does all the work. Returns false if the
-- output should be removed from the list.
local function FireSingleOutput( output, this, activator, data )

	if ( output.times == 0 ) then return false end

	local entitiesToFire = {}

	if ( output.entities == "!activator" ) then
		entitiesToFire = { activator }
	elseif ( output.entities == "!self" ) then
		entitiesToFire = { this }
	elseif ( output.entities == "!player" ) then
		entitiesToFire = player.GetAll()
	else
		entitiesToFire = ents.FindByName( output.entities )
	end

	for _, ent in ipairs( entitiesToFire ) do
		ent:Fire( output.input, data or output.param, output.delay, activator, this )
	end

	if ( output.times ~= -1 ) then
		output.times = output.times - 1
	end

	return ( output.times > 0 ) || ( output.times == -1 )

end

-- This function is used to trigger an output.
function ENT:TriggerOutput( name, activator, data )

	if ( !self.m_tOutputs ) then return end
	if ( !self.m_tOutputs[ name ] ) then return end

	local OutputList = self.m_tOutputs[ name ]

	for idx = #OutputList, 1, -1 do

		if ( OutputList[ idx ] and !FireSingleOutput( OutputList[ idx ], self, activator, data ) ) then

			-- Shift the indexes so this loop doesn't fail later
			table.remove( self.m_tOutputs[ name ], idx )

		end

	end

end
