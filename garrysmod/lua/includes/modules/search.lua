
module( "search", package.seeall )

local Providers = {}

function AddProvider( func, id )

	local prov = {
		func = func,
	}

	if ( id ) then
		Providers[ id ] = prov
	else
		table.insert( Providers, prov )
	end

end

function GetResults( str )

	str = str:lower()
	if ( str == "" ) then return {} end

	local results = {}

	for k, v in pairs( Providers ) do

		local tbl = v.func( str )
		for _, e in pairs( tbl ) do
			table.insert( results, e )
		end

		if ( #results >= 1024 ) then break end

	end

	-- Todo. Sort, weighted?

	return results

end
