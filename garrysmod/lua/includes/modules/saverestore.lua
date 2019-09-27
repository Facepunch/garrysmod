
local Msg			= Msg
local type			= type
local pairs			= pairs
local gmod			= gmod
local table			= table

--[[

	This module is to help bind the engine's saverestore stuff to Lua.

	This is so we can save Lua stuff in the save game file. The entities
	should automatically save most of their table contents to the save file.

	!!Warning!!: Editing this file may render old saves useless.

	You can hook into this system like so

	local function MySaveFunction( save )
		saverestore.WriteTable( my_table, save )
	end

	local function MyRestoreFunction( restore )
		my_table = saverestore.ReadTable( restore )
	end

	saverestore.AddSaveHook( "HookNameHere", MySaveFunction )
	saverestore.AddRestoreHook( "HookNameHere", MyRestoreFunction )

--]]

module( "saverestore" )

local TYPE_NONE		= 0
local TYPE_FLOAT	= 1 -- Treat all numbers as floats (they're all the same to Lua)
local TYPE_STRING	= 2
local TYPE_ENTITY	= 3
local TYPE_VECTOR	= 4
local TYPE_TABLE	= 5
local TYPE_BOOL		= 6
local TYPE_ANGLE	= 7

local SaveHooks = {}
local RestoreHooks = {}
local TableRefs = {}
local TableRef = 1

function PreSave()

	TableRefs = {}
	TableRef = 1

end

function PreRestore()

	TableRefs = {}
	TableRef = 1

end

--[[---------------------------------------------------------
	Name: GetTypeStr
	Desc: Given a string returns a TYPE_
-----------------------------------------------------------]]
local function GetTypeStr( name )

	if ( name == "function" ) then return TYPE_NONE end

	if ( name == "number" ) then return TYPE_FLOAT end
	if ( name == "string" ) then return TYPE_STRING end
	if ( name == "Entity" ) then return TYPE_ENTITY end
	if ( name == "Vehicle" ) then return TYPE_ENTITY end
	if ( name == "NPC" ) then return TYPE_ENTITY end
	if ( name == "Player" ) then return TYPE_ENTITY end
	if ( name == "Weapon" ) then return TYPE_ENTITY end
	if ( name == "Vector" ) then return TYPE_VECTOR end
	if ( name == "Angle" ) then return TYPE_ANGLE end
	if ( name == "table" ) then return TYPE_TABLE end
	if ( name == "boolean" ) then return TYPE_BOOL end

	-- These aren't saved
	if ( name == "ConVar" ) then return TYPE_NONE end
	if ( name == "PhysObj" ) then return TYPE_NONE end

	-- Bitch about it incase I've forgot to hook a savable type up
	Msg( "Can't save unknown type " .. name .. "\n" )
	return TYPE_NONE

end

--[[---------------------------------------------------------
	Name: GetType
	Desc: Given a variable returns a TYPE_
-----------------------------------------------------------]]
local function GetType( var )

	return GetTypeStr( type(var) )

end


--[[---------------------------------------------------------
	Name: IsWritable
	Desc: Returns true if we can save the K/V pair
-----------------------------------------------------------]]
local function IsWritable( k, v )

	local itype = GetType( k )
	if ( itype == TYPE_NONE ) then return false end
	if ( itype == TYPE_STRING && k == "SR_Recursion" ) then return false end

	local itype = GetType( v )
	if ( itype == TYPE_NONE ) then return false end

	return true

end


--[[---------------------------------------------------------
	Name: WriteVar
	Desc: Writes a single variable to the save
-----------------------------------------------------------]]
function WritableKeysInTable( t )

	local i = 0

	for k, v in pairs( t ) do
		if ( IsWritable( k, v ) ) then
			i = i + 1
		end
	end

	return i

end


--[[---------------------------------------------------------
	Name: WriteVar
	Desc: Writes a single variable to the save
-----------------------------------------------------------]]
function WriteVar( var, save )

	local itype = GetType( var )
	if ( itype == TYPE_NONE ) then return end

	save:StartBlock( type( var ) )

		if ( itype == TYPE_FLOAT ) then
			save:WriteFloat( var )
		elseif ( itype == TYPE_BOOL ) then
			save:WriteBool( var )
		elseif ( itype == TYPE_STRING ) then
			save:WriteString( var )
		elseif ( itype == TYPE_ENTITY ) then
			save:WriteEntity( var )
		elseif ( itype == TYPE_ANGLE ) then
			save:WriteAngle( var )
		elseif ( itype == TYPE_VECTOR ) then
			save:WriteVector( var )
		elseif ( itype == TYPE_TABLE ) then
			WriteTable( var, save )
		else
			Msg( "Error! Saving unsupported Type: " .. type( var ) .. "\n" )
		end

	save:EndBlock()

end


--[[---------------------------------------------------------
	Name: ReadVar
	Desc: Reads a single variable
-----------------------------------------------------------]]
function ReadVar( restore )

	local retval = 0
	local typename = restore:StartBlock()

		local itype = GetTypeStr( typename )

		if ( itype == TYPE_FLOAT ) then
			retval = restore:ReadFloat()
		elseif ( itype == TYPE_BOOL ) then
			retval = restore:ReadBool()
		elseif ( itype == TYPE_STRING ) then
			retval = restore:ReadString()
		elseif ( itype == TYPE_ENTITY ) then
			retval = restore:ReadEntity()
		elseif ( itype == TYPE_ANGLE ) then
			retval = restore:ReadAngle()
		elseif ( itype == TYPE_VECTOR ) then
			retval = restore:ReadVector()
		elseif ( itype == TYPE_TABLE ) then
			retval = ReadTable( restore )
		else
			Msg( "Error! Loading unsupported Type: " .. typename .. "\n" )
		end

	restore:EndBlock()

	return retval

end

--[[---------------------------------------------------------
	Name: WriteTable
	Desc: Writes a table to the save
-----------------------------------------------------------]]
function WriteTable( tab, save )

	-- Write a blank table (because read will be expecting one)
	if ( tab == nil ) then

		save:StartBlock( "Table" )
		save:EndBlock()

	end

	-- We have already saved this table
	if ( TableRefs[ tab ] ) then

		save:StartBlock( "TableRef" )
			save:WriteInt( TableRefs[ tab ] )
		save:EndBlock()

		return

	end

	TableRefs[ tab ] = TableRef

	save:StartBlock( "Table" )

		local iCount = WritableKeysInTable( tab )

		save:WriteInt( TableRef )
		TableRef = TableRef + 1

		save:WriteInt( iCount )

		for k, v in pairs( tab ) do

			if ( IsWritable( k, v ) ) then

				WriteVar( k, save )
				WriteVar( v, save )

			end

		end

	save:EndBlock()

end

--[[---------------------------------------------------------
	Name: ReadTable
	Desc: Assumes a table is waiting to be read, returns a table
-----------------------------------------------------------]]
function ReadTable( restore )

	local name = restore:StartBlock()
	local tab = {}

	if ( name == "TableRef" ) then

		local ref = restore:ReadInt()
		if ( !TableRefs[ ref ] ) then
			TableRefs[ ref ] = {}
			return
		end

		tab = TableRefs[ ref ]

	else

		local iRef = restore:ReadInt()
		local iCount = restore:ReadInt()

		if ( TableRefs[ iRef ] ) then
			tab = TableRefs[ iRef ]
		end

		for i = 0, iCount - 1 do

			local k = ReadVar( restore )
			local v = ReadVar( restore )
			tab[ k ] = v

		end

		TableRefs[ iRef ] = tab

	end

	restore:EndBlock()

	return tab

end


--[[---------------------------------------------------------
	Name: SaveEntity
	Desc: Called by the engine for each entity
-----------------------------------------------------------]]
function SaveEntity( ent, save )

	save:StartBlock( "EntityTable" )

		WriteTable( ent:GetTable(), save )

	save:EndBlock()

end

--[[---------------------------------------------------------
	Name: LoadEntity
	Desc: Called by the engine for each entity
-----------------------------------------------------------]]
function LoadEntity( ent, restore )

	local EntTable = ent:GetTable()

	local name = restore:StartBlock()

		if ( name == "EntityTable" ) then

			table.Merge( EntTable, ReadTable( restore ) )

		end

	restore:EndBlock()

	ent:SetTable( EntTable )

end


--[[---------------------------------------------------------
	Name: AddSaveHook
	Desc: Adds a hook enabling something to save something..
-----------------------------------------------------------]]
function AddSaveHook( name, func )

	local h = {}
	h.Name = name
	h.Func = func
	SaveHooks[ name ] = h

end


--[[---------------------------------------------------------
	Name: AddRestoreHook
	Desc: Adds a hook enabling something to restore something..
-----------------------------------------------------------]]
function AddRestoreHook( name, func )

	local h = {}
	h.Name = name
	h.Func = func
	RestoreHooks[ name ] = h

end


--[[---------------------------------------------------------
	Name: SaveGlobal
	Desc: Should save any Lua stuff that isn't entity based.
-----------------------------------------------------------]]
function SaveGlobal( save )

	save:StartBlock( "GameMode" )
		WriteTable( gmod.GetGamemode(), save )
	save:EndBlock()

	for k, v in pairs( SaveHooks ) do

		save:StartBlock( v.Name )

			v.Func( save )

		save:EndBlock()

	end

end


--[[---------------------------------------------------------
	Name: LoadGlobal
	Desc: ...
-----------------------------------------------------------]]
function LoadGlobal( restore )

	local name = restore:StartBlock()

		if ( name == "GameMode" ) then
			table.Merge( gmod.GetGamemode(), ReadTable( restore ) )
		end

	restore:EndBlock()


	while ( name != "EndGlobal" ) do

		name = restore:StartBlock()

			local tab = RestoreHooks[ name ]
			if ( tab ) then

				tab.Func( restore )

			end

		restore:EndBlock()

	end

end

