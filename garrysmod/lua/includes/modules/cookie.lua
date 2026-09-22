
if ( !sql.TableExists( "cookies" ) ) then

	sql.Query( "CREATE TABLE IF NOT EXISTS cookies ( key TEXT NOT NULL PRIMARY KEY, value TEXT );" )

end

module( "cookie", package.seeall )

--[[
	key:
		1 = number expireTime - if the SysTime expired then the cookie is fetched from SQL
		2 = string cookieValue
]]
local CachedEntries = {}

-- key = value (false for delete, else string value for insert)
local BufferedQueue = {}

local function GetCache( key )

	if ( BufferedQueue[ key ] == false ) then return nil end

	local entry = CachedEntries[ key ]

	if ( entry == nil || SysTime() > entry[ 1 ] ) then
		local val = sql.QueryValue( "SELECT value FROM cookies WHERE key = " .. SQLStr( key ) )

		if ( !val ) then
			return false
		end

		CachedEntries[ key ] = { SysTime() + 30, val }
	end

	return CachedEntries[ key ][ 2 ]

end

local function FlushCache()

	CachedEntries = {}
	BufferedQueue = {}

end

local function CommitToSQLite()

	sql.Begin()

	for k, v in pairs( BufferedQueue ) do
		if ( v == false ) then
			sql.Query( "DELETE FROM cookies WHERE key = " .. SQLStr( k ) )
		else
			sql.Query( "INSERT OR REPLACE INTO cookies ( key, value ) VALUES ( " .. SQLStr( k ) .. ", " .. SQLStr( v ) .. " )" )
		end
	end

	BufferedQueue = {}

	sql.Commit()

end

local function ScheduleCommit()

	timer.Create( "Cookie_CommitToSQLite", 0.1, 1, CommitToSQLite )

end

local function SetCache( key, value )

	if ( value == nil ) then return Delete( key ) end

	local strValue = tostring( value )

	-- It is unlikely that this could ever happen, but with an invalid __tostring method tostring() may silently fail
	if ( strValue == nil ) then
		error( "bad argument #2 to 'cookie.Set' (string expected, got " .. type( value ) .. ")", 2 )
	end

	if CachedEntries[ key ] then
		CachedEntries[ key ][ 1 ] = SysTime() + 30
		CachedEntries[ key ][ 2 ] = strValue
	else
		CachedEntries[ key ] = { SysTime() + 30, strValue }
	end

	BufferedQueue[ key ] = strValue

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
	BufferedQueue[ name ] = false

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
