
--
-- Seed the rand!
--
math.randomseed( os.time() )

--
-- Alias string.Format to global Format
--
Format = string.format

--
-- Send C the flags for any materials we want to create
--
local C_Material = Material

function Material( name, words )

	if ( !words ) then return C_Material( name ) end

	local str = (words:find("vertexlitgeneric") and "1" or "0")
	str = str .. (words:find("nocull") and "1" or "0")
	str = str .. (words:find("alphatest") and "1" or "0")
	str = str .. (words:find("mips") and "1" or "0")
	str = str .. (words:find("noclamp") and "1" or "0")
	str = str .. (words:find("smooth") and "1" or "0")
	str = str .. (words:find("ignorez") and "1" or "0")

	return C_Material( name, str )

end

--[[---------------------------------------------------------
	IsTableOfEntitiesValid
-----------------------------------------------------------]]
function IsTableOfEntitiesValid( tab )

	if ( !tab ) then return false end

	for k, v in pairs( tab ) do
		if ( !IsValid( v ) ) then return false end
	end

	return true

end

--[[---------------------------------------------------------
	Color related functions - they now have their own
	metatable so better put them in their own separate
	file
-----------------------------------------------------------]]

include( "util/color.lua" )

--[[---------------------------------------------------------
	Prints a table to the console
-----------------------------------------------------------]]
function PrintTable( t, indent, done )
	local Msg = Msg

	done = done or {}
	indent = indent or 0
	local keys = table.GetKeys( t )

	table.sort( keys, function( a, b )
		if ( isnumber( a ) && isnumber( b ) ) then return a < b end
		return tostring( a ) < tostring( b )
	end )

	done[ t ] = true

	for i = 1, #keys do
		local key = keys[ i ]
		local value = t[ key ]
		Msg( string.rep( "\t", indent ) )

		if  ( istable( value ) && !done[ value ] ) then

			done[ value ] = true
			Msg( key, ":\n" )
			PrintTable ( value, indent + 2, done )
			done[ value ] = nil

		else

			Msg( key, "\t=\t", value, "\n" )

		end

	end

end

--[[---------------------------------------------------------
	Returns a random vector
-----------------------------------------------------------]]
function VectorRand( min, max )
	min = min || -1
	max = max || 1
	return Vector( math.Rand( min, max ), math.Rand( min, max ), math.Rand( min, max ) )
end

--[[---------------------------------------------------------
	Returns a random angle
-----------------------------------------------------------]]
function AngleRand( min, max )
	return Angle( math.Rand( min || -90, max || 90 ), math.Rand( min || -180, max || 180 ), math.Rand( min || -180, max || 180 ) )
end

--[[---------------------------------------------------------
	Returns a random color
-----------------------------------------------------------]]
function ColorRand( alpha )
	if ( alpha ) then
		return Color( math.random( 0, 255 ), math.random( 0, 255 ), math.random( 0, 255 ), math.random( 0, 255 ) )
	end

	return Color( math.random( 0, 255 ), math.random( 0, 255 ), math.random( 0, 255 ) )
end


--[[---------------------------------------------------------
	Convenience function to precache a sound
-----------------------------------------------------------]]
function Sound( name )
	util.PrecacheSound( name )
	return name
end

--[[---------------------------------------------------------
	Convenience function to precache a model
-----------------------------------------------------------]]
function Model( name )
	util.PrecacheModel( name )
	return name
end

--[[---------------------------------------------------------
	Convenience function to precache a particle
-----------------------------------------------------------]]
function Particle( name )
	if ( CLIENT ) then
		game.AddParticles( name )
	end
	return name
end

-- Some nice globals so we don't keep creating objects for no reason
vector_origin		= Vector( 0, 0, 0 )
vector_up			= Vector( 0, 0, 1 )
angle_zero			= Angle( 0, 0, 0 )

color_white			= Color( 255, 255, 255, 255 )
color_black			= Color( 0, 0, 0, 255 )
color_transparent	= Color( 255, 255, 255, 0 )

--[[---------------------------------------------------------
	Includes the file - and adds it so the CS file list
-----------------------------------------------------------]]
function IncludeCS( filename )
	include( filename )

	if ( SERVER ) then
		AddCSLuaFile( filename )
	end
end

-- Globals
FORCE_STRING	= 1
FORCE_NUMBER	= 2
FORCE_BOOL		= 3

--[[---------------------------------------------------------
	AccessorFunc
	Quickly make Get/Set accessor fuctions on the specified table
-----------------------------------------------------------]]
function AccessorFunc( tab, varname, name, iForce )

	if ( !tab ) then debug.Trace() end

	tab[ "Get" .. name ] = function( self ) return self[ varname ] end

	if ( iForce == FORCE_STRING ) then
		tab[ "Set" .. name ] = function( self, v ) self[ varname ] = tostring( v ) end
	return end

	if ( iForce == FORCE_NUMBER ) then
		tab[ "Set" .. name ] = function( self, v ) self[ varname ] = tonumber( v ) end
	return end

	if ( iForce == FORCE_BOOL ) then
		tab[ "Set" .. name ] = function( self, v ) self[ varname ] = tobool( v ) end
	return end

	tab[ "Set" .. name ] = function( self, v ) self[ varname ] = v end

end

--[[---------------------------------------------------------
	Returns true if object is valid (is not nil and IsValid)
-----------------------------------------------------------]]
function IsValid( object )

	if ( !object ) then return false end

	local isvalid = object.IsValid
	if ( !isvalid ) then return false end

	return isvalid( object )

end

--[[---------------------------------------------------------
	Safely remove an entity
-----------------------------------------------------------]]
function SafeRemoveEntity( ent )

	if ( !IsValid( ent ) || ent:IsPlayer() ) then return end

	ent:Remove()

end

--[[---------------------------------------------------------
	Safely remove an entity (delayed)
-----------------------------------------------------------]]
function SafeRemoveEntityDelayed( ent, timedelay )

	if ( !IsValid( ent ) || ent:IsPlayer() ) then return end

	timer.Simple( timedelay, function() SafeRemoveEntity( ent ) end )

end

--[[---------------------------------------------------------
	Simple lerp
-----------------------------------------------------------]]
function Lerp( delta, from, to )

	if ( delta > 1 ) then return to end
	if ( delta < 0 ) then return from end

	return from + ( to - from ) * delta

end

--[[---------------------------------------------------------
	Convert Var to Bool
-----------------------------------------------------------]]
function tobool( val )
	if ( val == nil || val == false || val == 0 || val == "0" || val == "false" ) then return false end
	return true
end

--[[---------------------------------------------------------
	Universal function to filter out crappy models by name
-----------------------------------------------------------]]
local UselessModels = {
	"_gesture", "_anim", "_gst", "_pst", "_shd", "_ss", "_posture", "_anm",
	"ghostanim","_paths", "_shared", "anim_", "gestures_", "shared_ragdoll_"
}

function IsUselessModel( modelname )

	local modelname = modelname:lower()

	if ( !modelname:find( ".mdl", 1, true ) ) then return true end

	for k, v in pairs( UselessModels ) do
		if ( modelname:find( v, 1, true ) ) then
			return true
		end
	end

	return false

end

UTIL_IsUselessModel = IsUselessModel

--[[---------------------------------------------------------
	Given a number, returns the right 'th
-----------------------------------------------------------]]
local STNDRD_TBL = { "st", "nd", "rd" }
function STNDRD( num )
	num = num % 100
	if ( num > 10 and num < 20 ) then
		return "th"
	end

	return STNDRD_TBL[ num % 10 ] or "th"
end

--[[---------------------------------------------------------
	From Simple Gamemode Base (Rambo_9)
-----------------------------------------------------------]]
function TimedSin( freq, min, max, offset )
	return math.sin( freq * math.pi * 2 * CurTime() + offset ) * ( max - min ) * 0.5 + min
end

--[[---------------------------------------------------------
	From Simple Gamemode Base (Rambo_9)
-----------------------------------------------------------]]
function TimedCos( freq, min, max, offset )
	return math.cos( freq * math.pi * 2 * CurTime() + offset ) * ( max - min ) * 0.5 + min
end

--[[---------------------------------------------------------
	IsEnemyEntityName
-----------------------------------------------------------]]
local EnemyNames = {
	npc_antlion = true, npc_antlionguard = true, npc_antlionguardian = true, npc_barnacle = true,
	npc_breen = true, npc_clawscanner = true, npc_combine_s = true, npc_cscanner = true, npc_fastzombie = true,
	npc_fastzombie_torso = true, npc_headcrab = true, npc_headcrab_fast = true, npc_headcrab_poison = true,
	npc_hunter = true, npc_metropolice = true, npc_manhack = true, npc_poisonzombie = true,
	npc_strider = true, npc_stalker = true, npc_zombie = true, npc_zombie_torso = true, npc_zombine = true
}

function IsEnemyEntityName( victimtype )
	return EnemyNames[ victimtype ] or false
end

--[[---------------------------------------------------------
	IsFriendEntityName
-----------------------------------------------------------]]
local FriendlyNames = {
	npc_alyx = true, npc_barney = true, npc_citizen = true, npc_dog = true, npc_eli = true,
	npc_fisherman = true, npc_gman = true, npc_kleiner = true, npc_magnusson = true,
	npc_monk = true, npc_mossman = true, npc_odessa = true, npc_vortigaunt = true
}

function IsFriendEntityName( victimtype )
	return FriendlyNames[ victimtype ] or false
end

--[[---------------------------------------------------------
	Is content mounted?
		IsMounted( "cstrike" )
		IsMounted( 4010 )
-----------------------------------------------------------]]
function IsMounted( name )

	local games = engine.GetGames()

	for k, v in pairs( games ) do

		if ( !v.mounted ) then continue end

		if ( v.depot == name ) then return true end
		if ( v.folder == name ) then return true end

	end

	return false

end

--[[---------------------------------------------------------
	Replacement for C++'s iff ? aa : bb
-----------------------------------------------------------]]
function Either( iff, aa, bb )
	if ( iff ) then return aa end
	return bb
end

--
-- You can use this function to add your own CLASS_ var.
-- Adding in this way will ensure your CLASS_ doesn't collide with another
--
-- ie Add_NPC_Class( "MY_CLASS" )

function Add_NPC_Class( name )
	_G[ name ] = NUM_AI_CLASSES
	NUM_AI_CLASSES = NUM_AI_CLASSES + 1
end

if ( CLIENT ) then

	--[[---------------------------------------------------------
		Remember/Restore cursor position..
		Clientside only
		If you have a system where you hold a key to show the cursor
		Call RememberCursorPosition when the key is released and call
		RestoreCursorPosition to restore the cursor to where it was
		when the key was released.
		If you don't the cursor will appear in the middle of the screen
	-----------------------------------------------------------]]
	local StoredCursorPos = {}

	function RememberCursorPosition()

		local x, y = gui.MousePos()

		-- If the cursor isn't visible it will return 0,0 ignore it.
		if ( x == 0 && y == 0 ) then return end

		StoredCursorPos.x, StoredCursorPos.y = x, y

	end

	function RestoreCursorPosition()

		if ( !StoredCursorPos.x || !StoredCursorPos.y ) then return end
		input.SetCursorPos( StoredCursorPos.x, StoredCursorPos.y )

	end

end

--
-- This is supposed to be clientside, but was exposed to both states for years due to a bug.
--
function CreateClientConVar( name, default, shouldsave, userdata, helptext, min, max )

	local iFlags = 0

	if ( shouldsave || shouldsave == nil ) then
		iFlags = bit.bor( iFlags, FCVAR_ARCHIVE )
	end

	if ( userdata ) then
		iFlags = bit.bor( iFlags, FCVAR_USERINFO )
	end

	return CreateConVar( name, default, iFlags, helptext, min, max )

end

--[[---------------------------------------------------------
	Convar access functions
-----------------------------------------------------------]]

local ConVarCache = {}

function GetConVar( name )
	local c = ConVarCache[ name ]
	if not c then
		c = GetConVar_Internal( name )
		if not c then
			return
		end

		ConVarCache[ name ] = c
	end

	return c
end

function GetConVarNumber( name )
	if ( name == "maxplayers" ) then return game.MaxPlayers() end -- Backwards compatibility
	local c = GetConVar( name )
	return ( c and c:GetFloat() ) or 0
end

function GetConVarString( name )
	if ( name == "maxplayers" ) then return tostring( game.MaxPlayers() ) end -- ew
	local c = GetConVar( name )
	return ( c and c:GetString() ) or ""
end


--[[---------------------------------------------------------
	Safe functions
-----------------------------------------------------------]]

local type = type
local pcall = pcall
local rawget = rawget
local TypeID = TypeID
local istable = istable
local tostring = tostring
local string_format = string.format
local debug_getmetatable = debug.getmetatable

local fSafeIndex

do
	local function IndexPassThru( success, err, ... )
		if ( success ) then return true, err, ... end
		return false, string_format( "\"__index\" function errored (%s)", err )
	end

	fSafeIndex = function( var, key )
		local index = var
		local index_type
		
		-- If var is a table
		-- skip all of the extra checks verifying if a non-table can be indexed
		if ( not istable( var ) ) then
			local meta = debug_getmetatable( var )
			if ( meta == nil ) then return false, "no metatable" end
			
			index = rawget( meta, "__index" )
			if ( index == nil ) then return false, "no \"__index\" key defined" end
		
			index_type = TypeID( index )
			if ( index_type == TYPE_FUNCTION ) then return IndexPassThru( pcall( index, var, key ) ) end
			if ( index_type != TYPE_TABLE ) then return false, string_format( "expected \"__index\" key to be a table or function, got %s", type( index ) ) end
		end
		
		-- To prevent cyclic references
		local metas = { [ meta ] = true }
		
		-- Repeat the same process for __index sub-tables
		-- but not having __index present or it being the wrong type is no longer halting
		repeat
			-- Try raw indexing first
			local out = rawget( index, key )
			if ( out != nil ) then return true, out end
			
			-- Then check the metatable
			local meta = debug_getmetatable( index )
			if ( meta == nil ) then return true, nil end
			if ( metas[ meta ] ) then return false, "cyclic \"__index\" reference" end
			metas[ meta ] = true
			
			index = rawget( meta, "__index" )
			if ( index == nil ) then return true, nil end
			
			index_type = TypeID( index )
			if ( index_type == TYPE_FUNCTION ) then return IndexPassThru( pcall( index, var, key ) ) end
		until ( index_type != TYPE_TABLE )
		
		return true, nil
	end
	
	SafeIndex = fSafeIndex
end

do
	local DefaultMappings = {
		[TYPE_BOOL] = function( b )
			if ( b ) return "1" end
			return "0"
		end,
		[TYPE_NUMBER] = tostring,
		[TYPE_STRING] = tostring
	}

	function SafeSerialize( var, funcname, mappings )
		if ( funcname == nil ) then funcname = "Serialize" end
		if ( mappings == nil ) then mappings = DefaultMappings end
		
		local func = mappings[ TypeID( var ) ]
		if ( func != nil ) then return true, func( var ) end
		
		-- Skip indexing var itself by indexing its metatable directly
		-- If var is a table and has a Serialize method present, it is probably not an object instance
		-- but rather a metatable, ex. SafeSerialze( FindMetaTable("Vector") )
		-- This prevents calling Serialize incorrectly on either a binded object or metatable
		local meta = debug_getmetatable( var )
		if ( meta == nil ) then return false, "no metatable" end
		
		local success
		success, func = fSafeIndex( meta, funcname )
		if ( !success ) then return false, string_format( "failed to index the metatable (%s)", func ) end
		if ( func == nil ) then return false, string_format( "no \"%s\" function", funcname ) end
		if ( !isfunction( func ) ) then return false, string_format( "expected \"%s\" to be a function, got %s", funcname, type( func ) ) end
		
		local success, out = pcall( func, var )
		if ( !success ) then return false, string_format( "\"%s\" function errored (%s)", funcname, out ) end
		if ( !isstring( out ) ) then return false, string_format( "expected \"%s\" function to return a string, got %s", funcname, type( out ) ) end
		
		return true, out
	end
end

