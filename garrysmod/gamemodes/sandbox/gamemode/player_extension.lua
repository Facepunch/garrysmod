
local meta = FindMetaTable( "Player" )

-- Return if there's nothing to add on to
if ( !meta ) then return end

g_SBoxObjects = {}

function meta:CheckLimit( str )

	-- No limits in single player
	if ( game.SinglePlayer() ) then return true end

	local c = cvars.Number( "sbox_max" .. str, 0 )

	if ( c < 0 ) then return true end
	if ( self:GetCount( str ) > c - 1 ) then
		if ( SERVER ) then self:LimitHit( str ) end
		return false
	end

	return true

end

function meta:GetCount( str, minus )

	if ( CLIENT ) then
		return self:GetNWInt( "Count." .. str, 0 )
	end

	minus = minus or 0

	if ( !self:IsValid() ) then return end

	local key = self:UniqueID()
	local tab = g_SBoxObjects[ key ]

	if ( !tab || !tab[ str ] ) then

		self:SetNWInt( "Count."..str, 0 )
		return 0

	end

	local c = 0

	for k, v in pairs ( tab[ str ] ) do

		if ( IsValid( v ) ) then
			c = c + 1
		else
			tab[ str ][ k ] = nil
		end

	end

	self:SetNWInt( "Count." .. str, c - minus )

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

		ent:CallOnRemove( "GetCountUpdate", function( ent, ply, str ) ply:GetCount( str, 1 ) end, self, str )

	end

end

function meta:LimitHit( str )

	self:SendLua( 'hook.Run("LimitHit","' .. str .. '")' )

end

function meta:AddCleanup( type, ent )

	cleanup.Add( self, type, ent )

end

if ( SERVER ) then

	function meta:GetTool( mode )

		local wep = self:GetWeapon( "gmod_tool" )
		if ( !IsValid( wep ) ) then return nil end

		local tool = wep:GetToolObject( mode )
		if ( !tool ) then return nil end

		return tool

	end

	function meta:SendHint( str, delay )

		self.Hints = self.Hints or {}
		if ( self.Hints[ str ] ) then return end

		self:SendLua( 'hook.Run("AddHint","' .. str .. '","' .. delay .. '")' )
		self.Hints[ str ] = true

	end

	function meta:SuppressHint( str )

		self.Hints = self.Hints or {}
		if ( self.Hints[ str ] ) then return end

		self:SendLua( 'hook.Run("SuppressHint","' .. str .. '")' )
		self.Hints[ str ] = true

	end

else

	function meta:GetTool( mode )

		local wep
		for _, ent in pairs( ents.FindByClass( "gmod_tool" ) ) do
			if ( ent:GetOwner() == self ) then wep = ent break end
		end
		if (!IsValid( wep )) then return nil end

		local tool = wep:GetToolObject( mode )
		if ( !tool ) then return nil end

		return tool

	end

end
