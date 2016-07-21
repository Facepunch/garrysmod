
-- This is called from ENT:KeyValue(key,value) to store the output from
-- the map, it could also be called from ENT:AcceptInput I think, so if
-- ent_fire addoutput is used, we can store that too (that hasn't been
-- tested though).
-- Usage: self:StoreOutput("<name of output>","<entities to fire>,<input name>,<param>,<delay>,<times to be used>")
-- If called from ENT:KeyValue, then the first parameter is the key, and
-- the second is value.

function ENT:StoreOutput( name, info )
	local rawData = string.Explode( ",", info )

	local Output = {}
	Output.entities = rawData[1] or ""
	Output.input = rawData[2] or ""
	Output.param = rawData[3] or ""
	Output.delay = tonumber( rawData[4] ) or 0
	Output.times = tonumber( rawData[5] ) or -1

	self.Outputs = self.Outputs or {}
	self.Outputs[ name ] = self.Outputs[ name ] or {}

	table.insert( self.Outputs[ name ], Output )
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

	for _, ent in pairs( entitiesToFire ) do
		if ( output.delay == 0 ) then
			if ( IsValid( ent ) ) then
				ent:Input( output.input, activator, this, data or output.param )
			end
		else
			timer.Simple( output.delay, function()
				if ( IsValid( ent ) ) then
					ent:Input( output.input, activator, this, data or output.param )
				end
			end )
		end
	end

	if ( output.times ~= -1 ) then
		output.times = output.times - 1
	end

	return ( output.times > 0 ) || ( output.times == -1 )
end

-- This function is used to trigger an output.

function ENT:TriggerOutput( name, activator, data )
	if ( !self.Outputs ) then return end
	if ( !self.Outputs[ name ] ) then return end

	local OutputList = self.Outputs[ name ]

	for idx = #OutputList, 1, -1 do

		if ( OutputList[ idx ] and !FireSingleOutput( OutputList[ idx ], self.Entity, activator, data ) ) then

			self.Outputs[ name ][ idx ] = nil

		end

	end
end
