
--[[---------------------------------------------------------
	This module was primarily developed to enable toolmodes
	to share the numpad.

	Scripted Entities can add functions to be excecuted when
	a certain key on the numpad is pressed or released.
-----------------------------------------------------------]]

if ( !SERVER ) then return end

local tonumber		= tonumber
local pairs			= pairs
local unpack		= unpack
local table			= table
local ErrorNoHalt	= ErrorNoHalt
local MsgN			= MsgN
local saverestore	= saverestore
local math			= math
local IsValid		= IsValid

module( "numpad" )

local functions = {}
local keys_in = {}
local keys_out = {}
local lastindex = 1
local button_fired = false

function FromButton()

	return button_fired == true

end

local function Save( save )

	saverestore.WriteTable( keys_in, save )
	saverestore.WriteTable( keys_out, save )
	saverestore.WriteVar( lastindex, save )

end

local function Restore( restore )

	keys_in = saverestore.ReadTable( restore )
	keys_out = saverestore.ReadTable( restore )
	lastindex = saverestore.ReadVar( restore )

end

saverestore.AddSaveHook( "NumpadModule", Save )
saverestore.AddRestoreHook( "NumpadModule", Restore )

--[[---------------------------------------------------------
	Returns a unique index based on a player.
-----------------------------------------------------------]]
local function GetPlayerIndex( ply )

	if ( !IsValid( ply ) ) then return 0 end

	return ply:UniqueID()

end

--[[---------------------------------------------------------
	Fires the impulse to the child functions
-----------------------------------------------------------]]
local function FireImpulse( tab, pl, idx )

	if ( idx == nil ) then
		idx = GetPlayerIndex( pl )
	end

	if ( !tab ) then return end
	if ( !tab[ idx ] ) then return end

	for k, v in pairs( tab[ idx ] ) do

		local func = functions[ v.name ]

		local retval = func( pl, unpack( v.arg ) )

		-- Remove hook
		if ( retval == false ) then
			tab[ idx ][ k ] = nil
		end

	end

end

--[[---------------------------------------------------------
	Console Command
-----------------------------------------------------------]]
function Activate( pl, num, bIsButton )

	local key = math.Clamp( tonumber( num ), 0, 256 )

	-- Hack. Kinda. Don't call it again until the key has been lifted.
	-- When holding down 9 or 3 on the numpad it will repeat. Ignore that.
	if ( IsValid( pl ) ) then
		pl.keystate = pl.keystate or {}
		if ( pl.keystate[ key ] ) then return end
		pl.keystate[ key ] = true
	end

	button_fired = bIsButton

		FireImpulse( keys_in[ key ], pl, nil )

		-- And fire `all`
		FireImpulse( keys_in[ key ], pl, 0 )

	button_fired = false

end

--[[---------------------------------------------------------
	Console Command
-----------------------------------------------------------]]
function Deactivate( pl, num, bIsButton )

	local key = math.Clamp( tonumber( num ) , 0, 256 )

	if ( IsValid( pl ) ) then
		pl.keystate = pl.keystate or {}
		pl.keystate[ key ] = nil
	end

	button_fired = bIsButton

		FireImpulse( keys_out[ key ], pl, nil )

		-- And fire `all`
		FireImpulse( keys_out[ key ], pl, 0 )

	button_fired = false

end

--[[---------------------------------------------------------
	Toggle
-----------------------------------------------------------]]
function Toggle( pl, num )

	local key = math.Clamp( tonumber( num ), 0, 256 )

	pl.keystate = pl.keystate or {}
	if ( pl.keystate[ key ] ) then return Deactivate( pl, num ) end

	return Activate( pl, num )

end

--[[---------------------------------------------------------
	Adds an impulse to to the specified table
-----------------------------------------------------------]]
local function AddImpulse( table, ply, impulse )

	lastindex = lastindex + 1

	local idx = GetPlayerIndex( ply )
	table[ idx ] = table[ idx ] or {}
	table[ idx ][ lastindex ] = impulse

	return lastindex

end

--[[---------------------------------------------------------
	Adds a function to call when ply presses key
-----------------------------------------------------------]]
function OnDown( ply, key, name, ... )

	if ( !key ) then ErrorNoHalt( "ERROR: numpad.OnDown key is nil!\n" ) return end
	if ( key ~= key ) then MsgN( "ERROR: numpad.OnDown key is NaN!" ) return end
	keys_in[ key ] = keys_in[ key ] or {}

	local impulse = {}
	impulse.name = name
	impulse.arg = { ... }

	table.insert( impulse.arg, GetPlayerIndex( ply ) )

	return AddImpulse( keys_in[ key ], ply, impulse )

end

--[[---------------------------------------------------------
	Adds a function to call when ply releases key
-----------------------------------------------------------]]
function OnUp( ply, key, name, ... )

	if ( !key ) then ErrorNoHalt( "ERROR: numpad.OnUp key is nil!\n" ) return end
	if ( key ~= key ) then MsgN( "ERROR: numpad.OnUp key is NaN!" ) return end
	keys_out[ key ] = keys_out[ key ] or {}

	local impulse = {}
	impulse.name = name
	impulse.arg = { ... }

	table.insert( impulse.arg, GetPlayerIndex( ply ) )

	return AddImpulse( keys_out[ key ], ply, impulse )

end

--[[---------------------------------------------------------
	Removes key from tab (by unique index)
-----------------------------------------------------------]]
local function RemoveFromKeyTable( tab, idx )

	for k, v_key in pairs( tab ) do

		for k_, v_player in pairs( v_key ) do

			if ( v_player[ idx ] != nil ) then
				v_player[ idx ] = nil
			end

		end

	end

end

--[[---------------------------------------------------------
	Removes key (by unique index)
-----------------------------------------------------------]]
function Remove( idx )

	if ( !idx ) then return end

	RemoveFromKeyTable( keys_out, idx )
	RemoveFromKeyTable( keys_in, idx )

end

--[[---------------------------------------------------------
	Register a function
-----------------------------------------------------------]]
function Register( name, func )

	functions[ name ] = func

end
