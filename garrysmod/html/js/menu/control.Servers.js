
var RootScope = null;
var Scope = null;
var RequestNum = {};
var DigestUpdate = 0;
var ServerTypes = {};
var FirstTime = true;
var UpdateInterval = undefined;

function StripWeirdSymbols( name )
{
	// Weird symbols
	var ret = name.replace( /[\u2100-\u23FF\u2580-\u259F\u25A0-\u25FF\u2600-\u26FF\u2700-\u27BF\u2B00-\u2BFF]/g, "" );

	// Emojis
	ret = ret.replace( /\uD83C[\uDC00-\uDFFF]|\uD83D[\uDC00-\uDFFF]|\uD83E[\uDD10-\uDFFF]/g, "" );
	return ret;
}

function ControllerServers( $scope, $element, $rootScope, $location )
{
	RootScope = $rootScope;
	Scope = $scope;

	RootScope.ShowTab = 'internet';
	RootScope.GMCats = [ 'rp', 'pvp', 'pve', 'other', 'none' ];

	$scope.SVFilterHasPly = false;
	$scope.SVFilterNotFull = false;
	$scope.SVFilterHidePass = false;
	$scope.SVFilterHideOutdated = false;
	$scope.SVFilterMaxPing = 2000;
	$scope.SVFilterPlyMin = 0;
	$scope.SVFilterPlyMax = 128;
	RootScope.GMSort = '-(order)';
	RootScope.GMFilterTags = {};
	RootScope.GMHasFilterTags = false;
	RootScope.ServersPerPage = 128;
	$scope.JoinIfHasSlot = false;

	$scope.FindServerString = "";
	$scope.FoundServers = [];

	if ( !RootScope.CurrentGamemode ) RootScope.CurrentGamemode = null;

	if ( !RootScope.Refreshing ) RootScope.Refreshing = {};
	if ( !RootScope.ServerCount ) RootScope.ServerCount = {};

	$scope.DoStopRefresh = function()
	{
		if ( !RootScope.ServerType ) return;

		lua.Run( "DoStopServers( %s )", RootScope.ServerType );
	}

	$scope.$on( "$destroy", function()
	{
		$scope.DoStopRefresh();
		clearInterval( UpdateInterval );
	} );

	$scope.Refresh = function()
	{
		if ( !RootScope.ServerType ) return;

		if ( !RequestNum[ RootScope.ServerType ] )
		{
			RequestNum[ RootScope.ServerType ] = 1;
		}
		else
		{
			RequestNum[ RootScope.ServerType ]++;
		}

		//
		// Clear out all of the servers
		//
		ServerTypes[ RootScope.ServerType ].gamemodes = {};
		ServerTypes[ RootScope.ServerType ].list.length = 0;

		if ( !IN_ENGINE ) TestUpdateServers( RootScope.ServerType, RequestNum[ RootScope.ServerType ] );

		//
		// Get the server list from the engine
		//
		lua.Run( "GetServers( %s, %s )", RootScope.ServerType, String( RequestNum[ RootScope.ServerType ] ) );

		RootScope.Refreshing[ RootScope.ServerType ] = "true";
		RootScope.ServerCount[ RootScope.ServerType ] = 0;
		UpdateDigest( RootScope, 50 );
	}

	$scope.SelectServer = function( server, event )
	{
		if ( server == null )
		{
			RootScope.CurrentGamemode.Selected = null;
			clearInterval( UpdateInterval );
			return;
		}
		
		if ( event && event.which != 1 )
		{
			var txt = server.address;
			lua.Run( "SetClipboardText( %s )", txt );
			event.preventDefault();
			return;
		}

		RootScope.CurrentGamemode.Selected = server;
		$scope.JoinIfHasSlot = false;

		if ( !IN_ENGINE )
			SetPlayerList( server.address, { "1": { "time": 3037.74, "score": 5, "name": "Sethxi" }, "2": { "time": 2029.34, "score": 0, "name": "RedDragon124" }, "3": { "time": 1405.02, "score": 0, "name": "Joke (0_0)" }, "4": { "time": 462.15, "score": 0, "name": "TheAimBot" }, "5": { "time": 301.32, "score": 0, "name": "DesanPL"} } );

		lua.Run( "GetPlayerList( %s )", server.address );

		// Periodically update the server info.
		clearInterval( UpdateInterval );
		UpdateInterval = setInterval( function() {
			lua.Run( "GetPlayerList( %s )", server.address );
			lua.Run( "PingServer( %s )", server.address );
		}, 10000 );
	}

	$scope.SelectGamemode = function( gm )
	{
		RootScope.CurrentGamemode = gm;

		if ( gm ) gm.server_offset = 0;
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
			return StripWeirdSymbols( gm.info.title );

		return StripWeirdSymbols( gm.name );
	}

	$scope.JoinServer = function( srv )
	{
		// It's full, why even bother...
		// if ( srv.players >= srv.maxplayers ) return;

		clearInterval( UpdateInterval );
		$scope.JoinIfHasSlot = false;

		if ( srv.password )
			lua.Run( "RunConsoleCommand( \"password\", %s )", srv.password );

		lua.Run( "JoinServer( %s )", srv.address );

		// Stop updating so we are not spamming connections and potentially crash player's internet
		$scope.DoStopRefresh();
	}
	$rootScope.JoinServer = $scope.JoinServer;
	
	$scope.PasswordInput = function( e, srv )
	{
		if ( e.keyCode == 13 )
			$scope.JoinServer( srv )
	}
	$rootScope.PasswordInput = $scope.PasswordInput;

	$scope.PasswordInput = function( e, srv )
	{
		if ( e.keyCode == 13 )
			$scope.JoinServer( srv )
	}
	$rootScope.PasswordInput = $scope.PasswordInput;

	$scope.SwitchType = function( type )
	{
		if ( RootScope.ServerType == type ) return;

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

		RootScope.ServerType		= type;
		RootScope.Gamemodes			= ServerTypes[type].gamemodes;
		RootScope.GamemodeList		= ServerTypes[type].list;
		RootScope.CurrentGamemode	= null;

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
		if ( server.version_c < 0 && $scope.SVFilterHideOutdated ) return false;
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

		if ( RootScope.GMHasFilterTags && gm.info && !$scope.GMFilterTags[ gm.info.tag ? gm.info.tag : "none" ] ) return false;

		return true;
	}

	$scope.FindServersAtAddress = function()
	{
		Scope.FoundServers = [];
		if ( Scope.FindServerString <= 0 ) return;

		if ( !IN_ENGINE )
		{
			ReceiveFoundServers( [
				{ name: "Test server", map: "gm_test", address: "192.168.1.1:20823", ping: 69, players: 0, botplayers: 0, maxplayers: 376, gamemode: "sandbox" },
				{ name: "Test server2", map: "gm_test", address: "192.168.1.1:20823", ping: 1337, players: 0, botplayers: 0, maxplayers: 376, gamemode: "sandbox" },
			] );
		}

		lua.Run( "FindServersAtAddress( %s )", Scope.FindServerString.trim() );
	
		UpdateDigest( RootScope, 50 );
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
	RootScope.Refreshing[type] = "false";
	UpdateDigest( RootScope, 50 );
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
		server_offset:	0,
		sort_players:	0,
		OrderByMain:	'recommended',
		OrderBy:		[ 'recommended', 'ping', 'address' ],
		info:			GetGamemodeInfo( name ),
		FilterFlags:	{},
		HasPreferFlags:	false
	};

	ServerTypes[type].list.push( ServerTypes[type].gamemodes[name] );

	return ServerTypes[type].gamemodes[name];
}

function pad( num ) { return ( num < 10 ? "0" : "" ) + num.toString(); }

function FormatVersion( ver )
{
	if ( !ver ) return "Unknown version";

	var y = Math.floor( ver / 10000 );
	var m = Math.floor( ( ver - y * 10000 ) / 100 );
	var d = ver - y * 10000 - m * 100;
	return ( y > 99 ? pad( y ) : ( "20" + pad( y ) ) ) + "." + pad( m ) + "." + pad( d );
}

// Calculates the default server ranking
function CalculateRank( server )
{
	var recommended = server.ping;

	if ( server.players == 0 ) recommended += 75; // Server is empty
	//if ( server.players >= server.maxplayers ) recommended += 100; // Server is full, can't join it
	if ( server.pass || server.version_c < 0 ) recommended += 300; // Password protected or outdated, can't join it
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

function UpdateInfiniteScroll( elem )
{
	if ( !RootScope.CurrentGamemode ) return;

	RootScope.CurrentGamemode.server_offset = Math.max( Math.floor( elem.scrollTop / 22 ) - ( RootScope.ServersPerPage / 4 ), 0 );
	RootScope.CurrentGamemode.server_offset -= RootScope.CurrentGamemode.server_offset % 2; // Keeps the style of every other line consistent.
	UpdateDigest( RootScope, 50 );
}

function UpdateServer( address, ping, name, map, players, maxplayers, botplayers, pass )
{
	if ( !RootScope.CurrentGamemode || !RootScope.CurrentGamemode.Selected )
	{
		clearInterval( UpdateInterval );
		return;
	}

	var server = RootScope.CurrentGamemode.Selected;
	if ( server.address != address ) return;

	server.ping = parseInt( ping );
	server.name = name;
	server.map = map;
	server.players = parseInt( players ) - parseInt( botplayers );
	server.maxplayers = parseInt( maxplayers ) - parseInt( botplayers );
	server.botplayers = parseInt( botplayers );
	server.pass = pass == "1";

	if ( Scope.JoinIfHasSlot && server.players < server.maxplayers )
	{
		RootScope.JoinServer( server );
	}

	UpdateDigest( RootScope, 50 );
}

function AddServer( type, id, ping, name, desc, map, players, maxplayers, botplayers, pass, lastplayed, address, gamemode, workshopid, isAnon, version, isFav, loc, gmcat )
{
	if ( id != RequestNum[ type ] ) return;

	if ( !gamemode ) gamemode = desc;
	if ( maxplayers <= 1 ) return;

	version = parseInt( version ) || 0;
	if ( !IN_ENGINE ) GMOD_VERSION_INT = 20200101;

	// Validate gamemode category
	if ( gmcat )
	{
		var found = false;
		for ( var i = 0; i < RootScope.GMCats.length; i++ )
		{
			if ( RootScope.GMCats[ i ] == gmcat )
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
		name:			StripWeirdSymbols( name.trim() ),
		desc:			desc,
		map:			map,
		players:		parseInt( players ) - parseInt( botplayers ),
		maxplayers:		parseInt( maxplayers ) - parseInt( botplayers ),
		botplayers:		parseInt( botplayers ),
		pass:			pass == "1",
		lastplayed:		parseInt( lastplayed ) * 1000, // Steam gives us time in seconds
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

	if ( !IN_ENGINE && !version ) data.version_c = 0;

	data.hasmap = DoWeHaveMap( data.map );
	
	if ( !IN_ENGINE && ( Math.random() < 0.5 ) ) data.lastplayed = Date.now() - Math.random() * 1000000000;

	// Generate a user-friendly date that is also as short as possible
	var actualDate = new Date( data.lastplayed );
	var pad = function( num ) { return  ( "0" + num ).slice( -2 ); }
	data.lastplayedDate = pad( actualDate.getDate() ) + "." + pad( actualDate.getMonth() + 1 ) + "." + actualDate.getFullYear();
	data.lastplayedTime = pad( actualDate.getHours() ) + ":" + pad( actualDate.getMinutes() ); // + ":" + pad( actualDate.getSeconds() );

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

	RootScope.ServerCount[ type ] += 1;

	UpdateDigest( RootScope, 100 );
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

function ReverseFilter( me )
{
	cat = me.dataset.cat;
	
	RootScope.GMCats.forEach( function( category )
	{
		RootScope.GMFilterTags[ category ] = true;
		document.getElementById( "gmfltr_hide_" + category ).checked = true;
	} );

	delete RootScope.GMFilterTags[ cat ];
	document.getElementById( "gmfltr_hide_" + cat ).checked = false;

	RootScope.GMHasFilterTags = true;

	UpdateDigest( RootScope, 50 );
}

function SwitchFilter( me )
{
	cat = me.dataset.cat;
	
	if ( me.checked )
	{
		RootScope.GMFilterTags[ cat ] = true;
	}
	else
	{
		delete RootScope.GMFilterTags[ cat ];
	}

	RootScope.GMHasFilterTags = Object.keys( RootScope.GMFilterTags ).length > 0;

	UpdateDigest( RootScope, 50 );
}

function SetPlayerList( serverip, players )
{
	if ( !RootScope.CurrentGamemode || !RootScope.CurrentGamemode.Selected ) return;
	if ( RootScope.CurrentGamemode.Selected.address != serverip ) return;

	RootScope.CurrentGamemode.Selected.playerlist = players;

	UpdateDigest( RootScope, 50 );
}

function GetHighestKey( obj )
{
	var h = 0;
	var v = "";

	for ( k in obj )
	{
		if ( h == 0 || obj[k] > h )
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
	var gi = GetGamemodeInfo( server.gamemode );

	// Use the most common title
	if ( !gi.titles ) gi.titles = {};

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

	if ( !gi.titles[ server.desc ] ) { gi.titles[ server.desc ] = 0; }
	gi.titles[ server.desc ] += Math.min( server.players, 10 );
	if ( server.desc == server.gamemode ) gi.titles[ server.desc ] = 0; // Internal name is always a fallback
	gi.title = GetHighestKey( gi.titles );

	// categories
	if ( server.category != "" )
	{
		if ( !gi.categories ) gi.categories = {};
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
		if ( !gi.wsid ) gi.wsid = {};
		if ( !gi.wsid[ server.workshopid ] ) { gi.wsid[ server.workshopid ] = 1; } else { gi.wsid[ server.workshopid ]++; }
		gi.workshopid = GetHighestKey( gi.wsid );
	}

	// flags, for filtering
	gi = GetGamemode( server.gamemode, type );
	if ( server.flag != "" )
	{
		if ( !gi.flags ) gi.flags = {};
		gi.flags[ server.flag ] = true;
		gi.hasflags = true;
	}
}

function ReceiveFoundServers( data )
{
	Scope.FoundServers = data;

	UpdateDigest( RootScope, 60 );
}
