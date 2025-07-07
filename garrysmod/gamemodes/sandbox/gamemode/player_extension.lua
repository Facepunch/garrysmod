
local meta = FindMetaTable( "Player" )

-- Return if there's nothing to add on to
if ( !meta ) then return end

if ( SERVER ) then
	g_SBoxObjects = {}
end

function meta:CheckLimit( str )

	-- No limits in single player
	if ( game.SinglePlayer() ) then return true end

	local c = cvars.Number( "sbox_max" .. str, 0 )
	local count = self:GetCount( str )

	local ret = hook.Run( "PlayerCheckLimit", self, str, count, c )
	if ( ret != nil ) then
		if ( !ret && SERVER ) then self:LimitHit( str ) end
		return ret
	end

	if ( c < 0 ) then return true end

	if ( count > c - 1 ) then
		if ( SERVER ) then self:LimitHit( str ) end
		return false
	end

	return true

end

function meta:GetCount( str, minus )

	if ( CLIENT ) then
		return self:GetNWInt( "Count." .. str, 0 )
	end

	if ( !self:IsValid() ) then return end

	local key = self:UniqueID()
	local tab = g_SBoxObjects[ key ]
	if ( !tab || !tab[ str ] ) then
		self:SetNWInt( "Count." .. str, 0 )
		return 0
	end

	local c = 0
	for k, v in pairs( tab[ str ] ) do

		if ( IsValid( v ) && !v:IsMarkedForDeletion() ) then
			c = c + 1
		else
			tab[ str ][ k ] = nil
		end

	end

	-- Clear the table for this "count type" if its empty
	if ( c == 0 ) then tab[ str ] = nil end

	-- Clear the top level table for the player if there's nothing in it left
	if ( !next( tab ) ) then g_SBoxObjects[ key ] = nil end

	minus = minus or 0
	self:SetNWInt( "Count." .. str, math.max( c - minus, 0 ) )

	return c

end

function meta:AddCount( str, ent )

	if ( SERVER ) then

		local key = self:UniqueID()
		g_SBoxObjects[ key ] = g_SBoxObjects[ key ] or {}
		g_SBoxObjects[ key ][ str ] = g_SBoxObjects[ key ][ str ] or {}

		local tab = g_SBoxObjects[ key ][ str ]

		table.insert( tab, ent )

		-- Update count (for client)
		self:GetCount( str )

		-- Update count on deletion
		ent:CallOnRemove( "GetCountUpdate", function( ent, ply, countType, uid )
			if ( !IsValid( ply ) ) then ply = player.GetByUniqueID( uid ) end
			ply:GetCount( countType )
		end, self, str, key )

	end

end

function meta:GetTool( mode )

	local wep = self:GetWeapon( "gmod_tool" )
	if ( !IsValid( wep ) || !wep.GetToolObject ) then return nil end

	local tool = wep:GetToolObject( mode )
	if ( !tool ) then return nil end

	return tool

end

if ( SERVER ) then

	function meta:AddCleanup( type, ent )

		cleanup.Add( self, type, ent )

	end

	function meta:LimitHit( str )

		self:SendLua( string.format( 'hook.Run("LimitHit",%q)', str ) )

	end

	function meta:SendHint( str, delay )

		self.Hints = self.Hints or {}
		if ( self.Hints[ str ] ) then return end

		self:SendLua( string.format( 'hook.Run("AddHint",%q,%d)', str, delay ) )
		self.Hints[ str ] = true

	end

	function meta:SuppressHint( str )

		self.Hints = self.Hints or {}
		if ( self.Hints[ str ] ) then return end

		self:SendLua( string.format( 'hook.Run("SuppressHint",%q)', str ) )
		self.Hints[ str ] = true

	end

end
