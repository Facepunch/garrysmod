
var Scope = null
var RequestNum = {};
var DigestUpdate = 0;
var ServerTypes = {};
var FirstTime = true;

function ControllerServers( $scope, $element, $rootScope, $location )
{
	Scope = $rootScope;
	Scope.ShowTab = 'internet';

	if ( !Scope.CurrentGamemode )
		Scope.CurrentGamemode = null;

	if ( !Scope.Refreshing )
		Scope.Refreshing = {}

	$scope.DoStopRefresh = function()
	{
		lua.Run( "DoStopServers( '" + Scope.ServerType + "' )" );
	}

	$scope.Refresh = function()
	{
		if ( !Scope.ServerType ) return;

		if ( !RequestNum[ Scope.ServerType ] ) RequestNum[ Scope.ServerType ] = 1; else RequestNum[ Scope.ServerType ]++;

		//
		// Clear out all of the servers
		//
		ServerTypes[Scope.ServerType].gamemodes = {};
		ServerTypes[Scope.ServerType].list.length = 0;

		if ( !IN_ENGINE )
			TestUpdateServers( Scope.ServerType, RequestNum[ Scope.ServerType ] );

		//
		// Get the server list from the engine
		//
		lua.Run( "GetServers( '"+Scope.ServerType+"', '"+RequestNum[Scope.ServerType ]+"' )" );

		Scope.Refreshing[Scope.ServerType] = "true";
		UpdateDigest( Scope, 50 );
	}

	$scope.SelectServer = function( server )
	{
		Scope.CurrentGamemode.Selected = server;

		if ( !IN_ENGINE )
			SetPlayerList( server.address, { "1": { "time": 3037.74, "score": 5, "name": "Sethxi" }, "2": { "time": 2029.34, "score": 0, "name": "RedDragon124" }, "3": { "time": 1405.02, "score": 0, "name": "Joke (0_0)" }, "4": { "time": 462.15, "score": 0, "name": "TheAimBot" }, "5": { "time": 301.32, "score": 0, "name": "DesanPL"} } );

		lua.Run( "GetPlayerList( '"+server.address+"' )" );

		if ( server.DoubleClick )
		{
			$scope.JoinServer( server );
			return;
		}

		//
		// ng-dblclick doesn't work properly in engine, so we fake it!
		//
		server.DoubleClick = true;

		setTimeout( function()
		{
			server.DoubleClick = false;
		}, 500 )
	}

	$scope.SelectGamemode = function( gm )
	{
		Scope.CurrentGamemode = gm;
	}

	$scope.ServerClass = function( sv )
	{
		var tags = "";

		if ( !sv.hasmap ) tags += " missingmap ";
		if ( sv.players == 0 ) tags += " empty ";

		return tags;
	}

	$scope.ServerRank = function( sv )
	{
		if ( sv.recommended < 50 )	return "rank5";
		if ( sv.recommended < 100 )	return "rank4";
		if ( sv.recommended < 200 )	return "rank3";
		if ( sv.recommended < 300 )	return "rank2";
		return "rank1";
	}

	$scope.ChangeOrder = function( gm, order )
	{
		if ( gm.OrderByMain == order )
		{
			gm.OrderReverse = !gm.OrderReverse;
			return;
		}

		gm.OrderByMain = order;
		gm.OrderBy = [order, 'recommended', 'ping', 'address'];
		gm.OrderReverse = false;
	}

	$scope.GamemodeName = function( gm )
	{
		if ( !gm ) return "Unknown Gamemode";

		if ( gm.info && gm.info.title )
			return gm.info.title;

		return gm.name;
	}

	$scope.JoinServer = function ( gm )
	{
		if ( gm.password )
			lua.Run( "RunConsoleCommand( \"password\", \"" + gm.password + "\" )" )

		lua.Run( "JoinServer( \"" + gm.address + "\" )" )
		$scope.DoStopRefresh();
	}

	$scope.SwitchType = function( type )
	{
		if ( Scope.ServerType == type ) return;

		// Stop refreshing previous type
		$scope.DoStopRefresh();

		var FirstTime = false;
		if ( !ServerTypes[type] )
		{
			ServerTypes[type] =
			{
				gamemodes: {},
				list: []
			};

			FirstTime = true;
		}

		Scope.ServerType		= type;
		Scope.Gamemodes			= ServerTypes[type].gamemodes;
		Scope.GamemodeList		= ServerTypes[type].list
		Scope.CurrentGamemode	= null

		if ( FirstTime )
		{
			$scope.Refresh();
		}
	}

	$scope.InstallGamemode = function( gm )
	{
		lua.Run( "steamworks.Subscribe( %s )", String( gm.info.workshopid ) );
	}

	$scope.ToggleFavorite = function( server )
	{
		if ( server.favorite ) {
			server.favorite = false;
			lua.Run( "serverlist.RemoveServerFromFavorites( %s )", String( server.address ) );
		} else {
			server.favorite = true;
			lua.Run( "serverlist.AddServerToFavorites( %s )", String( server.address ) );
		}
	}

	$scope.ShouldShowInstall = function( gm )
	{
		if ( !gm ) return false;
		if ( !gm.info ) return false;
		if ( !gm.info.workshopid ) return false;
		if ( gm.info.workshopid == "" ) return false;
		if ( subscriptions.Contains( String( gm.info.workshopid ) ) ) return false;

		return true;
	}

	$rootScope.ShowBack = true;

	if ( FirstTime )
	{
		FirstTime = false;
		$scope.SwitchType( 'internet' );
	}
}

function FinishedServeres( type )
{
	Scope.Refreshing[type] = "false";
	UpdateDigest( Scope, 50 );
}

function GetGamemode( name, type )
{
	if ( !ServerTypes[type] ) return;

	if ( ServerTypes[type].gamemodes[name] ) return ServerTypes[type].gamemodes[name]

	ServerTypes[type].gamemodes[name] =
	{
		name:			name,
		servers:		[],
		num_servers:	0,
		num_players:	0,
		OrderByMain:	'recommended',
		OrderBy:		['recommended', 'ping', 'address'],
		info:			GetGamemodeInfo( name )
	};

	ServerTypes[type].list.push( ServerTypes[type].gamemodes[name] )

	return ServerTypes[type].gamemodes[name];
}

function AddServer( type, id, ping, name, desc, map, players, maxplayers, botplayers, pass, lastplayed, address, gamemode, workshopid )
{
	if ( id != RequestNum[ type ] ) return;

	if ( !gamemode ) gamemode = desc;
	if ( maxplayers <= 1 ) return;

	var data =
	{
		ping:			parseInt( ping ),
		name:			name.trim(),
		desc:			desc,
		map:			map,
		players:		parseInt( players ) - parseInt( botplayers ),
		maxplayers:		parseInt( maxplayers ),
		botplayers:		parseInt( botplayers ),
		pass:			pass,
		lastplayed:		parseInt( lastplayed ),
		address:		address,
		gamemode:		gamemode,
		password:		'',
		workshopid:		workshopid,
		favorite:		false // This needs to be set properly
	};

	if ( type == "favorite" ) {
		data.favorite = true; // This needs to be set properly
	}

	data.hasmap = DoWeHaveMap( data.map );

	data.recommended = data.ping;
	if ( data.players == 0 ) data.recommended += 75; // Server is empty
	if ( data.players >= data.maxplayers ) data.recommended += 100; // Server is full, can't join it
	if ( data.pass ) data.recommended += 300; // Password protected, can't join it

	// The first few bunches of players reduce the impact of the server's ping on the ranking a little
	if ( data.players >= 4 ) data.recommended -= 10;
	if ( data.players >= 8 ) data.recommended -= 15;
	if ( data.players >= 16 ) data.recommended -= 15;
	if ( data.players >= 32 ) data.recommended -= 10;
	if ( data.players >= 64 ) data.recommended -= 10;

	data.listen = data.desc.indexOf( '[L]' ) >= 0;
	if ( data.listen ) data.desc = data.desc.substr( 4 );

	var gm = GetGamemode( data.gamemode, type );
	gm.servers.push( data );

	UpdateGamemodeInfo( data )

	gm.num_servers += 1;
	gm.num_players += data.players

	gm.element_class = "";
	if ( gm.num_players == 0 ) gm.element_class = "noplayers";
	if ( gm.num_players > 50 ) gm.element_class = "lotsofplayers";

	gm.order = gm.num_players + Math.random();

	UpdateDigest( Scope, 50 );

}

function MissingGamemodeIcon( element )
{
	if ( !IN_ENGINE ) {
		element.src = "../../img/addons.png";
	} else {
		element.src = "../gamemodes/base/icon24.png";
	}
	return true;
}

function SetPlayerList( serverip, players )
{
	if ( !Scope.CurrentGamemode.Selected ) return;
	if ( Scope.CurrentGamemode.Selected.address != serverip ) return;

	Scope.CurrentGamemode.Selected.playerlist = players

	UpdateDigest( Scope, 50 );
}
