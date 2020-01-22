
local string = string
local math = math

--[[---------------------------------------------------------
	Name: string.ToTable( string )
-----------------------------------------------------------]]
function string.ToTable( str )
	local tbl = {}

	for i = 1, string.len( str ) do
		tbl[i] = string.sub( str, i, i )
	end

	return tbl
end

--[[---------------------------------------------------------
	Name: string.JavascriptSafe( string )
	Desc: Takes a string and escapes it for insertion in to a JavaScript string
-----------------------------------------------------------]]
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

	str = str:gsub( ".", javascript_escape_replacements )

	-- U+2028 and U+2029 are treated as line separators in JavaScript, handle separately as they aren't single-byte
	str = str:gsub( "\226\128\168", "\\\226\128\168" )
	str = str:gsub( "\226\128\169", "\\\226\128\169" )

	return str

end

--[[---------------------------------------------------------
	Name: string.PatternSafe( string )
	Desc: Takes a string and escapes it for insertion in to a Lua pattern
-----------------------------------------------------------]]
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

function string.PatternSafe( str )
	return ( str:gsub( ".", pattern_escape_replacements ) )
end

--[[---------------------------------------------------------
	Name: explode(seperator ,string)
	Desc: Takes a string and turns it into a table
	Usage: string.explode( " ", "Seperate this string")
-----------------------------------------------------------]]
local totable = string.ToTable
local string_sub = string.sub
local string_find = string.find
local string_len = string.len
function string.Explode(separator, str, withpattern)
	if ( separator == "" ) then return totable( str ) end
	if ( withpattern == nil ) then withpattern = false end

	local ret = {}
	local current_pos = 1

	for i = 1, string_len( str ) do
		local start_pos, end_pos = string_find( str, separator, current_pos, !withpattern )
		if ( !start_pos ) then break end
		ret[ i ] = string_sub( str, current_pos, start_pos - 1 )
		current_pos = end_pos + 1
	end

	ret[ #ret + 1 ] = string_sub( str, current_pos )

	return ret
end

function string.Split( str, delimiter )
	return string.Explode( delimiter, str )
end

--[[---------------------------------------------------------
	Name: Implode( seperator, Table)
	Desc: Takes a table and turns it into a string
	Usage: string.Implode( " ", { "This", "Is", "A", "Table" } )
-----------------------------------------------------------]]
function string.Implode( seperator, Table ) return
	table.concat( Table, seperator )
end

--[[---------------------------------------------------------
	Name: GetExtensionFromFilename( path )
	Desc: Returns extension from path
	Usage: string.GetExtensionFromFilename("garrysmod/lua/modules/string.lua")
-----------------------------------------------------------]]
function string.GetExtensionFromFilename( path )
	return path:match( "%.([^%.]+)$" )
end

--[[---------------------------------------------------------
	Name: StripExtension( path )
-----------------------------------------------------------]]
function string.StripExtension( path )
	local i = path:match( ".+()%.%w+$" )
	if ( i ) then return path:sub( 1, i - 1 ) end
	return path
end

--[[---------------------------------------------------------
	Name: GetPathFromFilename( path )
	Desc: Returns path from filepath
	Usage: string.GetPathFromFilename("garrysmod/lua/modules/string.lua")
-----------------------------------------------------------]]
function string.GetPathFromFilename( path )
	return path:match( "^(.*[/\\])[^/\\]-$" ) or ""
end

--[[---------------------------------------------------------
	Name: GetFileFromFilename( path )
	Desc: Returns file with extension from path
	Usage: string.GetFileFromFilename("garrysmod/lua/modules/string.lua")
-----------------------------------------------------------]]
function string.GetFileFromFilename( path )
	if ( !path:find( "\\" ) && !path:find( "/" ) ) then return path end 
	return path:match( "[\\/]([^/\\]+)$" ) or ""
end

--[[-----------------------------------------------------------------
	Name: FormattedTime( TimeInSeconds, Format )
	Desc: Given a time in seconds, returns formatted time
			If 'Format' is not specified the function returns a table
			conatining values for hours, mins, secs, ms

	Examples: string.FormattedTime( 123.456, "%02i:%02i:%02i")	==> "02:03:45"
			  string.FormattedTime( 123.456, "%02i:%02i")		==> "02:03"
			  string.FormattedTime( 123.456, "%2i:%02i")		==> " 2:03"
			  string.FormattedTime( 123.456 )					==> { h = 0, m = 2, s = 3, ms = 45 }
-------------------------------------------------------------------]]
function string.FormattedTime( seconds, format )
	if ( not seconds ) then seconds = 0 end
	local hours = math.floor( seconds / 3600 )
	local minutes = math.floor( ( seconds / 60 ) % 60 )
	local millisecs = ( seconds - math.floor( seconds ) ) * 100
	seconds = math.floor( seconds % 60 )

	if ( format ) then
		return string.format( format, minutes, seconds, millisecs )
	else
		return { h = hours, m = minutes, s = seconds, ms = millisecs }
	end
end

--[[---------------------------------------------------------
	Name: Old time functions
-----------------------------------------------------------]]
function string.ToMinutesSecondsMilliseconds( TimeInSeconds ) return string.FormattedTime( TimeInSeconds, "%02i:%02i:%02i" ) end
function string.ToMinutesSeconds( TimeInSeconds ) return string.FormattedTime( TimeInSeconds, "%02i:%02i" ) end

local function pluralizeString( str, quantity )
	return str .. ( ( quantity ~= 1 ) and "s" or "" )
end

function string.NiceTime( seconds )

	if ( seconds == nil ) then return "a few seconds" end

	if ( seconds < 60 ) then
		local t = math.floor( seconds )
		return t .. pluralizeString( " second", t )
	end

	if ( seconds < 60 * 60 ) then
		local t = math.floor( seconds / 60 )
		return t .. pluralizeString( " minute", t )
	end

	if ( seconds < 60 * 60 * 24 ) then
		local t = math.floor( seconds / (60 * 60) )
		return t .. pluralizeString( " hour", t )
	end

	if ( seconds < 60 * 60 * 24 * 7 ) then
		local t = math.floor( seconds / ( 60 * 60 * 24 ) )
		return t .. pluralizeString( " day", t )
	end

	if ( seconds < 60 * 60 * 24 * 365 ) then
		local t = math.floor( seconds / ( 60 * 60 * 24 * 7 ) )
		return t .. pluralizeString( " week", t )
	end

	local t = math.floor( seconds / ( 60 * 60 * 24 * 365 ) )
	return t .. pluralizeString( " year", t )

end

function string.Left( str, num ) return string.sub( str, 1, num ) end
function string.Right( str, num ) return string.sub( str, -num ) end

function string.Replace( str, tofind, toreplace )
	local tbl = string.Explode( tofind, str )
	if ( tbl[ 1 ] ) then return table.concat( tbl, toreplace ) end
	return str
end

--[[---------------------------------------------------------
	Name: Trim( s )
	Desc: Removes leading and trailing spaces from a string.
			Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.Trim( s, char )
	if ( char ) then char = char:PatternSafe() else char = "%s" end
	return string.match( s, "^" .. char .. "*(.-)" .. char .. "*$" ) or s
end

--[[---------------------------------------------------------
	Name: TrimRight( s )
	Desc: Removes trailing spaces from a string.
			Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.TrimRight( s, char )
	if ( char ) then char = char:PatternSafe() else char = "%s" end
	return string.match( s, "^(.-)" .. char .. "*$" ) or s
end

--[[---------------------------------------------------------
	Name: TrimLeft( s )
	Desc: Removes leading spaces from a string.
			Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.TrimLeft( s, char )
	if ( char ) then char = char:PatternSafe() else char = "%s" end
	return string.match( s, "^" .. char .. "*(.+)$" ) or s
end

function string.NiceSize( size )

	size = tonumber( size )

	if ( size <= 0 ) then return "0" end
	if ( size < 1000 ) then return size .. " Bytes" end
	if ( size < 1000 * 1000 ) then return math.Round( size / 1000, 2 ) .. " KB" end
	if ( size < 1000 * 1000 * 1000 ) then return math.Round( size / ( 1000 * 1000 ), 2 ) .. " MB" end

	return math.Round( size / ( 1000 * 1000 * 1000 ), 2 ) .. " GB"

end

-- Note: These use Lua index numbering, not what you'd expect
-- ie they start from 1, not 0.

function string.SetChar( s, k, v )

	local start = s:sub( 0, k - 1 )
	local send = s:sub( k + 1 )

	return start .. v .. send

end

function string.GetChar( s, k )

	return s:sub( k, k )

end

local meta = getmetatable( "" )

function meta:__index( key )
	local val = string[ key ]
	if ( val ) then
		return val
	elseif ( tonumber( key ) ) then
		return self:sub( key, key )
	else
		error( "attempt to index a string value with bad key ('" .. tostring( key ) .. "' is not part of the string library)", 2 )
	end
end

function string.StartWith( String, Start )

	return string.sub( String, 1, string.len( Start ) ) == Start

end

function string.EndsWith( String, End )

	return End == "" or string.sub( String, -string.len( End ) ) == End

end

function string.FromColor( color )

	return Format( "%i %i %i %i", color.r, color.g, color.b, color.a )

end

function string.ToColor( str )

	local col = Color( 255, 255, 255, 255 )

	local r, g, b, a = str:match( "(%d+) (%d+) (%d+) (%d+)" )

	col.r = tonumber( r ) or 255
	col.g = tonumber( g ) or 255
	col.b = tonumber( b ) or 255
	col.a = tonumber( a ) or 255

	return col

end

function string.Comma( number )

	if ( isnumber( number ) ) then
		number = string.format( "%f", number )
		number = string.match( number, "^(.-)%.?0*$" ) -- Remove trailing zeros
	end

	local k

	while true do
		number, k = string.gsub( number, "^(-?%d+)(%d%d%d)", "%1,%2" )
		if ( k == 0 ) then break end
	end

	return number

end
