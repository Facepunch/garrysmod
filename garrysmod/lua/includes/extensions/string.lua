
local string = string
local math = math

--[[---------------------------------------------------------
	Name: string.ToTable( string )
-----------------------------------------------------------]]
function string.ToTable( input )
	local tbl = {}

	-- For numbers, as some addons do this..
	local str = tostring( input )

	for i = 1, #str do
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
	["\'"] = "\\\'",
	["`"] = "\\`",
	["$"] = "\\$",
	["{"] = "\\{",
	["}"] = "\\}"
}

function string.JavascriptSafe( str )

	str = string.gsub( str, ".", javascript_escape_replacements )

	-- U+2028 and U+2029 are treated as line separators in JavaScript, handle separately as they aren't single-byte
	str = string.gsub( str, "\226\128\168", "\\\226\128\168" )
	str = string.gsub( str, "\226\128\169", "\\\226\128\169" )

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
	return ( string.gsub( str, ".", pattern_escape_replacements ) )
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
function string.Explode( separator, str, withpattern )
	if ( separator == "" ) then return totable( str ) end
	if ( withpattern == nil ) then withpattern = false end

	local ret = {}
	local current_pos = 1

	for i = 1, string_len( str ) do
		local start_pos, end_pos = string_find( str, separator, current_pos, not withpattern )
		if ( not start_pos ) then break end
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
	for i = #path, 1, -1 do
		local c = string.sub( path, i, i )
		if ( c == "/" or c == "\\" ) then return nil end
		if ( c == "." ) then return string.sub( path, i + 1 ) end
	end

	return nil
end

--[[---------------------------------------------------------
	Name: StripExtension( path )
-----------------------------------------------------------]]
function string.StripExtension( path )
	for i = #path, 1, -1 do
		local c = string.sub( path, i, i )
		if ( c == "/" or c == "\\" ) then return path end
		if ( c == "." ) then return string.sub( path, 1, i - 1 ) end
	end

	return path
end

--[[---------------------------------------------------------
	Name: GetPathFromFilename( path )
	Desc: Returns path from filepath
	Usage: string.GetPathFromFilename("garrysmod/lua/modules/string.lua")
-----------------------------------------------------------]]
function string.GetPathFromFilename( path )
	for i = #path, 1, -1 do
		local c = string.sub( path, i, i )
		if ( c == "/" or c == "\\" ) then return string.sub( path, 1, i ) end
	end

	return ""
end

--[[---------------------------------------------------------
	Name: GetFileFromFilename( path )
	Desc: Returns file with extension from path
	Usage: string.GetFileFromFilename("garrysmod/lua/modules/string.lua")
-----------------------------------------------------------]]
function string.GetFileFromFilename( path )
	for i = #path, 1, -1 do
		local c = string.sub( path, i, i )
		if ( c == "/" or c == "\\" ) then return string.sub( path, i + 1 ) end
	end

	return path
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
	if ( char ) then char = string.PatternSafe( char ) else char = "%s" end
	return string.match( s, "^" .. char .. "*(.-)" .. char .. "*$" ) or s
end

--[[---------------------------------------------------------
	Name: TrimRight( s )
	Desc: Removes trailing spaces from a string.
			Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.TrimRight( s, char )
	if ( char ) then char = string.PatternSafe( char ) else char = "%s" end
	return string.match( s, "^(.-)" .. char .. "*$" ) or s
end

--[[---------------------------------------------------------
	Name: TrimLeft( s )
	Desc: Removes leading spaces from a string.
			Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.TrimLeft( s, char )
	if ( char ) then char = string.PatternSafe( char ) else char = "%s" end
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

	return string.sub( s, 0, k - 1 ) .. v .. string.sub( s, k + 1 )

end

function string.GetChar( s, k )

	return string.sub( s, k, k )

end

local meta = getmetatable( "" )

function meta:__index( key )

	local val = string[ key ]
	if ( val ~= nil ) then
		return val
	elseif ( tonumber( key ) ) then
		return string.sub( self, key, key )
	end

end

function string.StartsWith( str, start )

	return string.sub( str, 1, string.len( start ) ) == start

end
string.StartWith = string.StartsWith

function string.EndsWith( str, endStr )

	return endStr == "" or string.sub( str, -string.len( endStr ) ) == endStr

end

function string.FromColor( color )

	return Format( "%i %i %i %i", color.r, color.g, color.b, color.a )

end

function string.ToColor( str )

	local r, g, b, a = string.match( str, "(%d+) (%d+) (%d+) (%d+)" )
	return Color( tonumber( r ) or 255, tonumber( g ) or 255, tonumber( b ) or 255, tonumber( a ) or 255 )

end

function string.Comma( number, str )

	if ( str ~= nil and not isstring( str ) ) then
		error( "bad argument #2 to 'string.Comma' (string expected, got " .. type( str ) .. ")", 2 )
	elseif ( str ~= nil and string.match( str, "%d" ) ~= nil ) then
		error( "bad argument #2 to 'string.Comma' (non-numerical values expected, got " .. str .. ")", 2 )
	end

	local replace = str == nil and "%1,%2" or "%1" .. str .. "%2"

	if ( isnumber( number ) ) then
		number = string.format( "%f", number )
		number = string.match( number, "^(.-)%.?0*$" ) -- Remove trailing zeros
	end

	local index = -1
	while index ~= 0 do number, index = string.gsub( number, "^(-?%d+)(%d%d%d)", replace ) end

	return number

end

function string.Interpolate( str, lookuptable )

	return ( string.gsub( str, "{([_%a][_%w]*)}", lookuptable ) )

end

function string.CardinalToOrdinal( cardinal )

	local basedigit = cardinal % 10

	if ( basedigit == 1 ) then
		if ( cardinal % 100 == 11 ) then
			return cardinal .. "th"
		end

		return cardinal .. "st"
	elseif ( basedigit == 2 ) then
		if ( cardinal % 100 == 12 ) then
			return cardinal .. "th"
		end

		return cardinal .. "nd"
	elseif ( basedigit == 3 ) then
		if ( cardinal % 100 == 13 ) then
			return cardinal .. "th"
		end

		return cardinal .. "rd"
	end

	return cardinal .. "th"

end

function string.NiceName( name )

	name = name:Replace( "_", " " )

	-- Try to split text into words, where words would start with single uppercase character
	local newParts = {}
	for id, str in ipairs( string.Explode( " ", name ) ) do
		local wordStart = 1
		for i = 2, str:len() do
			local c = str[ i ]
			if ( c:upper() == c ) then
				local toAdd = str:sub( wordStart, i - 1 )
				if ( toAdd:upper() == toAdd ) then continue end
				table.insert( newParts, toAdd )
				wordStart = i
			end

		end

		table.insert( newParts, str:sub( wordStart, str:len() ) )
	end

	-- Capitalize
	--[[
	for i, word in ipairs( newParts ) do
		if ( #word == 1 ) then
			newParts[i] = string.upper( word )
		else
			newParts[i] = string.upper( string.sub( word, 1, 1 ) ) .. string.sub( word, 2 )
		end
	end

	return table.concat( newParts, " " )]]

	local ret = table.concat( newParts, " " )
	ret = string.upper( string.sub( ret, 1, 1 ) ) .. string.sub( ret, 2 )
	return ret

end
