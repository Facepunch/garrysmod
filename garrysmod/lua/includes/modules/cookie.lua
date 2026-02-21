
if ( !sql.TableExists( "cookies" ) ) then

	sql.Query( "CREATE TABLE IF NOT EXISTS cookies ( key TEXT NOT NULL PRIMARY KEY, value TEXT );" )

end

module( "cookie", package.seeall )

local CachedEntries = {}
local BufferedWrites = {}
local BufferedDeletes = {}

local function GetCache( key )

	if ( BufferedDeletes[ key ] ) then return nil end

	local entry = CachedEntries[ key ]

	if ( entry == nil || SysTime() > entry[ 1 ] ) then
		local name = SQLStr( key )
		local val = sql.QueryValue( "SELECT value FROM cookies WHERE key = " .. name )

		if !val then
			return false
		end

		CachedEntries[ key ] = { SysTime() + 30, val }
	end

	return CachedEntries[ key ][ 2 ]

end

local function FlushCache()

	CachedEntries = {}
	BufferedWrites = {}
	BufferedDeletes = {}

end

local function CommitToSQLite()

	sql.Begin()

	for k, v in pairs( BufferedWrites ) do
		sql.Query( "INSERT OR REPLACE INTO cookies ( key, value ) VALUES ( " .. SQLStr( k ) .. ", " .. SQLStr( v ) .. " )" )
	end

	for k, v in pairs( BufferedDeletes ) do
		sql.Query( "DELETE FROM cookies WHERE key = " .. SQLStr( k ) )
	end

	BufferedWrites = {}
	BufferedDeletes = {}

	sql.Commit()

end

local function ScheduleCommit()

	timer.Create( "Cookie_CommitToSQLite", 0.1, 1, CommitToSQLite )

end

local function SetCache( key, value )

	if ( value == nil ) then return Delete( key ) end

	if CachedEntries[ key ] then
		CachedEntries[ key ][ 1 ] = SysTime() + 30
		CachedEntries[ key ][ 2 ] = value
	else
		CachedEntries[ key ] = { SysTime() + 30, value }
	end

	BufferedWrites[ key ] = value

	ScheduleCommit()

end

-- Get a String Value
function GetString( name, default )

	local val = GetCache( name )
	if ( !val ) then return default end

	return val

end

-- Get a Number Value
function GetNumber( name, default )

	local val = GetCache( name )
	if ( !val ) then return default end

	return tonumber( val )

end

-- Delete a Value
function Delete( name )

	CachedEntries[ name ] = nil
	BufferedWrites[ name ] = nil
	BufferedDeletes[ name ] = true

	ScheduleCommit()

end

-- Set a Value
function Set( name, value )

	SetCache( name, value )

end

hook.Add( "ShutDown", "SaveCookiesOnShutdown", CommitToSQLite )

if ( !CLIENT_DLL ) then return end

concommand.Add( "lua_cookieclear", function( ply, command, arguments )

	sql.Query( "DELETE FROM cookies" )
	FlushCache()

end )

