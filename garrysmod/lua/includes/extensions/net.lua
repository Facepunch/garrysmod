
--
-- Sizes for ints to send
--
local TYPE_SIZE = 4
local UINTV_SIZE = 5

local Char2HexaLookup, Hexa2CharLookup = {}, {}

--
-- Generate Hexa Lookups
-- Hexa is a 6-bit English character encoding
--
do
    local HexaRanges = {
        { "a", "z" },
        { "A", "Z" },
        { "0", "9" },
		{ "_", "_" }
    }
    
    local offset = 1
    
    for k, v in ipairs( HexaRanges ) do
    
        local sChar, eChar = v[ 1 ]:byte( ), v[ 2 ]:byte( )
        
        for char = sChar, eChar do
        
            local hexa = char - sChar + offset
            
            Char2HexaLookup[ char ] = hexa
            Hexa2CharLookup[ hexa ] = string.char( char )
        
        end
        
        offset = offset + 1 + eChar - sChar
    
    end
	
end

--
-- Converts an ASCII character in to a Hexa Character
--
local function CharToHexa( c )

    return Char2HexaLookup[ c ]

end

--
-- Converts a Hexa character in to an ASCII character
--
local function HexaToChar( h )

    return Hexa2CharLookup[ h ]
    
end

--
-- Returns true if the string can be represented in 7-Bit ASCII
-- Null bytes are not allowed as they are used for termination
--
local function Is7BitString( str )

    return str:find( "[\x80-\xFF%z]" ) == nil
    
end

--
-- Returns true if the string can be represented in Hexa
--
local function IsHexaString( str )

    return str:find( "[^a-zA-Z0-9_]" ) == nil
    
end

--
-- Returns true if the argument is NaN ( can also be interpreted as 0/0 )
--
local function IsNaN( x )
    return x ~= x
end

--
-- An imaginary NaN table for caching in writing.table
--
local NaN = {}

--
-- This exists because you can't make a table index NaN
-- We need to do this so we can cache it in our references table
--
local function IndexSafe( x )
    if( IsNaN( x ) ) then return NaN end
    return x
end

local reading, writing

--
-- Gets the type of way we are going to send the data
-- Not all of these exist in reality
-- We are only going to add 16 types ( 0-15 ) since that's
-- the max we can fit into 4 bits
--
local function SendType( x )

    local t = type( x )
	
    if( IsColor( x ) ) then
        return "Color"
    end
	
    if( TypeID( x ) == TYPE_ENTITY ) then
        return "Entity"
    end
	
    if( x == 1 or x == 0 ) then return "bit" end
	
	--
	-- check if a number has no decimal places
	-- and is able to be sent in an int
	--
	
    if( t == "number" and x % 1 == 0 and x >= -0x7FFFFFFF and x <= 0xFFFFFFFF ) then
		
		-- test if we can fit it in a single byte with uintv
		if( x < bit.lshift( 1, UINTV_SIZE ) and x >= 0 ) then
			return "uintv"
		end
		
        if( x <= 0x7FFF and x >= -0x7FFF ) then
            return "int16"
        end
		
        if( x <= 0x7FFFFFFF and x >= -0x7FFFFFFF ) then
            return "int32"
        end
		
        return "uintv"
		
    end
	
    if( t == "string" and IsHexaString( x ) ) then 
		return "hexastring"
	end
	
    if( t == "string" and Is7BitString( x ) ) then 
		return "string7"
	end
	
    return t

end

local StringToTypeLookup, TypeToStringLookup = { }, { }

do
	StringToTypeLookup = {
		string       = 0,
		number       = 1,
		table        = 2,
		boolean      = 3,
		endtable     = 4,
		Vector       = 5,
		Angle        = 6,
		Color        = 7,
		Entity       = 8,
		bit          = 9,
		hexastring   = 10,
		int16        = 11,
		int32        = 12,
		reference    = 13,
		uintv        = 14,
		string7      = 15
	}
	
	for k,v in pairs( StringToTypeLookup ) do 
		TypeToStringLookup[ v ] = k
	end
	
end

local function TypeToString( n )
	return TypeToStringLookup[ n ]
end

local function StringToType( s )
	return StringToTypeLookup[ s ]
end

local ReferenceType = StringToType( "reference" )
local TableType     = StringToType( "table" )

reading = {
	-- 
	-- Normal gmod types we can't really improve
	--
    Color       = net.ReadColor,
    boolean     = net.ReadBool,
    number      = net.ReadDouble,
    bit         = net.ReadBit,
	
	--
	-- Entity
	-- CClientEntityList::GetMaxEntityIndex( ) returns 8096
	-- valve developer wiki says 1/2 are static, non networkable
	-- therefore we are going to use 12 bits to send the index
	--
    Entity = function( )
	
        if( net.ReadBool( ) ) then -- non null
            return Entity( net.ReadUInt( 13 ) )
        end
        
        return NULL
		
    end,
	
    -- 
	-- A reference index in our already-sent-table
	-- 
    reference = function( rs )
        return rs[ reading.uintv( ) ]
    end,

	--
	-- Variable length unsigned integers
	--
    uintv = function( )
        local i = 0
        local ret = 0
        while true do
            local t = net.ReadUInt( UINTV_SIZE )
            ret = ret + bit.lshift( t, i * UINTV_SIZE )
            if( not net.ReadBool( ) ) then break end
            i = i + 1
        end
        return ret
    end,
	
	--
	-- 7 bit encoded strings
	-- NULL terminated
	--
    string7 = function( )
        if( net.ReadBool( ) ) then
            return util.Decompress( net.ReadData( reading.uintv( ) ) )
        else
            local ret = ""
			
            while true do
			
                local chr = net.ReadUInt( 7 )
                if( chr == 0 ) then return ret end
                ret = ret..string.char( chr )
				
            end
        end
    end,
	
	--
	-- Our 6-bit encoded strings
	-- NULL terminated
	--
    hexastring = function( )
        if( net.ReadBool( ) ) then
            return util.Decompress( net.ReadData( reading.uintv( ) ) )
        else
		
            local ret = ""
			
            while true do 
                local chr = net.ReadUInt( 6 )
                if( chr == 0 ) then return ret end -- terminator
                ret = ret..Hexa2CharLookup[ chr ]
            end
			
        end
    end,
	
	--
	-- 16-bit signed integer
	--
    int16 = function( )
        return net.ReadInt( 16 )
    end,
	
	-- 
	-- 32-bit signed integer
	--
    int32 = function( )
        return net.ReadInt( 32 )
    end,
	
	--
	-- Lua string
	-- not null terminated
	--
    string = function( )
        if( net.ReadBool( ) ) then -- compressed or not
            return util.Decompress( net.ReadData( reading.uintv( ) ) )
        else
            return net.ReadData( reading.uintv( ) )
        end
    end,
	
	--
	-- Vector, we are using our own wrapper since 
	-- default net.WriteVector loses lots of precision
	--
	
    Vector = function( )
	
        return Vector( net.ReadFloat( ), net.ReadFloat( ), net.ReadFloat( ) )
		
    end,
	
	
	--
	-- Angle, we are using our own wrapper since 
	-- default net.WriteAngle loses lots of precision
	--
    Angle = function( )
        return Angle( net.ReadFloat( ), net.ReadFloat( ), net.ReadFloat( ) )
    end,
	
	--
	-- our readtable
	-- directly used as net.ReadTable
	--
    table = function( references )
        local ret = { }
		
		-- our default reference list
        local references = references or { }
		
        references[ #references + 1 ] = ret
        local num = #references + 1
		
        if( net.ReadBool( ) ) then 
			-- we have at least one index starting from 1
		
            local max = reading.uintv( )
			
            for i = 1, max do
			
                local type = net.ReadUInt( TYPE_SIZE )
                local v = reading[ TypeToString( type ) ]( references )
				
                if( type ~= ReferenceType ) then
				
                    if( type == TableType ) then
                        num = #references + 1
                    else
                        references[ num ] = v
                        num = num + 1
                    end
					
                end
				
                ret[ i ] = v
				
            end
        end
		
		--
		-- Make sure we don't infinite loop
		--
        for i = 1, 8096 do
		
            local type = net.ReadUInt( TYPE_SIZE )
			
			--
			-- Check if it's a real value
			--
            if( TypeToString( type ) == "endtable" ) then break end
            local k = reading[ TypeToString( type ) ]( references ) 
			
            if( type ~= ReferenceType ) then
			
                if( type == TableType ) then
                    num = #references + 1
                else
                    references[ num ] = k
                    num = num + 1
                end
				
            end
			
            type = net.ReadUInt( TYPE_SIZE )
            local v = reading[ TypeToString( type )  ]( references )
			
            if( type ~= ReferenceType ) then
			
                if( type == TableType ) then
                    num = #references + 1
                else
                    references[ num ] = v
                    num = num + 1
                end
				
            end
			
            ret[ k ] = v
			
        end
        return ret
    end
}


writing = {
    bit = net.WriteBit,
    Color = net.WriteColor,
    boolean = net.WriteBool,
    number = net.WriteDouble,
	
	--
	-- Variable length unsigned integers
	--
    uintv = function( n )
        while( n > 0 ) do
            net.WriteUInt( n, UINTV_SIZE )
            n = bit.rshift( n, UINTV_SIZE )
            net.WriteBool( n > 0 )
        end
    end,
	
	--
	-- 7 bit encoded strings
	-- NULL terminated
	--
    string7 = function( s )
        local compressed = util.Compress( s )
        local c_len = compressed == nil and 0xFFFFFFFF or #compressed
        if( c_len < #s / 8 * 7 ) then
            net.WriteBool( true )
            writing.uintv( c_len )
            net.WriteData( compressed, c_len )
        else
            net.WriteBool( false )
            for i = 1, s:len( ) do
                net.WriteUInt( s[ i ]:byte( ), 7 )
            end
            net.WriteUInt( 0, 7 )
        end
    end,
    
	--
	-- Our 6-bit encoded strings
	-- NULL terminated
	--
    hexastring = function( s )
        local compressed = util.Compress( s )
        local c_len = compressed == nil and 0xFFFFFFFF or #compressed
        if( c_len < #s / 8 * 6 ) then
            net.WriteBool( true )
            writing.uintv( c_len )
            net.WriteData( compressed, c_len )
        else
            net.WriteBool( false )
            for i = 1, s:len( ) do
                net.WriteUInt( Char2HexaLookup[ s[ i ]:byte( ) ], 6 )
            end
            net.WriteUInt( 0, 6 )
        end
    end,

	--
	-- 16-bit signed integer
	--
    int16 = function( w )
        net.WriteInt( w, 16 )
    end,
	
	--
	-- 32-bit signed integer
	--
    int32 = function( d )
        net.WriteInt( d, 32 )
    end,
	
	--
	-- Entity
	--
    Entity = function( e )
	
        if( (IsValid( e ) or game.GetWorld( ) == e) and e:EntIndex( ) < 4096 ) then
		
            net.WriteBool( true )
            net.WriteUInt( e:EntIndex( ), 13 )
			
            return
			
        end
		
        net.WriteBool( false ) -- NULL
		
    end,
	
	--
	-- Vector, we are using our own wrapper since 
	-- default net.WriteVector loses lots of precision
	--
    Vector = function( v )
	
        net.WriteFloat( v.x )
        net.WriteFloat( v.y )
        net.WriteFloat( v.z )
		
    end,
	
	--
	-- Angle, we are using our own wrapper since 
	-- default net.WriteAngle loses lots of precision
	--
    Angle = function( a )
        net.WriteFloat( a.p )
        net.WriteFloat( a.y )
        net.WriteFloat( a.r )
    end,
	
	--
	-- Lua string
	-- not null terminated
	--
    string = function( x )
	
        local compressed = util.Compress( x )
		
		-- when compressed returns nil, we need to make sure we use lua string
        local c_len = compressed == nil and 0xFFFFFFFF or #compressed
        local x_len = #x
		
        if( c_len < x_len ) then
		
            net.WriteBool( true )
            writing.uintv( c_len )
            net.WriteData( compressed, c_len )
			
        else -- we are doing this for zero embedded strings
		
            net.WriteBool( false )
            writing.uintv( x_len )
            net.WriteData( x, x_len )
			
        end
    end,
	
	--
	-- our writetable
	-- directly used as net.WriteTable
	--
	
    table = function( tbl, indices, num )
	
		-- our already-done indices
        local done = {}
		
        num = num or 1
		
		-- our already-sent data
        local indices = indices or { }
		
        indices[ tbl ] = num
		
        num = num + 1
        local t_len = #tbl
		
        if( t_len ~= 0 ) then
			-- we have indices that start from 1 to x
			
            net.WriteBool( true )
            writing.uintv( t_len )
			
            for i = 1, t_len do
			
                done[ i ] = true
                local v = tbl[ i ]
				
                if( indices[ v ] ) then
				
                    net.WriteUInt( ReferenceType, TYPE_SIZE )
                    writing.uintv( indices[ v ] )
					
                else
				
                    local t = SendType( v )
					
                    net.WriteUInt( StringToType( t ), TYPE_SIZE )
                    local _num = writing[ t ]( v, rs, num )
					
                    if( t ~= "table" ) then
					
                        indices[ IndexSafe( v ) ] = num
                        num = num + 1
						
                    else -- dont store the table in our references since writetable does it for us
                        num = _num
                    end
					
                end
				
            end
        else
            net.WriteBool( false )
        end
		
        for k,v in next, tbl, nil do
		
            if( done[ k ] ) then continue end
			
            if( indices[ k ] ) then
			
                net.WriteUInt( ReferenceType, TYPE_SIZE )
                writing.uintv( indices[ k ] )
				
            else
			
                local t = SendType( k )
				
                net.WriteUInt( StringToType( t ), TYPE_SIZE )
                local _num = writing[ t ]( k, rs, num )
				
                if( t ~= "table" ) then
                    indices[ IndexSafe( k ) ] = num
                    num = num + 1
                else -- dont store our reference since writetable does that for us
                    num = _num
                end
				
            end
            
            if( indices[ v ] ) then
                net.WriteUInt( ReferenceType, TYPE_SIZE )
                writing.uintv( indices[ v ] )
            else
			
                local t = SendType( v )
				
                net.WriteUInt( StringToType ( t ), TYPE_SIZE )
                local _num = writing[ t ]( v, rs, num )
				
                if( t ~= "table" ) then
                    indices[ IndexSafe( v ) ] = num
                    num = num + 1
                else
                    num = _num
                end
				
            end
        end
		
        net.WriteUInt( StringToType( "endtable" ), TYPE_SIZE )
		
        return num
    end
}

net.WriteTable = writing.table
net.ReadTable = reading.table
