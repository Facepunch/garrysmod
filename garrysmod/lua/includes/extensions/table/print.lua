local white = Color( 230, 230, 230 )
local red = Color( 212, 53, 109 )
local yellow = Color( 212, 202, 107 )
local purple = Color( 157, 110, 212 )
local cyan = Color( 102, 217, 239 )
local dark = Color( 105, 105, 105 )

local IsValidKeyName

do
	local reserved = { [ "and" ] = true, [ "break" ] = true, [ "do" ] = true, [ "else" ] = true, [ "elseif" ] = true, [ "end" ] = true, [ "false" ] = true, [ "for" ] = true, [ "function" ] = true, [ "if" ] = true, [ "in" ] = true, [ "local" ] = true, [ "nil" ] = true, [ "not" ] = true, [ "or" ] = true, [ "repeat" ] = true, [ "return" ] = true, [ "then" ] = true, [ "true" ] = true, [ "until" ] = true, [ "while" ] = true}

	function IsValidKeyName( key )
		-- name cant be reserved word
		if reserved[ key ] then return false end

		-- it should start with letters or underscore, It should continue with alphanumerics
		if ( key:match( "^[%a_][%w_]*$" ) == nil ) then return false end

		return true
	end
end

local MsgC = MsgC

if SERVER and system.IsLinux() then
	function MsgC( ... ) -- polyfill to make MsgC works in linux srcds
		for _, v in ipairs( { ... } ) do
			if ( IsColor( v ) ) then
				Msg( string.format( "\27[38;2;%d;%d;%dm", v.r, v.g, v.b ) )
			else
				Msg( v )
			end
		end

		Msg("\27[0m")
	end
end

local function Round( num )
	return math.Round( num, 3 )
end

local gmodObjects = {}

function gmodObjects.Player( v, compact )
	MsgC( cyan, "Player", white, compact and "(" or "( ", purple, v:UserID(), white, compact and ")" or " )" )
end

function gmodObjects.Entity( v, compact )
	MsgC( cyan, "Entity", white, compact and "(" or "( ", purple, v:EntIndex(), white, compact and ")" or " )" )
end

local gmodAxisObjects = { Vector = true, Angle = true }

local function MsgValue( v, compact, noPretty )
	if isstring( v ) then
		if v:find( "\n", 1, true ) then
			MsgC( yellow, "[[", v, "]]" )
		else
			MsgC( yellow, "\"", v, "\"" )
		end
	elseif IsColor( v ) then
		local separator = noPretty and "," or ", "

		MsgC(
			cyan, "Color", white, compact and "(" or "( ",
			purple, v.r, red, separator,
			purple, v.g, red, separator,
			purple, v.b
		)

		if v.a ~= 255 then
			MsgC(
				red, separator,
				purple, v.a
			)
		end

		MsgC( white, compact and ")" or " )" )
	elseif gmodObjects[ type( v ) ] then
		gmodObjects[ type( v ) ]( v, compact )
	elseif gmodAxisObjects[ type( v ) ] then
		local separator = noPretty and "," or ", "

		MsgC(
			cyan, type( v ), white, compact and "(" or "( ",
			purple, Round( v[ 1 ] )
		)

		if v[ 2 ] ~= 0 then
			MsgC( red, separator, purple, Round( v[ 2 ] ) )
		end

		if v[ 3 ] ~= 0 then
			MsgC( red, separator, purple, Round( v[ 3 ] ) )
		end

		MsgC( white, compact and ")" or " )" )
	elseif isfunction( v ) then
		local info = debug.getinfo( v )
		local defined = info.linedefined == info.lastlinedefined and info.linedefined or info.linedefined .. "-" .. info.lastlinedefined

		MsgC( purple, v, dark, " --[[ ", info.short_src, ":", defined, " ]]" )
	else
		MsgC( purple, v )
	end
end

local function MsgKey( k, indent, compact, noPretty )
	if ( isstring( k ) == false ) then
		MsgC( indent, red, compact and "[" or "[ " )
		MsgValue( k, compact, noPretty )

		if noPretty then
			MsgC( red, compact and "]=" or " ]=" )
		else
			MsgC( red, compact and "] = " or " ] = " )
		end
	elseif ( IsValidKeyName( k ) ) then
		MsgC( indent, white, k, red, noPretty and "=" or " = " )
	elseif noPretty then
		MsgC( indent, red, "[", yellow, "\"", k, yellow, "\"", red, compact and "]=" or " ]=" )
	else
		MsgC( indent, red, "[ ", yellow, "\"", k, yellow, "\"", red, compact and "] = " or " ] = " )
	end
end

local function tablePrint( tbl, compact, noPretty, _lvl, _done )
	local len = 0
	for _ in pairs( tbl ) do
		len = len + 1
	end

	if ( len == 0 ) then
		return MsgC( red, noPretty and "{}" or "{}\n" )
	end

	local isSeq = len == #tbl
	local not_isSeq = not isSeq

	if ( not_isSeq ) then
		local new = {}
		local index = 0

		for k, v in pairs( tbl ) do
			index = index + 1
			new[ index ] = { k = k, v = v }
		end

		table.sort( new, function( a, b )
			if ( isnumber( a.k ) and isnumber( b.k ) ) then
				return a.k < b.k
			end

			return tostring( a.k ) < tostring( b.k )
		end )

		tbl = new
	end

	local iter = isSeq and ipairs or pairs
	local indent = noPretty and "" or string.rep( "\t", _lvl )
	local table_indent = noPretty and "" or string.rep( "\t", _lvl - 1 )
	local i = 1

	MsgC( red, noPretty and "{" or "{\n" )

	for k, v in iter( tbl ) do
		if ( isSeq ) then
			Msg( indent )
		else
			k, v = v.k, v.v
			MsgKey( k, indent, compact, noPretty )
		end

		if ( istable( v ) and IsColor( v ) == false ) then
			if _done[ v ] then
				MsgC( purple, tostring( v ) )
			else
				_done[ v ] = true
				tablePrint( v, compact, noPretty, _lvl + 1, _done )
			end
		else
			MsgValue( v, compact, noPretty )
		end

		if i == len then
			if noPretty == false then Msg( "\n" ) end
		else
			MsgC( red, noPretty and "," or ",\n" )
		end

		i = i + 1
	end

	MsgC( table_indent, red, "}" )

	if ( _lvl == 1 and noPretty == false ) then Msg( "\n" ) end
end

function table.Print( tbl, compact, noPretty )
	tablePrint( tbl, compact == true, noPretty == true, 1, { [ tbl ] = true } )
end
