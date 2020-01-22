
var ServerSettings = []
var scope = null;
var rootScope = null;

function ControllerNewGame( $scope, $element, $rootScope, $location, $filter )
{
	for ( var i = 0; i < gScope.MapList.length; i++ )
	{
		if ( gScope.MapList[i][ "category" ] == "Favourites" )
		{
			if ( !$scope.CurrentCategory ) $scope.CurrentCategory = "Favourites";
		}
	}

	if ( !$scope.CurrentCategory ) $scope.CurrentCategory = "Sandbox";

	$scope.Players =
	[
		{ num: 1, label: 'maxplayers_1' },
		{ num: 2, label: 'maxplayers_2' },
		{ num: 4, label: 'maxplayers_4' },
		{ num: 8, label: 'maxplayers_8' },
		{ num: 16, label: 'maxplayers_16' },
		{ num: 32, label: 'maxplayers_32' },
		{ num: 64, label: 'maxplayers_64' },
		{ num: 128, label: 'maxplayers_128' },
	]

	$scope.MaxPlayersOption = $scope.Players[0];

	if ( localStorage.MaxPlayers ) {
		var maxPlayers = localStorage.MaxPlayers;
		for (var i = 0; i < $scope.Players.length; i++) {
			if ( $scope.Players[i].num == maxPlayers ) {
				$scope.MaxPlayersOption = $scope.Players[i];
				$rootScope.MaxPlayers = maxPlayers;
				break;
			}
		}
	}

	if ( !$rootScope.Map )				$rootScope.Map = "gm_flatgrass";
	if ( !$rootScope.MaxPlayers )		$rootScope.MaxPlayers = 1;
	if ( !$rootScope.ServerSettings )	$rootScope.ServerSettings = ServerSettings;
	if ( !$rootScope.LastCategory )		$rootScope.LastCategory = $scope.CurrentCategory;

	lua.Run( "UpdateServerSettings()" );
	lua.Run( "LoadLastMap()" );

	rootScope = $rootScope;
	scope = $scope;

	$rootScope.ShowBack = true;

	$scope.SwitchCategory = function( cat )
	{
		$scope.CurrentCategory = cat;
	}

	$scope.MapClass = function( m )
	{
		if ( m == $rootScope.Map )
			return "selected";

		return "";
	}

	$scope.SelectMap = function ( m )
	{
		$rootScope.Map = m;
		$rootScope.LastCategory = $scope.CurrentCategory;
	}

	$scope.DoubleClick = ""
	$scope.ClickMap = function( m )
	{
		$scope.SelectMap( m );

		if ( $scope.DoubleClick == m )
		{
			$scope.StartGame();
			return;
		}

		//
		// ng-dblclick doesn't work properly in engine, so we fake it!
		//
		$scope.DoubleClick = m;

		setTimeout( function()
		{
			$scope.DoubleClick = "";
		}, 500 )
	}

	$scope.FavMap = function( m )
	{
		lua.Run( 'ToggleFavourite( "' + m + '" )' );
	}

	$scope.MapIcon = function( m, cat )
	{
		// BSP version 21
		if ( /*cat == "Left 4 Dead 2" || cat == "Portal 2"  || cat == "CS: Global Offensive" || cat == "Blade Symphony" || cat == "Alien Swarm" || cat == "Dino D-Day" ||*/ cat == "INFRA" )
		{
			return "img/incompatible.png"
		}

		if ( !IN_ENGINE ) return "img/downloading.png"

		return "asset://mapimage/" + m
	}

	$scope.IsFavMap = function( m )
	{
		for ( var i = 0; i < gScope.MapList.length; i++ )
		{
			if ( gScope.MapList[i][ "category" ] == "Favourites" )
			{
				var obj = gScope.MapList[i][ "maps" ]
				for ( var map in obj )
				{
					if ( m == ( obj[ map ] ) ) return true
				}
			}
		}

		return false;
	}

	$scope.FavMapHover = function( m )
	{
		if ( this.IsFavMap( m ) ) return "faviconremove";
		return "faviconadd";
	}

	$scope.FavMapClass = function( m )
	{
		if ( this.IsFavMap( m ) ) return "favtoggle_always";
		return "favtoggle";
	}

	EscapeConVarValue = function( str )
	{
		str = str.replace( /\\/g,'\\\\' );
		return str.replace( new RegExp( '"', 'g' ), '\\\"' );
	}

	$scope.StartGame = function()
	{
		lua.Run( 'SaveLastMap( "' + $rootScope.Map + '", "' + $rootScope.LastCategory + '" )' );

		lua.Run( 'hook.Run( "StartGame" )' )
		lua.Run( 'RunConsoleCommand( "progress_enable" )' )

		lua.Run( 'RunConsoleCommand( "disconnect" )' )
		lua.Run( 'RunConsoleCommand( "maxplayers", "' + $rootScope.MaxPlayers + '" )' )

		if ( $rootScope.MaxPlayers > 0 )
		{
			lua.Run( 'RunConsoleCommand( "sv_cheats", "0" )' )
			lua.Run( 'RunConsoleCommand( "commentary", "0" )' )
		}

		// $scope.ServerSettings gets changed from Lua between this point and the timeout below
		// Perhaps UpdateServerSettings() in mainmenu.lua shouldn't call to JS if the gamemode wasn't actually changed?
		// Or maybe this entire system needs changing
		$scope.ServerSettingsSaved = $scope.ServerSettings;

		setTimeout( function()
		{
			for ( k in $scope.ServerSettingsSaved.Numeric )
			{
				lua.Run( 'RunConsoleCommand( "' + $scope.ServerSettingsSaved.Numeric[ k ].name + '", "' + EscapeConVarValue( $scope.ServerSettingsSaved.Numeric[ k ].Value ) + '" )' )
			}

			for ( k in $scope.ServerSettingsSaved.Text )
			{
				lua.Run( 'RunConsoleCommand( "' + $scope.ServerSettingsSaved.Text[ k ].name + '", "' + EscapeConVarValue( $scope.ServerSettingsSaved.Text[ k ].Value ) + '" )' )
			}

			for ( k in $scope.ServerSettingsSaved.CheckBox )
			{
				lua.Run( 'RunConsoleCommand( "' + $scope.ServerSettingsSaved.CheckBox[ k ].name + '", "' + ( $scope.ServerSettingsSaved.CheckBox[ k ].Value ? 1 : 0 ) + '" )' )
			}

			lua.Run( 'RunConsoleCommand( "hostname", "' + EscapeConVarValue( $scope.ServerSettingsSaved.hostname ) + '" )' )
			lua.Run( 'RunConsoleCommand( "p2p_enabled", "' + ( $scope.ServerSettingsSaved.p2p_enabled ? 1 : 0 ) + '" )' )
			lua.Run( 'RunConsoleCommand( "p2p_friendsonly", "' + ( $scope.ServerSettingsSaved.p2p_friendsonly ? 1 : 0 ) + '" )' )
			lua.Run( 'RunConsoleCommand( "sv_lan", "' + ( $scope.ServerSettingsSaved.sv_lan ? 1 : 0 ) + '" )' )
			lua.Run( 'RunConsoleCommand( "maxplayers", "' + $rootScope.MaxPlayers + '" )' )
			lua.Run( 'RunConsoleCommand( "map", "' + $rootScope.Map.trim() + '" )' )

			$scope.ServerSettingsSaved = undefined;
		}, 200 );

		$location.url( "/" )
	}

	$scope.UpdateMaxPlayers = function( mp )
	{
		$scope.MaxPlayersOption = mp;
		$rootScope.MaxPlayers = $scope.MaxPlayersOption.num;
		localStorage.MaxPlayers = mp.num;
	}

	$scope.CountFiltered = function( maps )
	{
		if ( !$scope.SearchText )
			return maps.length;

		return $filter('filter')(maps, $scope.SearchText).length;
	}

	var oldSvLan = 0;
	var oldp2p = 0;

	$scope.CheckboxCheck = function()
	{
		$scope.ServerSettings.sv_lan = Number( $scope.ServerSettings.sv_lan ) == 1;
		$scope.ServerSettings.p2p_enabled = Number( $scope.ServerSettings.p2p_enabled ) == 1;

		if ( oldSvLan != $scope.ServerSettings.sv_lan && $scope.ServerSettings.sv_lan == true && $scope.ServerSettings.p2p_enabled == true ) {
			$scope.ServerSettings.p2p_enabled = false;
			UpdateDigest( $scope, 50 );
		} else if ( oldp2p != $scope.ServerSettings.p2p_enabled && $scope.ServerSettings.p2p_enabled == true && $scope.ServerSettings.sv_lan == true ) {
			$scope.ServerSettings.sv_lan = false;
			UpdateDigest( $scope, 50 );
		}

		oldp2p = $scope.ServerSettings.p2p_enabled;
		oldSvLan = $scope.ServerSettings.sv_lan;

		if ( !$scope.ServerSettings.p2p_enabled ) {
			if ( document.getElementById( "p2p_friendsonly" ) !== null ) {
				document.getElementById( "p2p_friendsonly" ).disabled = true;
			}
			$scope.ServerSettings.p2p_friendsonly = false;
			UpdateDigest( $scope, 50 );
		} else if ( document.getElementById( "p2p_friendsonly" ) !== null ) {
			document.getElementById( "p2p_friendsonly" ).disabled = false;
		}
	}
}

function SetLastMap( map, category )
{
	if ( scope ) {
		scope.CurrentCategory = category;
		UpdateDigest( scope, 50 );
	}

	if ( rootScope ) {
		rootScope.Map = map;
		rootScope.LastCategory = category;
		UpdateDigest( rootScope, 50 );
	}

	setTimeout( function() {
		var elem = document.querySelector( '.mapicon.selected' );
		if ( elem ) elem.scrollIntoView( { behavior: 'smooth', block: 'center' } );
	}, 100 );
}

function UpdateServerSettings( sttngs )
{
	sttngs.CheckBox = [];
	sttngs.Numeric = [];
	sttngs.Text = [];

	sttngs.maxplayers = parseInt( sttngs.maxplayers );
	sttngs.p2p_friendsonly = Number( sttngs.p2p_friendsonly ) == 1;
	sttngs.p2p_enabled = Number( sttngs.p2p_enabled ) == 1;
	sttngs.sv_lan = Number( sttngs.sv_lan ) == 1;

	if ( sttngs.settings )
	{
		for ( k in sttngs.settings )
		{
			var s = sttngs.settings[k]
			if ( s.type == "CheckBox" ) { s.Value = s.Value == "1"; sttngs.CheckBox.push( s ); }
			if ( s.type == "Numeric" ) { sttngs.Numeric.push( s ); }
			if ( s.type == "Text" ) { sttngs.Text.push( s ); }
		}
	}

	if ( rootScope )
	{
		rootScope.ServerSettings = sttngs;
		UpdateDigest( rootScope, 50 );
	}

	ServerSettings = sttngs;
}
