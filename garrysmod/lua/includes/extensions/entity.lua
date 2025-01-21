
local meta = FindMetaTable( "Entity" )

-- Return if there's nothing to add on to
if ( !meta ) then return end

function meta:SetSpawnFlags( flags )
    self:SetKeyValue( "spawnflags", flags )
end

function meta:AddSpawnFlags( flags )
    self:SetKeyValue( "spawnflags", bit.bor( self:GetSpawnFlags(), flags ) )
end

function meta:RemoveSpawnFlags( flags )
    self:SetKeyValue( "spawnflags", bit.band( self:GetSpawnFlags(), bit.bnot( flags ) ) )
end

function meta:GetShouldPlayPickupSound()
	return self.m_bPlayPickupSound or false
end

function meta:SetShouldPlayPickupSound( bPlaySound )
	self.m_bPlayPickupSound = tobool( bPlaySound ) or false
end

--
-- Entity index accessor. This used to be done in engine, but it's done in Lua now because it's faster
--
function meta:__index( key )

	--
	-- Search the metatable. We can do this without dipping into C, so we do it first.
	--
	local val = meta[ key ]
	if ( val != nil ) then return val end

	--
	-- Search the entity table
	--
	local tab = meta.GetTable( self )
	if ( tab ) then
		local tabval = tab[ key ]
		if ( tabval != nil ) then return tabval end
	end

	--
	-- Legacy: sometimes use self.Owner to get the owner.. so lets carry on supporting that stupidness
	-- This needs to be retired, just like self.Entity was.
	--
	if ( key == "Owner" ) then return meta.GetOwner( self ) end

	return nil

end

--[[---------------------------------------------------------
	Name: Short cut to add entities to the table
-----------------------------------------------------------]]
function meta:GetVar( name, default )

	local Val = self:GetTable()[ name ]
	if ( Val == nil ) then return default end

	return Val

end

if ( SERVER ) then

	function meta:SetCreator( ply --[[= NULL]] )
		if ( ply == nil ) then
			ply = NULL
		elseif ( !isentity( ply ) ) then
			error( "bad argument #1 to 'SetCreator' (Entity expected, got " .. type( ply ) .. ")", 2 )
		end

		self.m_PlayerCreator = ply
	end

	function meta:GetCreator()
		return self.m_PlayerCreator or NULL
	end

end

--[[---------------------------------------------------------
	Name: Returns true if the entity has constraints attached to it
-----------------------------------------------------------]]
function meta:IsConstrained()

	if ( CLIENT ) then return self:GetNWBool( "IsConstrained" ) end

	local c = self:GetTable().Constraints
	local bIsConstrained = false

	if ( c ) then

		for k, v in pairs( c ) do
			if ( IsValid( v ) ) then bIsConstrained = true break end
			c[ k ] = nil
		end

	end

	self:SetNWBool( "IsConstrained", bIsConstrained )
	return bIsConstrained

end

--[[---------------------------------------------------------
	Name: Short cut to set tables on the entity table
-----------------------------------------------------------]]
function meta:SetVar( name, value )

	self:GetTable()[ name ] = value

end

--[[---------------------------------------------------------
	Name: CallOnRemove
	Desc: Call this function when this entity dies.
	Calls the function like Function( <entity>, <optional args> )
-----------------------------------------------------------]]
function meta:CallOnRemove( name, func, ... )

	local mytable = self:GetTable()
	mytable.OnDieFunctions = mytable.OnDieFunctions or {}

	mytable.OnDieFunctions[ name ] = { Name = name, Function = func, Args = { ... } }

end

--[[---------------------------------------------------------
	Name: RemoveCallOnRemove
	Desc: Removes the named hook
-----------------------------------------------------------]]
function meta:RemoveCallOnRemove( name )

	local mytable = self:GetTable()
	mytable.OnDieFunctions = mytable.OnDieFunctions or {}
	mytable.OnDieFunctions[ name ] = nil

end

--[[---------------------------------------------------------
	Simple mechanism for calling the die functions.
-----------------------------------------------------------]]
local function DoDieFunction( ent )

	if ( !ent or !ent.OnDieFunctions ) then return end

	for k, v in pairs( ent.OnDieFunctions ) do

		-- Functions aren't saved - so this could be nil if we loaded a game.
		if ( v && v.Function ) then

			v.Function( ent, unpack( v.Args ) )

		end

	end

end

hook.Add( "EntityRemoved", "DoDieFunction", DoDieFunction )

function meta:PhysWake()

	local phys = self:GetPhysicsObject()
	if ( !IsValid( phys ) ) then return end

	phys:Wake()

end

local GetColorOriginal4 = meta.GetColor4Part  -- Do not use me! I will be removed
local GetColorOriginal = meta.GetColor
function meta:GetColor()

	-- Backwards comp slower method
	if ( !GetColorOriginal4 ) then
		return GetColorOriginal( self )
	end

	return Color( GetColorOriginal4( self ) )

end

local SetColorOriginal4 = meta.SetColor4Part  -- Do not use me! I will be removed
local SetColorOriginal = meta.SetColor
function meta:SetColor( col )

	-- Backwards comp slower method
	if ( !SetColorOriginal4 ) then
		return SetColorOriginal( self, col )
	end

	-- Even more backwards compat
	if ( !col ) then
		return SetColorOriginal4( self, 255, 255, 255, 255 )
	end

	SetColorOriginal4( self, col.r, col.g, col.b, col.a )

end

function meta:GetChildBones( bone )

	local bonecount = self:GetBoneCount()
	if ( bonecount == 0 or bonecount < bone ) then return end

	local bones = {}

	for k = 0, bonecount - 1 do
		if ( self:GetBoneParent( k ) != bone ) then continue end
		table.insert( bones, k )
	end

	return bones

end

function DTVar_ReceiveProxyGL( ent, name, id, val )
	if ( ent.CallDTVarProxies ) then
		ent:CallDTVarProxies( name, id, val )
	end
end

function meta:InstallDataTable()

	self.dt = {}
	local typetable = {}
	local datatable = {}
	local keytable = {}
	local dtmeta = {}
	local editing = {}

	dtmeta.__index = function ( ent, key )

		local dt = datatable[ key ]
		if ( dt == nil ) then return end

		return dt.GetFunc( self, dt.index, key )

	end

	dtmeta.__newindex = function( ent, key, value )

		local dt = datatable[ key ]
		if ( dt == nil ) then return end

		dt.SetFunc( self, dt.index, value )

	end

	local function FindUnusedIndex( typename )

		local tbl = typetable[ typename ]
		if ( !tbl ) then return 0 end

		for i = 0, 31 do
			if ( !tbl[i] ) then return i end
		end

	end

	self.IsDTVarSlotUsed = function( ent, typename, index )

		local tbl = typetable[ typename ]
		if ( !tbl or !tbl[index] ) then return false end
		return true

	end

	self.DTVar = function( ent, typename, index, name )

		if ( isstring( index ) && !name ) then
			name = index
			index = FindUnusedIndex( typename )
		elseif ( !index && isstring( name ) ) then
			index = FindUnusedIndex( typename )
		end

		local SetFunc = ent[ "SetDT" .. typename ]
		local GetFunc = ent[ "GetDT" .. typename ]

		if ( !SetFunc or !GetFunc ) then
			MsgN( "Couldn't addvar ", name, " - type ", typename, " is invalid!" )
			return
		end

		local data = {
			index = index,
			name = name,
			SetFunc = SetFunc,
			GetFunc = GetFunc,
			typename = typename,
			Notify = {}
		}

		typetable[ typename ] = typetable[ typename ] or {}
		typetable[ typename ][ index ] = data
		datatable[ name ] = data

		return data

	end

	--
	-- Access to the editing table
	--
	self.GetEditingData = function()
		return editing
	end

	--
	-- Adds an editable variable.
	--
	self.SetupEditing = function( ent, name, keyname, data )

		if ( !data ) then return end

		if ( !data.title ) then data.title = name end

		editing[ keyname ] = data

	end

	self.SetupKeyValue = function( ent, keyname, kvtype, setfunc, getfunc, other_data )

		keyname = keyname:lower()

		keytable[ keyname ] = {
			KeyName		= keyname,
			Set			= setfunc,
			Get			= getfunc,
			Type		= kvtype
		}

		if ( other_data ) then

			table.Merge( keytable[ keyname ], other_data )

		end

	end

	local CallProxies = function( ent, tbl, name, oldval, newval )

		for i = 1, #tbl do
			tbl[ i ]( ent, name, oldval, newval )
		end

	end

	self.CallDTVarProxies = function( ent, typename, index, newVal )

		local t = typetable[ typename ] && typetable[ typename ][ index ] or nil
		if ( t ) then
			CallProxies( ent, t.Notify, t.name, t.GetFunc( ent, index ), newVal )
		end

	end

	self.NetworkVar = function( ent, typename, index, name, other_data )

		if ( isstring( index ) && ( istable( name ) or !name ) ) then
			other_data = name
			name = index
			index = FindUnusedIndex( typename )
		elseif ( !index && isstring( name ) ) then
			index = FindUnusedIndex( typename )
		end

		local t = ent.DTVar( ent, typename, index, name )

		-- Some addons call these on the entity table, and that used to work, so we keep that
		ent[ "Set" .. name ] = function( selfent, value )
			CallProxies( ent, t.Notify, name, t.GetFunc( ent, index ), value )
			t.SetFunc( ent, index, value )
		end

		ent[ "Get" .. name ] = function( selfent )
			return t.GetFunc( ent, index )
		end

		if ( !other_data ) then return end

		-- This KeyName stuff is absolutely unnecessary, there's absolutely no reason for it to exist
		-- But we cannot remove it now because dupes will break. It should've used the "name" variable
		if ( other_data.KeyName ) then
			ent:SetupKeyValue( other_data.KeyName, typename, ent[ "Set" .. name ], ent[ "Get" .. name ], other_data )
			ent:SetupEditing( name, other_data.KeyName, other_data.Edit )
		end

	end

	--
	-- Add a function that gets called when the variable changes
	-- Note: this doesn't work on the client yet - which drastically reduces its usefulness.
	--
	self.NetworkVarNotify = function( ent, name, func )

		if ( !datatable[ name ] ) then error( "calling NetworkVarNotify on missing network var " .. name ) end

		table.insert( datatable[ name ].Notify, func )

	end

	--
	-- Create an accessor of an element. This is mainly so you can use spare
	-- network vars (vectors, angles) to network single floats.
	--
	self.NetworkVarElement = function( ent, typename, index, element, name, other_data )

		if ( isstring( index ) && isstring( element ) ) then
			other_data = name
			name = element
			element = index
			index = FindUnusedIndex( typename )
		elseif ( !index && isstring( name ) ) then
			index = FindUnusedIndex( typename )
		end

		local t = ent.DTVar( ent, typename, index, name )
		t.element = element

		ent[ "Set" .. name ] = function( selfent, value )
			local old = t.GetFunc( selfent, index )
			old[ element ] = value
			t.SetFunc( selfent, index, old )
		end

		ent[ "Get" .. name ] = function( selfent )
			return t.GetFunc( selfent, index )[ element ]
		end

		if ( !other_data ) then return end

		-- This KeyName stuff is absolutely unnecessary, there's absolutely no reason for it to exist
		-- But we cannot remove it now because dupes will break. It should've used the "name" variable
		if ( other_data.KeyName ) then
			ent:SetupKeyValue( other_data.KeyName, "float", ent[ "Set" .. name ], ent[ "Get" .. name ], other_data )
			ent:SetupEditing( name, other_data.KeyName, other_data.Edit )
		end

	end

	self.SetNetworkKeyValue = function( ent, key, value )

		key = key:lower()

		local k = keytable[ key ]
		if ( !k ) then return end

		local v = util.StringToType( value, k.Type )
		if ( v == nil ) then return end

		k.Set( ent, v )
		return true

	end

	self.GetNetworkKeyValue = function( ent, key )

		key = key:lower()

		local k = keytable[ key ]
		if ( !k ) then return end

		return k.Get( ent )

	end

	--
	-- Called by the duplicator system to get the network vars
	--
	self.GetNetworkVars = function( ent )

		local dt = {}

		for k, v in pairs( datatable ) do

			-- Don't try to save entities (yet?)
			if ( v.typename == "Entity" ) then continue end

			if ( v.element ) then
				dt[ k ] = v.GetFunc( ent, v.index )[ v.element ]
			else
				dt[ k ] = v.GetFunc( ent, v.index )
			end

		end

		--
		-- If there's nothing in our table - then return nil.
		--
		if ( table.IsEmpty( dt ) ) then return nil end

		return dt

	end

	--
	-- Called by the duplicator system to restore from network vars
	--
	self.RestoreNetworkVars = function( ent, tab )

		if ( !tab ) then return end

		-- Loop this entities data table
		for k, v in pairs( datatable ) do

			-- If it contains this entry
			if ( tab[ k ] == nil ) then continue end

			-- Support old saves/dupes with incorrectly saved data
			if ( v.element && ( isangle( tab[ k ] ) or isvector( tab[ k ] ) ) ) then
				tab[ k ] = tab[ k ][ v.element ]
			end

			-- Set it.
			if ( ent[ "Set" .. k ] ) then
				ent[ "Set" .. k ]( ent, tab[ k ] )
			else
				v.SetFunc( ent, v.index, tab[ k ] )
			end

		end

	end

	setmetatable( self.dt, dtmeta )

	--
	-- In sandbox the client can edit certain values on certain entities
	-- we implement this here incase any other gamemodes want to use it
	-- although it is of course deactivated by default.
	--

	--
	-- This function takes a keyname and a value - both strings.
	--
	--
	-- Called serverside it will set the value.
	--
	self.EditValue = function( ent, variable, value )

		if ( !isstring( variable ) ) then return end
		if ( !isstring( value ) ) then return end

		--
		-- It can be called clientside to send a message to the server
		-- to request a change of value.
		--
		if ( CLIENT ) then

			net.Start( "editvariable" )
				net.WriteEntity( ent )
				net.WriteString( variable )
				net.WriteString( value )
			net.SendToServer()

		end

		--
		-- Called serverside it simply changes the value
		--
		if ( SERVER ) then

			ent:SetNetworkKeyValue( variable, value )

		end

	end

end

if ( SERVER ) then

	util.AddNetworkString( "editvariable" )

	net.Receive( "editvariable", function( len, client )

		local ent = net.ReadEntity()

		if ( !IsValid( ent ) ) then return end
		if ( !isfunction( ent.GetEditingData ) ) then return end
		if ( ent.AdminOnly && !( client:IsAdmin() or game.SinglePlayer() ) ) then return end

		local key = net.ReadString()

		-- Is this key in our edit table?
		local editor = ent:GetEditingData()[ key ]
		if ( !istable( editor ) ) then return end

		local val = net.ReadString()
		hook.Run( "VariableEdited", ent, client, key, val, editor )

	end )

	function meta:GetUnFreezable()
		return self.m_bUnFreezable or false
	end

	function meta:SetUnFreezable( bFreeze )
		self.m_bUnFreezable = tobool( bFreeze ) or false
	end

end

--
-- Networked var proxies
--
function meta:SetNetworked2VarProxy( name, func )

	if ( !self.NWVarProxies ) then
		self.NWVarProxies = {}
	end

	self.NWVarProxies[ name ] = func

end

function meta:GetNetworked2VarProxy( name )

	if ( self.NWVarProxies ) then
		local func = self.NWVarProxies[ name ]
		if ( isfunction( func ) ) then
			return func
		end
	end

	return nil

end

meta.SetNW2VarProxy = meta.SetNetworked2VarProxy
meta.GetNW2VarProxy = meta.GetNetworked2VarProxy

hook.Add( "EntityNetworkedVarChanged", "NetworkedVars", function( ent, name, oldValue, newValue )

	if ( ent.NWVarProxies ) then
		local func = ent.NWVarProxies[ name ]

		if ( isfunction( func ) ) then
			func( ent, name, oldValue, newValue )
		end
	end

end )

--
-- Vehicle Extensions
--
local vehicle = FindMetaTable( "Vehicle" )

--
-- We steal some DT slots by default for vehicles
-- to control the third person view. You should use
-- these functions if you want to play with them because
-- they might eventually be moved into the engine - so manually
-- editing the DT values will stop working.
--
function vehicle:SetVehicleClass( s )

	self:SetDTString( 3, s )

end

function vehicle:GetVehicleClass()

	return self:GetDTString( 3 )

end

function vehicle:SetThirdPersonMode( b )

	self:SetDTBool( 3, b )

end

function vehicle:GetThirdPersonMode()

	return self:GetDTBool( 3 )

end

function vehicle:SetCameraDistance( dist )

	self:SetDTFloat( 3, dist )

end

function vehicle:GetCameraDistance()

	return self:GetDTFloat( 3 )

end
