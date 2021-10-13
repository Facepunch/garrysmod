
var Scope = null
var RequestNum = {};
var DigestUpdate = 0;
var ServerTypes = {};
var FirstTime = true;

function ControllerServers( $scope, $element, $rootScope, $location )
{
	Scope = $rootScope;
	Scope.ShowTab = 'internet';
	Scope.GMCats = [ 'rp', 'pvp', 'pve', 'other', 'none' ];

	Scope.SVFilterHasPly = false;
	Scope.SVFilterNotFull = false;
	Scope.SVFilterHidePass = false;
	Scope.SVFilterMaxPing = 2000;
	Scope.SVFilterPlyMin = 0;
	Scope.SVFilterPlyMax = 128;
	Scope.GMSort = '-(order)';
	Scope.GMFilterTags = {};
	Scope.GMHasFilterTags = false;

	if ( !Scope.CurrentGamemode ) Scope.CurrentGamemode = null;

	if ( !Scope.Refreshing ) Scope.Refreshing = {}
	if ( !Scope.ServerCount ) Scope.ServerCount = {}

	$scope.DoStopRefresh = function()
	{
		if ( !Scope.ServerType ) return;

		lua.Run( "DoStopServers( %s )", Scope.ServerType );
	}

	$scope.$on( "$destroy", function()
	{
		$scope.DoStopRefresh();
	} );

	$scope.Refresh = function()
	{
		if ( !Scope.ServerType ) return;

		if ( !RequestNum[ Scope.ServerType ] )
		{
			RequestNum[ Scope.ServerType ] = 1;
		}
		else
		{
			RequestNum[ Scope.ServerType ]++;
		}

		//
		// Clear out all of the servers
		//
		ServerTypes[ Scope.ServerType ].gamemodes = {};
		ServerTypes[ Scope.ServerType ].list.length = 0;

		if ( !IN_ENGINE ) TestUpdateServers( Scope.ServerType, RequestNum[ Scope.ServerType ] );

		//
		// Get the server list from the engine
		//
		lua.Run( "GetServers( %s, %s )", Scope.ServerType, String( RequestNum[ Scope.ServerType ] ) );

		Scope.Refreshing[ Scope.ServerType ] = "true";
		Scope.ServerCount[ Scope.ServerType ] = 0;
		UpdateDigest( Scope, 50 );
	}

	$scope.SelectServer = function( server, event )
	{
		if ( event && event.which != 1 )
		{
			var txt = server.address + " (Anon:" + server.isAnon + ")";
			lua.Run( "SetClipboardText( %s )", txt );
			event.preventDefault();
			return;
		}

		Scope.CurrentGamemode.Selected = server;

		if ( !IN_ENGINE )
			SetPlayerList( server.address, { "1": { "time": 3037.74, "score": 5, "name": "Sethxi" }, "2": { "time": 2029.34, "score": 0, "name": "RedDragon124" }, "3": { "time": 1405.02, "score": 0, "name": "Joke (0_0)" }, "4": { "time": 462.15, "score": 0, "name": "TheAimBot" }, "5": { "time": 301.32, "score": 0, "name": "DesanPL"} } );

		lua.Run( "GetPlayerList( %s )", server.address );

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
		gm.OrderBy = [ order, 'recommended', 'ping', 'address' ];
		gm.OrderReverse = false;
	}

	$scope.GamemodeName = function( gm )
	{
		if ( !gm ) return "Unknown Gamemode";

		if ( gm.info && gm.info.title )
			return gm.info.title;

		return gm.name;
	}

	$scope.JoinServer = function ( srv )
	{
		// It's full, why even bother...
		// if ( srv.players >= srv.maxplayers ) return;

		if ( srv.password )
			lua.Run( "RunConsoleCommand( \"password\", %s )", srv.password );

		lua.Run( "JoinServer( %s )", srv.address );
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
		Scope.GamemodeList		= ServerTypes[type].list;
		Scope.CurrentGamemode	= null;

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
		if ( server.favorite )
		{
			server.favorite = false;
			lua.Run( "serverlist.RemoveServerFromFavorites( %s )", String( server.address ) );
		}
		else
		{
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

	$scope.FilterFlag = function( flag )
	{
		if ( !$scope.CurrentGamemode ) return;

		if ( $scope.CurrentGamemode.FilterFlags[ flag ] == false )
		{
			$scope.CurrentGamemode.FilterFlags[ flag ] = undefined;
		}
		else
		{
			$scope.CurrentGamemode.FilterFlags[ flag ] = !$scope.CurrentGamemode.FilterFlags[ flag ];
		}

		// Kinda ugly hack :(
		$scope.CurrentGamemode.HasPreferFlags = Object.keys( $scope.CurrentGamemode.FilterFlags ).filter( function( key ) { return $scope.CurrentGamemode.FilterFlags[ key ] === true; } ).length > 0;
	}
	$scope.FilterFlagClass = function( flag )
	{
		if ( $scope.CurrentGamemode.FilterFlags[ flag ] == undefined ) return "";
		if ( $scope.CurrentGamemode.FilterFlags[ flag ] == true ) return "prefer";
		return "avoid";
	}

	$scope.serverFilter = function( server )
	{
		if ( $scope.CurrentGamemode.Search &&
			server.name.toLowerCase().indexOf( $scope.CurrentGamemode.Search.toLowerCase() ) == -1 &&
			server.address.indexOf( $scope.CurrentGamemode.Search ) == -1 &&
			server.map.toLowerCase().indexOf( $scope.CurrentGamemode.Search.toLowerCase() ) == -1 ) return false;

		if ( server.players < 1 && $scope.SVFilterHasPly ) return false;
		if ( server.players >= server.maxplayers && $scope.SVFilterNotFull ) return false;
		if ( server.pass && $scope.SVFilterHidePass ) return false;
		if ( server.ping > $scope.SVFilterMaxPing ) return false;
		if ( server.players < $scope.SVFilterPlyMin ) return false;
		if ( server.players > $scope.SVFilterPlyMax ) return false;
		if ( server.flag && $scope.CurrentGamemode.FilterFlags[ server.flag ] == false ) return false;
		if ( $scope.CurrentGamemode.HasPreferFlags && $scope.CurrentGamemode.FilterFlags[ server.flag ] != true ) return false;

		return true;
	}

	$scope.gamemodeFilter = function( gm )
	{
		if ( $scope.GMSearch )
		{
			var found = false;
			if ( gm.name.toLowerCase().indexOf( $scope.GMSearch.toLowerCase() ) != -1 ) found = true;
			if ( !found && gm.info && gm.info.title.toLowerCase().indexOf( $scope.GMSearch.toLowerCase() ) != -1 ) found = true;
			if ( !found ) return false;
		}

		if ( Scope.GMHasFilterTags && gm.info && !$scope.GMFilterTags[ gm.info.tag ? gm.info.tag : "none" ] ) return false;

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
		sort_players:	0,
		OrderByMain:	'recommended',
		OrderBy:		[ 'recommended', 'ping', 'address' ],
		info:			GetGamemodeInfo( name ),
		FilterFlags:	{},
		HasPreferFlags:	false
	};

	ServerTypes[type].list.push( ServerTypes[type].gamemodes[name] )

	return ServerTypes[type].gamemodes[name];
}

function pad( num ) { return ( num < 10 ? "0" : "" ) + num.toString() }

function FormatVersion( ver )
{
	if ( !ver ) return "Unknown version";

	var y = Math.floor( ver / 10000 );
	var m = Math.floor( ( ver - y * 10000 ) / 100 );
	var d = ver - y * 10000 - m * 100;
	return "20" + pad( y ) + "." + pad( m ) + "." + pad( d )
}

// Calculates the default server ranking
function CalculateRank( server )
{
	var recommended = server.ping;

	if ( server.players == 0 ) recommended += 75; // Server is empty
	if ( server.players >= server.maxplayers ) recommended += 100; // Server is full, can't join it
	if ( server.pass ) recommended += 300; // Password protected, can't join it
	if ( server.isAnon ) recommended += 1000; // Anonymous server

	// The first few bunches of players reduce the impact of the server's ping on the ranking a little
	if ( server.players >= 4 ) recommended -= 10;
	if ( server.players >= 8 ) recommended -= 15;
	if ( server.players >= 16 ) recommended -= 15;
	if ( server.players >= 32 ) recommended -= 10;
	if ( server.players >= 64 ) recommended -= 10;

	return recommended;
}

// Generate a flag from sevrer name if the server doesn't have it set.
// This is a temporary measure and should not be relied on, you should use sv_location
var prefixes = { ru: "ru", rus: "ru", fr: "fr", usa: "us", uk: "gb", en: "gb", eng: "gb", ger: "de", pl: "pl", dk: "dk", eu: "eu" };
function GenerateFlag( server )
{
	for ( var key in prefixes )
	{
		var s = server.name.toLowerCase().indexOf( "[" + key + "]" );
		if ( s == -1 ) continue;
		server.name = server.name.replace( server.name.substring( s, s + key.length + 2 ), "" ).trim();
		return prefixes[ key ];
	}

	return "";
}

function AddServer( type, id, ping, name, desc, map, players, maxplayers, botplayers, pass, lastplayed, address, gamemode, workshopid, isAnon, version, isFav, loc, gmcat )
{
	if ( id != RequestNum[ type ] ) return;

	if ( !gamemode ) gamemode = desc;
	if ( maxplayers <= 1 ) return;

	version = parseInt( version ) || 0;
	if ( !IN_ENGINE ) GMOD_VERSION_INT = 200101;

	// Validate gamemode category
	if ( gmcat )
	{
		var found = false;
		for ( var i = 0; i < Scope.GMCats.length; i++ )
		{
			if ( Scope.GMCats[ i ] == gmcat )
			{
				found = true;
				break;
			}
		}
		if ( !found ) gmcat = "";
	}

	// Validate sv_location
	if ( loc && !loc.match( /^[a-zA-Z]+$/ ) )
	{
		loc = "";
	}

	var data =
	{
		ping:			parseInt( ping ),
		name:			name.trim(),
		desc:			desc,
		map:			map,
		players:		parseInt( players ) - parseInt( botplayers ),
		maxplayers:		parseInt( maxplayers ) - parseInt( botplayers ),
		botplayers:		parseInt( botplayers ),
		pass:			pass == "1",
		lastplayed:		parseInt( lastplayed ),
		address:		address,
		flag: 			loc.toLowerCase(),
		category: 		gmcat || "",
		gamemode:		gamemode,
		password:		'',
		workshopid:		workshopid,
		isAnon:			isAnon,
		version:		FormatVersion( version ),
		version_c:		( version > GMOD_VERSION_INT ) ? 1 : ( GMOD_VERSION_INT == version ? 0 : -1 ),
		favorite:		isFav == "true"
	};

	if ( !data.flag ) data.flag = GenerateFlag( data );
	if ( data.flag == "eu" ) data.flag = "europeanunion"; // ew

	if ( !IN_ENGINE && !version ) data.version_c = 0

	data.hasmap = DoWeHaveMap( data.map );

	data.recommended = CalculateRank( data );

	data.listen = data.desc.indexOf( '[L]' ) >= 0;
	if ( data.listen ) data.desc = data.desc.substr( 4 );

	var gm = GetGamemode( data.gamemode, type );
	gm.servers.push( data );

	UpdateGamemodeInfo( data, type );

	gm.num_servers += 1;
	gm.num_players += data.players;

	if ( !data.isAnon ) gm.sort_players += data.players;

	gm.element_class = "";
	if ( gm.num_players == 0 ) gm.element_class = "noplayers";
	if ( gm.num_players > 50 ) gm.element_class = "lotsofplayers";

	gm.order = gm.sort_players; // + Math.random();

	Scope.ServerCount[ type ] += 1;

	UpdateDigest( Scope, 50 );

}

function MissingGamemodeIcon( element )
{
	if ( !IN_ENGINE )
	{
		element.src = "img/addons.png";
		return true;
	}

	element.src = "../gamemodes/base/icon24.png";
	return true;
}

function MissingFlag( element )
{
	element.src = "img/unk_flag.png";
	return true;
}

function ReverseFilter( cat, me )
{
	Scope.GMCats.forEach( function( category )
	{
		Scope.GMFilterTags[ category ] = true;
		document.getElementById( "gmfltr_hide_" + category ).checked = true;
	} );

	delete Scope.GMFilterTags[ cat ];
	document.getElementById( "gmfltr_hide_" + cat ).checked = false;

	Scope.GMHasFilterTags = true;

	UpdateDigest( Scope, 50 );
}

function SwitchFilter( cat, me )
{
	if ( me.checked )
	{
		Scope.GMFilterTags[ cat ] = true;
	}
	else
	{
		delete Scope.GMFilterTags[ cat ];
	}

	Scope.GMHasFilterTags = Object.keys( Scope.GMFilterTags ).length > 0;

	UpdateDigest( Scope, 50 );
}

function SetPlayerList( serverip, players )
{
	if ( !Scope.CurrentGamemode || !Scope.CurrentGamemode.Selected ) return;
	if ( Scope.CurrentGamemode.Selected.address != serverip ) return;

	Scope.CurrentGamemode.Selected.playerlist = players;

	UpdateDigest( Scope, 50 );
}

function GetHighestKey( obj )
{
	var h = 0;
	var v = "";

	for ( k in obj )
	{
		if ( obj[k] > h )
		{
			h = obj[k];
			v = k;
		}
	}

	return v;
}

//
// Updates information about gamemodes we don't have using server info
//
function UpdateGamemodeInfo( server, type )
{
	var gi = GetGamemodeInfo( server.gamemode )

	// Use the most common title
	if ( !gi.titles ) gi.titles = {}

	// First try to see if we have a capitalized version already (i.e. sandbox should be Sandbox)
	if ( server.desc == server.gamemode.toLowerCase() )
	{
		var names = Object.keys( gi.titles );
		for ( var i = 0; i < names.length; i++ )
		{
			var name = names[ i ];
			if ( name != name.toLowerCase() && name.toLowerCase() == server.gamemode.toLowerCase() )
			{
				server.desc = name;
				break;
			}
		}
	}

	if ( !gi.titles[ server.desc ] ) { gi.titles[ server.desc ] = 1; } else { gi.titles[ server.desc ]++; }
	gi.title = GetHighestKey( gi.titles );

	// categories
	if ( server.category != "" )
	{
		if ( !gi.categories ) gi.categories = {}
		if ( !gi.categories[ server.category ] ) { gi.categories[ server.category ] = 1; } else { gi.categories[ server.category ]++; }
		gi.tag = GetHighestKey( gi.categories );
		if ( gi.tag ) gi.tag_set = true;
	}

	// temporary measure while everyone adjusts
	// DO NOT rely on this
	if ( !gi.tag_set )
	{
		if ( gi.title.toLowerCase().indexOf( "roleplay" ) != - 1 || gi.title.indexOf( " RP" ) != -1 || gi.title.indexOf( "RP " ) != -1 || gi.title.indexOf( "RP" ) == gi.title.length - 2 )
		{
			gi.tag = "rp";
		}
		else
		{
			gi.tag = "";
		}
	}

	// Use the most common workshop id
	if ( server.workshopid != "" && server.workshopid != "0" )
	{
		if ( !gi.wsid ) gi.wsid = {}
		if ( !gi.wsid[ server.workshopid ] ) { gi.wsid[ server.workshopid ] = 1; } else { gi.wsid[ server.workshopid ]++; }
		gi.workshopid = GetHighestKey( gi.wsid );
	}

	// flags, for filtering
	gi = GetGamemode( server.gamemode, type )
	if ( server.flag != "" )
	{
		if ( !gi.flags ) gi.flags = {}
		gi.flags[ server.flag ] = true;
		gi.hasflags = true;
	}
}

