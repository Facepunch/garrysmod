--[[---------------------------------------------------------
   Name: string.ToTable( string )
-----------------------------------------------------------]]
function string.ToTable ( str )
	local tbl = {}
	
	for i = 1, string.len( str ) do
		tbl[i] = string.sub( str, i, i )
	end
	
	return tbl
end


function string.JavascriptSafe( str )

	str = str:Replace( "\\", "\\\\" )
	str = str:Replace( "\"", "\\\"" )
	str = str:Replace( "\n", "\\n" )
	str = str:Replace( "\r", "\\r" )
	
	return str

end
--[[---------------------------------------------------------
   Name: explode(seperator ,string)
   Desc: Takes a string and turns it into a table
   Usage: string.explode( " ", "Seperate this string")
-----------------------------------------------------------]]
local totable = string.ToTable
local string_sub = string.sub
local string_gsub = string.gsub
local string_gmatch = string.gmatch
function string.Explode(separator, str, withpattern)
	if (separator == "") then return totable( str ) end
	 
	local ret = {}
	local index,lastPosition = 1,1
	 
	-- Escape all magic characters in separator
	if not withpattern then separator = string_gsub( separator, "[%-%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1" ) end
	 
	-- Find the parts
	for startPosition,endPosition in string_gmatch( str, "()" .. separator.."()" ) do
		ret[index] = string_sub( str, lastPosition, startPosition-1)
		index = index + 1
		 
		-- Keep track of the position
		lastPosition = endPosition
	end
	 
	-- Add last part by using the position we stored
	ret[index] = string_sub( str, lastPosition)
	return ret
end

function string.Split( str, delimiter )
	return string.Explode( delimiter, str )
end

--[[---------------------------------------------------------
   Name: Implode(seperator ,Table)
   Desc: Takes a table and turns it into a string
   Usage: string.Implode( " ", {"This", "Is", "A", "Table"})
-----------------------------------------------------------]]
function string.Implode(seperator,Table) return 
	table.concat(Table,seperator) 
end

--[[---------------------------------------------------------
   Name: GetExtensionFromFilename(path)
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
	if ( i ) then return path:sub(1, i-1) end
	return path

end

--[[---------------------------------------------------------
   Name: GetPathFromFilename(path)
   Desc: Returns path from filepath
   Usage: string.GetPathFromFilename("garrysmod/lua/modules/string.lua")
-----------------------------------------------------------]]
function string.GetPathFromFilename(path)
	return path:match( "^(.*[/\\])[^/\\]-$" ) or ""
end
--[[---------------------------------------------------------
   Name: GetFileFromFilename(path)
   Desc: Returns file with extension from path
   Usage: string.GetFileFromFilename("garrysmod/lua/modules/string.lua")
-----------------------------------------------------------]]
function string.GetFileFromFilename(path)
	return path:match( "[\\/]([^/\\]+)$" ) or ""
end

--[[-----------------------------------------------------------------
   Name: FormattedTime( TimeInSeconds, Format )
   Desc: Given a time in seconds, returns formatted time
		 If 'Format' is not specified the function returns a table 
		 conatining values for hours, mins, secs, ms

   Examples: string.FormattedTime( 123.456, "%02i:%02i:%02i")  ==> "02:03:45"
			 string.FormattedTime( 123.456, "%02i:%02i")       ==> "02:03"
			 string.FormattedTime( 123.456, "%2i:%02i")        ==> " 2:03"
			 string.FormattedTime( 123.456 )        		==> {h = 0, m = 2, s = 3, ms = 45}
-------------------------------------------------------------------]]

function string.FormattedTime( seconds, Format )
	if not seconds then seconds = 0 end
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds / 60) % 60)
	local millisecs = ( seconds - math.floor( seconds ) ) * 100
	seconds = math.floor(seconds % 60)
	
	if Format then
		return string.format( Format, minutes, seconds, millisecs )
	else
		return { h=hours, m=minutes, s=seconds, ms=millisecs }
	end
end

--[[---------------------------------------------------------
   Name: Old time functions
-----------------------------------------------------------]]

function string.ToMinutesSecondsMilliseconds( TimeInSeconds )	return string.FormattedTime( TimeInSeconds, "%02i:%02i:%02i")	end
function string.ToMinutesSeconds( TimeInSeconds )		return string.FormattedTime( TimeInSeconds, "%02i:%02i")	end

function string.NiceTime( seconds )

	if ( seconds == nil ) then return "a few seconds" end

	if ( seconds < 60 ) then
		return math.floor( seconds ) .. " seconds";
	end

	if ( seconds < 60 * 60 ) then
		return math.floor( seconds / 60 ) .. " minutes";
	end

	if ( seconds < 60 * 60 * 24 ) then
		return math.floor( seconds / (60 * 60) ) .. " hours";
	end

	if ( seconds < 60 * 60 * 24 ) then
		return math.floor( seconds / (60 * 60 * 24) ) .. " days";
	end

	return "ages"

end



function string.Left(str, num)
	return string.sub(str, 1, num)
end

function string.Right(str, num)
	return string.sub(str, -num)
end


function string.Replace( str, tofind, toreplace )
	tofind = tofind:gsub( "[%-%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1" )
	toreplace = toreplace:gsub( "%%", "%%%1" )
	return ( str:gsub( tofind, toreplace ) )
end

--[[---------------------------------------------------------
   Name: Trim(s)
   Desc: Removes leading and trailing spaces from a string.
		 Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.Trim( s, char )
	if ( !char ) then char = "%s" end
	return ( s:gsub( "^" .. char .. "*(.-)" .. char .. "*$", "%1" ) )
end

--[[---------------------------------------------------------
   Name: TrimRight(s)
   Desc: Removes trailing spaces from a string.
		 Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.TrimRight( s, char )
	if ( !char ) then char = " " end
	
	if ( string.sub( s, -1 ) == char ) then
		s = string.sub( s, 0, -2 )
		s = string.TrimRight( s, char )
	end
	
	return s
end

--[[---------------------------------------------------------
   Name: TrimLeft(s)
   Desc: Removes leading spaces from a string.
		 Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.TrimLeft( s, char )
	if ( !char ) then char = " " end
	
	if ( string.sub( s, 1 ) == char ) then
		s = string.sub( s, 1 )
		s = string.TrimLeft( s, char )
	end
	
	return s
end

function string.NiceSize( size )
	
	size = tonumber( size )

	if ( size <= 0 ) then return "0" end
	if ( size < 1024 ) then return size .. " Bytes" end
	if ( size < 1024 * 1024 ) then return math.Round( size / 1024, 2 ) .. " KB" end
	if ( size < 1024 * 1024 * 1024 ) then return math.Round( size / (1024*1024), 2 ) .. " MB" end
	
	return math.Round( size / (1024*1024*1024), 2 ) .. " GB"

end

-- Note: These use Lua index numbering, not what you'd expect
-- ie they start from 1, not 0.

function string.SetChar( s, k, v )

	local start = s:sub( 0, k-1 )
	local send = s:sub( k+1 )
	
	return start .. v .. send

end

function string.GetChar( s, k )

	return s:sub( k, k )

end

local meta = getmetatable( "" )

function meta:__index( key )
	if ( string[key] ) then
		return string[key]
	elseif ( tonumber( key ) ) then
		return self:sub( key, key )
	else
		error( "bad key to string index (number expected, got " .. type( key ) .. ")", 2 )
	end
end

function string.StartWith( String, Start )

   return string.sub( String, 1, string.len (Start ) ) == Start

end

function string.EndsWith( String, End )

   return End == '' or string.sub( String, -string.len( End ) ) == End

end

function string.FromColor( color )

   return Format( "%i %i %i %i", color.r, color.g, color.b, color.a );

end

function string.ToColor( str )

	local col = Color( 255, 255, 255, 255 )

	col.r, col.g, col.b, col.a = str:match("(%d+) (%d+) (%d+) (%d+)")

	col.r = tonumber( col.r )
	col.g = tonumber( col.g )
	col.b = tonumber( col.b )
	col.a = tonumber( col.a )

	return col

end

function string.Comma( number )

	local number = tostring( number )

	while true do  

		number, k = string.gsub( number, "^(-?%d+)(%d%d%d)", '%1,%2')
		if ( k == 0 ) then break end
	end

	return number

end
