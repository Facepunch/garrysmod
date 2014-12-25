
--
-- Seed the rand!
--
math.randomseed( os.time() );

--
-- Alias string.Format to global Format
--
Format = string.format

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
function PrintTable ( t, indent, done )

	done = done or {}
	indent = indent or 0

	for key, value in pairs (t) do

		Msg( string.rep ("\t", indent) )

		if  ( istable(value) && !done[value] ) then

			done [value] = true
			Msg( tostring(key) .. ":" .. "\n" );
			PrintTable (value, indent + 2, done)

		else

			Msg( tostring (key) .. "\t=\t" )
			Msg( tostring(value) .. "\n" )

		end

	end

end


--[[---------------------------------------------------------
   Returns a random vector
-----------------------------------------------------------]]
function VectorRand()

	return Vector( math.Rand(-1.0, 1.0), math.Rand(-1.0, 1.0), math.Rand(-1.0, 1.0) )
end


--[[---------------------------------------------------------
   Returns a random angle
-----------------------------------------------------------]]
function AngleRand()

	return Angle( math.Rand(-90, 90), math.Rand(-180, 180), math.Rand(-180, 180) )
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


-- Some nice globals so we don't keep creating objects for no reason

vector_origin 		= Vector( 0, 0, 0 )
vector_up	 		= Vector( 0, 0, 1 )
angle_zero			= Angle( 0, 0, 0 )

color_white 		= Color( 255, 	255, 	255, 	255 )
color_black 		= Color( 0, 	0, 		0, 		255 )
color_transparent 	= Color( 255, 	255, 	255, 	0 )


--[[---------------------------------------------------------
   Includes the file - and adds it so the CS file list
-----------------------------------------------------------]]
function IncludeCS( filename )
	
	include( filename )

	if ( SERVER ) then
		AddCSLuaFile( filename )
	end
	
end

-- Globals..
FORCE_STRING 	= 1
FORCE_NUMBER 	= 2
FORCE_BOOL		= 3

--[[---------------------------------------------------------
   AccessorFunc
   Quickly make Get/Set accessor fuctions on the specified table
-----------------------------------------------------------]]
function AccessorFunc( tab, varname, name, iForce )

	if ( !tab ) then debug.Trace() end

	tab[ "Get"..name ] = function ( self ) return self[ varname ] end

	if ( iForce == FORCE_STRING ) then
		tab[ "Set"..name ] = function ( self, v ) self[ varname ] = tostring(v) end
	return end
	
	if ( iForce == FORCE_NUMBER ) then
		tab[ "Set"..name ] = function ( self, v ) self[ varname ] = tonumber(v) end
	return end
	
	if ( iForce == FORCE_BOOL ) then
		tab[ "Set"..name ] = function ( self, v ) self[ varname ] = tobool(v) end
	return end
	
	tab[ "Set"..name ] = function ( self, v ) self[ varname ] = v end

end

--[[---------------------------------------------------------
	Returns true if object is valid (is not nil and IsValid)
-----------------------------------------------------------]]
function IsValid( object )

	if ( !object ) then return false end
	if ( !object.IsValid ) then return false end

	return object:IsValid()

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
	
	return from + (to - from) * delta;

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
function UTIL_IsUselessModel( modelname ) 

	local modelname = modelname:lower()

	if ( modelname:find( "_gesture" ) ) then return true end
	if ( modelname:find( "_anim" ) ) then return true end
	if ( modelname:find( "_gst" ) ) then return true end
	if ( modelname:find( "_pst" ) ) then return true end
	if ( modelname:find( "_shd" ) ) then return true end
	if ( modelname:find( "_ss" ) ) then return true end
	if ( modelname:find( "_posture" ) ) then return true end
	if ( modelname:find( "_anm" ) ) then return true end
	if ( modelname:find( "ghostanim" ) ) then return true end
	if ( modelname:find( "_paths" ) ) then return true end
	if ( modelname:find( "_shared" ) ) then return true end
	if ( modelname:find( "anim_" ) ) then return true end
	if ( modelname:find( "gestures_" ) ) then return true end
	if ( modelname:find( "shared_ragdoll_" ) ) then return true end
	if ( !modelname:find( ".mdl" ) ) then return true end
	
	return false

end


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


--[[---------------------------------------------------------
	Given a number, returns the right 'th
-----------------------------------------------------------]]
local STNDRD_TBL = {"st", "nd", "rd"}
function STNDRD( num )
	num = num % 100
	if ( num > 10 and num < 20 ) then
		return "th"
	end

	return STNDRD_TBL[num % 10] or "th"
end


--[[---------------------------------------------------------
	From Simple Gamemode Base (Rambo_9)
-----------------------------------------------------------]]
function TimedSin(freq,min,max,offset)
	return math.sin(freq * math.pi * 2 * CurTime() + offset) * (max-min) * 0.5 + min
end 

--[[---------------------------------------------------------
	From Simple Gamemode Base (Rambo_9)
-----------------------------------------------------------]]
function TimedCos(freq,min,max,offset)
	return math.cos(freq * math.pi * 2 * CurTime() + offset) * (max-min) * 0.5 + min
end 

--[[---------------------------------------------------------
	IsEnemyEntityName
-----------------------------------------------------------]]
local EnemyNames = {
	npc_antlion = true, npc_antlionguard = true, npc_breen = true, npc_combine_s = true, 
	npc_cscanner = true, npc_fastzombie = true, npc_fastzombie_torso = true, npc_gman = true, 
	npc_headcrab = true, npc_headcrab_fast = true, npc_headcrab_poison = true, npc_hunter = true, 
	npc_manhack = true, npc_poisonzombie = true, npc_zombie = true, npc_zombie_torso = true
}

function IsEnemyEntityName( victimtype )

	return EnemyNames[ victimtype ] or false

end

--[[---------------------------------------------------------
	IsFriendEntityName
-----------------------------------------------------------]]
local FriendlyNames = {
	 npc_alyx = true, npc_barney = true, npc_citizen = true, npc_eli = true, npc_kleiner = true, 
	 npc_magnusson = true, npc_monk = true, npc_mossman = true, npc_vortigaunt = true
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
-- ie  Add_NPC_Class( "MY_CLASS" )

function Add_NPC_Class( name )

	_G[ name ] = NUM_AI_CLASSES
	NUM_AI_CLASSES = NUM_AI_CLASSES + 1

end

