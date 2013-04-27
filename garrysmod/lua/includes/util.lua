
--
-- Seed the rand!
--
math.randomseed( os.time() );

--
-- Name: Global.Format
-- Desc: An alias to string.format
-- Realm: Shared
-- Arg1:
-- Ret1:
--
Format = string.format

--
-- Name: Global.IsTableOfEntitiesValid
-- Desc: Checks if a table contains only valid entities
-- Realm: Shared
-- Arg1: table|tab|A table containing entities
-- Ret1: boolean|Does the table contain only valid entities
--

function IsTableOfEntitiesValid( tab )

	if (!tab) then return false end

	for k, v in pairs( tab ) do
		if ( !IsValid( v ) ) then return false end
	end
	
	return true
	
end

--
-- Name: Global.Color
-- Desc: Creates a color
-- Realm: Shared
-- Arg1: number|red|First argument in an RGB value <0-255>
-- Arg2: number|green|Second argument in an RGB value <0-255>
-- Arg3: number|blue|Third argument in an RGB value <0-255>
-- Arg4: number|alpha|The alpha amount of a color (transparency) <0-255>
--

function Color( r, g, b, a )

	a = a or 255
	return { r = math.min( tonumber(r), 255 ), g =  math.min( tonumber(g), 255 ), b =  math.min( tonumber(b), 255 ), a =  math.min( tonumber(a), 255 ) }
	
end

--
-- Name: Global.ColorAlpha
-- Desc: Sets the alpha (transparency) of a color
-- Realm: Shared
-- Arg1: table|color|The color value where the transparency will be set
-- Arg2: number|alpha|The alpha value to be set
-- Ret1: table|A new color value with the values specified. Not a refrence to the old value.
--

function ColorAlpha( c, a )

	return { r = c.r, g = c.g, b = c.b, a =  math.min( tonumber(a * 255), 255 ) }
	
end

--
-- Name: Global.PrintTable
-- Desc: Loops through all values of a table recursively and prints them
-- Realm: Shared
-- Arg1: table|t|Table to be printed
-- Arg2: number|indent|Internally used argument. How many indentation nodes to set.
-- Arg3: table|done|Internally used argument. Use as the base case on a recursive function.
-- Ret1:
--

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

--
-- Name: Global.VectorRand
-- Desc: Returns a random vector
-- Realm: Shared
-- Arg1:
-- Ret1: Vector|A randomly generated vector betweem Vector<-1, -1, -1> and Vector<1, 1, 1>
--

function VectorRand()
	return Vector( math.Rand(-1.0, 1.0), math.Rand(-1.0, 1.0), math.Rand(-1.0, 1.0) )
end

--
-- Name: Global.AngleRand
-- Desc: Returns a random anhle
-- Realm: Shared
-- Arg1:
-- Ret1: Vector|A randomly generated vector betweem Vector<-180, -180, -180> and Vector<180, 180, 180>
--

function AngleRand()
	return Angle( math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180) )
end

--
-- Name: Global.Sound
-- Desc: An alias of util.PrecacheSound
-- Realm: Shared
-- Arg1: string|SoundName|The name of the sound you want to precache
-- Ret1: string|The sound name that was precached; Same as first argument
--

function Sound( name )
	util.PrecacheSound( name )
	return name
end

--
-- Name: Global.Model
-- Desc: An alias of util.PrecacheModel
-- Realm: Shared
-- Arg1: string|ModelName|The name of the model you want to precache
-- Ret1: string|The model name that was precached. Same as first argument
--

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

--
-- Name: Global.IncludeCS
-- Desc: Includes a file (and adds it to be sent to the client if ran serverside)
-- Realm: Shared
-- Arg1: string|filename|The name of the file you want to include and have sent to the client
-- Ret1:
--

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

--
-- Name: Global.AccessorFunc
-- Realm: Shared
-- Desc: Makes simple Get/Set functions for a specified table key
-- Arg1: table|tab|The table you wish for the accessor function to be made on
-- Arg2: any|key|The key of the table the Get/Set functions will modify
-- Arg3: string|name|The name the functions will use (automatically prefixed with Get or Set)
-- Arg4: number|iForce|The type of values the variable will be restricted to (uses FORCE_ enums)
--

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

--
-- Name: Global.AccessorFuncNW
-- Realm: Shared
-- Desc: Depricated function- use SetupDataTables instead
-- Arg1:
-- Ret1:
--

function AccessorFuncNW( tab, varname, name, varDefault, iForce )

	ErrorNoHalt( "[AccessorFuncNW] is depreciated. Look up 'SetupDataTables'. Sorry :(" );

end

--[[---------------------------------------------------------
	Returns true if object is valid (is not nil and IsValid)
-----------------------------------------------------------]]

--
-- Name: Global.IsValid
-- Realm: Shared
-- Desc: Checks if an object is valid and not nil.
-- Arg1: any|object|The object to be checked for validation
-- Ret1: boolean|Is the object valid?
--

function IsValid( object )

	if ( !object ) then return false end
	if ( !object.IsValid ) then return false end

	return object:IsValid()

end

--
-- Name: Global.SafeRemoveEntity
-- Realm: Shared
-- Desc: Checks if an object is valid and if it is removes it
-- Arg1: Entity|ent|The ent that should be deleted
-- Ret1:
--

function SafeRemoveEntity( ent )

	if ( !ent || !ent:IsValid() || ent:IsPlayer() ) then return end
	
	ent:Remove()
	
end

--
-- Name: Global.SafeRemoveEntityDelayed
-- Realm: Shared
-- Desc: Waits n seconds, then if an object is valid and if it is removes it
-- Arg1: Entity|ent|The ent that should be deleted
-- Arg2: number|timedelay|The amount of time in seconds to wait before running Global.SafeRemoveEntity on an entity
-- Ret1:
--

function SafeRemoveEntityDelayed( ent, timedelay )

	if (!ent || !ent:IsValid()) then return end
	
	timer.Simple( timedelay, function() SafeRemoveEntity( ent ) end )
	
end

--
-- Name: Global.Lerp
-- Realm: Shared
-- Desc: Performs a linear interpolation from the start number to the end number.
-- Arg1: number|delta|The fraction for finding the result. This number is clamped between 0 and 1.
-- Arg2: number|from|The starting number. Returned if delta is less then 0.
-- Arg3: number|to|The ending number. Returned if delta is greater then 1.
-- Ret1: number|The result the interpolation of delta
--

function Lerp( delta, from, to )

	if ( delta > 1 ) then return to end
	if ( delta < 0 ) then return from end
	
	return from + (to - from) * delta;

end

--
-- Name: Global.tobool
-- Realm: Shared
-- Desc: Attempts to convert a variable into a boolean
-- Arg1: any|val|The fraction for finding the result. This number is clamped between 0 and 1.
-- Ret1: boolean|nil, false, 0, and "false" values return false everything else returns true
--

function tobool( val )
	if ( val == nil || val == false || val == 0 || val == "0" || val == "false" ) then return false end
	return true
end

--
-- Name: Global.UTIL_IsUselessModel
-- Realm: Shared
-- Desc: Universal function to filter out crappy models by name
-- Arg1: boolean|modelname|The name of the model to be checked for uselessness
-- Ret1: boolean|Is the modelname a useful?
--

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

--
-- Name: Global.RememberCursorPosition
-- Realm: Client
-- Desc: Saves the position of your cursor, restored with Global.RestoreCursorPosition
-- Arg1:
-- Ret1:
--

local StoredCursorPos = {}

function RememberCursorPosition()

	local x, y = gui.MousePos()
	
	-- If the cursor isn't visible it will return 0,0 ignore it.
	if ( x == 0 && y == 0 ) then return end
	
	StoredCursorPos.x, StoredCursorPos.y = x, y
	
end

--
-- Name: Global.RestoreCursorPosition
-- Realm: Client
-- Desc: Sets the cursor position to that saved in Global.RememberCursorPosition
-- Arg1:
-- Ret1:
--

function RestoreCursorPosition()

	if ( !StoredCursorPos.x || !StoredCursorPos.y ) then return end
	input.SetCursorPos( StoredCursorPos.x, StoredCursorPos.y )

end

--
-- Name: Global.STNDRD
-- Realm: Shared
-- Desc: Returns the spatinal ordinal suffix for a number
-- Arg1: number|num|The number who's suffix you want
-- Ret1: string|The the spatinal ordinal suffix of the first argument
--

function STNDRD( num )
	local n = tonumber( string.Right( tostring( num ), 1 ) )
	
	if ( num > 3 and num < 21 ) then
		return "th"
	elseif ( n == 1 ) then
		return "st"
	elseif ( n == 2 ) then
		return "nd"
	elseif ( n == 3 ) then
		return "rd"
	end
	
	return "th"
end


--[[---------------------------------------------------------
	From Simple Gamemode Base (Rambo_9)
-----------------------------------------------------------]]

--
-- Name: Global.TimedSin
-- Realm: Shared
-- Desc: Returns a fluctuating sine value
-- Arg1: number|freq
-- Arg2: number|min
-- Arg3: number|max
-- Arg4: number|offset
-- Ret1: number|Value
--

function TimedSin(freq,min,max,offset)
	return math.sin(freq * math.pi * 2 * CurTime() + offset) * (max-min) * 0.5 + min
end 

--
-- Name: Global.TimedCos
-- Realm: Shared
-- Desc: Returns a fluctuating sine value
-- Arg1: number|freq
-- Arg2: number|min
-- Arg3: number|max
-- Arg4: number|offset
-- Ret1: number|Value
--

function TimedCos(freq,min,max,offset)
	return math.cos(freq * math.pi * 2 * CurTime() + offset) * (max-min) * 0.5 + min
end 

--
-- Name: Global.IsEnemyEntityName
-- Realm: Shared
-- Desc: Checks if an NPC is enemy in the HL2 story line.\nDoesn't the hostility of the enemy.
-- Arg1: string|victimtype|The NPC name to check
-- Ret1: boolean|Is the NPC an enemy?
--

function IsEnemyEntityName( victimtype )

	if ( victimtype == "npc_combine_s" ) then return true; end
	if ( victimtype == "npc_cscanner" ) then return true; end
	if ( victimtype == "npc_manhack" ) then return true; end
	if ( victimtype == "npc_hunter" ) then return true; end
	if ( victimtype == "npc_antlion" ) then return true; end
	if ( victimtype == "npc_antlionguard" ) then return true; end
	if ( victimtype == "npc_antlion_worker" ) then return true; end
	if ( victimtype == "npc_fastzombie_torso" ) then return true; end
	if ( victimtype == "npc_fastzombie" ) then return true; end
	if ( victimtype == "npc_headcrab" ) then return true; end
	if ( victimtype == "npc_headcrab_fast" ) then return true; end
	if ( victimtype == "npc_poisonzombie" ) then return true; end
	if ( victimtype == "npc_headcrab_poison" ) then return true; end
	if ( victimtype == "npc_zombie" ) then return true; end
	if ( victimtype == "npc_zombie_torso" ) then return true; end
	if ( victimtype == "npc_zombine" ) then return true; end
	if ( victimtype == "npc_gman" ) then return true; end
	if ( victimtype == "npc_breen" ) then return true; end

	return false

end

--
-- Name: Global.IsFriendEntityName
-- Realm: Shared
-- Desc: Checks if an NPC is friendly in the HL2 story line.\nDoesn't the hostility of the enemy.
-- Arg1: string|victimtype|The NPC name to check
-- Ret1: boolean|Is the NPC a friend?
--

function IsFriendEntityName( victimtype )

	if ( victimtype == "npc_monk" ) then return true; end
	if ( victimtype == "npc_alyx" ) then return true; end
	if ( victimtype == "npc_barney" ) then return true; end
	if ( victimtype == "npc_citizen" ) then return true; end
	if ( victimtype == "npc_kleiner" ) then return true; end
	if ( victimtype == "npc_magnusson" ) then return true; end
	if ( victimtype == "npc_eli" ) then return true; end
	if ( victimtype == "npc_mossman" ) then return true; end
	if ( victimtype == "npc_vortigaunt" ) then return true; end

	return false

end

--
-- Name: Global.IsMounted
-- Realm: Shared
-- Desc: Checks if content from a game is mounted
-- Arg1: string/number|name|The game string or app ID to check
-- Ret1: boolean|Is the game mounted?
--

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

--
-- Name: Global.Either
-- Realm: Shared
-- Desc: A function based if statement.\nReplacement for C++'s iff ? aa : bb
-- Arg1: boolean|iff|The value that will be evaluated
-- Arg2: any|aa|The value to be returned if arg1 is true
-- Arg3: any|bb|The value to be returned if arg1 is false
-- Ret1: boolean|Argument 2 or Argument 3
--

function Either( iff, aa, bb ) 

	if ( iff ) then return aa end
	return bb

end

--
-- Name: Global.Add_NPC_Class
-- Realm: Shared
-- Desc: You can use this function to add your own CLASS_ var\nAdding in this way will ensure your CLASS_ doesn't collide with another\nAdding in this way will ensure your CLASS_ doesn't collide with another
-- Arg1: string|name|The name of the new global variable
-- Ret1: 
--

function Add_NPC_Class( name )

	_G[ name ] = NUM_AI_CLASSES
	NUM_AI_CLASSES = NUM_AI_CLASSES + 1

end

