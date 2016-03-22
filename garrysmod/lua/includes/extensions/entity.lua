
local meta = FindMetaTable( "Entity" )

-- Return if there's nothing to add on to
if ( !meta ) then return end

AccessorFunc( meta, "m_bPlayPickupSound", "ShouldPlayPickupSound" )

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
	local tab = self:GetTable()
	if ( tab ) then
		local val = tab[ key ]
		if ( val != nil ) then return val end
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

	function meta:SetCreator( ply )
		self.m_PlayerCreator = ply
	end

	function meta:GetCreator()
		return self.m_PlayerCreator
	end

end

--[[---------------------------------------------------------
	Name: Returns true if the entity has constraints attached to it
-----------------------------------------------------------]]
function meta:IsConstrained()

	if ( CLIENT ) then return self:GetNetworkedBool( "IsConstrained" ) end

	local c = self:GetTable().Constraints
	local bIsConstrained = false

	if ( c ) then

		for k, v in pairs( c ) do
			if ( IsValid( v ) ) then bIsConstrained = true break end
			c[ k ] = nil
		end

	end

	self:SetNetworkedBool( "IsConstrained", bIsConstrained )
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

	if ( !ent || !ent.OnDieFunctions ) then return end

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

function meta:GetChildBones( bone )

	local bonecount = self:GetBoneCount()
	if ( bonecount == 0 || bonecount < bone ) then return end

	local bones = {}

	for k = 0, bonecount - 1 do
		if ( self:GetBoneParent( k ) != bone ) then continue end
		table.insert( bones, k )
	end

	return bones

end

function meta:InstallDataTable()

	self.dt = {}
	local datatable = {}
	local keytable = {}
	local meta = {}
	local editing = {}

	meta.__index = function ( ent, key )

		local dt = datatable[ key ]
		if ( dt == nil ) then return end

		return dt.GetFunc( self, dt.index, key )

	end

	meta.__newindex = function( ent, key, value )

		local dt = datatable[ key ]
		if ( dt == nil ) then return end

		dt.SetFunc( self, dt.index, value )

	end

	self.DTVar = function( ent, typename, index, name )

		local SetFunc = ent[ "SetDT" .. typename ]
		local GetFunc = ent[ "GetDT" .. typename ]

		if ( !SetFunc || !GetFunc ) then
			MsgN( "Couldn't addvar " , name, " - type ", typename," is invalid!" )
			return
		end

		datatable[ name ] = {
			index = index,
			SetFunc = SetFunc,
			GetFunc = GetFunc,
			typename = typename,
			keyname = keyname,
			Notify = {}
		}

		return datatable[ name ]

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

	self.SetupKeyValue = function( ent, keyname, type, setfunc, getfunc, other_data )

		keyname = keyname:lower()

		keytable[ keyname ] = {
			KeyName		= keyname,
			Set			= setfunc,
			Get			= getfunc,
			Type		= type,
			EditType	= EditType,
			EditData	= EditData
		}

		if ( other_data ) then

			table.Merge( keytable[ keyname ], other_data )

		end

	end

	local CallProxies = function( ent, tbl, name, oldval, newval )

		for k, v in pairs( tbl ) do
			v( ent, name, oldval, newval )
		end

	end

	self.NetworkVar = function( ent, typename, index, name, other_data )

		local t = ent.DTVar( ent, typename, index, name )

		ent[ "Set" .. name ] = function( self, value )
			CallProxies( ent, t.Notify, name, self.dt[ name ], value )
			self.dt[ name ] = value
		end

		ent[ "Get" .. name ] = function( self )
			return self.dt[ name ]
		end

		if ( !other_data ) then return end

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

		ent.DTVar( ent, typename, index, name, keyname )

		ent[ "Set" .. name ] = function( self, value )
			local old = self.dt[ name ]
			old[ element ] = value
			self.dt[ name ] = old
		end

		ent[ "Get" .. name ] = function( self )
			return self.dt[ name ][ element ]
		end

		if ( !other_data ) then return end

		if ( other_data.KeyName ) then
			ent:SetupKeyValue( other_data.KeyName, "float", ent[ "Set" .. name ], ent[ "Get" .. name ], other_data )
			ent:SetupEditing( name, other_data.KeyName, other_data.Edit )
		end

	end

	self.SetNetworkKeyValue = function( self, key, value )

		key = key:lower()

		local k = keytable[ key ]
		if ( !k ) then return end

		local v = util.StringToType( value, k.Type )
		if ( v == nil ) then return end

		k.Set( self, v )
		return true

	end

	self.GetNetworkKeyValue = function( self, key )

		key = key:lower()

		local k = keytable[ key ]
		if ( !k ) then return end

		return k.Get( self )

	end

	--
	-- Called by the duplicator system to get the network vars
	--
	self.GetNetworkVars = function( ent )

		local dt = {}

		for k, v in pairs( datatable ) do

			-- Don't try to save entities (yet?)
			if ( v.typename == "Entity" ) then continue end

			dt[ k ] = v.GetFunc( ent, v.index )

		end

		--
		-- If there's nothing in our table - then return nil.
		--
		if ( table.Count( dt ) == 0 ) then return nil end

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

			-- Set it.
			if ( ent[ "Set" .. k ] ) then
				ent[ "Set" .. k ]( ent, tab[ k ] )
			else
				v.SetFunc( ent, v.index, tab[k] )
			end

		end

	end

	setmetatable( self.dt, meta )

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
	self.EditValue = function( self, variable, value )

		if ( !isstring( variable ) ) then return end
		if ( !isstring( value ) ) then return end

		--
		-- It can be called clientside to send a message to the server
		-- to request a change of value.
		--
		if ( CLIENT ) then

			net.Start( "editvariable" )
				net.WriteUInt( self:EntIndex(), 32 )
				net.WriteString( variable )
				net.WriteString( value )
			net.SendToServer()

		end

		--
		-- Called serverside it simply changes the value
		--
		if ( SERVER ) then

			self:SetNetworkKeyValue( variable, value )

		end

	end

	if ( SERVER ) then

		util.AddNetworkString( "editvariable" )

		net.Receive( "editvariable", function( len, client )

			local iIndex = net.ReadUInt( 32 )
			local ent = Entity( iIndex )

			if ( !IsValid( ent ) ) then return end
			if ( !isfunction( ent.GetEditingData ) ) then return end
			if ( ent.AdminOnly && !client:IsAdmin() ) then return end

			local key = net.ReadString()

			-- Is this key in our edit table?
			local editor = ent:GetEditingData()[ key ]
			if ( !istable( editor ) ) then return end

			local val = net.ReadString()
			hook.Run( "VariableEdited", ent, client, key, val, editor )

		end )

	end

end

if ( SERVER ) then

	AccessorFunc( meta, "m_bUnFreezable", "UnFreezable" )

end

--
-- Networked var proxies
--
function meta:SetNetworkedVarProxy( name, func )

	if ( !self.NWVarProxies ) then
		self.NWVarProxies = {}
	end

	self.NWVarProxies[ name ] = func

end

function meta:GetNetworkedVarProxy( name )

	if ( self.NWVarProxies ) then
		local func = self.NWVarProxies[ name ]
		if ( isfunction( func ) ) then
			return func
		end
	end

	return nil

end

meta.SetNWVarProxy = meta.SetNetworkedVarProxy
meta.GetNWVarProxy = meta.GetNetworkedVarProxy

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
