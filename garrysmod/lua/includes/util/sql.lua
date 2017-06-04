
-- Return if there's nothing to add on to
if ( !sql ) then return end


--[[----------------------------------------------------------
    Attempts to make a string safe to put into the database
------------------------------------------------------------]]
function sql.SQLStr( str_in, bNoQuotes )
	
	local str = tostring( str_in )
	
	str = str:gsub( "'", "''" )
	
	local null_chr = string.find( str, "\0" )
	if null_chr then
		str = string.sub( str, 1, null_chr - 1 )
	end
	
	-- If no quotes return string, otherwise add quotes
	return bNoQuotes and str or "'" .. str .. "'"
end

SQLStr = sql.SQLStr


--[[---------------------------------------------------------
    Returns true if the table exists. False if it doesn't
-----------------------------------------------------------]]
function sql.TableExists( name )
	
	-- Query table name. If found return true, otherwise return false.
	return sql.Query( "select name FROM sqlite_master WHERE name="..SQLStr( name ).." AND type='table'" ) and true or false

end

--[[---------------------------------------------------------
    Query and get a single row
	eg sql.QueryRow( "SELECT * from ratings LIMIT 1" )
-----------------------------------------------------------]]
function sql.QueryRow( query, row )

	row = row or 1

	local r = sql.Query( query );
	
	-- Return row queried or nil on failure
	return r and r[ row ] or nil

end

--[[---------------------------------------------------------
    Query and get a single value
	eg sql.QueryValue( "SELECT count(*) from ratings" )
-----------------------------------------------------------]]
function sql.QueryValue( query )

	local r = sql.QueryRow( query );
	
	if ( r ) then 
	
		-- Is this really the best way to get the first/only value in a table
		for k, v in pairs( r ) do return v end
		
	end
	
	return r

end

--[[---------------------------------------------------------
    Call before lots of inserts (100+), will hold off writing to disk
	until Commit is called, which will increase performance (a lot)
-----------------------------------------------------------]]
function sql.Begin()
	sql.Query( "BEGIN;" )
end


--[[---------------------------------------------------------
    See Above
-----------------------------------------------------------]]
function sql.Commit()
	sql.Query( "COMMIT;" )
end


--[[----------------------------------------------------------
	m_strError is set by the dll
------------------------------------------------------------]]
function sql.LastError()
	return sql.m_strError
end
