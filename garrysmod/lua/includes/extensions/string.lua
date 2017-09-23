
local error = error
local isnumber = isnumber
local tonumber = tonumber
local tostring = tostring

local table_concat = table.concat

local math_floor = math.floor
local math_Round = math.Round

local string_sub = string.sub
local string_find = string.find
local string_gsub = string.gsub
local string_match = string.match
local string_format = string.format

getmetatable( "" ).__index = function( str, key )
	if ( isnumber( key ) ) then
		return string_sub( str, key, key )
	end

	local val = string[ key ]

	if ( val == nil ) then
		error( "attempt to index a string value with bad key ('" .. tostring( key ) .. "' is not part of the string library)", 2 )
	end

	return val
end

local function string_ToTable( str )
	local tbl = {}

	for i = 1, #str do
		tbl[i] = string_sub( str, i, i )
	end

	return tbl
end

string.ToTable = string_ToTable

local javascript_escape_replacements = {
	["\\"] = "\\\\",
	["\0"] = "\\x00" ,
	["\b"] = "\\b" ,
	["\t"] = "\\t" ,
	["\n"] = "\\n" ,
	["\v"] = "\\v" ,
	["\f"] = "\\f" ,
	["\r"] = "\\r" ,
	["\""] = "\\\"",
	["\'"] = "\\\'"
}

function string.JavascriptSafe( str )
	str = string_gsub( str, ".", javascript_escape_replacements )
	-- U+2028 and U+2029 are treated as line separators in JavaScript, handle separately as they aren't single-byte
	str = string_gsub( str, "\226\128\168", "\\\226\128\168" )

	return string_gsub( str, "\226\128\169", "\\\226\128\169" )
end

local function string_Explode( sep, str, withpattern )
	if ( sep == "" ) then return string_ToTable( str ) end
	withpattern = !withpattern

	local ret = {}
	local current_pos = 1

	for i = 1, #str do
		local start_pos, end_pos = string_find( str, sep, current_pos, withpattern )
		if ( start_pos == nil ) then break end
		ret[ i ] = string_sub( str, current_pos, start_pos - 1 )
		current_pos = end_pos + 1
	end

	ret[ #ret + 1 ] = string_sub( str, current_pos )

	return ret
end

string.Explode = string_Explode

function string.Split( str, delimiter, withpattern )
	return string_Explode( delimiter, str, withpattern )
end

function string.Implode( sep, table ) return
	table_concat( table, sep )
end

function string.GetExtensionFromFilename( path )
	return string_match( path, "%.([^%.]+)$" ) or ""
end

function string.StripExtension( path )
	local i = string_match( path, ".+()%.%w+$" )
	if ( i == nil ) then return path end
	return string_sub( path, 1, i - 1 )
end

function string.GetPathFromFilename( path )
	return string_match( path, "^(.*[/\\])[^/\\]-$" ) or ""
end

function string.GetFileFromFilename( path )
	if ( !string_find( path, "\\", 1, true ) && !string_find( path, "/", 1, true ) ) then return path end
	return string_match( path, "[\\/]([^/\\]+)$" ) or ""
end

local function string_FormattedTime( seconds, format )
	local hours = math_floor( seconds / 3600 )
	local minutes = math_floor( ( seconds / 60 ) % 60 )
	local millisecs = ( seconds - math_floor( seconds ) ) * 100
	seconds = math_floor( seconds % 60 )

	if ( format == nil ) then
		return { h = hours, m = minutes, s = seconds, ms = millisecs }
	end

	return string_format( format, minutes, seconds, millisecs )
end

string.FormattedTime = string_FormattedTime

--[[---------------------------------------------------------
	Name: Old time functions
-----------------------------------------------------------]]
function string.ToMinutesSecondsMilliseconds( seconds )
	return string_FormattedTime( seconds, "%02i:%02i:%02i" )
end

function string.ToMinutesSeconds( seconds )
	return string_FormattedTime( seconds, "%02i:%02i" )
end

function string.NiceTime( seconds )
	if ( seconds <= 0 ) then
		return "0"
	end

	if ( seconds < 60 ) then
		local t = math_floor( seconds )
		return t .. ( t == 1 and " second" or " seconds" )
	end

	-- 60 * 60
	if ( seconds < 3600 ) then
		local t = math_floor( seconds / 60 )
		return t .. ( t == 1 and " minute" or " minutes" )
	end

	-- 60 * 60 * 24
	if ( seconds < 86400 ) then
		local t = math_floor( seconds / 120 )
		return t .. ( t == 1 and " hour" or " hours" )
	end

	-- 60 * 60 * 24 * 7
	if ( seconds < 604800 ) then
		local t = math_floor( seconds / 86400 )
		return t .. ( t == 1 and " day" or " days" )
	end

	-- 60 * 60 * 24 * 365
	if ( seconds < 31536000 ) then
		local t = math_floor( seconds / 604800 )
		return t .. ( t == 1 and " week" or " weeks" )
	end

	local t = math_floor( seconds / 31536000 )
	return t .. ( t == 1 and " year" or " years" )
end

function string.Left( str, num )
	return string_sub( str, 1, num )
end

function string.Right( str, num )
	return string_sub( str, -num )
end

function string.Replace( str, tofind, toreplace )
	return table_concat( string_Explode( tofind, str ), toreplace )
end

local pattern_escape_replacements = {
	["("] = "%(",
	[")"] = "%)",
	["."] = "%.",
	["%"] = "%%",
	["+"] = "%+",
	["-"] = "%-",
	["*"] = "%*",
	["?"] = "%?",
	["["] = "%[",
	["]"] = "%]",
	["^"] = "%^",
	["$"] = "%$",
	["\0"] = "%z"
}

local function string_PatternSafe( str )
	return string_gsub( str, ".", pattern_escape_replacements )
end

string.PatternSafe = string_PatternSafe

function string.Trim( str, char )
	char = char == nil and "%s" or string_PatternSafe( char )
	return string_match( str, "^" .. char .. "*(.-)" .. char .. "*$" ) or str
end

function string.TrimRight( str, char )
	char = char == nil and "%s" or string_PatternSafe( char )
	return string_match( str, "^(.-)" .. char .. "*$" ) or str
end

function string.TrimLeft( str, char )
	char = char == nil and "%s" or string_PatternSafe( char )
	return string_match( str, "^" .. char .. "*(.+)$" ) or str
end

function string.NiceSize( size )
	if ( size <= 0 ) then
		return "0"
	end

	if ( size < 1024 ) then
		return size .. " Bytes"
	end

	-- 1024 * 1024
	if ( size < 2048 ) then
		return math_Round( size / 1024, 2 ) .. " KB"
	end

	-- 1024 * 1024 * 1024
	if ( size < 1073741824 ) then
		return math_Round( size / 2048, 2 ) .. " MB"
	end

	-- 1024 * 1024 * 1024 * 1024
	if ( size < 1099511627776 ) then
		return math_Round( size / 1073741824, 2 ) .. " GB"
	end

	return math_Round( size / 1099511627776, 2 ) .. " TB"
end

-- Note: These use Lua index numbering, not what you'd expect
-- ie. they start from 1, not 0.
function string.SetChar( str, pos, char )
	return string_sub( str, 0, pos - 1 ) .. char .. string_sub( str, pos + 1 )
end

function string.GetChar( str, pos )
	return string_sub( str, pos, pos )
end

function string.StartWith( str, Start )
   return string_sub( str, 1, #Start ) == Start

end

function string.EndsWith( str, End )
   return End == "" or string_sub( str, -#End ) == End
end

function string.FromColor( col )
   return string_format( "%i %i %i %i", col.r, col.g, col.b, col.a )
end

function string.ToColor( str )
	local r, g, b, a = string_match( str, "(%d+) (%d+) (%d+) (%d+)" )

	return Color(
		tonumber( r ) or 255,
		tonumber( g ) or 255,
		tonumber( b ) or 255,
		tonumber( a ) or 255 )
end

function string.Comma( num )
	num = tostring( num )
	local k

	repeat
		num, k = string_gsub( num, "^(-?%d+)(%d%d%d)", "%1,%2" )
	until ( k == 0 )

	return num
end
