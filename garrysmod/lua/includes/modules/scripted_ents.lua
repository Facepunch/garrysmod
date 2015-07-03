
--[[---------------------------------------------------------
  Name: scripted_ents
  Desc: Scripted Entity factory
-----------------------------------------------------------]]

module( "scripted_ents", package.seeall )

local Aliases = {}
local SEntList = {}

local BaseClasses = {}
BaseClasses[ "anim" ] = "base_anim"
BaseClasses[ "point" ] = "base_point"
BaseClasses[ "brush" ] = "base_brush"
BaseClasses[ "filter" ] = "base_filter"

--[[---------------------------------------------------------
	Name: TableInherit( t, base )
	Desc: Copies any missing data from base to t
-----------------------------------------------------------]]
local function TableInherit( t, base )

	for k, v in pairs( base ) do 
		
		if ( t[k] == nil ) then
			t[k] = v
		elseif ( istable( t[k] ) ) then
			TableInherit( t[k], v )
		end
		
	end
	
	t[ "BaseClass" ] = base
	
	return t

end

--[[---------------------------------------------------------
	Name: Register( table, string, bool )
-----------------------------------------------------------]]
function Register( t, name )

	local Base = t.Base
	if ( !Base ) then Base = BaseClasses[ t.Type ] end
	
	local old = SEntList[ name ]
	local tab = {}
	
	tab.type		= t.Type
	tab.t			= t
	tab.isBaseType	= true
	tab.Base		= Base
	tab.t.ClassName	= name
	
	if ( !Base ) then
		Msg( "WARNING: Scripted entity "..name.." has an invalid base entity!\n" )
	end

	SEntList[ name ] = tab

	-- Allow all SENTS to be duplicated, unless specified
	if ( !t.DisableDuplicator ) then
		duplicator.Allow( name )
	end
	
	--
	-- If we're reloading this entity class
	-- then refresh all the existing entities.
	--
	if ( old != nil ) then

		--
		-- Foreach entity using this class
		--
		table.ForEach( ents.FindByClass( name ), function( _, entity ) 
		
			--
			-- Replace the contents with this entity table
			--
			table.Merge( entity, tab.t )

			--
			-- Call OnReloaded hook (if it has one)
			--
			if ( entity.OnReloaded ) then
				entity:OnReloaded()
			end
		
		end )

	end

	if ( !t.Spawnable ) then return end

	list.Set( "SpawnableEntities", name, {
		-- Required information
		PrintName		= t.PrintName, 
		ClassName		= name,
		Category		= t.Category,

		-- Optional information
		NormalOffset	= t.NormalOffset,
		DropToFloor		= t.DropToFloor,
		Author			= t.Author,
		AdminOnly		= t.AdminOnly,
		Information		= t.Information
	} )

end

--
-- All scripts have been loaded...
--
function OnLoaded()

	--
	-- Once all the scripts are loaded we can set up the baseclass
	-- - we have to wait until they're all setup because load order
	-- could cause some entities to load before their bases!
	--
	table.ForEach( SEntList, function( k, v ) 

		baseclass.Set( k, Get( k ) )

	end )

end


--[[---------------------------------------------------------
	Name: Get( string )
-----------------------------------------------------------]]
function Get( name )
	
	-- Do we have an alias?
	if ( Aliases[ name ] ) then
		name = Aliases[ name ]
	end

	if ( SEntList[ name ] == nil ) then return nil end

	-- Create/copy a new table
	local retval = {}
	for k, v in pairs( SEntList[ name ].t ) do
		retval[k] = v
	end
	
	-- Derive from base class
	if ( name != SEntList[ name ].Base ) then
		
		local base = Get( SEntList[ name ].Base )
		
		if ( !base ) then
		
			Msg("ERROR: Trying to derive entity " .. tostring( name ) .. " from non existant entity " .. tostring( SEntList[ name ].Base ) .. "!\n" )
		
		else
	
			retval = TableInherit( retval, base )
		
		end
		
	end
	
	return retval

end

--[[---------------------------------------------------------
	Name: GetType( string )
-----------------------------------------------------------]]
function GetType( name )

	for k, v in pairs( BaseClasses ) do 
		if ( name == v ) then return k end
	end
	
	local ent = SEntList[ name ]
	if ( ent == nil ) then return nil end
	
	if ( ent.type ) then
		return ent.type
	end
	
	if ( ent.Base ) then
		return GetType( ent.Base )
	end
	
	return nil

end

--[[---------------------------------------------------------
	Name: GetStored( string )
	Desc: Gets the REAL sent table, not a copy
-----------------------------------------------------------]]
function GetStored( name )
	return SEntList[ name ]
end

--[[---------------------------------------------------------
  Name: GetList( string )
  Desc: Get a list of all the registered SENTs
-----------------------------------------------------------]]
function GetList()
	local result = {}
	
	for k,v in pairs( SEntList ) do
		result[ k ] = v
	end
	
	return result
end

--[[---------------------------------------------------------
	Name: GetSpawnable
-----------------------------------------------------------]]
function GetSpawnable()

	local result = {}
	
	for k, v in pairs( SEntList ) do
		
		local tab = v.t
		
		if ( tab.Spawnable ) then
			table.insert( result, tab )
		end
		
	end
	
	return result

end

--[[---------------------------------------------------------
	Name: Alias
-----------------------------------------------------------]]
function Alias( From, To )

	Aliases[ From ] = To

end

--[[---------------------------------------------------------
	Name: GetMember
-----------------------------------------------------------]]
function GetMember( entity_name, membername )

	if ( !entity_name ) then return end

	local ent = SEntList[ entity_name ]

	if ( !ent ) then return end

	local member = ent.t[ membername ]
	if ( member != nil ) then return member end

	-- If our base is the same as us - don't infinite loop!
	if ( entity_name == ent.Base ) then return end

	return GetMember( ent.Base, membername )

end
