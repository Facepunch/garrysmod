

module( "matproxy", package.seeall )

ProxyList = {}
ActiveList = {}

--
-- Called by engine, returns true if we're overriding a proxy
--
function ShouldOverrideProxy( name )

	return ProxyList[ name ] != nil

end

--
-- Called to add a new proxy (see lua/matproxy/ for examples)
--
function Add( tbl )

	if ( !tbl.name ) then return; end
	if ( !tbl.bind ) then return; end

	local bReloading = ProxyList[ tbl.name ] != nil

	ProxyList[ tbl.name ] = tbl

	--
	-- If we're reloading then reload all the active entries that use this proxy
	--
	if ( bReloading ) then

		for k, v in pairs( ActiveList ) do

			if ( tbl.name != v.name ) then continue end

			Msg( "Reloading: ", v.Material, "\n" )
			Init( tbl.name, k, v.Material, v.Values )

		end

	end

end

--
-- Called by the engine from OnBind
--
function Call( name, mat, ent )

	local proxy = ActiveList[ name ]
	if ( !proxy ) then return end
	if ( !proxy.bind ) then return end

	proxy:bind( mat, ent )

end

--
-- Called by the engine from OnBind
--
function Init( name, uname, mat, values )

	local proxy = ProxyList[ name ]
	if ( !proxy ) then return end

	ActiveList[ uname ] = table.Copy( proxy )
	local proxy = ActiveList[ uname ];

	if ( !proxy.init ) then return end

	proxy:init( mat, values )

	-- Store these incase we reload
	proxy.Values	= values
	proxy.Material	= mat

end